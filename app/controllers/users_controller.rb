# frozen_string_literal: true

class UsersController < ApplicationController

  before_action :load_user, except: %i[index new create]
  before_action :logged_in_user, except: %i[show new create]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: :destroy
  before_action :find_user, only: [:show]

  def show
    @user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Xử lý khi lưu thành công
      flash[:success] = "welcome_to_the_sample_app!"
      redirect_to @user, status: :see_other
    else
      # Xử lý khi lưu không thành công
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def index
    @pagy, @users = pagy(User.all, items: 10)
  end

  def destroy
    if @user.destroy
      flash[:success] = 'User deleted successfully.'
    else
      flash[:danger] = 'Failed to delete user.'
    end
    redirect_to users_path
  end

  private

  def load_user
    @user = User.find_by(id: params[:id])

    return if @user

    flash[:danger] = 'User not found!'
    redirect_to root_url
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end

  def correct_user
    return if @user == current_user

    flash[:error] = 'You cannot edit this account.'
    redirect_to root_url
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def find_user
    @user = User.find_by(id: params[:id])
    unless @user
      flash[:warning] = "Not found user!"
      redirect_to root_path
    end
end
