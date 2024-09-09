*** Settings ***
Library      RequestsLibrary
Library      JSONLibrary
Library      String


*** Variables ***
${BASE_URL}              https://www.quickpickdeal.com/api
${REGISTER_ENDPOINT}     /auth/registration
${LOGIN_ENDPOINT}        /auth/login
&{headers}               Content-Type=application/json;charset=utf-8


*** Test Cases ***
Login Function with AlphaNumeric email and password
    Create Session  mysession  ${BASE_URL}
    ${random_string}=      Generate Random String  10  [LETTERS]
    # Create random email id's
    ${email}=  Set Variable  testuser1234${random_string}@example.com

    ${register_response}=         Post On Session  mysession  ${REGISTER_ENDPOINT}  data={"email": "${email}", "fullName": "test user", "phoneNumber": "9415128845", "password": "12as345", "confirmPassword": "12as345"}  headers=${headers}
    ${login_response}=    POST On Session  mysession  ${LOGIN_ENDPOINT}     data={"email": "${email}", "password": "12as345"}    headers=${headers}

    Should Be Equal As Strings  ${login_response.status_code}  200
    ${loginjson_response}=  To Json  ${login_response.content}

    # Validations
    Should Be True   $loginjson_response['Success']
    Should Be Equal  ${loginjson_response['Error']}  ${NONE}
    ${expected_data}=  Create Dictionary  Id=5136  Email=${email}  FullName=test user  PhoneNumber=9415128845
    Should Be Equal  ${loginjson_response['Data']['Email']}  ${expected_data['Email']}
    Should Be Equal  ${loginjson_response['Data']['FullName']}  ${expected_data['FullName']}
    Should Be Equal  ${loginjson_response['Data']['PhoneNumber']}  ${expected_data['PhoneNumber']}
    




