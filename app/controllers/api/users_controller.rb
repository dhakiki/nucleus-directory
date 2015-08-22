module Api
  class UsersController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    respond_to :json

    def index
      @users = User.all
      respond_with :api, @users
    end

    def show
      user = User.find(params[:id])
      user = user.to_json if user
      user_skills = Skill.where user_id: params[:id]
      #trying to embed attribute into user (probably a better way to do this than re-parsing)
      if user_skills
        user = JSON.parse user
        user['skills'] = user_skills
      end
      respond_with user, status: :ok
    end

    def create
      supervisor = User.find_by full_name: params[:user][:supervisor_name]
      params[:user][:supervisor_id] = supervisor.id if supervisor
      @user = User.new(user_params)

      if @user.save
        respond_with @user, status: :ok
      else
        render json: {error: @user.errors.messages, status: :unprocessable_entity}
      end
    end

    def update
      supervisor = User.find_by full_name: params[:user][:supervisor_name]
      params[:user][:supervisor_id] = supervisor.id if supervisor
      @user = User.find(params[:id])
      # todo: improvements here? need the text field for the edit but don't know if i can do away with it
      # update subordinate's supervisor_name fields
      if params[:user][:full_name] != @user.full_name
        @user.subordinates.each do |subordinate|
          subordinate.supervisor_name = params[:user][:full_name]
          subordinate.save!
        end
      end
      if @user.update(user_params)
        render json: {user: @user, status: :ok}
      else
        render json: { error: @user.errors.messages, status: :unprocessable_entity }
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.subordinates.each do |subordinate|
        subordinate.supervisor_name = ""
        subordinate.supervisor_id = nil
        subordinate.save!
      end
      @user.destroy
      render json: { status: :ok }
    end

    private

    def record_not_found
      respond_with error: 'User not found', status: :unprocessable_entity
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :full_name, :email, :bio, :title, :position, :supervisor_name, :supervisor_id, :twitter_profile, :github_profile, :additional_link, :location, :industry_experiences, :industry_interests, :technology_interests, :notes, :start_date, :disabled, skills_attributes: [:id, :name, :level, :_destroy], google_account_attributes: [:google_id, :token, :name, :email, :picture])
    end
  end
end
