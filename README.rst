README
======

.. image:: https://travis-ci.org/grzanka/cookiecutter-pip-docker-versioneer.svg?branch=master
    :target: https://travis-ci.org/grzanka/cookiecutter-pip-docker-versioneer

.. image:: https://ci.appveyor.com/api/projects/status/github/grzanka/cookiecutter-pip-docker-versioneer?branch=master&svg=true
    :target: https://ci.appveyor.com/project/grzanka/cookiecutter-pip-docker-versioneer

.. image:: https://readthedocs.org/projects/cookiecutter-pip-docker-versioneer/badge/?version=latest
    :target: http://cookiecutter-pip-docker-versioneer.readthedocs.io/en/latest/?badge=latest
    :alt: Documentation Status

What's this
===========

A template to generate skeleton of python project, including:

* example main script with argument parsing
* few unittests in separate directory
* skeleton of documentation in rST format (ready to be shipped to readthedocs service)
* packaging configuration (project is ready to be shipped to PyPI repository)
* travis configuration which runs test after each commit
* tox configuration to ensure compatibility between various python versions and

    * flake to ensure that code follows Python standards (described in PEP??)
    * sphinx to ensure that documentation is properly formatted

* tests in docker, to ensure that project will work smoothly in userspace under various Linux distributions

An example
==========

Checkout a repository generated with this template:

* https://github.com/grzankatest/python-cookie05



Which problem this tool will solve
==================================

Let us assume that we want to start a Python project with following goals:

* user wants to check if PID  of process which is using maximum of CPU is a prime number
* it runs on Linux
* user doesn't have a root access
* user wants easily install this tool (preferably "pip install --user")

So far, so good. Seems easy to code. We can use python subprocess module to call "ps" and extract necessary information.

So what could be the problem ? Lets start with python version. Which one to choose ?
Lets look on it from user's perspective. Here is short listing of popular
Linux distributions (still supported) and Python versions installed there:

XXX XXX

We can assume that user will not be eager to install newer python version (no root rights and too lazy to compile from sources).
It means we need to support almost all versions from 2.6 to 3.5.

To ensure that everything works well we come up with set of unit tests.
There is a tool, called Tox which can run a bunch of virtualenv's
(small isolated python virtual enviroments) with different version of python installed.
We can combine it with Travis continous integration service which runs the tests on its own
machines and be sure that the code works well with many Python versions.

There is however another problem emerging. Our project depends on behaviour of "ps" command, and it might differ from
one linux distribution to another. Using simply tox won't solve this problem as it will have the same "ps" version in all
its virtualenvs.

The solution is to use docker containers. We can specify list of Linux distributions and for each of them:

* get the image of container with bare system
* as root install default python version using a system package manager
* create a dummy user
* as user: install our project using pip and test it

In this way we'll be sure that from user perspective our project behave well.

Users would also like to have nice webpage with step-by-step documentation and an easy way to upgrade the tool to higher
version. To make it possible we provide support for following technologies:

* versioneer to easily create new versions using github "Release" feature
* sphinx to generate and publish documentation on "ReadTheDocs" service
* git commit message parsing to run docker tests conditionally

Resources
---------

* To start using it, visit http://cookiecutter-pip-docker-versioneer.rtfd.org
* GitHub: https://github.com/grzanka/cookiecutter-pip-docker-versioneer
* Free software: MIT license


A template for PIP python package, with versioneer and travis/docker tests

Requirements
------------
Install first `cookiecutter` command line::

  pip install cookiecutter

Usage
-----
