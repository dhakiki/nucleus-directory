class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_skill_levels, except: [:index]
  before_action :set_user_positions, except: [:index]
  before_action :set_all_users, except: [:index]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user_skills = Skill.where user: @user
  end

  # GET /users/new
  def new
    @user = User.new
    @users = User.all.pluck(:full_name).to_json
  end

  # GET /users/1/edit
  def edit
    @users = User.all.pluck(:full_name).to_json
  end

  # POST /users
  # POST /users.json
  def create
    supervisor = User.find_by full_name: params[:user][:supervisor_name]
    params[:user][:supervisor_id] = supervisor.id if supervisor
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    # todo: improvements here? need the text field for the edit but don't know if i can do away with it
    # update subordinate's supervisor_name fields
    if params[:user][:full_name] != @user.full_name
      @user.subordinates.each do |subordinate|
        subordinate.supervisor_name = params[:user][:full_name]
        subordinate.save!
      end
    end
    supervisor = User.find_by full_name: params[:user][:supervisor_name]
    params[:user][:supervisor_id] = supervisor.id if supervisor
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :full_name, :email, :bio, :title, :position, :supervisor_name, :supervisor_id, :twitter_profile, :github_profile, :additional_link, :location, :industry_experiences, :industry_interests, :technology_interests, :notes, :start_date, :disabled, skills_attributes: [:id, :name, :level, :_destroy], google_account_attributes: [:google_id, :token, :name, :email, :picture])
    end

    def set_all_users
      @all_users = User.all
    end

    def set_skill_levels
      @skill_levels = Skill::SKILL_LEVELS
    end

    def set_user_positions
      @user_positions = User::LEVELS
    end
end
