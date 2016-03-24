import robot
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn

from irods.session import iRODSSession

class PythoniRODSKeywords(object):

    """
    Connection manager handles the connection & disconnnection to the irods grid.
    """

    ROBOT_LIBRARY_SCOPE = 'Global'

    def __init__(self):
        """
        Create private variables

        """
        self._cache = robot.utils.ConnectionCache('No connection created')
        self.builtin = BuiltIn()
        self.debug = 0
        #self._gridconnection = None
        self._alias = None
        self._host = None
        self._port = None
        self._user = None
        self._password = None
        self._zone = None
        self._session = None
        self._builtin = BuiltIn()


    def connect_to_grid(self, alias, host='localhost', port=1247, user='rods', password='rods', zone='tempZone'):
        """Create connection to an iRODS grid
         using the parameters passed in.
           'alias'    - Robotframework alias to identify the connection
           'host'     - the fqdn of the iRODS server
           'port'     - the port to connect on
           'user'     - a valid iRODS username
           'password' - the iRODS password for the username given
           'zone'     - a valid iRODS zone, tempZone is used by default

        Example usage:
        | # To connect to foo.bar.org's iRODS service on port 1247 |
        | Connect To Grid | foo.bar.org | ${1247} | jdoe | jdoePassword | tempZone

        """
        self.builtin.log('Creating session %s' % alias, 'DEBUG')
        self._alias = alias
        self._host = host
        self._port = port
        self._user = user
        self._password = password
        self._zone = zone
        logger.debug('Creating Connection using : alias=%s, host=%s, port=%s, user=%s, password=%s, zone=%s ' \
                    % (alias, host, port, user, password, zone))
        self._session = iRODSSession(self, alias, host=host, port=port, user=user, password=password, zone=zone)


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
