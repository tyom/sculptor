Feature: Run `create` command
  In order to create new models

  Scenario: Create a new model scaffold
    Given I run `sculptor create test` interactively
    Then I wait for output to contain "Creating model: source/test"
    And I wait for output to contain "Title"
    Then I hit enter
    And I wait for output to contain "Description"
    Then I hit enter
    And I wait for output to contain "Stylesheet"
    Then I hit enter
    And I wait for output to contain "Use iframe?"
    Then I type "n"
    And I wait for output to contain "Include data?"
    Then I type "n"
    And the exit status should be 0
    Then the output should contain "create"

  Scenario: Create a new model scaffold and set meta data
    Given I run `sculptor create test` interactively
    Then I wait for output to contain "Creating model: source/test"
    And I wait for output to contain "Title"
    Then I type "Hello World"
    And I wait for output to contain "Description"
    Then I type "My model description"
    And I wait for output to contain "Stylesheet"
    Then I type "styles"
    And I wait for output to contain "Use iframe?"
    Then I type "n"
    And I wait for output to contain "Include data?"
    Then I type "y"
    And the exit status should be 0
    Then the output should contain "create"
    And a directory named "source/test" should exist
    Then the file "source/test/test.html.slim" should contain "Hello World"
    And the file "source/test/test.html.slim" should contain "My model description"
    And the file "source/test/index.html.slim" should contain "'partials/glyptotheque/model-index'"
    And the file "source/test/test.yaml" should contain "hello: World"
    And the file "source/test/styles.scss" should contain "@import 'bourbon'"
