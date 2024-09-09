*** Settings ***
Library      RequestsLibrary
Library      JSONLibrary
Library      String
Library      SeleniumLibrary


*** Variables ***
${BASE_URL}  https://www.quickpickdeal.com/api
${REGISTER_ENDPOINT}  /auth/registration
&{headers}      Content-Type=application/json;charset=utf-8
${errorMessage}=    Email already in use. please log in instead


*** Test Cases ***
Register with existing email id   #Valid email and password
    Create Session  mysession  ${BASE_URL}
    ${random_string}=      Generate Random String  10  [LETTERS]
    # Create random email id's
    ${email}=  Set Variable  testuser${random_string}@example.com

    ${register_response}=  Post On Session  mysession  ${REGISTER_ENDPOINT}  data={"email": "${email}", "fullName": "test user", "phoneNumber": "9415128845", "password": "12345", "confirmPassword": "12345"}  headers=${headers}
    ${response_existingEmail}=  Post On Session  mysession  ${REGISTER_ENDPOINT}  data={"email": "${email}", "fullName": "test user", "phoneNumber": "9415128845", "password": "12345", "confirmPassword": "12345"}  headers=${headers}

    # Validations
    Should Be Equal As Strings  ${register_response.status_code}  200
    ${json_response}=  To Json  ${response_existingEmail.content}

    Should Not Be True   ${json_response['Success']}
    Should Be Equal      ${json_response['Data']}  ${NONE}
    Should Be Equal      ${json_response['Error']}  ${errorMessage}

    

  


