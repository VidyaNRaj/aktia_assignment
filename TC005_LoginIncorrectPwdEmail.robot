*** Settings ***
Library      RequestsLibrary
Library      JSONLibrary
Library      String


*** Variables ***
${BASE_URL}              https://www.quickpickdeal.com/api
${REGISTER_ENDPOINT}     /auth/registration
${LOGIN_ENDPOINT}        /auth/login
&{headers}               Content-Type=application/json;charset=utf-8
${ErrorMessage}=    Please check your credentail, Invalid username or password. Please try again


*** Test Cases ***
Login Function with Incorrect password and email
    Create Session  mysession  ${BASE_URL}
    ${random_string}=      Generate Random String  10  [LETTERS]
    # Create random email id's
    ${email}=  Set Variable  testuser${random_string}@example.com
   
    ${register_response}=         Post On Session  mysession  ${REGISTER_ENDPOINT}  data={"email": "${email}", "fullName": "test user", "phoneNumber": "9415128845", "password": "12345", "confirmPassword": "12345"}  headers=${headers}
    ${login_response}=    POST On Session  mysession  ${LOGIN_ENDPOINT}     data={"email": "abc@test.com", "password": "12225"}    headers=${headers}
    ${LoginInvalidResp}=    To Json    ${login_response.content}

    # Validations
    Should Not Be True    ${LoginInvalidResp['Success']}
    Should Be Equal       ${LoginInvalidResp['Error']}  ${ErrorMessage}
    Should Be Equal       ${LoginInvalidResp['Data']}   ${None}

    

    