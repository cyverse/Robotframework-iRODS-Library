*** Settings ***
Library           PythoniRODSKeywords
Library           Collections
Library           OperatingSystem

*** Variables ***
${irodshost}      host_here
${irodsport}      1247
${username}       username_here
${password}       password_here
${zone}           zone_here

${my_file}        test.txt

*** Test Cases ***
Connect-Not-Valid
    Comment    Connect to iRods Grid
    ${output} =    Check Connection
    Should Not Be True    ${output}

Connect-Valid
    Comment    Connect to iRods Grid
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}   ${zone}
    ${output} =    Check Connection
    Should Be True    ${output}

Connect-Disconnect
    Comment    Connect and disconnect to iRods Grid
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}   ${zone}
    Disconnect From Grid
    ${output} =    Check Connection
    Should Not Be True    ${output}

List-Contents-Of-Path
    Comment    Connect and list contents of path
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}   ${zone}
    ${output_list} =        List Contents of Directory    /iplant/home/${username}
    List Should Contain Value     ${output_list}    TestOutFile1

Get-File
    Comment     Connect and grab file
    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}   ${zone}
    ${output_list}=         List Contents of Directory    /iplant/home/${username}
    ${first_in_list}=       Get From List           ${output_list}    0
    Get File From Irods    /iplant/home/${username}/${first_in_list} 
    File Should Exist       ${first_in_list}    

#Put-File
#    Comment    Connect and put file
#    Connect To Grid    ${irodshost}    ${irodsport}    ${username}    ${password}   ${zone}
#    Put File           /iplant/home/${username}    ${my_file}
#    ${output_list} =        List Contents of Directory    /iplant/home/${username}  ${my_file}
#    List Should Contain Value     ${output_list}    ${my_file}
