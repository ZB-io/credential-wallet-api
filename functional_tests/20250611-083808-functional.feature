Feature: Extend Functional and Non-Functional Test Support for API Input Handling

Scenario: Verify functionality when user provides valid input for "board_type = 'none'"
  Given the API base URL 'http://localhost:3000'
  And "board_type" is set to 'none'
  When I send a POST request to '/set-board-type' with payload '{"board_type": "none", "user_input": "JIRA-1234"}'
  Then the response status should be 200
  And the response body should contain 'Input successfully processed'

Scenario: Verify behavior when no user input is provided for "board_type = 'none'"
  Given the API base URL 'http://localhost:3000'
  And "board_type" is set to 'none'
  When I send a POST request to '/set-board-type' with payload '{"board_type": "none", "user_input": ""}'
  Then the response status should be 400
  And the response body should contain 'Error: Input cannot be empty'

Scenario: Verify system validation for invalid or special character input when "board_type = 'none'"
  Given the API base URL 'http://localhost:3000'
  And "board_type" is set to 'none'
  When I send a POST request to '/validate-user-input' with payload '{"user_input": "@#*&!"}'
  Then the response status should be 422
  And the response body should contain 'Error: Invalid characters in user input'

Scenario: Verify system behavior when "board_type != 'none'"
  Given the API base URL 'http://localhost:3000'
  And "board_type" is set to 'basic'
  When I send a POST request to '/set-board-type' with payload '{"board_type": "basic"}'
  Then the response status should be 200
  And the response body should contain 'No additional input required'

Scenario: Verify behavior when a valid "board_type" is changed to 'none'
  Given the API base URL 'http://localhost:3000'
  And "board_type" is initially set to 'basic'
  When I send a POST request to '/update-board-type' with payload '{"board_type": "none"}'
  Then I send a POST request to '/set-board-type' with payload '{"board_type": "none", "user_input": "JIRA-5678"}'
  Then the response status should be 200
  And the response body should contain 'Input successfully processed'

Scenario: Verify system response time for valid user input when "board_type = 'none'"
  Given the API base URL 'http://localhost:3000'
  And "board_type" is set to 'none'
  When I send a POST request to '/set-board-type' with payload '{"board_type": "none", "user_input": "JIRA-1234"}'
  Then the response status should be 200 within 2 seconds
  And the response body should contain 'Input successfully processed'

Scenario: Verify resilience to invalid data during user input for "board_type = 'none'"
  Given the API base URL 'http://localhost:3000'
  And "board_type" is set to 'none'
  When I send multiple POST requests to '/validate-user-input' with payloads like '{"user_input": "@#123"}'
  Then the response status should consistently be 422
  And the application should not crash or affect other users

Scenario: Verify maximum character limit for the input field when "board_type = 'none'"
  Given the API base URL 'http://localhost:3000'
  And "board_type" is set to 'none'
  When I send a POST request to '/validate-user-input' with payload '{"user_input": "<300_characters_string>"}'
  Then the response status should be 400
  And the response body should contain 'Error: Input exceeds maximum length'

Scenario: Test security features of the input field for vulnerabilities like SQL Injection
  Given the API base URL 'http://localhost:3000'
  And "board_type" is set to 'none'
  When I send a POST request to '/validate-user-input' with payload '{"user_input": "DROP TABLE users;"}'
  Then the response status should be 400
  And the response body should contain 'Error: Invalid input detected'

Scenario: Verify accessibility compliance for input fields when "board_type = 'none'"
  Given the application interface for setting "board_type = 'none'"
  When I use NVDA or JAWS screen reader to navigate the input field
  Then the input field should be fully accessible
  And metadata for accessibility attributes should be present

Scenario: Verify the input box to accept comma-separated JIRA IDs
  Given the API base URL 'http://localhost:3000'
  And "board_type" is set to 'none'
  When I send a POST request to '/validate-user-input' with payload '{"user_input": "JIRA-1234, JIRA-5678"}'
  Then the response status should be 200
  And the response body should contain '[ "JIRA-1234", "JIRA-5678" ]'

Scenario: Verify handling of multiple JIRA ID entries under heavy load conditions
  Given the API base URL 'http://localhost:3000'
  And multiple users are setting "board_type = 'none'" concurrently
  When each user sends a POST request to '/set-board-type' with valid inputs like '{"user_input": "JIRA-1234"}'
  Then the response status should be 200 for all requests
  And the application should handle high traffic without performance degradation
