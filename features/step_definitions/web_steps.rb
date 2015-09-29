Given(/^I visit "([^"]*)"$/) do |url|
  visit url
end

When(/^I click "([^"]*)"$/) do |link|
  click_on(link)
end

When(/^I click the last revision$/) do
  within('.history') do
    all(:link).last.click
  end
  end

Then(/^I should see "([^"]*)"$/) do |pattern|
  expect(page).to have_content(pattern)
end

Then(/^I should see a heading with "([^"]*)"$/) do |text|
  page.assert_selector('h1', text: text)
end
