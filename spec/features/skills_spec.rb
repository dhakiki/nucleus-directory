require 'rails_helper'

describe "Skills", js:true, type: :request do
  let (:user) { create :user }
  let (:skill) { create :skill }
  it "adds a skill to a new user" do
    visit root_path
    click_link "New User"
    fill_in "First name", with: 'Chiquita'
    fill_in "Last name", with: 'Banana'
    page.execute_script("$('#user_last_name').trigger('change')")
    click_link "Add a skill"
    fill_in "Skill", with: 'Dancing'
    find_field('Level').find('option[value="3"]').click
    click_button "Create User"
    expect(page).to have_content("User was successfully created.")
  end

  it 'edits a skill on an existing user' do
    visit root_path
    expect(page).to have_text("Will")
    first(:link, 'Show').click
    expect(page).to have_content("Name:ActingLevel:1")
    click_link "Edit"
    find_field('Level').find('option[value="5"]').click
    click_button "Update User"
    expect(page).to have_content("User was successfully updated.")
    expect(page).to have_content("Name:ActingLevel:5")
  end

  it 'removes a skill on an existing user' do
    visit root_path
    expect(page).to have_text("Will")
    first(:link, 'Show').click
    expect(page).to have_content("Name:ActingLevel:5")
    click_link "Edit"
    click_link 'Remove'
    click_button "Update User"
    expect(page).to have_content("User was successfully updated.")
    expect(page).to have_no_content("Name:ActingLevel:5")
  end
end
