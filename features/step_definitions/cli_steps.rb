Given(/^I create a file with a history$/) do
  step %(I create a document "file.md" with content "old content")
  step %(I run "git add file.md")
  step %(I run "git commit -m 'added file' -- file.md")
  step %(I create a document "file.md" with content "new content")
  step %(I run "git commit -m 'updated file' -- file.md")
end

When(/^I run "([^"]*)"$/) do |cmd|
  o, e, s = nil
  Dir.chdir(REPO_PATH) do
    o, e, s = Open3.capture3(cmd)
  end
  fail "Error running `#{cmd}` - #{e}" unless s.success?
end
