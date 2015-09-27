Given(/^I visit "([^"]*)"$/) do |url|
  get url
end

Then(/^I should see "([^"]*)"$/) do |pattern|
  expect(last_response.body).to match(pattern)
end
