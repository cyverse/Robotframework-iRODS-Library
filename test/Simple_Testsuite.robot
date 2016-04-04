*** Settings ***
Library           iRODSLibrary
Library           Collections
Library           OperatingSystem

*** Variables ***
${irodshost}      host_here
${irodsport}      1247
${username}       username_here
${password}       password_here
${zone}           zone_here
${my_file}        test/put_test.txt
${put_directory}  test/put_dir

*** Test Cases ***
Connect-Not-Valid
    [Tags]    functional
    Comment    Connect to iRods Grid
    ${output} =    Check Connection
    Log    ${output}
    Should Not Be True    ${output}

Connect-Valid
    [Tags]    smoke
    Comment    Connect to iRods Grid
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}   ${zone}
    ${output} =    Check Connection
    Log    ${output}
    Should Be True    ${output}

Connect-Disconnect
    [Tags]    smoke
    Comment    Connect and disconnect to iRods Grid
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}   ${zone}
    Disconnect From Grid
    ${output} =    Check Connection
    Log    ${output}
    Should Not Be True    ${output}

List-Contents-Of-Path
    [Tags]    smoke
    Comment    Connect and list contents of path
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}   ${zone}
    ${output_list} =    List Contents of Collection    /iplant/home/${username}
    Log    ${output_list}
    List Should Contain Value    ${output_list}    test.txt

Get-File
    [Tags]    functional
    Comment     Connect and grab file
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}   ${zone}
    ${output_list} =    List Contents of Collection    /iplant/home/${username}
    Log    ${output_list}
    ${first_in_list} =    Get From List    ${output_list}    0
    Log    ${first_in_list}
    Get File From Irods    /iplant/home/${username}/${first_in_list}
    File Should Exist    ${first_in_list}

Put-File
    [Tags]    functional
    Comment    Connect and put file
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}    ${zone}
    ${output_base_filename} =    Put File Into Irods    /iplant/home/${username}    ${my_file}
    ${output_list} =    List Contents of Collection    /iplant/home/${username}
    Log    ${output_list}
    List Should Contain Value    ${output_list}    ${output_base_filename}

Delete-File
    [Tags]    functional
    Comment    Connect, put file, then delete
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}    ${zone}
    ${output_base_filename} =    Put File Into Irods    /iplant/home/${username}    ${my_file}
    ${output_list} =    List Contents of Collection    /iplant/home/${username}
    Log    ${output_list}
    List Should Contain Value    ${output_list}    ${output_base_filename}
    Delete_File_From_Irods    /iplant/home/${username}/${output_base_filename}
    ${output_list} =    List Contents of Collection    /iplant/home/${username}
    Log    ${output_list}
    List Should Not Contain Value    ${output_list}    ${output_base_filename}

Add-Metadata-For-File
    [Tags]    functional
    Comment    Connect and add metadata for first file in collection
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}    ${zone}
    ${collection_list} =    List Contents of Collection    /iplant/home/${username}
    Log    ${collection_list}
    ${first_in_list} =    Get From List    ${collection_list}    0
    Log    ${first_in_list}
    Add Metadata For File   /iplant/home/${username}/${first_in_list}    key_1    value_1
    ${metadata_list} =    Get Metadata For File   /iplant/home/${username}/${first_in_list}
    Log    ${metadata_list}
    List Should Contain Value    ${metadata_list}    key_1 

Add-Metadata-For-Collection
    [Tags]    functional
    Comment    Connect and add metadata for first file in collection
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}    ${zone}
    ${collection_list} =    List Contents of Collection    /iplant/home/${username}
    Log    ${collection_list}
    ${first_in_list} =    Get From List    ${collection_list}    0
    Log    ${first_in_list}
    Add Metadata For Collection   /iplant/home/${username}/analyses    key_1    value_1
    ${metadata_list} =    Get Metadata For Collection   /iplant/home/${username}/analyses
    Log    ${metadata_list}
    List Should Contain Value    ${metadata_list}    key_1 

Retrieve-Metadata-For-File
    [Tags]    functional
    Comment    Connect and grab metadata from first file in collection
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}    ${zone}
    ${collection_list} =    List Contents of Collection    /iplant/home/${username}
    Log    ${collection_list}
    ${first_in_list} =    Get From List    ${collection_list}    0
    Log    ${first_in_list}
    ${metadata_list} =    Get Metadata For File   /iplant/home/${username}/${first_in_list}
    Log    ${metadata_list}
    List Should Contain Value    ${metadata_list}    ipc_UUID

Retrieve-Metadata-For-Directory
    [Tags]    functional
    Comment    Connect and grab metadata from first file in collection
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}    ${zone}
    ${metadata_list} =    Get Metadata For Collection   /iplant/home/${username}/analyses
    Log    ${metadata_list}
    List Should Contain Value    ${metadata_list}    ipc_UUID

Put-Directory
    [Tags]    functional
    Comment    Connect and put directory
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}    ${zone}
    ${output_base_directory_name} =    Put Directory Into Irods    /iplant/home/${username}    ${put_directory}
    Log    ${output_base_directory_name}
    ${output_list} =    List Contents of Collection    /iplant/home/${username}
    Log    ${output_list}
    List Should Contain Value    ${output_list}    /iplant/home/${username}/${output_base_directory_name}

Get-Directory
    [Tags]    functional
    Comment     Connect and grab file
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}   ${zone}
    Get Directory From Irods    /iplant/home/${username}/analyses
    Directory Should Exist    analyses
    Directory Should Not Be Empty    analyses

Create a collection
    [Tags]    functional
    Comment    Define variables
    Set Test Variable    ${NewCollName}    NewCollectionName
    Comment    Connect and create a new collection
    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
    ${CollectionID} =    Create A Collection    /iplant/home/${UserName}/${NewCollName}


#Attempt to Create a collection that already exists
#    [Tags]    regression
#    Comment    Define variables
#    Set Test Variable    ${NewCollName}    NewCollectionName
#    Comment    Connect and create a new collection
#    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
#    ${CollectionID} =    Create A Collection    /iplant/home/${UserName}/${NewCollName}
#    Should Contain    ${CollectionID}    Error message about already existing collection
#
#Rename a collection
#    [Tags]    functional
#    Comment    Define variables
#    Set Test Variable    ${CurColName}    NewCollectionName
#    Set Test Variable    ${NewColName}    CollectionNameRenamed
#    Comment    Connect and delte an existing collection
#    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
#    Rename A Collection    /iplant/home/${UserName}/${CurColName}    /iplant/home/${UserName}/${NewColName}
#
#Rename a collection that doesn't exist
#    [Tags]    regression
#    Comment    Define variables
#    Set Test Variable    ${CurColName}    NonExistantCollectionName
#    Set Test Variable    ${NewColName}    ShouldNeverExistCollectionName
#    Comment    Connect and delte an existing collection
#    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
#    Rename A Collection    /iplant/home/${UserName}/${CurColName}    /iplant/home/${UserName}/${NewColName}
#    Comment    Trap for error message being returned
#    Should Contain    ${output}    Error message about collection not existing
#
#Delete a collection
#    [Tags]    functional
#    Comment    Define variables
#    Set Test Variable    ${CollName}    CollectionNameRenamed
#    Comment    Connect and delte an existing collection
#    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
#    Delete A Collection    /iplant/home/${UserName}/${CollName}    False    True
#
#Delete a collection that doesn't exist
#    [Tags]    regression
#    Comment    Define variables
#    Set Test Variable    ${CollName}    NonExistantCollectionName
#    Comment    Connect and delte an existing collection
#    Connect To Grid    ${iRODSHost}    ${iRODSPort}    ${UserName}    ${Password}    ${Zone}
#    Delete A Collection    /iplant/home/${UserName}/${CollName}    False    True
#    Comment    Trap for error message being returned
#    Should Contain    ${output}    Error message about collection not existing
