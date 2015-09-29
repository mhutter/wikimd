Feature: Must-Have features

  Scenario: Create documents on FS
    Given an empty Repository
    When I create a document "My File.md" with content "# Hello, World!"
    Then the repo should have a file "My File.md" with content "# Hello, World!"

  Scenario: Edit document on FS
    Given an empty Repository
    When I create a document "file.md" with content "old content"
    And I run "git add file.md"
    And I run "git commit -m 'added file' -- file.md"
    And I create a document "file.md" with content "new content"
    And I run "git commit -m 'updated file' -- file.md"
    Then the repo should have a file "file.md" with content "new content"
    And the history for "file.md" should have 2 entries.

  Scenario: View Documents on the web interface
    Given an empty Repository
    And a document "File.txt" with content "Hello, Web!"
    Given I visit "/File.txt"
    Then I should see "Hello, Web!"

  Scenario: View revision History in web interface
    Given an empty Repository
    And I create a file with a history
    When I visit "/file.md"
    And I click "History"
    Then I should see "History"
    And I should see "added file"
    And I should see "updated file"

  Scenario: Display an old revision in web interface
    Given an empty Repository
    And I create a file with a history
    When I visit "/file.md"
    And I click "History"
    And I click the last revision
    Then I should see "old conten"
    And I should see "Displaying file at rev."

  Scenario: Formatting with Markdown
    Given an empty Repository
    And I create a document "syntax.md" with content "# Hello, Markdown!"
    When I visit "/syntax.md"
    Then I should see a heading with "Hello, Markdown!"
    # Details about Markdown formatting see "spec/wikimd/renderer_spec.rb"
