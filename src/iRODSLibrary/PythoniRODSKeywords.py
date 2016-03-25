from irods.session import iRODSSession
import robot
from robot.libraries.BuiltIn import BuiltIn 

class PythoniRODSKeywords(object):
    """
    List of available keywords for robot framework's use in testing
    """ 
    def __init__(self):
        """Create private variables"""
        self._cache = robot.utils.ConnectionCache("No sessions created")
        self._builtin = BuiltIn()
    
    def connect_to_grid(self, host='localhost', port=1247, user='rods', password='rods', zone='tempZone', alias='default_connection'):
        """Create connection to an iRODS grid
         using the parameters passed in.
           'host' - the fqdn of the iRODS server
           'port' - the port to connect on
           'user' - a valid iRODS username
           'password' - the iRODS password for the username given
           'zone' - a valid iRODS zone, tempZone is used by default

        """
        host = str(host)
        port = int(port)
        user = str(user)
        password = str(password)
        zone = str(zone)
        session = iRODSSession(host=host, port=port, user=user, password=password, zone=zone)
        self._cache.register(session, alias=alias)
    
    def check_connection(self, alias='default_connection'):
        """ See if there is a valid connection to the iRODS server

        """
        try:
            session = self._cache.switch(alias)
            if session is not None:
                return True
            else:
                return False
        except RuntimeError:
            return False


    def list_contents_of_directory(self, path=None, alias="default_connection"):
        """Provide a path to list contents of

        """
        if path is None:
            return []
        session = self._cache.switch(alias)
        coll = session.collections.get(path)
        # Grab files and place them in list of contents
        list_of_contents = [obj.name for obj in coll.data_objects]
        # Grab dirs and place them in the list of contents
        list_of_contents.extend([col.path for col in coll.subcollections])
        return list_of_contents

    def disconnect_from_grid(self, alias='default_connection'):
        """ Delete connection to the iRODS server

        """
        try:
            session = self._cache.switch(alias)
            self._cache.register(None, alias=alias)
        except RuntimeError:
            return False
             
