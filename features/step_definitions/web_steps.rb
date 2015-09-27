Given(/^I visit "([^"]*)"$/) do |url|
  visit url
end

When(/^I click "([^"]*)"$/) do |link|
  click_on(link)
end

Then(/^I should see "([^"]*)"$/) do |pattern|
  expect(page).to have_content(pattern)
end
