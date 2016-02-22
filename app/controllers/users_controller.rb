class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    render layout: "metronic_layout"
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def create_admin
    a = User.create(email: "example#{SecureRandom.uuid[0..4]}@example.net",
      password: "password",
      admin: true
    )
    if params[:redir_to].present?
      redirect_to params[:redir_to], :notice => "Created #{a.email}"
    else
      rediret_to "/", :notice => "Created #{a.email}"
    end
  end

  # POST /users
  # POST /users.json
  def create
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
    require 'rmagick'
    if params[:user].keys == ["picture"]
      @user.picture_content_type = params[:user][:picture].content_type
      @user.picture = params[:user][:picture].read
      @user.picture_file_name = params[:user][:picture].original_filename
      @user.save
      @user = User.find(@user.id)
      picture = Magick::Image.from_blob(@user.picture)[0]
      picture.auto_orient!
      picture.resize_to_fit!(140, 140)
      picture.resize_to_fill!(140, 140)
      @user.picture = picture.to_blob
      @user.save
      redirect_to @user, notice: 'Image was successfully updated.' and return
    end

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

  def show_picture
    user = User.find(params[:id])
    if ! user.picture
      user.picture = (open('app/assets/images/empty_profile_picture.jpg', 'rb') { |f| f.read })
      send_data user.picture, :type => "image/jpeg" ,:disposition => 'inline'
    else
      send_data user.picture, :type => user.picture_content_type ,:disposition => 'inline'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      #params[:user]
      params.require(:user).permit(:email, :password, :password_confirmation, :seed, :admin,
        :first_name, :last_name)
    end
end
