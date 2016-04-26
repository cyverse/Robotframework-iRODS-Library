*** Settings ***
Library           iRODSLibrary
Library           Collections

*** Variables ***
${iRODSHost}      host_here
${iRODSPort}      1247
${UserName}       username_here
${Password}       password_here
${Zone}           zone_here
${my_file}        ../../test/put_test.txt
${ConnAlias}      QATesting

*** Test Cases ***
Connect to valid iRODS grid
    [Tags]    smoke
    Comment    Connect to iRods Grid
    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}   ${Zone}    ${ConnAlias}

Verify iRODS connection
    [Tags]    smoke
    ${output} =    Check Connection    ${ConnAlias}
    Log    ${output}
    Should Be True    ${output}

Create iRODSLibrary_Regression collection
    [Tags]    smoke
    Comment    Define variables
    Set Test Variable    ${NewCollName}    iRODSLibrary_Regression
    Comment    Connect and create a new collection
    Comment    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
    ${CollectionPath} =    Create A Collection    /iplant/home/${UserName}/${NewCollName}    ${ConnAlias}
    Should Contain    ${CollectionPath}    /iplant/home/${UserName}/${NewCollName}

Create a collection
    [Tags]    functional
    Comment    Define variables
    Set Test Variable    ${PathAdd}    iRODSLibrary_Regression
    Set Test Variable    ${NewCollName}    NewCollectionName
    Comment    Connect and create a new collection
    Comment    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
    ${CollectionPath} =    Create A Collection    /iplant/home/${UserName}/${PathAdd}/${NewCollName}    ${ConnAlias}
    Should Contain    ${CollectionPath}    /iplant/home/${UserName}/${PathAdd}/${NewCollName}

Create a collection that exists
    [Tags]    functional
    Comment    Define variables
    Set Test Variable    ${PathAdd}    iRODSLibrary_Regression
    Set Test Variable    ${NewCollName}    NewCollectionName
    Comment    Connect and create a new collection
    Comment    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
    ${CollectionPath} =    Create A Collection    /iplant/home/${UserName}/${PathAdd}/${NewCollName}    ${ConnAlias}
    Log    ${CollectionPath}
    Comment    Should Contain    ${CollectionPath}    /iplant/home/${UserName}/${NewCollName}
    Should Contain    ${CollectionPath}    The collection already exists

Rename a collection that does not exist
    [Tags]    functional    skipped
    Comment    Define variables
    Set Test Variable    ${CurColName}    NonExistCollection
    Set Test Variable    ${NewColName}    CollectionNameRenamed
    Comment    Connect and delte an existing collection
    Comment    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
    ${output}    Rename A Collection    /iplant/home/${UserName}/${CurColName}    /iplant/home/${UserName}/${NewColName}    ${ConnAlias}
    Log    ${output}
    Should Contain    ${output}    An error occurred

Rename a collection
    [Tags]    functional    skipped
    Comment    Define variables
    Set Test Variable    ${CurColName}    NewCollectionName
    Set Test Variable    ${NewColName}    CollectionNameRenamed
    Comment    Connect and delte an existing collection
    Comment    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}    ${ConnAlias}
    Rename A Collection    /iplant/home/${UserName}/${CurColName}    /iplant/home/${UserName}/${NewColName}    ${ConnAlias}

Delete a collection
    [Tags]    functional    skipped
    Comment    Define variables
    Set Test Variable    ${CollName}    CollectionNameRenamed
    Comment    Connect and delte an existing collection
    Comment    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}    ${ConnAlias}
    Delete A Collection    /iplant/home/${UserName}/${CollName}    False    True    ${ConnAlias}

Delete with recursive and not send to trash (force)
    [Tags]    functional    skipped
    Set Test Variable    ${PathAdd}    iRODSLibrary_Regression
    Delete A Collection    /iplant/home/${UserName}/${PathAdd}    True    True    ${ConnAlias}

Delete with recursive and send to trash (no force)
    [Tags]    functional    skipped

Add a file to a collection
    [Tags]    functional    skipped    skipped
    Comment    Connect and put file
    Connect To Grid    ${irodshost}    ${irodsport}    ${UserName}    ${Password}    ${zone}    ${ConnAlias}
    ${output_base_filename} =    Put File Into Irods    /iplant/home/${UserName}    ${my_file}    ${ConnAlias}
    ${output_list} =    List Contents of Collection    /iplant/home/${UserName}    ${ConnAlias}
    Log    ${output_list}
    List Should Contain Value    ${output_list}    ${output_base_filename}

Rename a file
    [Tags]    functional    skipped

Delete a file from a collection
    [Tags]    functional    skipped

Batch upload files
    [Tags]    functional    skipped

List the contents of a collection
    [Tags]    functional    skipped    skipped
    Comment    Connect and list contents of path
    Connect To Grid    ${irodshost}    ${irodsport}    ${UserName}    ${Password}   ${zone}    ${ConnAlias}
    ${output_list} =    List Contents of Collection    /iplant/home/${UserName}    ${ConnAlias}
    Log    ${output_list}
    List Should Contain Value    ${output_list}    test.txt

Download a file
    [Tags]    functional    skipped    skipped
    Comment     Connect and grab file
    Connect To Grid    ${irodshost}    ${irodsport}    ${UserName}    ${Password}   ${zone}    ${ConnAlias}
    ${output_list} =    List Contents of Collection    /iplant/home/${UserName}    ${ConnAlias}
    Log    ${output_list}
    ${first_in_list} =    Get From List    ${output_list}    0
    Log    ${first_in_list}
    Get File From Irods    /iplant/home/${username}/${first_in_list}    ${ConnAlias}
    File Should Exist    ${first_in_list}

Download a collection
    [Tags]    functional    skipped

Connect on behalf of User
    [Tags]    functional
    Comment    Define Variables
    Set Test Variable    ${UserZone}    ${Zone}
    Comment    Connect to iRods Grid as de-irods on behalf of ipctest
    Connect To Grid On Behalf    ${irodshost}    ${irodsport}    ${iRODSAdminUser}    ${iRODSAdminPass}   ${Zone}    ${UserName}    ${UserZone}    ${ConnAlias}2
    ${output} =    Check Connection    ${ConnAlias}2
    Log    ${output}
    Should Be True    ${output}
    ${output_list} =    List Contents of Collection    /iplant/home/${UserName}    ${ConnAlias}2
    Log    ${output_list}
    List Should Contain Value    ${output_list}    /iplant/home/${UserName}/TestData_qa-3
    Disconnect From Grid    ${ConnAlias}2

Remove Toplevel Regression Collection
    [Tags]    functional
    Comment    Define variables
    Set Test Variable    ${CollName}    iRODSLibrary_Regression
    Comment    Connect and delte an existing collection
    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${iRODSAdminUser}    ${iRODSAdminPass}    ${Zone}    ${ConnAlias}3
    Delete A Collection    /iplant/home/${UserName}/${CollName}    True    True    ${ConnAlias}3
    ${output_list} =    List Contents of Collection    /iplant/home/${UserName}    ${ConnAlias}3
    Should Not Contain    ${output_list}    /iplant/home/${UserName}/${CollName}

Disconnect from a grid
    [Tags]    smoke
    Disconnect From Grid    ${ConnAlias}

Disconnect from all grids
    [Tags]    smoke
    Disconnect From All Grids
