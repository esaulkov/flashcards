class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]
  def new
  end

  def create
    if login(session_params[:email],
             session_params[:password],
             session_params[:remember_me])
      set_locale
      redirect_back_or_to root_path, notice: t("Welcome")
    else
      flash.now[:error] = t("Wrong login")
      render :new
    end
  end

  def destroy
    logout
    redirect_to log_in_path, notice: t("You log out")
  end

  private

  def session_params
    params.require(:session).permit(:email, :password, :remember_me)
  end
end
