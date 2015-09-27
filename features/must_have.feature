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
    And a document "File.md" with content "# Hello, Web!"
    Given I visit "/File.md"
    Then I should see "<h1>Hello, Web!</h1>"

  Scenario: View revision History in web interface
    Given an empty Repository
    And I create a document "file.md" with content "old content"
    And I run "git add file.md"
    And I run "git commit -m 'added file' -- file.md"
    And I create a document "file.md" with content "new content"
    And I run "git commit -m 'updated file' -- file.md"
    When I visit "/h/file.md"
    Then I should see "History"
    And I should see "added file"
    And I should see "updated file"
