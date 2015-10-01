Feature: Should-have Features

  Scenario: Edit a Document on the web interface
    Given an empty Repository
    And I create a document "file.md" with content "old content"
    And I run "git add file.md"
    And I run "git commit -m 'added file' -- file.md"
    When I visit "/file.md"
    And I click "Edit"
    And I fill in "content" with "new content"
    And I click "Save"
    Then I should see "new content"
    And I should see "has been saved"
    And the repo should have a file "file.md" with content "new content"
    And the history for "file.md" should have 2 entries.
