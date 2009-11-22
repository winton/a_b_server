Feature: API

  As an application
  I want to retrieve test and variant data
  I want retrieve a security token for use in JSON-P calls from the end user
  In order to begin running tests
  
  Scenario: An authorized application performs a GET request on /boot.json
    Given a user exists for the application
    And the application has an authorized single access token
    And test data exists
    When the application requests /boot.json (GET)
    Then respond with test names
    And respond with variant names with visit counts
    And respond with a JSON-P security token
  
  Scenario: An authorized application performs a GET request on /convert.js
    Given the application provides an authorized session id/token combination
    And the application provides a list of variant names
    And test data exists
    When the application requests /convert.js (GET)
    Then increment conversions for each variant
  
  Scenario: An authorized application performs a GET request on /visit.js
    Given the application provides an authorized session id/token combination
    And the application provides a list of variant names
    And test data exists
    When the application requests /visit.js (GET)
    Then increment visitors for each variant
