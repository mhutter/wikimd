When(/^I run "([^"]*)"$/) do |cmd|
  o, e, s = nil
  Dir.chdir(REPO_PATH) do
    o, e, s = Open3.capture3(cmd)
  end
  fail "Error running `#{cmd}` - #{e}" unless s.success?
end
