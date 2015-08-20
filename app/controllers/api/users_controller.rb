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
      @user = User.new(user_params)

      if @user.save
        respond_with @user, status: :ok
      else
        render json: {error: @user.errors.messages, status: :unprocessable_entity}
      end
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        render json: {user: @user, status: :ok}
      else
        render json: { error: @user.errors.messages, status: :unprocessable_entity }
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      render json: { status: :ok }
    end

    private

    def record_not_found
      respond_with error: 'User not found', status: :unprocessable_entity
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, skills_attributes: [:id, :name, :level, :_destroy], google_account_attributes: [:google_id, :token, :name, :email, :picture])
    end
  end
end
