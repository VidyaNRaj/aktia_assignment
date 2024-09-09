*** Settings ***
Library      RequestsLibrary
Library      JSONLibrary
Library      String


*** Variables ***
${BASE_URL}              https://www.quickpickdeal.com/api
${REGISTER_ENDPOINT}     /auth/registration
${LOGIN_ENDPOINT}        /auth/login
&{headers}      Content-Type=application/json;charset=utf-8
${errorMessage}=    {'Email': ['The Email field is required.', 'The Email field is not a valid e-mail address.']}
${title}=            One or more validation errors occurred.


*** Test Cases ***
Registration with empty email and valid password
    Create Session    mysession  ${BASE_URL} 
    ${register_response}=  Post On Session  mysession  ${REGISTER_ENDPOINT}  data={"email": "", "fullName": "test user", "phoneNumber": "9415128845", "password": "12345", "confirmPassword": "12345"}  headers=${headers}    expected_status=400
    ${json_response}=  To Json  ${register_response.content}
    ${json_response_string}    Convert To String    ${json_response['errors']}

    #Validations
    Should Be Equal    ${json_response_string}    ${errorMessage}
    Should Be Equal    ${json_response['title']}    ${title}
    



