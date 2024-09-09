*** Settings ***
Library  RequestsLibrary
Library  JSONLibrary
Library  String


*** Variables ***
${BASE_URL}  https://www.quickpickdeal.com/api
${REGISTER_ENDPOINT}  /auth/registration
${LOGIN_ENDPOINT}   /auth/login
&{headers}      Content-Type=application/json;charset=utf-8
${expect_result}=    {'Password': ['The Password must be at least 5 characters long.'], 'ConfirmPassword': ["'ConfirmPassword' and 'Password' do not match."]}
${title}=    One or more validation errors occurred.


*** Test Cases ***
Register with Invalid Password and valid Email
    Create Session  mysession  ${BASE_URL} 
    ${random_string}=      Generate Random String  10  [LETTERS]
    # Create random email id's
    ${email}=  Set Variable  testuser${random_string}@example.com
    
    ${register_response}=  Post On Session  mysession  ${REGISTER_ENDPOINT}  data={"email": "${email}", "fullName": "test user", "phoneNumber": "9415128845", "password": "123", "confirmPassword": "12345"}  headers=${headers}    expected_status=400
    ${json_response}=  To Json  ${register_response.content}
    ${json_response_string}    Convert To String    ${json_response['errors']}

    #Validations
    Should Be Equal    ${json_response_string}    ${expect_result}
    Should Be Equal    ${json_response['title']}    ${title}
    



