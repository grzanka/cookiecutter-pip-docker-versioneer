#!/usr/bin/env bash

pip install -rrequirements.txt
pip install coverage
pip install codeclimate-test-reporter
pip install pytest-cov

python -V
py.test --cov
codeclimate-test-reporter