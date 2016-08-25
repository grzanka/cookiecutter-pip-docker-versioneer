Welcome to cookiecutter-pip-docker-versioneer's documentation!
==============================================================

Contents:

.. toctree::
   :maxdepth: 2

   installation
   usage
   technologies
   contributing
   authors
   todo


Quick-start guide
-----------------

Prerequisite - install cookiecutter Python package::

  pip install cookiecutter --user

Now lets generate a new project template. Cookiecutter will ask you few questions. Answer honestly, most important are - project name, github username.
We'll create a sample project called primehunter::

  cookiecutter gh:grzanka/cookiecutter-pip-docker-versioneer

Example session (i've replied only to questions about: name, email, github username and project name - for rest I've used default values)::

   cookiecutter gh:grzanka/cookiecutter-pip-docker-versioneer
   Cloning into 'cookiecutter-pip-docker-versioneer'...
   remote: Counting objects: 217, done.
   remote: Compressing objects: 100% (176/176), done.
   remote: Total 217 (delta 120), reused 128 (delta 31), pack-reused 0
   Receiving objects: 100% (217/217), 31.95 KiB | 0 bytes/s, done.
   Resolving deltas: 100% (120/120), done.
   Checking connectivity... done.
   full_name [Your name]: Leszek Grzanka
   email [Your address email (eq. you@example.com)]: grzanka@agh.edu.pl
   github_username [Your github username]: grzanka
   project_name [Name of the project]: primehunter
   project_short_description [A short description of the project]:
   repo_name [python-primehunter]:
   package_name [primehunter]:
   distribution_name [primehunter]:
   project_slug [primehunter]:
   Select travis:
   1 - yes
   2 - no
   Choose from 1, 2 [1]:
   Select use_pypi_deployment_with_travis:
   1 - yes
   2 - no
   Choose from 1, 2 [1]:
   command_line_interface_bin_name [run_primehunter]:
   pypi_username [grzanka]:
   Select versioneer:
   1 - yes
   2 - no
   Choose from 1, 2 [1]:
   Select docker:
   1 - yes
   2 - no
   Choose from 1, 2 [1]:
   Select requiresio:
   1 - no
   2 - yes
   Choose from 1, 2 [1]:

Cookiecutter created directory called `primehunter` will lots of goods inside. Lets step into it and put it on github.
First we create the initial repository (make sure you `create <https://github.com/new>`_ an *empty* Github
project). Remember to put your github username (and reponame) in `git remote add` command ::

  cd primehunter
  git init .
  git add .
  git commit -m "Initial commit"
  git remote add origin https://github.com/grzanka/python-primehunter.git
  git push -u origin master

Version information is necesasry to run the project, to have it we need to install Python package called versioneer
and generate two helper files (I don't keep them in repo) used to calculate the version::

  pip install versioneer
  versioneer install

Now we can run the example::

   → PYTHONPATH=. python primehunter/run_primehunter.py --help
   usage: run_primehunter.py [-h] [--what] [--version]

   optional arguments:
     -h, --help  show this help message and exit
     --what      please help me !
     --version   show program's version number and exit

   → PYTHONPATH=. python primehunter/run_primehunter.py --version
   0.post.dev1

   → PYTHONPATH=. python primehunter/run_primehunter.py --what
   Hej ho
   137
   [1 2 3 4]

Next steps are following:

* `Enable the repository in your Travis CI account <https://travis-ci.org/profile>`_.
* `Add the repo to your ReadTheDocs account <https://readthedocs.org/dashboard/import/>`_ + turn on the ReadTheDocs
  service hook. Don't forget to enable virtualenv and specify ``docs/requirements.txt`` as the requirements file in
  `Advanced Settings`.
* Create new package on PyPI service (you might use testing)
* Commit some changes to see if travis is publishing package to PyPI testing
* Check if documentation is generated on ReadTheDocs
* Run tests on docker
* Release first version on github (0.1.0)
* Check on you own system if it works


Indices and tables
==================

* :ref:`genindex`

