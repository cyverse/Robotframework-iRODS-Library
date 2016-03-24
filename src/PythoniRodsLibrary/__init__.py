from PythoniRodsKeywords import PythoniRodsKeywords
from version import VERSION

_version_ = VERSION


class PythoniRodsLibrary(PythoniRodsKeywords):
    """ PythoniRodsLibrary is a client keyword library that uses
    the python-irodsclient module from iRODS
    https://github.com/irods/python-irodsclient


        Examples:
        | Create Session | google | http://www.google.com |
        | Create Session | github  | http://github.com/api/v2/json |
        | ${resp} | Get  google  |  / |
        | Should Be Equal As Strings |  ${resp.status_code} | 200 |
        | ${resp} | Get  github  | /user/search/bulkan |
        | Should Be Equal As Strings  |  ${resp.status_code} | 200 |
        | ${jsondata}  | To Json |  ${resp.content} |
        | Dictionary Should Contain Value | ${jsondata['users'][0]} | Bulkan Savun Evcimen |

    """
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
