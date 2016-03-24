from robot.libraries.BuiltIn import BuiltIn 
from irods.session import iRODSSession

class PythoniRODSKeywords(object):
    """
    Connectino manager handles the connection & disconnnection to the irods grid.
    """ 
    def __init__(self):
        """Create private variables"""
        self._host = None
        self._port = None
        self._user = None
        self._password = None
        self._zone = None
        self._session = None
        self._builtin = BuiltIn()
    
    def connect_to_grid(self, host='localhost', port=1247, user='rods', password='rods', zone='tempZone'):
        """Create connection to an iRODS grid
         using the parameters passed in.
           'host' - the fqdn of the iRODS server
           'port' - the port to connect on
           'user' - a valid iRODS username
           'password' - the iRODS password for the username given
           'zone' - a valid iRODS zone, tempZone is used by default

        """
        self._host = host
        self._port = port
        self._user = user
        self._password = password
        self._zone = zone
        self._session = iRODSSession(host=host, port=port, user=user, password=password, zone=zone)
    
    def check_connection(self):
        """ See if there is a valid connection to the iRODS server

        """
        if self._session is None:
            return False
        else:
            return True

    def disconnect_from_grid(self):
        """ Delete connection to the iRODS server

        """
        self._session = None
