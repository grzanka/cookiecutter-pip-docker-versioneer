#!/bin/bash

# based on https://github.com/audreyr/cookiecutter-pypackage/

set -x # Print command traces before executing command

set -e # Exit immediately if a simple command exits with a non-zero status.

set -o pipefail # Return value of a pipeline as the value of the last command to
                # exit with a non-zero status, or zero if all commands in the
                # pipeline exit successfully.

TOXENV=$1

DEPLOY=1
if [ -z "$2" ]
  then
    DEPLOY=0
fi

TMPDIR=`mktemp -d`
PROJNAME="cookie05"
EMAIL="grzanka@agh.edu.pl"
NAME="Leszek Grzanka"
GITHUBUSER="grzankatest"

require() {
    type $1 >/dev/null 2>/dev/null
}

cleanup() {
    rm -rf $PROJNAME
    rm -f $TMPDIR/github_deploy_config.json
}
trap cleanup EXIT

prepare_cookie_config() {
    cat <<EOT > $1
default_context:
    full_name: $NAME
    email: $EMAIL
    github_username: $GITHUBUSER
    project_name: $PROJNAME
    requiresio: "yes"
EOT
}

setup_travis() {
        # install travis client
        ruby -v
        gem install travis -q --no-rdoc --no-ri
        travis version

        echo "Logging to travis"
        # disable printing bash command to hide GITHUBTOKEN
        set +x
        travis login --org -g $GITHUBTOKEN -u $GITHUBUSER --no-manual --no-interactive
        set -x
        travis whoami

        # syncing repos
        travis sync

        # listing repos
        travis repos

        # enabling repo in travis
        travis enable -r $GITHUBUSER/$GITHUBREPO

        # listing repos
        travis repos
}


deploy_to_github() {
        GITHUBREPO=python-$PROJNAME

        # remove repo, if exists
        echo "Attempt to delete repo $GITHUBREPO (username $GITHUBUSER)"
        # disable printing bash command to hide GITHUBTOKEN
        set +x
        curl -X DELETE -H "Authorization: token $GITHUBTOKEN" https://api.github.com/repos/$GITHUBUSER/$GITHUBREPO
        sleep 5

        # create repo
        echo "Creating repo $GITHUBREPO (username $GITHUBUSER)"
        curl -u "$GITHUBUSER:$GITHUBTOKEN" https://api.github.com/user/repos -d "{\"name\":\"$GITHUBREPO\"}"
        sleep 5

        # enable travis for this newly created repo
        setup_travis

        # save credentials in a store, this way "git push" won't ask for a password
        git config --global credential.helper store
        cat <<EOF > ~/.git-credentials
https://$GITHUBUSER:$GITHUBTOKEN@github.com
EOF
        set -x

        git remote add origin https://github.com/$GITHUBUSER/$GITHUBREPO.git

        # now move to directory containing repo and push it to remote
        cd $1
        git push -u origin master

        # add informative header to generated travis file
        TMPFILE=mktemp
        cp README.rst $TMPFILE
        echo "Travis generated this project on:" `date` > README.rst
        echo "" >> README.rst
        echo "Github commit https://github.com/grzanka/cookiecutter-pip-docker-versioneer/commit/"$TRAVIS_COMMIT >>  README.rst
        echo "" >> README.rst
        cat $TMPFILE >> README.rst

        # commiting modified readme and pushing to remote
        git add README.rst
        git commit -m "README updated"
        git push -u origin master

        # trigger building documentation on readthedocs
        # you need however first manually enable project in readthedocs service
        curl -X POST http://readthedocs.org/build/$GITHUBREPO
}

require cookiecutter

# save current directory
CURDIR=`pwd`

# move to temporary directory, to be save and not clutter original workspace
cd $TMPDIR

prepare_cookie_config $TMPDIR/github_deploy_config.json
echo "Running test script..."
cookiecutter --config-file $TMPDIR/github_deploy_config.json --no-input $CURDIR
(
    cd ./$PROJNAME

    # creating git repository here and adding all files
    export HOME=`pwd`
    git config --global user.email $EMAIL
    git config --global user.name $NAME
    git init .
    git add -A .
    git commit -m "initial commit"

    # generating versioneeer files
    pip install versioneer
    pip install -r requirements.txt
    versioneer install

    # running necessary tests
    PYTHONPATH=. python $PROJNAME/run_$PROJNAME.py --help
    PYTHONPATH=. python $PROJNAME/run_$PROJNAME.py --version
    PYTHONPATH=. python $PROJNAME/run_$PROJNAME.py
    PYTHONPATH=. python $PROJNAME/run_$PROJNAME.py --verbose
    tox -e $TOXENV -- -n 8

    # if github deploy enabled, put this repository to github and run travis tests
    if [[ $DEPLOY -eq 1 ]]
    then
        if [ $TRAVIS_BRANCH = "master" -a $TRAVIS_PULL_REQUEST = "false" ]
        then
            deploy_to_github `pwd`
        else
            echo "Not running deploy_to_github, this task was triggered from branch other than master or from PR"
            echo "TRAVIS_BRANCH="$TRAVIS_BRANCH
            echo "TRAVIS_PULL_REQUEST="$TRAVIS_PULL_REQUEST
        fi
    else
        echo "Not running deploy_to_github, as you called this script with DEPLOY="$DEPLOY
    fi
)

echo Done
