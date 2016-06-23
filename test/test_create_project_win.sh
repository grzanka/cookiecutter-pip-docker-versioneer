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
CTMPDIR=$TEMP
PROJNAME="cookie05"
EMAIL="grzanka@agh.edu.pl"
NAME="Leszek Grzanka"
GITHUBUSER="grzankatest"
GITHUBREPO=python-$PROJNAME

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

# save current directory
CURDIR=`pwd`
export HOME=`pwd`/..

# move to temporary directory, to be save and not clutter original workspace
cd $CTMPDIR

env

ls -al /c/Miniconda/envs/python/$PYTHON_VERSION/scripts

prepare_cookie_config $CTMPDIR/github_deploy_config.json
echo "Running test script..."
cookiecutter --config-file $CTMPDIR/github_deploy_config.json --no-input $CURDIR
(
    cd $PROJNAME

    # generating versioneeer files
    pip install versioneer

    pip install -r requirements.txt
    versioneer install

    # running necessary tests
    PYTHONPATH=. python $PROJNAME/run_$PROJNAME.py --help
    PYTHONPATH=. python $PROJNAME/run_$PROJNAME.py --version
    PYTHONPATH=. python $PROJNAME/run_$PROJNAME.py
    PYTHONPATH=. python $PROJNAME/run_$PROJNAME.py --verbose

    # TODO move following line to requirements-test.txt or requirements-dev.txt
    pip install -r tests/requirements-test.txt

    py.test
)

echo Done