from iRODSLibrary import PythoniRODSKeywords
from version import VERSION

_version_ = VERSION


class iRODSLibrary(PythoniRODSKeywords):
    """ iRODSLibrary is a client keyword library that uses
    the python-irodsclient module from iRODS
    https://github.com/irods/python-irodsclient


        Examples:
        | Create Session | google | http://www.google.com |

    """
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
