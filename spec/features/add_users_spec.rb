require 'rails_helper'

describe "AddUsers", type: :request, js:true do
  it "adds a basic user" do
    visit root_path
    click_link "New User"
    fill_in "First name", with: 'Doreen'
    fill_in "Last name", with: 'Hakimi'
    page.execute_script("$('#user_last_name').trigger('change')")
    expect(find_field('Email').value).to eq 'doreen.hakimi@originate.com'
    click_button "Create User"
    expect(page).to have_content("User was successfully created.")
  end

  it "edits a basic user" do
    visit root_path
    expect(page).to have_text("Donald")
    within('tr[data-uuid="donald.trump@originate.com"]') do
      click_on('Edit')
    end
    expect(find_field('Email').value).to eq 'donald.trump@originate.com'
    fill_in "First name", with: 'President'
    page.execute_script("$('#user_first_name').trigger('change')")
    expect(find_field('Email').value).to eq 'president.trump@originate.com'
    click_button 'Update User'
    expect(page).to have_content("User was successfully updated.")
    click_link 'Back'
    expect(page).to have_text("President")
    expect(page).to_not have_text("Donald")
  end

  it "deletes a basic user" do
    visit root_path
    page.accept_alert do
      within('tr[data-uuid="tobe.deleted@originate.com"]') do
        click_on('Destroy')
      end
    end
    expect(page).to_not have_content("Tobe")
  end

  it "errors when try to add a user with no first name", js:true do
    visit root_path
    click_link "New User"
    click_button "Create User"
    expect(page).to have_css(".user_first_name.field_with_errors")
    expect(page).to have_css(".user_last_name.field_with_errors")
    expect(page).to have_css(".user_email.field_with_errors")
  end
  
  it "doesnt fill an email when only enter first name" do
    visit root_path
    click_link "New User"
    fill_in "First name", with: 'Doreen'
    page.execute_script("$('#user_first_name').trigger('change')")
    expect(find_field('Email').value).to eq ''
  end
  
  it "doesnt fill an email when only enter last name" do
    visit root_path
    click_link "New User"
    fill_in "Last name", with: 'Hakimi'
    page.execute_script("$('#user_last_name').trigger('change')")
    expect(find_field('Email').value).to eq ''
  end

  context 'supervisor functionality', js:true do
    it 'creates a new subordinate of rob meadows' do
      expect(User.find_by(email: 'rob.meadows@originate.com').subordinates.length).to be 0
      visit root_path
      click_link "New User"
      fill_in "First name", with: 'Regina'
      fill_in "Last name", with: 'Phalangie'
      page.execute_script("$('#user_last_name').trigger('change')")
      fill_in "Supervisor name", with: 'Rob Meadows'
      click_button "Create User"
      expect(page).to have_content("User was successfully created.")
      expect(page).to have_content("Reporting to:Rob Meadows")
      click_link "Rob Meadows"
      expect(page).to have_content("rob.meadows@originate.com")
      expect(User.find_by(email: 'rob.meadows@originate.com').subordinates.length).to be 1
    end

    it 'updates a users supervisor to bob meadows', js:true do
      expect(User.find_by(email: 'bobthebuilder.meadows@originate.com').subordinates.length).to be 0
      expect(User.find_by(email: 'kevin.goslar@originate.com').subordinates.length).to be 1
      visit root_path
      expect(page).to have_text("Dora")
      within('tr[data-uuid="dora.explorer@originate.com"]') do
        click_on('Edit')
      end
      fill_in "Supervisor name", with: 'BobTheBuilder Meadows'
      click_button 'Update User'
      expect(page).to have_content("User was successfully updated.")
      expect(User.find_by(email: 'bobthebuilder.meadows@originate.com').subordinates.length).to be 1
      expect(User.find_by(email: 'kevin.goslar@originate.com').subordinates.length).to be 0
    end

    it 'updates subordinate\'s supervisor\'s name when change supervisor\'s name', js:true do
      visit root_path
      within('tr[data-uuid="robert.meadows@originate.com"]') do
        click_on('Edit')
      end
      fill_in "First name", with: 'Bobby'
      page.execute_script("$('#user_first_name').trigger('change')")
      click_button 'Update User'
      expect(page).to have_content("User was successfully updated.")
      click_link 'Back'
      within('tr[data-uuid="boots.explorer@originate.com"]') do
        click_on('Show')
      end
      expect(page).to have_content("Reporting to:Bobby Meadows")

    end
  end
end
