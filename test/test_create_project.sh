#!/bin/bash

# based on https://github.com/audreyr/cookiecutter-pypackage/

set -e

require() {
    type $1 >/dev/null 2>/dev/null
}

cleanup() {
    rm -rf name-of-the-project
}
trap cleanup EXIT


require cookiecutter

echo "Running test script..."
cookiecutter . --no-input
(
    cd ./name-of-the-project
    pwd
)

echo Done
