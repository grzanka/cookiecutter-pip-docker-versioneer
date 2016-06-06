#!/usr/bin/env bash

set -x # Print command traces before executing command

set -e # Exit immediately if a simple command exits with a non-zero status.

set -o pipefail # Return value of a pipeline as the value of the last command to
                # exit with a non-zero status, or zero if all commands in the
                # pipeline exit successfully.

# install dependencies
PYTHON_VERSION="py3"
if [[ $TOXENV == py27* ]]; then PYTHON_VERSION="py2" ; fi
sudo bash {{cookiecutter.project_slug}}/install_deps.sh $PYTHON_VERSION

# install packages in main pip virtualenv (use cache if possible)
# these packages will be used from within env created by tox
pip install -r {{cookiecutter.project_slug}}/requirements.txt
pip install -r {{cookiecutter.project_slug}}/tests/requirements-test.txt