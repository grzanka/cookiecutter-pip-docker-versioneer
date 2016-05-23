#!/bin/bash

# based on https://github.com/audreyr/cookiecutter-pypackage/

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


PROJNAME="cookie01"
EMAIL="grzanka@agh.edu.pl"
NAME="Leszek Grzanka"
GITHUBUSER="grzankatest"

require() {
    type $1 >/dev/null 2>/dev/null
}

cleanup() {
    rm -rf $PROJNAME
    rm github_deploy_config.json
}
trap cleanup EXIT


require cookiecutter

cd test

cat <<EOT >> github_deploy_config.json
default_context:
    full_name: $NAME
    email: $EMAIL
    github_username: $GITHUBUSER
    project_name: $PROJNAME
EOT


echo "Running test script..."
cookiecutter --config-file github_deploy_config.json --no-input ..
(
    cd ./$PROJNAME
    export HOME=`pwd`
    git config --global user.email $EMAIL
    git config --global user.name $NAME
    git init .
    git add -A .
    git commit -m "initial commit"
    pip install versioneer
    pip install -r requirements.txt
    versioneer install
    PYTHONPATH=. python $PROJNAME/run_$PROJNAME.py --help
    PYTHONPATH=. python $PROJNAME/run_$PROJNAME.py --version
    PYTHONPATH=. python $PROJNAME/run_$PROJNAME.py
    PYTHONPATH=. python $PROJNAME/run_$PROJNAME.py --verbose
    tox -e $TOXENV -- -n 8
    if [[ $DEPLOY -eq 1 ]]
    then
        GITHUBREPO=python-$PROJNAME


        # disabled temporarily

        # remove repo, if exists
        #echo "Attempt to delete repo $GITHUBREPO (username $GITHUBUSER)"
        #curl -X DELETE -H "Authorization: token $GITHUBTOKEN" https://api.github.com/repos/$GITHUBUSER/$GITHUBREPO

        # create repo
        #echo "Creating repo $GITHUBREPO (username $GITHUBUSER)"
        #curl -u "$GITHUBUSER:$GITHUBTOKEN" https://api.github.com/user/repos -d "{\"name\":\"$GITHUBREPO\"}"

        # save credentials in a store, this way "git push" won't ask for a password
        git config --global credential.helper store
        echo "https://$GITHUBUSER:$GITHUBTOKEN@github.com" > ~/.git-credentials

        # add timestamp to generated travis file
        TMPFILE=mktemp
        cp README.rst $TMPFILE
        echo "Travis generated this project on:" `date` > README.rst
        echo "" >> README.rst
        cat $TMPFILE >> README.rst

        git add README.rst
        git commit -m "README updated"


        git remote add origin https://github.com/$GITHUBUSER/$GITHUBREPO.git
        git push -v -u origin master


    fi
)

echo Done
