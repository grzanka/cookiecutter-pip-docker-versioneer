===============================
{{ cookiecutter.project_name }}
===============================

.. image:: https://img.shields.io/pypi/v/{{ cookiecutter.repo_name }}.svg
        :target: https://pypi.python.org/pypi/{{ cookiecutter.repo_name }}

.. image:: https://img.shields.io/travis/{{ cookiecutter.repo_group }}/{{ cookiecutter.repo_name }}.svg
        :target: https://travis-ci.org/{{ cookiecutter.repo_group }}/{{ cookiecutter.repo_name }}

.. image:: https://readthedocs.org/projects/{{ cookiecutter.repo_name }}/badge/?version=latest
        :target: https://readthedocs.org/projects/{{ cookiecutter.repo_name }}/?badge=latest
        :alt: Documentation Status

========
Overview
========

.. start-badges

.. list-table::
    :stub-columns: 1

    * - docs
      - |docs|
    * - tests
      - {%- if cookiecutter.travis|lower == 'yes' %} |travis|{% endif -%}
        {%- if cookiecutter.appveyor|lower == 'yes' %} |appveyor|{% endif -%}
        {%- if cookiecutter.codeclimate|lower == 'yes' %} |codeclimate|{% endif -%}
        {%- if cookiecutter.requiresio|lower == 'yes' %} |requires|{% endif -%}
{{ '' }}
    * - package
      - |version| |downloads| |wheel| |supported-versions| |supported-implementations|

.. |docs| image:: https://readthedocs.org/projects/{{ cookiecutter.repo_name }}/badge/?style=flat
    :target: https://readthedocs.org/projects/{{ cookiecutter.repo_name|replace('.', '') }}
    :alt: Documentation Status
{{ '' }}
{%- if cookiecutter.travis|lower == 'yes' %}
.. |travis| image:: https://travis-ci.org/{{ cookiecutter.github_username }}/{{ cookiecutter.repo_name }}.svg?branch=master
    :alt: Travis-CI Build Status
    :target: https://travis-ci.org/{{ cookiecutter.github_username }}/{{ cookiecutter.repo_name }}
{% endif %}
{%- if cookiecutter.appveyor|lower == 'yes' %}
.. |appveyor| image:: https://ci.appveyor.com/api/projects/status/github/{{ cookiecutter.github_username }}/{{ cookiecutter.repo_name }}?branch=master&svg=true
    :alt: Appveyor Build Status
    :target: https://ci.appveyor.com/project/{{ cookiecutter.github_username }}/{{ cookiecutter.repo_name }}
{% endif %}
{%- if cookiecutter.requiresio|lower == 'yes' %}
.. |requires| image:: https://requires.io/github/{{ cookiecutter.github_username }}/{{ cookiecutter.repo_name }}/requirements.svg?branch=master
    :alt: Requirements Status
    :target: https://requires.io/github/{{ cookiecutter.github_username }}/{{ cookiecutter.repo_name }}/requirements/?branch=master
{% endif %}
{%- if cookiecutter.codeclimate|lower == 'yes' %}
.. |codeclimate| image:: https://codeclimate.com/github/{{ cookiecutter.github_username }}/{{ cookiecutter.repo_name }}/badges/gpa.svg
   :target: https://codeclimate.com/github/{{ cookiecutter.github_username }}/{{ cookiecutter.repo_name }}
   :alt: CodeClimate Quality Status
{% endif %}
.. |version| image:: https://img.shields.io/pypi/v/{{ cookiecutter.distribution_name }}.svg?style=flat
    :alt: PyPI Package latest release
    :target: https://pypi.python.org/pypi/{{ cookiecutter.distribution_name }}

.. |downloads| image:: https://img.shields.io/pypi/dm/{{ cookiecutter.distribution_name }}.svg?style=flat
    :alt: PyPI Package monthly downloads
    :target: https://pypi.python.org/pypi/{{ cookiecutter.distribution_name }}

.. |wheel| image:: https://img.shields.io/pypi/wheel/{{ cookiecutter.distribution_name }}.svg?style=flat
    :alt: PyPI Wheel
    :target: https://pypi.python.org/pypi/{{ cookiecutter.distribution_name }}

.. |supported-versions| image:: https://img.shields.io/pypi/pyversions/{{ cookiecutter.distribution_name }}.svg?style=flat
    :alt: Supported versions
    :target: https://pypi.python.org/pypi/{{ cookiecutter.distribution_name }}

.. |supported-implementations| image:: https://img.shields.io/pypi/implementation/{{ cookiecutter.distribution_name }}.svg?style=flat
    :alt: Supported implementations
    :target: https://pypi.python.org/pypi/{{ cookiecutter.distribution_name }}

.. end-badges

{{ cookiecutter.project_short_description|wordwrap(119) }}


Installation
============

::

    pip install {{ cookiecutter.distribution_name }}


:: Development version

    pip install -i https://testpypi.python.org/pypi {{ cookiecutter.distribution_name }}



Documentation
=============

https://{{ cookiecutter.repo_name|replace('.', '') }}.readthedocs.io/


Features
--------

* TODO

Credits
---------

This package was created with Cookiecutter_ and the `grzanka/cookiecutter-pip-docker-versioneer`_ project template.

.. _Cookiecutter: https://github.com/audreyr/cookiecutter
.. _`grzanka/cookiecutter-pip-docker-versioneer`: https://github.com/grzanka/cookiecutter-pip-docker-versioneer
