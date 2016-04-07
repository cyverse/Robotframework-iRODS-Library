#!/usr/bin/env python

import codecs
import os
import re
from pip.req import parse_requirements
from setuptools import setup, find_packages


NAME = "Robotframework-iRODS"
PACKAGES = find_packages(where="src")
META_PATH = os.path.join("src", "iRODSLibrary", "__init__.py")

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

######################################################################

install_reqs = parse_requirements("requirements.txt", session=False) 
required = [str(ir.req) for ir in install_reqs]

HERE = os.path.abspath(os.path.dirname(__file__))

def read(*parts):
    """
    Build an absolute path from *parts* and and return the contents of the
    resulting file.  Assume UTF-8 encoding.
    """
    with codecs.open(os.path.join(HERE, *parts), "rb", "utf-8") as f:
        return f.read()


META_FILE = read(META_PATH)


def find_meta(meta):
    """
    Extract __*meta*__ from META_FILE.
    """
    meta_match = re.search(
        r"^__{meta}__ = ['\"]([^'\"]*)['\"]".format(meta=meta),
        META_FILE, re.M
    )
    if meta_match:
        return meta_match.group(1)
    raise RuntimeError("Unable to find __{meta}__ string.".format(meta=meta))

if __name__ == "__main__":
    setup(
        name         = NAME, 
        version      = find_meta("version"),
        description  = 'Robot Framework keyword library wrapper around python-irodsclient',
        long_description = DESCRIPTION,
        author       = 'Andre Mercer',
        author_email = 'amercer@cyverse.org',
        url          = 'https://github.com/cyverse/Robotframework-iRODS-Library',
        license      = 'University of Arizona License',
        packages     = ['iRODSLibrary'],
        package_data = {'iRODSLibrary': ['tests/*.robot']},
        package_dir  = {"": "src"},
        install_requires = required,
        dependency_links= [
            'git+git://github.com/irods/python-irodsclient.git'
        ],
        classifiers  = CLASSIFIERS.splitlines()
    )
