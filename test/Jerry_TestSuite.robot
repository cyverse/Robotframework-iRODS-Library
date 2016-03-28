*** Settings ***
Library           iRODSLibrary

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
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}   ${zone}
    ${output} =    Check Connection
    Log    ${output}
    Should Be True    ${output}

Create a collection
    [Tags]    functional
    Comment    Define variables
    Set Test Variable    ${NewCollName}    NewCollectionName
    Comment    Connect and create a new collection
    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
    ${CollectionID} =    Create A Collection    /iplant/home/${UserName}/${NewCollName}

Rename a collection
    [Tags]    functional
    Comment    Define variables
    Set Test Variable    ${CurColName}    NewCollectionName
    Set Test Variable    ${NewColName}    CollectionNameRenamed
    Comment    Connect and delte an existing collection
    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
    Rename A Collection    /iplant/home/${UserName}/${CurColName}    /iplant/home/${UserName}/${NewColName}

Delete a collection
    [Tags]    functional
    Comment    Define variables
    Set Test Variable    ${CollName}    CollectionNameRenamed
    Comment    Connect and delte an existing collection
    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
    Delete A Collection    /iplant/home/${UserName}/${CollName}    False    True

Delete with recursive and not send to trash (force)
    [Tags]    functional    skipped

Delete with recursive and send to trash (no force)
    [Tags]    functional    skipped

Add a file to a collection
    [Tags]    functional    skipped
    Comment    Connect and put file
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}    ${zone}
    ${output_base_filename} =    Put File Into Irods    /iplant/home/${username}    ${my_file}
    ${output_list} =    List Contents of Collection    /iplant/home/${username}
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
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}   ${zone}
    ${output_list} =    List Contents of Collection    /iplant/home/${username}
    Log    ${output_list}
    List Should Contain Value    ${output_list}    test.txt

Download a file
    [Tags]    functional    skipped
    Comment     Connect and grab file
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}   ${zone}
    ${output_list} =    List Contents of Collection    /iplant/home/${username}
    Log    ${output_list}
    ${first_in_list} =    Get From List    ${output_list}    0
    Log    ${first_in_list}
    Get File From Irods    /iplant/home/${username}/${first_in_list}
    File Should Exist    ${first_in_list}

Download a collection
    [Tags]    functional    skipped
