cookiecutter-pip-docker-versioneer
==================================

.. image:: https://travis-ci.org/grzanka/cookiecutter-pip-docker-versioneer.svg?branch=master
    :target: https://travis-ci.org/grzanka/cookiecutter-pip-docker-versioneer

.. image:: https://readthedocs.org/projects/cookiecutter-pip-docker-versioneer/badge/?version=latest
    :target: http://cookiecutter-pip-docker-versioneer.readthedocs.io/en/latest/?badge=latest
    :alt: Documentation Status

Short
------------

* Documentation: http://cookiecutter-pip-docker-versioneer.rtfd.org/
* GitHub: https://github.com/grzanka/cookiecutter-pip-docker-versioneer
* Free software: MIT license


A template for PIP python package, with versioneer and travis/docker tests

Requirements
------------
Install first `cookiecutter` command line: `pip install cookiecutter`

Usage
-----
Generate a new Cookiecutter template layout: `cookiecutter gh:grzanka/cookiecutter-cookiecutter-pip-docker-versioneer`    


After this you can create the initial repository (make sure you `create <https://github.com/new>`_ an *empty* Github
project)::

  git init .
  git add .
  git commit -m "Initial skel."
  git remote add origin git@github.com:X/Y.git
  git push -u origin master

Then:

* `Enable the repository in your Travis CI account <https://travis-ci.org/profile>`_.
* `Add the repo to your ReadTheDocs account <https://readthedocs.org/dashboard/import/>`_ + turn on the ReadTheDocs
  service hook. Don't forget to enable virtualenv and specify ``docs/requirements.txt`` as the requirements file in
  `Advanced Settings`.
