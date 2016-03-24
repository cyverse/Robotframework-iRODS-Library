#!/usr/bin/env python

from distutils.core import setup

from os.path import abspath, dirname, join
execfile(join(dirname(abspath(__file__)), 'src', 'PythoniRodsLibrary', 'version.py'))

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

setup(name         = 'Robotframework-iRODS',
      version      = VERSION,
      description  = 'Robot Framework keyword library wrapper around python-irodsclient',
      long_description = DESCRIPTION,
      author       = 'Andre Mercer',
      author_email = 'amercer@cyverse.org',
      url          = 'https://github.com/iPlantCollaborativeOpenSource/Robotframework-iRODS-Library',
      license      = 'Public Domain',
      keywords     = 'robotframework testing test automation irods',
      platforms    = 'any',
      classifiers  = CLASSIFIERS.splitlines(),
      package_dir  = {'' : 'src'},
      packages     = ['PythoniRodsLibrary'],
      package_data = {'PythoniRodsLibrary': ['tests/*.robot']},
      requires=[
          'robotframework',
          'git+https://github.com/irods/python-irodsclient.git'
      ],
)

""" From now on use this approach

python setup.py sdist upload
git tag -a 0.0.1 -m 'version 0.0.1'
git push --tags"""
