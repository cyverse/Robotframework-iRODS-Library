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

*** Test Cases ***
Connect to valid iRODS grid
    [Tags]    functional
    Comment    Connect to iRods Grid
    Connect To Grid    ${irodshost}    ${irodsport}    ${UserName}    ${Password}   ${zone}    qairods
    ${output} =    Check Connection    qairods
    Log    ${output}
    Should Be True    ${output}

Create a collection
    [Tags]    functional
    Comment    Define variables
    Set Test Variable    ${NewCollName}    NewCollectionName
    Comment    Connect and create a new collection
    Comment    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
    ${CollectionPath} =    Create A Collection    /iplant/home/${UserName}/${NewCollName}    qairods
    Should Contain    ${CollectionPath}    /iplant/home/${UserName}/${NewCollName}

Create a collection that exists
    [Tags]    functional
    Comment    Define variables
    Set Test Variable    ${NewCollName}    NewCollectionName
    Comment    Connect and create a new collection
    Comment    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
    ${CollectionPath} =    Create A Collection    /iplant/home/${UserName}/${NewCollName}    qairods
    Log    ${CollectionPath}
    Comment    Should Contain    ${CollectionPath}    /iplant/home/${UserName}/${NewCollName}
    Should Contain    ${CollectionPath}    The collection already exists

Rename a collection that does not exist
    [Tags]    functional
    Comment    Define variables
    Set Test Variable    ${CurColName}    NonExistCollection
    Set Test Variable    ${NewColName}    CollectionNameRenamed
    Comment    Connect and delte an existing collection
    Comment    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
    ${output}    Rename A Collection    /iplant/home/${UserName}/${CurColName}    /iplant/home/${UserName}/${NewColName}    qairods
    Log    ${output}
    Should Contain    ${output}    An error occurred

Rename a collection
    [Tags]    functional
    Comment    Define variables
    Set Test Variable    ${CurColName}    NewCollectionName
    Set Test Variable    ${NewColName}    CollectionNameRenamed
    Comment    Connect and delte an existing collection
    Comment    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
    Rename A Collection    /iplant/home/${UserName}/${CurColName}    /iplant/home/${UserName}/${NewColName}    qairods

Delete a collection
    [Tags]    functional
    Comment    Define variables
    Set Test Variable    ${CollName}    CollectionNameRenamed
    Comment    Connect and delte an existing collection
    Comment    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
    Delete A Collection    /iplant/home/${UserName}/${CollName}    False    True    qairods

Delete with recursive and not send to trash (force)
    [Tags]    functional    skipped

Delete with recursive and send to trash (no force)
    [Tags]    functional    skipped

Add a file to a collection
    [Tags]    functional    skipped
    Comment    Connect and put file
    Connect To Grid    ${irodshost}    ${irodsport}    ${UserName}    ${Password}    ${zone}
    ${output_base_filename} =    Put File Into Irods    /iplant/home/${UserName}    ${my_file}
    ${output_list} =    List Contents of Collection    /iplant/home/${UserName}
    Log    ${output_list}
    List Should Contain Value    ${output_list}    ${output_base_filename}

Rename a file
    [Tags]    functional    skipped

Delete a file from a collection
    [Tags]    functional    skipped

Batch upload files
    [Tags]    functional    skipped

List the contents of a collection
    [Tags]    functional    skipped
    Comment    Connect and list contents of path
    Connect To Grid    ${irodshost}    ${irodsport}    ${UserName}    ${Password}   ${zone}
    ${output_list} =    List Contents of Collection    /iplant/home/${UserName}
    Log    ${output_list}
    List Should Contain Value    ${output_list}    test.txt

Download a file
    [Tags]    functional    skipped
    Comment     Connect and grab file
    Connect To Grid    ${irodshost}    ${irodsport}    ${UserName}    ${Password}   ${zone}
    ${output_list} =    List Contents of Collection    /iplant/home/${UserName}
    Log    ${output_list}
    ${first_in_list} =    Get From List    ${output_list}    0
    Log    ${first_in_list}
    Get File From Irods    /iplant/home/${username}/${first_in_list}
    File Should Exist    ${first_in_list}

Download a collection
    [Tags]    functional    skipped

Connect on behalf of User
    [Tags]    functional
    Comment    Define Variables
    Set Test Variable    ${iRODSHost}    qairods.iplantcollaborative.org
    Set Test Variable    ${iRODSPort}    1247
    Set Test Variable    ${iRoDSAdminUser}    de-irods
    Set Test Variable    ${iRODSAdminPass}    SlamDunk99
    Set Test Variable    ${UserName}    ipctest
    Set Test Variable    ${Password}    1PCTest$
    Set Test Variable    ${Zone}    iplant
    Set Test Variable    ${UserZone}    iplant
    Comment    Connect to iRods Grid as de-irods on behalf of ipctest
    Connect To Grid On Behalf    ${irodshost}    ${irodsport}    ${iRODSAdminUser}    ${iRODSAdminPass}   ${Zone}    ${UserName}    ${UserZone}    qairods2
    ${output} =    Check Connection    qairods2
    Log    ${output}
    Should Be True    ${output}
    ${output_list} =    List Contents of Collection    /iplant/home/${UserName}    qairods2
    Log    ${output_list}
    List Should Contain Value    ${output_list}    /iplant/home/${UserName}/TestData_qa-3
    Disconnect From Grid    qairods2

Disconnect from a grid
    [Tags]    smoke
    Disconnect From Grid    qairods
