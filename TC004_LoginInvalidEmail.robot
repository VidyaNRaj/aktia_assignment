*** Settings ***
Library      RequestsLibrary
Library      JSONLibrary
Library      String


*** Variables ***
${BASE_URL}           https://www.quickpickdeal.com/api
${REGISTER_ENDPOINT}  /auth/registration
${LOGIN_ENDPOINT}     /auth/login
&{headers}            Content-Type=application/json;charset=utf-8
${EmailMessage}=    {'Email': ['The Email field is not a valid e-mail address.']}
${title}=            One or more validation errors occurred.


*** Test Cases ***
Login Function with Invalid Email and Valid password
    Create Session  mysession  ${BASE_URL}
    ${random_string}=      Generate Random String  10  [LETTERS]
    # Create random email id's
    ${email}=  Set Variable  testuser${random_string}@example.com
 
    ${register_response}=         Post On Session  mysession  ${REGISTER_ENDPOINT}  data={"email": "${email}", "fullName": "test user", "phoneNumber": "9415128845", "password": "12345", "confirmPassword": "12345"}  headers=${headers}
    ${login_response}=    POST On Session  mysession  ${LOGIN_ENDPOINT}     data={"email": "testingCase", "password": "12345"}    headers=${headers}    expected_status=400

    ${LoginInvalidResp}=       To Json    ${login_response.content}
    ${json_response_string}    Convert To String    ${LoginInvalidResp['errors']}

    # Validations
    Should Be Equal    ${json_response_string}         ${EmailMessage}
    Should Be Equal    ${LoginInvalidResp['title']}    ${title}

    

    