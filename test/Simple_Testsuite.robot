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
${my_file}        ../../test/put_test.txt

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
    [Tags]    functional    skipped
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
