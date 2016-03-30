#!/usr/bin/env python

from os.path import abspath, dirname, join

from pip.req import parse_requirements
import setuptools

execfile(join(dirname(abspath(__file__)), 'src', 'iRODSLibrary', 'version.py'))

DESCRIPTION = """
Robot Framework keyword library wrapper around the python-irodsclient.
"""[1:-1]


CLASSIFIERS = """
Development Status :: 5 - Production/Stable
License :: Public Domain
Operating System :: OS Independent
Programming Language :: Python
Topic :: Software Development :: Testing
"""[1:-1]

install_reqs = parse_requirements("requirements.txt", session=False)
required = [str(ir.req) for ir in install_reqs]

setuptools.setup(
    name         = 'Robotframework-iRODS',
    version      = VERSION,
    description  = 'Robot Framework keyword library wrapper around python-irodsclient',
    long_description = DESCRIPTION,
    author       = 'Andre Mercer',
    author_email = 'amercer@cyverse.org',
    url          = 'https://github.com/cyverse/Robotframework-iRODS-Library',
    license      = 'University of Arizona License',
    packages     = setuptools.find_packages(),
    install_requires = required,
    dependency_links= [
        'git+git://github.com/irods/python-irodsclient.git'
    ],
    classifiers  = CLASSIFIERS.splitlines()
)

""" From now on use this approach

python setup.py sdist upload
git tag -a 0.0.1 -m 'version 0.0.1'
git push --tags"""
