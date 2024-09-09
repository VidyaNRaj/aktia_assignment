*** Settings ***
Library      RequestsLibrary
Library      JSONLibrary
Library      String
Library      SeleniumLibrary


*** Variables ***
${BASE_URL}             https://www.quickpickdeal.com/api
${REGISTER_ENDPOINT}    /auth/registration
&{headers}              Content-Type=application/json;charset=utf-8


*** Test Cases ***
Register New User with valid email and password   #Valid email and password
    Create Session  mysession  ${BASE_URL}
    ${random_string}=      Generate Random String  10  [LETTERS]
    
    # Create random email id's
    ${email}=  Set Variable  testuser${random_string}@example.com
    ${register_response}=  Post On Session  mysession  ${REGISTER_ENDPOINT}  data={"email": "${email}", "fullName": "test user", "phoneNumber": "9415128845", "password": "12345", "confirmPassword": "12345"}  headers=${headers}
    
    # Validations
    Should Be Equal As Strings  ${register_response.status_code}  200
    ${json_response}=  To Json  ${register_response.content}

    Should Be True   $json_response['Success']
    Should Be Equal  ${json_response['Error']}  ${NONE}
    ${expected_data}=  Create Dictionary  Id=5136  Email=${email}  FullName=test user  PhoneNumber=9415128845
    Should Be Equal  ${json_response['Data']['Email']}  ${expected_data['Email']}
    Should Be Equal  ${json_response['Data']['FullName']}  ${expected_data['FullName']}
    Should Be Equal  ${json_response['Data']['PhoneNumber']}  ${expected_data['PhoneNumber']}
    
    

  


