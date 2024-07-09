class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration, only: %i(edit update)

  def new
  end

  def edit
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render :new, status: :unprocessable_entity
    end
  end


  def update
    if user_params[:password].empty?
      # handle the case when the password is empty

    elsif @user.update(user_params)
      # handle the case when the password update is successful
      redirect_to login_path

    else
      # handle the case when the password update fails
      render :edit, status: :unprocessable_entity
    end
  end


  private

  def load_user

    @user = User.find_by(reset_digest: User.digest(params[:id]))
    return if @user
    flash[:danger] = "User not found!"
    redirect_to root_url
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])
    flash[:danger] = "User is inactivated!"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end
  
  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = "Password reset has expired."
    redirect_to new_password_reset_url
  end

end
