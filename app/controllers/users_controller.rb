# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = "Not found user!"

    redirect_to root_path
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

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
