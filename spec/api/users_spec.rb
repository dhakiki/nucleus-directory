require 'rails_helper'

describe 'Users API', type: :request do
  let(:valid_attributes) {
    {
      first_name: 'Keanu',
      last_name: 'Reeves',
      email: 'keanu.reeves@originate.com'
    }
  }

  let(:invalid_attributes) {
    {
      something: 'cool',
      another_something: 'cool'
    }
  }
  let(:valid_session) { {} }

  describe "GET /users" do
    it 'gets user data' do
      user = FactoryGirl.create :user
      get '/api/users'
      response_object = JSON.parse response.body
      expect(response).to have_http_status(200)
      response_user = response_object.first
      expect(response_user['first_name']).to eq(user.first_name)
      expect(response_user['last_name']).to eq(user.last_name)
    end
    
    it 'gets an existing users data' do
      user = FactoryGirl.create :user
      skill = FactoryGirl.create :skill
      get '/api/users/1'
      response_object = JSON.parse response.body
      puts response_object
      #todo: finish checking test
    end
    
    it 'does not find inexistant user' do
      get '/api/users/144'
      expect(response).to have_http_status(200)
      response_object = JSON.parse response.body
      expect(response_object['error']).to eq "User not found"
    end

  end

  describe 'POST /user' do
    it 'creates a new valid user' do
      expect { post '/api/users', {user: valid_attributes} }.to change{ User.count }.by(1)
    end

    it 'does not create an invalid user' do
      expect { post '/api/users', {user: invalid_attributes} }.to change{ User.count }.by(0)
      puts JSON.parse response.body
      #todo finish checking values
    end

    it "assigns a newly created user as @user" do
      post '/api/users', {:user => valid_attributes}
      expect(assigns(:user)).to be_a(User)
      expect(assigns(:user)).to be_persisted
    end
  end
end
