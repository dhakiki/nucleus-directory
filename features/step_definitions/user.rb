Given(/^A User is in the application$/) do
  visit root_path
end

Given(/^A User exists in the database$/) do
  user = FactoryGirl.create(:user, first_name: 'Donald', last_name: 'Trump', full_name: 'Donald Trump', email: 'donald.trump@originate.com')
end

Given(/^A Second User exists in the database$/) do
  other_user = FactoryGirl.create(:user, first_name: 'Will', last_name: 'Smith', full_name: 'Will Smith', email: 'will.smith@originate.com')
end

When(/^she creates a basic user$/) do
  click_link "New User"
  fill_in "First name", with: 'Doreen'
  fill_in "Last name", with: 'Hakimi'
  page.execute_script("$('#user_first_name').trigger('change')")
  click_button "Create User"
end

Then(/^a user should be added$/) do
  expect(page).to have_content("User was successfully created.")
end

When(/^she edits a basic user$/) do
  within('tr[data-uuid="donald.trump@originate.com"]') do
    click_on('Edit')
  end
  expect(find_field('Email').value).to eq 'donald.trump@originate.com'
  fill_in "First name", with: 'President'
  page.execute_script("$('#user_first_name').trigger('change')")
  click_button 'Update User'
end

Then(/^the user should be updated$/) do
  expect(page).to have_content("User was successfully updated.")
end

When(/^she deletes a basic user$/) do
  page.accept_alert do
    within('tr[data-uuid="donald.trump@originate.com"]') do
      click_on('Destroy')
    end
  end
end

Then(/^the user should be deleted$/) do
  expect(page).to_not have_content("Donald")
end

When(/^she attempts to create a user with no name$/) do
  click_link "New User"
  click_button "Create User"
end

Then(/^she fails to create a new user$/) do
  expect(page).to have_css(".user_first_name.field_with_errors")
  expect(page).to have_css(".user_last_name.field_with_errors")
  expect(page).to have_css(".user_email.field_with_errors")
end

When(/^she enters a first name only$/) do
  click_link "New User"
  fill_in "First name", with: 'Doreen'
  page.execute_script("$('#user_first_name').trigger('change')")
end

When(/^she enters a last name only$/) do
  click_link "New User"
  fill_in "Last Name", with: 'Hakimi'
  page.execute_script("$('#user_last_name').trigger('change')")
end

Then(/^the email is still not populated$/) do
  expect(find_field('Email').value).to eq ''
end

When(/^she creates a new subordinate$/) do
  click_link "New User"
  fill_in "First name", with: 'Ivana'
  fill_in "Last name", with: 'Trump'
  page.execute_script("$('#user_first_name').trigger('change')")
  fill_in "Supervisor name", with: "Donald Trump"
  click_button 'Create User'
end

Then(/^she appears to report to her superior$/) do
  visit root_path
  within('tr[data-uuid="ivana.trump@originate.com"]') do
    click_on('Show')
  end
  expect(page).to have_content("Reporting to:Donald Trump")
  click_link "Donald Trump"
  expect(page).to have_content("donald.trump@originate.com")
  expect(User.find_by(email: 'donald.trump@originate.com').subordinates.length).to be 1
end

When(/^A Subordinate exists in the database$/) do
  subordinate = FactoryGirl.create(:user, first_name: 'Ivana', last_name: 'Trump', full_name: 'Ivana Trump', email: 'ivana.trump@originate.com', supervisor_name: 'Donald Trump', supervisor_id: 1)
end

When(/^she changes a user\'s supervisor$/) do
  within('tr[data-uuid="ivana.trump@originate.com"]') do
    click_on('Edit')
  end
  fill_in 'Supervisor name', with: 'Will Smith'
  click_button 'Update User'
end

Then(/^she appears to report to her new superior$/) do
  visit root_path
  within('tr[data-uuid="ivana.trump@originate.com"]') do
    click_on('Show')
  end
  expect(page).to have_content("Reporting to:Will Smith")
  expect(page).to_not have_content("Reporting to:Donald Trump")
  click_link "Will Smith"
  expect(page).to have_content("will.smith@originate.com")
  expect(User.find_by(email: 'donald.trump@originate.com').subordinates.length).to be 0
  expect(User.find_by(email: 'will.smith@originate.com').subordinates.length).to be 1
end

Then(/^the subordinate appears to report to her updated superior$/) do
  visit root_path
  within('tr[data-uuid="ivana.trump@originate.com"]') do
    click_on('Show')
  end
  expect(page).to have_content("Reporting to:President Trump")
  expect(page).to_not have_content("Reporting to:Donald Trump")
end

Then(/^the subordinate appears to report to no one$/) do
  visit root_path
  within('tr[data-uuid="ivana.trump@originate.com"]') do
    click_on('Show')
  end
  expect(page).to_not have_content("Reporting to:Donald Trump")
  expect(User.find_by(email: 'ivana.trump@originate.com').supervisor).to eq nil
end
