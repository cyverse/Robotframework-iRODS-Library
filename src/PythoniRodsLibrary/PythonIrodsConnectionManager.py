from robot.libraries.BuiltIn import BuiltIn 
from irods.session import iRODSSession

class PythonIrodsConnectionManager(object):
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
    
    def connect_to_irods(self, host='localhost', port=1247, user='rods', password='rods', zone='tempZone'):
        """Create iRODSSession variable with variables provided"""
        self._host = host
        self._port = port
        self._user = user
        self._password = password
        self._zone = zone
        self._session = iRODSSession(host=host, port=port, user=user, password=password, zone=zone)
    
    def check_connection(self):
        if self._session is None:
            return False
        else:
            return True

    def disconnect_to_irods(self):
        """Delete connection variable to irods"""
        self._session = None
