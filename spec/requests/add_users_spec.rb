require 'rails_helper'

describe "AddUsers", type: :request, js:true do
  it "adds a basic user", js:true do
    visit root_path
    click_link "New User"
    fill_in "First name", with: 'Doreen'
    fill_in "Last name", with: 'Hakimi'
    page.execute_script("$('#user_last_name').trigger('change')")
    expect(find_field('Email').value).to eq 'doreen.hakimi@originate.com'
    click_button "Create User"
    expect(page).to have_content("User was successfully created.")
  end

  it "edits a basic user", js:true do
    visit root_path
    expect(page).to have_text("Will")
    first(:link, 'Edit').click
    expect(find_field('Email').value).to eq 'will.smith@originate.com'
    fill_in "First name", with: 'Jaden'
    page.execute_script("$('#user_first_name').trigger('change')")
    expect(find_field('Email').value).to eq 'jaden.smith@originate.com'
    click_button 'Update User'
    expect(page).to have_content("User was successfully updated.")
    click_link 'Back'
    expect(page).to have_text("Jaden")
    expect(page).to_not have_text("Will")
  end

  it "deletes a basic user", js:true do
    visit root_path
    expect(page).to have_text("Jaden")
    page.accept_alert do
      first(:link, 'Destroy').click
    end
    expect(page).to_not have_content("Jaden")
  end

  it "errors when try to add a user with no first name", js:true do
    visit root_path
    click_link "New User"
    click_button "Create User"
    expect(page).to have_css(".user_first_name.field_with_errors")
    expect(page).to have_css(".user_last_name.field_with_errors")
    expect(page).to have_css(".user_email.field_with_errors")
  end
end
