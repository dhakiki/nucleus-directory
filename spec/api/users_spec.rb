require 'rails_helper'

describe 'Users API', type: :request do
  before do
    DatabaseCleaner.clean
  end
  let(:valid_user_attributes) {
    {
      first_name: 'Keanu',
      last_name: 'Reeves',
      full_name: 'Keanu Reeves',
      email: 'keanu.reeves@originate.com'
    }
  }
  let(:existing_user_attributes) {
    {
      first_name: 'Clone',
      last_name: 'Person',
      full_name: 'Clone Person',
      email: 'clone.person@originate.com'
    }
  }

  let(:valid_user_with_skills_attributes) {
    {
      first_name: 'Keanu',
      last_name: 'Reeves',
      full_name: 'Keanu Reeves',
      email: 'keanu.reeves@originate.com',
      skills_attributes: [
        {
          name: 'Acting',
          level: 3
        },
        {
          name: 'Making Jokes',
          level: 5
        }
      ]
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
      expect(response_object['first_name']).to eq(user.first_name)
      expect(response_object['last_name']).to eq(user.last_name)
      expect(response_object['email']).to eq(user.email)
    end
    
    it 'does not find inexistant user' do
      get '/api/users/144'
      expect(response).to have_http_status(200)
      response_object = JSON.parse response.body
      expect(response_object['error']).to eq "User not found"
    end

  end

  describe 'POST /user' do
    it 'creates a new valid user with no skills' do
      expect { post '/api/users', {user: valid_user_attributes} }.to change{ User.count }.by(1)
    end

    it 'creates a new valid user with skills' do
      expect { post '/api/users', {user: valid_user_with_skills_attributes} }.to change{ Skill.count }.by(2)
    end

    it 'does not create an invalid user' do
      expect { post '/api/users', {user: invalid_attributes} }.to change{ User.count }.by(0)
      response_object = JSON.parse response.body
      expect(response_object['error']).to_not be_nil
    end

    it "assigns a newly created user as @user" do
      post '/api/users', {user: valid_user_attributes}
      expect(assigns(:user)).to be_a(User)
      expect(assigns(:user)).to be_persisted
    end

    it 'errors when creating a user with a duplicate email' do
      user = FactoryGirl.create(:user, first_name: 'Clone', last_name: 'Person', email: 'clone.person@originate.com')
      expect { post '/api/users', {user: existing_user_attributes} }.to change{ User.count }.by(0)
      response_object = JSON.parse response.body
      expect(response_object['error']).to_not be_nil
    end
    context 'supervisor/subordinate creation' do
      let(:valid_subordinate_params) {
        {
          first_name: 'Dave',
          last_name: 'Minion',
          full_name: 'Dave Minion',
          email: 'dave.minion@originate.com',
          supervisor_name: 'Boss Person'
        }
      
      }
      it 'creates a subordinate properly' do
        user = FactoryGirl.create(:user, first_name: 'Boss', last_name: 'Person', full_name: 'Boss Person', email: 'boss.person@originate.com')
        expect { post '/api/users', {user: valid_subordinate_params} }.to change{ User.find_by(email: 'boss.person@originate.com').subordinates.length }.by(1)
      end
    end
  end

  describe 'PUT /user' do
    context 'with valid params' do
      let(:new_attributes) {
        {
          first_name: 'Jaden',
          email: 'jaden.smith@originate.com'
        }
      }
      let(:google_attributes) {
        {
          google_account_attributes: {
            google_id: 'abcitseasyas123',
            token: 'assimpleasdoremi',
            name: 'Will Smith',
            email: 'will.smith@originate.com',
            picture: 'http://cdn.celebritycarsblog.com/wp-content/uploads/Will-Smith.jpg'
          }
        }
      }

      it 'updates a user successfully' do
        user = FactoryGirl.create :user
        put "/api/users/#{user.id}", {id: user.id, user: new_attributes} 
        response_object = JSON.parse response.body
        new_user = response_object['user']
        expect(new_user['first_name']).to eq('Jaden')
        expect(new_user['email']).to eq('jaden.smith@originate.com')
      end

      it 'updates a users google profile successfully' do
        user = FactoryGirl.create :user
        expect { put "/api/users/#{user.id}", {id: user.id, user: google_attributes} }.to change{ GoogleAccount.count }.by(1)
      end

      context 'supervisor/subordinate updates' do
        let(:subordinate_with_new_boss_attributes) {
          {
            supervisor_name: 'OtherBoss Person'
          }
        }
        let(:new_supervisor_attributes) {
          {
            first_name: 'Gru',
            email: 'gru.person@originate.com',
            full_name: 'Gru Person'
          }
        }
        
        let!(:old_boss) { FactoryGirl.create(:user, first_name: 'Boss', last_name: 'Person', full_name: 'Boss Person', email: 'boss.person@originate.com') }
        let!(:new_boss) { FactoryGirl.create(:user, first_name: 'OtherBoss', last_name: 'Person', full_name: 'OtherBoss Person', email: 'otherboss.person@originate.com') }
        let!(:user) { FactoryGirl.create(:user, first_name: 'Dave', last_name: 'Minion', full_name: 'Dave Minion', email: 'dave.minion@originate.com', supervisor_name: 'Boss Person', supervisor_id: 1) }

        it 'assigns to new supervisor subordinates list' do
          expect { put "/api/users/#{user.id}", {id: user.id, user: subordinate_with_new_boss_attributes} }.to change{ User.find_by(email: 'otherboss.person@originate.com').subordinates.length }.by(1)
        end

        it 'removes from old supervisor subordinates list' do
          expect { put "/api/users/#{user.id}", {id: user.id, user: subordinate_with_new_boss_attributes} }.to change{ User.find_by(email: 'boss.person@originate.com').subordinates.length }.by(-1)
        end

        it 'updates subordinates supervisor names properly' do
          put "/api/users/#{old_boss.id}", {id: user.id, user: new_supervisor_attributes}
          expect(User.find(user.id).supervisor_name).to eq("Gru Person")
        end
      end
    end

    context 'with invalid params' do

      let(:invalid_attribues) {
        {
          iwanna: 'rockrightnow',
          imrobbase: 'andicametogetdown'
        }
      }
      it 'does not update with failed attribues' do
        user = FactoryGirl.create :user
        put "/api/users/#{user.id}", {id: user.id, user: invalid_attributes} 
        response_object = JSON.parse response.body
        same_user = response_object['user']
        expect(same_user['first_name']).to eq('Will')
        expect(same_user['email']).to eq('will.smith@originate.com')
      end
    end
  end

  describe 'DELETE /user' do
    it 'deletes a user properly' do
      user = FactoryGirl.create :user
      expect {
        delete "/api/users/#{user.id}"
      }.to change(User, :count).by(-1)
    end

    context 'supervisor/superior deletion' do
      let!(:boss) { FactoryGirl.create(:user, first_name: 'Boss', last_name: 'Person', full_name: 'Boss Person', email: 'boss.person@originate.com') }
      let!(:user) { FactoryGirl.create(:user, first_name: 'Dave', last_name: 'Minion', full_name: 'Dave Minion', email: 'dave.minion@originate.com', supervisor_name: 'Boss Person', supervisor_id: 1) }
      
      it 'updates user when supervisor gets deleted' do
        delete "/api/users/#{boss.id}"
        expect(User.find(user.id).supervisor).to be nil
        expect(User.find(user.id).supervisor_name).to eq ""
      end

      it 'updates supervisor\'s subordinates list when subordinate gets deleted' do
        expect{ delete "/api/users/#{user.id}" }.to change { User.find(boss.id).subordinates.length }.by(-1)
      end

    end
  end
end
