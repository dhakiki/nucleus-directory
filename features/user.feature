Feature: User

  Scenario: Add a Basic User
    Given A User is in the application
    When she creates a basic user
    Then a user should be added

  Scenario: Edits a Basic User
    Given A User exists in the database
    When A User is in the application
    And she edits a basic user
    Then the user should be updated

  Scenario: Deletes a Basic User
    Given A User exists in the database
    When A User is in the application
    And she deletes a basic user
    Then the user should be deleted

  Scenario: Fails when creating a user without required fields
    Given A User is in the application
    When she attempts to create a user with no name
    Then she fails to create a new user

  Scenario: Email generator fails with only first name
    Given A User is in the application
    When she enters a first name only
    Then the email is still not populated

  Scenario: Email generator fails with only last name
    Given A User is in the application
    When she enters a first name only
    Then the email is still not populated

  Scenario: Creating a subordinate of a supervisor
    Given A User exists in the database
    When A User is in the application 
    And she creates a new subordinate
    Then a user should be added
    And she appears to report to her superior

  Scenario: Changing a subordinate's supervisor
    Given A User exists in the database
    And A Second User exists in the database
    And A Subordinate exists in the database
    And she appears to report to her superior
    When A User is in the application
    And she changes a user's supervisor
    Then the user should be updated
    And she appears to report to her new superior

  Scenario: Updating supervisor's name
    Given A User exists in the database
    And A Subordinate exists in the database
    And she appears to report to her superior
    When A User is in the application
    And she edits a basic user
    Then the user should be updated
    And the subordinate appears to report to her updated superior

  Scenario: Deletes a supervisor updates subordinate properly
    Given A User exists in the database
    And A Subordinate exists in the database
    And she appears to report to her superior
    When A User is in the application
    And she deletes a basic user
    Then the user should be deleted
    And the subordinate appears to report to no one
