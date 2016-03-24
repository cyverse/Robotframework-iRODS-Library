from iRODSLibrary import PythoniRODSKeywords
from version import VERSION

_version_ = VERSION


class iRODSLibrary(PythoniRODSKeywords):
    """ iRODSLibrary is a client keyword library that uses
    the python-irodsclient module from iRODS
    https://github.com/irods/python-irodsclient


        Examples:
        | Connect To Grid | iPlant | data.iplantcollaborative.org | ${1247} | jdoe | jdoePassword | tempZone

    """
    
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
