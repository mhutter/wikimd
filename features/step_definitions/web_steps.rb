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

When(/^I select the first revision$/) do
  within(first('.history > li')) do
    check('compare[]')
  end
end

When(/^I select the last revision$/) do
  within(all('.history > li').last) do
    check('compare[]')
  end
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in(field, with: value)
end

Then(/^I should see "([^"]*)"$/) do |pattern|
  expect(page).to have_content(pattern)
end

Then(/^I should see a heading with "([^"]*)"$/) do |text|
  page.assert_selector('h1', text: text)
end
