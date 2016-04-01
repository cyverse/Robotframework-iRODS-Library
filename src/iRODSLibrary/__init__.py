from iRODSLibrary import iRODSLibrary

__version__ = "0.0.3"

class iRODSLibrary(iRODSLibrary):
    """ iRODSLibrary is a client keyword library that uses
    the python-irodsclient module from iRODS
    https://github.com/irods/python-irodsclient


        Examples:
        | Connect To Grid | iPlant | data.iplantcollaborative.org | ${1247} | jdoe | jdoePassword | tempZone

    """

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
