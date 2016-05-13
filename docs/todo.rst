TODO!
======================================

* check https://github.com/ionelmc/cookiecutter-pylibrary
* check https://github.com/kragniz/cookiecutter-pypackage-minimal

"Define testing dependencies in tox.ini Avoid duplicating dependency definitions, and use tox.ini as the canonical description of how the unittests should be run."

"setup.py should be the canonical source of package dependencies There is no reason to duplicate dependency specifiers (i.e. also using a requirements.txt file). See the testing section below for testing dependencies."

"setup.py should not import anything from the package When installing from source, the user may not have the packages dependencies installed, and importing the package is likely to raise an ImportError."

* release checklist https://gist.github.com/audreyr/5990987