*** Settings ***
Library      RequestsLibrary
Library      JSONLibrary
Library      String


*** Variables ***
${BASE_URL}              https://www.quickpickdeal.com/api
${REGISTER_ENDPOINT}     /auth/registration
${LOGIN_ENDPOINT}        /auth/login
&{headers}              Content-Type=application/json;charset=utf-8
${errorMessage}=    {'Password': ['The Password field is required.', 'The Password must be at least 5 characters long.']}
${title}=           One or more validation errors occurred.


*** Test Cases ***
Login with empty password and valid email
    Create Session    mysession  ${BASE_URL} 
    ${random_string}=      Generate Random String  10  [LETTERS]
    # Create random email id's
    ${email}=  Set Variable  testuser${random_string}@example.com

    ${login_response}=          Post On Session  mysession  ${LOGIN_ENDPOINT}  data={"email": "${email}", "fullName": "test user", "phoneNumber": "9415128845", "password": "", "confirmPassword": ""}  headers=${headers}    expected_status=400
    ${json_response}=    To Json  ${login_response.content}
    ${json_response_string}    Convert To String    ${json_response['errors']}

    #Validations
    Should Be Equal    ${json_response_string}    ${errorMessage}
    Should Be Equal    ${json_response['title']}    ${title}
    



