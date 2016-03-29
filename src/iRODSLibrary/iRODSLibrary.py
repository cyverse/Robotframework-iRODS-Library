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

    def connect_to_grid(self, host='localhost', port=1247, user='rods', password='rods', zone='tempZone',
                        alias='default_connection'):
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
        logger.info('Connect To Grid using : alias=%s, host=%s, port=%s, user=%s, password=%s, '
                    'zone=%s ' % (alias, host, port, user, password, zone))
        session = iRODSSession(host=host, port=port, user=user, password=password, zone=zone)
        self._cache.register(session, alias=alias)


    def connect_to_grid_on_behalf(self, host='localhost', port=1247, user='rods', password='rods', zone='tempZone',
                        client_user='another_user', client_zone='another_zone', alias='default_connection'):
        """ Create connection to an iRODS grid
            using the parameters passed in to act on behalf of a user.
            'alias'       - Robotframework alias to identify the connection
            'host'        - the fqdn of the iRODS server
            'port'        - the port to connect on
            'user'        - a valid iRODS username
            'password'    - the iRODS password for the username given
            'zone'        - a valid iRODS zone, tempZone is used by default
            'client_user' - username of user who is being acted on behalf of
            'client_zone' - zone of user who is being acted on behalf of

        Example usage:
        | # To connect to foo.bar.org's iRODS service on port 1247 |
        | Connect To Grid | foo.bar.org | ${1247} | jdoe | jdoePassword | tempZone | UAT

        """
        host = str(host)
        port = int(port)
        user = str(user)
        password = str(password)
        zone = str(zone)
        logger.info('Connect To Grid On Behalf using : alias=%s, host=%s, port=%s, user=%s, password=%s, '
                    'zone=%s, client_user=%s, client_zone=%s ' % (alias, host, port, user, password, zone,
                                                                  client_user, client_zone))
        session = iRODSSession(host=host, port=port, user=user, password=password, zone=zone, client_user=client_user,
                               client_zone=client_zone)
        self._cache.register(session, alias=alias)

    def check_connection(self, alias='default_connection'):
        """ See if there is a valid connection to the iRODS server

        """
        try:
            logger.info('Check Connection : alias=%s' % (alias))
            session = self._cache.switch(alias)
            if session is not None:
                return True
            else:
                return False
        except RuntimeError:
            return False

    def create_a_collection(self, path=None, alias="default_connection"):
        """ Create a new iRODS collection at the given path

        """
        logger.info('Create a Collection : alias=%s, path=%s' % (alias, path))
        session = self._cache.switch(alias)
        coll = session.collections.create(path)
        return coll.path


    def rename_a_collection(self, oldpath=None, newpath=None, alias="default_connection"):
        """ Rename an existing iRODS collection

        """
        logger.info('Rename a Collection : alias=%s, oldpath=%s, newpath=%s' % (alias, oldpath, newpath))
        session = self._cache.switch(alias)
        coll = session.collections.move(oldpath, newpath)

    def delete_a_collection(self, path=None, recursive=True, force=False, alias="default_connection"):
        """ Delete an existing iRODS collection at the given path

            'path' = the collection you want to delete (full path)
            'recursive' = boolean defaults to true
            'force' = boolean defaults to false (all items sent to trash)

        """
        logger.info('Delete a Collection : alias=%s, path=%s, recursive=%s, force=%s' % (alias, path, recursive, force))
        session = self._cache.switch(alias)
        coll = session.collections.remove(path)

    def list_contents_of_collection(self, path=None, alias="default_connection"):
        """ Provide a path to list contents of

        """
        logger.info('List Contents Of Collection : alias=%s, path=%s' % (alias, path))
        if path is None:
            return []
        session = self._cache.switch(alias)
        coll = session.collections.get(path)
        # Grab files and place them in list of contents
        list_of_contents = [obj.name for obj in coll.data_objects]
        # Grab dirs and place them in the list of contents
        list_of_contents.extend([col.path for col in coll.subcollections])
        return list_of_contents
    
    def put_file_into_irods(self, path=None, filename="./test.txt", alias="default_connection"):
        """ Provide a path for a file to be uploaded

        """
        logger.info('Put File Into iRODS : alias=%s, path=%s, filename=%s ' % (alias, path, filename))
        path = str(path)
        base_filename = os.path.basename(str(filename))
        irods_file_path = path + "/" + base_filename
        session = self._cache.switch(alias)
        try:
            data_obj = session.data_objects.get(irods_file_path)
        except:
            data_obj = session.data_objects.create(irods_file_path)
        finally:
            file_local = open(filename, 'rb')
            payload = file_local.read()
            file_irods = data_obj.open('r+')
            file_irods.write(payload)
            file_local.close()
            file_irods.close()
        # For testing purposes
        return base_filename

    def get_file_from_irods(self, path=None, alias="default_connection"):
        """ Provide a path for a file to be pulled down

        """
        logger.info('Get File From iRODS : alias=%s, path=%s ' % (alias, path))
        path = str(path)
        new_file_path = os.path.basename(path)
        source = self.get_source(path=path, alias=alias)
        file = open(new_file_path, 'w+')
        file.write(source)
        file.close()

    def get_source(self, path, alias="default_connection"):
        """ Get Source

        """
        logger.info('Get Source : alias=%s, path=%s ' % (alias, path))
        session = self._cache.switch(alias)
        source = session.data_objects.get(path)
        file = source.open()
        payload = ''
        for r,row in enumerate(file.read()):
            payload += row
        file.close()
        return payload
    
    def add_metadata_for_file(self, path, key="default_key", value="default_value", alias="default_connection"):
        """ Add metadata for a file using key:value pairs

        """
        logger.info('Add Metadata For File : alias=%s, path=%s, key=%s, value=%s ' % (alias, path, key, value))
        session = self._cache.switch(alias)
        obj = session.data_objects.get(str(path))
        meta_data_file_list = self.get_metadata_for_file(path, alias)
        if key not in meta_data_file_list and value not in meta_data_file_list:
            obj.metadata.add(key, value)

    def add_metadata_for_collection(self, path, key="default_key", value="default_value", alias="default_connection"):
        """ Add metadata for a Collection using key:value pairs

        """
        logger.info('Add Metadata For Collection : alias=%s, path=%s, key=%s, value=%s ' % (alias, path, key, value))
        session = self._cache.switch(alias)
        obj = session.collections.get(str(path))
        meta_data_collection_list = self.get_metadata_for_collection(path, alias)
        if key not in meta_data_collection_list and value not in meta_data_collection_list:
            obj.metadata.add(key, value)

    def get_metadata_for_file(self, path, alias="default_connection"):
        """ Get metadata for a file returning key:value pairs

        """
        logger.info('Get Metadata For File : alias=%s, path=%s ' % (alias, path))
        session = self._cache.switch(alias)
        obj = session.data_objects.get(str(path))
        return [x.name for x in obj.metadata.items()]

    def get_metadata_for_collection(self, path, alias="default_connection"):
        """ Get metadata for a collection returning key:value pairs

        """
        logger.info('Get Metadata For Collection : alias=%s, path=%s ' % (alias, path))
        session = self._cache.switch(alias)
        obj = session.collections.get(str(path))
        return [x.name for x in obj.metadata.items()]

    def disconnect_from_grid(self, alias='default_connection'):
        """ Delete connection to the iRODS server

        """
        try:
            logger.info('Disconnect From Grid : alias=%s' % (alias))
            session = self._cache.switch(alias)
            self._cache.register(None, alias=alias)
        except RuntimeError:
            return False


    def disconnect_from_all_grids(self):
        """ Delete connections to All iRODS servers

        """
        logger.info('Disconnect From All Grid')
        self._cache.empty_cache()
