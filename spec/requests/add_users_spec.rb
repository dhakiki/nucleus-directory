require 'rails_helper'

describe "AddUsers", type: :request do
  it "adds a basic user" do
    visit root_path
    click_link "New User"
    fill_in "First name", with: 'Doreen'
    fill_in "Last name", with: 'Hakimi'
    click_button "Create User"
    expect(page).to have_content("User was successfully created.")
  end

  it "errors when try to add a user with no first name" do
    visit root_path
    click_link "New User"
    click_button "Create User"
    expect(page).to have_css(".user_first_name.field_with_errors")
    expect(page).to have_css(".user_last_name.field_with_errors")
  end
end
