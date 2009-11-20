Feature: API

  As a client
  I want to retrieve test and variant data
  I want retrieve a security token for use in JSON-P calls from the end user
  In order to begin running tests
  
  Scenario: An authorized client performs a GET request on /boot.json
    Given an authorized token
    When GET request /boot.json
    Then return test names
    And return variant names with visit counts
    And return a JSON-P security token
  
  Scenario: An authorized client performs a GET request on /convert.js
    Given an authorized token
    And a list of variant names
    When GET request /convert.js
    Then increment conversions for each variant
  
  Scenario: An authorized client performs a GET request on /visit.js
    Given an authorized token
    And a list of variant names
    When GET request /visit.js
    Then increment visitors for each variant
