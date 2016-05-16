import setuptools
import sys

{%- if cookiecutter.versioneer|lower == 'yes' %}
try:
    import versioneer
except ImportError:
    # dirty hack needed by readthedoc generation tool
    import subprocess

    subprocess.call(["versioneer", "install"])
    import versioneer
{% endif %}

packages = ['{{ cookiecutter.package_name }}']
tests_flag = '--add_tests'
if tests_flag in sys.argv:
    sys.argv.remove(tests_flag)
    packages.append('{{ cookiecutter.package_name }}.test')

with open('README.rst') as readme_file:
    readme = readme_file.read()

setuptools.setup(
    name='{{ cookiecutter.distribution_name }}',
    version=versioneer.get_version(),
    packages=packages,
    url='https://github.com/{{ cookiecutter.github_username }}/{{ cookiecutter.repo_name }}',
    license='GPL',
    author='{{ cookiecutter.full_name }}',
    author_email='{{ cookiecutter.email }}',
    description='{{ cookiecutter.project_short_description }}',
    long_description=readme + '\n',
    classifiers=[
        # How mature is this project? Common values are
        #   3 - Alpha
        #   4 - Beta
        #   5 - Production/Stable
        'Development Status :: 3 - Alpha',

        # Indicate who your project is intended for
        'Intended Audience :: Developers',
        'Topic :: Software Development :: Build Tools',

        # Pick your license as you wish (should match "license" above)
        'License :: OSI Approved :: MIT License',

        # Specify the Python versions you support here. In particular, ensure
        # that you indicate whether you support Python 2, Python 3 or both.
        'Programming Language :: Python :: 3.2',
        'Programming Language :: Python :: 3.3',
        'Programming Language :: Python :: 3.4',
    ],
    entry_points={
        'console_scripts': [
            '{{ cookiecutter.command_line_interface_bin_name }}=' + \
            '{{ cookiecutter.package_name }}.{{ cookiecutter.command_line_interface_bin_name }}:main',
        ],
    },
{%- if cookiecutter.versioneer|lower == 'yes' %}
    cmdclass=versioneer.get_cmdclass(),
{% endif %}
)
