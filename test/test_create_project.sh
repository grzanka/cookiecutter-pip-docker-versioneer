#!/bin/bash

# based on https://github.com/audreyr/cookiecutter-pypackage/

set -e

require() {
    type $1 >/dev/null 2>/dev/null
}

cleanup() {
    rm -rf python_boilerplate
}
trap cleanup EXIT


require cookiecutter

echo "Running test script..."
cookiecutter . --no-input
(
    cd ./python_boilerplate
    pwd
)

echo Done
