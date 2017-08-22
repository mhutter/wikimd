Given(/^an empty Repository$/) do
  REPO_PATH.rmtree if REPO_PATH.exist?
  REPO_PATH.mkpath
  # initialize the git repo
  step 'I run "git init"'
  step 'I run "git config commit.gpgsign false"'
  @repo = WikiMD::Repository.new(REPO_PATH)
end

Given(/^a document "([^"]*)" with content "([^"]*)"$/) do |file, content|
  REPO_PATH.join(file).write(content)
end

When(/^I create a document "([^"]*)" with content "([^"]*)"$/) do |file, content|
  REPO_PATH.join(file).write(content)
end

Then(/^the repo should have a file "([^"]*)" with content "([^"]*)"$/) do |file, content|
  expect(REPO_PATH.join(file).read).to eq content
end

Then(/^the history for "([^"]*)" should have (\d+) entries\.$/) do |file, count|
  expect(@repo.history(file).length).to eq count.to_i
end
