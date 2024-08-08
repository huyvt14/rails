# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params.dig(:session, :email)&.downcase)

    if user&.authenticate(params.dig(:session, :password))
      forwarding_url = session[:forwarding_url]
      # Log the user in and redirect to the user's show page.
      reset_session
      log_in(user)
      params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
      redirect_to forwarding_url || user
      # redirect_to user, status: :see_other
    else
      # Create an error message.
      flash.now[:danger] = t "invalid_email_password_combination"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_path, status: :see_other
  end
end
