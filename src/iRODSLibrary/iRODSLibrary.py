import os
import tempfile

from irods.session import iRODSSession
import robot
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn 

class iRODSLibrary(object):

    """
    List of available keywords for robot framework's use in testing
    """ 
    def __init__(self):
        """Create private variables"""
        self._cache = robot.utils.ConnectionCache("No sessions created")
        self._builtin = BuiltIn()
    
    def connect_to_grid(self, host='localhost', port=1247, user='rods', password='rods', zone='tempZone', alias='default_connection'):
        """ Create connection to an iRODS grid
            using the parameters passed in.
            'alias'    - Robotframework alias to identify the connection
            'host'     - the fqdn of the iRODS server
            'port'     - the port to connect on
            'user'     - a valid iRODS username
            'password' - the iRODS password for the username given
            'zone'     - a valid iRODS zone, tempZone is used by default

        Example usage:
        | # To connect to foo.bar.org's iRODS service on port 1247 |
        | Connect To Grid | foo.bar.org | ${1247} | jdoe | jdoePassword | tempZone | UAT

        """
        host = str(host)
        port = int(port)
        user = str(user)
        password = str(password)
        zone = str(zone)
        logger.info('Creating connection using : alias=%s, host=%s, port=%s, user=%s, password=%s,'
                    'zone=%s ' % (alias, host, port, user, password, zone))
        session = iRODSSession(host=host, port=port, user=user, password=password, zone=zone)
        self._cache.register(session, alias=alias)
    
    def check_connection(self, alias='default_connection'):
        """ See if there is a valid connection to the iRODS server

        """
        try:
            logger.info('Verifying connection : alias=%s' % (alias))
            session = self._cache.switch(alias)
            if session is not None:
                return True
            else:
                return False
        except RuntimeError:
            return False


    def list_contents_of_collection(self, path=None, alias="default_connection"):
        """ Provide a path to list contents of

        """
        logger.info('Returning contents of collection : alias=%s, path=%s' % (alias, path))
        if path is None:
            return []
        session = self._cache.switch(alias)
        coll = session.collections.get(path)
        # Grab files and place them in list of contents
        list_of_contents = [obj.name for obj in coll.data_objects]
        # Grab dirs and place them in the list of contents
        list_of_contents.extend([col.path for col in coll.subcollections])
        return list_of_contents
    
    def get_file_from_irods(self, path=None, alias="default_connection"):
        """ Provide a path for a file to be pulled down

        """
        path = str(path)
        new_file_path = os.path.basename(path)
        source = self.get_source(path=path, alias=alias)
        file = open(new_file_path, 'w+')
        file.write(source)
        file.close()

    def get_source(self, path, alias="default_connection"):
            session = self._cache.switch(alias)
            source = session.data_objects.get(path)
            file = source.open()
            payload = ''
            for r,row in enumerate(file.read()):
                payload += row
            file.close()
            return payload

    def disconnect_from_grid(self, alias='default_connection'):
        """ Delete connection to the iRODS server

        """
        try:
            logger.info('Disconnecting connetion : alias=%s' % (alias))
            session = self._cache.switch(alias)
            self._cache.register(None, alias=alias)
        except RuntimeError:
            return False
             
