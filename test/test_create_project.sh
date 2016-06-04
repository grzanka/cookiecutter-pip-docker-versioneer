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

# global settings
CTMPDIR=`mktemp -d -t XXXXXXXX`
PROJNAME="cookie05"
EMAIL="grzanka@agh.edu.pl"
NAME="Leszek Grzanka"
GITHUBUSER="grzankatest"
GITHUBREPO=python-$PROJNAME

require() {
    type $1 >/dev/null 2>/dev/null
}

#on exit remove generated files
cleanup() {
    rm -rf $PROJNAME
    rm -f $CTMPDIR/github_deploy_config.json
}
trap cleanup EXIT

# save cookiecutter config with default values
prepare_cookie_config() {
    cat <<EOT > $1
default_context:
    full_name: $NAME
    email: $EMAIL
    github_username: $GITHUBUSER
    project_name: $PROJNAME
    requiresio: "yes"
    codeclimate: "yes"
EOT
}

# write ~/.pypirc file with plaintext password
# TODO figureout if plain-text password can be avoided
write_pypirc() {
PYPIRC=~/.pypirc
USERNAME=${1}
PASSWORD=${2}

if [ -e "${PYPIRC}" ]; then
    rm ${PYPIRC}
fi

touch ${PYPIRC}
cat <<pypirc >${PYPIRC}
[distutils]
index-servers =
    pypi
    pypitest

[pypi]
repository: https://pypi.python.org/pypi
username: ${USERNAME}
password: ${PASSWORD}

[pypitest]
repository: https://testpypi.python.org/pypi
username: ${USERNAME}
password: ${PASSWORD}
pypirc

if [ ! -e "${PYPIRC}" ]; then
    echo "ERROR: Unable to write file ~/.pypirc"
    exit 1
fi
}

# setup travis client, login and re-enable builds for repo
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


# install travis client, build package and register it in pypitest repo
setup_deploy_to_pypi() {
        set +x
        write_pypirc $GITHUBUSER $PYPIPASS
        set -x

        pip install wheel
        python setup.py bdist_wheel

#        python setup.py register -r pypitest --show-response -v
}

# deploy package to github
deploy_to_github() {

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

        # now move to directory containing repo and push it to remote
        cd $1

        git remote add origin https://github.com/$GITHUBUSER/$GITHUBREPO.git

        git push -u origin master

        # commiting modified travis cfg and pushing to remote
        set +x
        ENCPYPIPASS=`travis encrypt PYPIPASS=$PYPIPASS -r $GITHUBUSER/$GITHUBREPO`
        ENCPYPITESTPASS=`travis encrypt PYPITESTPASS=$PYPIPASS -r $GITHUBUSER/$GITHUBREPO`
        sed -i "s#\"PYPI_PASS_ENCRYPTED_TO_BE_REPLACED\"#${ENCPYPIPASS}#g" .travis.yml
        sed -i "s#\"PYPITEST_PASS_ENCRYPTED_TO_BE_REPLACED\"#${ENCPYPITESTPASS}#g" .travis.yml
        set -x
        git add .travis.yml
        git commit -m "travis config updated"
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
export HOME=`pwd`/..

# move to temporary directory, to be save and not clutter original workspace
cd $CTMPDIR

prepare_cookie_config $CTMPDIR/github_deploy_config.json
echo "Running test script..."
cookiecutter --config-file $CTMPDIR/github_deploy_config.json --no-input $CURDIR
(
    cd ./$PROJNAME

    # creating git repository here and adding all files
    git config --global user.email $EMAIL
    git config --global user.name $NAME
    git init .
    git add -A .
    git commit -m "initial commit"

    # generating versioneeer files
    pip install versioneer

    # install dependencies
    PYTHON_VERSION="py3"
    if [[ $TOXENV == "py27" ]]; then PYTHON_VERSION="py2" ; fi
    sudo bash ./install_deps.sh $PYTHON_VERSION

    pip install -r requirements.txt
    versioneer install

    # running necessary tests
    PYTHONPATH=. python $PROJNAME/run_$PROJNAME.py --help
    PYTHONPATH=. python $PROJNAME/run_$PROJNAME.py --version
    PYTHONPATH=. python $PROJNAME/run_$PROJNAME.py
    PYTHONPATH=. python $PROJNAME/run_$PROJNAME.py --verbose

    # TODO move following line to requirements-test.txt or requirements-dev.txt
    pip install tox virtualenv
    tox -e $TOXENV -- -n 8

    # if github deploy enabled, put this repository to github and run travis tests
    if [[ $DEPLOY -eq 1 ]]
    then
        # test pypi
        setup_deploy_to_pypi

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