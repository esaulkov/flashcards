class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]
  def new
  end

  def create
    if login(session_params[:email],
      session_params[:password],
      session_params[:remember_me])
      redirect_back_or_to root_path, notice: "Добро пожаловать!"
    else
      flash.now[:error] = "Неверный e-mail или пароль"
      render :new
    end
  end

  def destroy
    logout
    redirect_to log_in_path, notice: "Вы вышли из системы"
  end

  private

  def session_params
    params.require(:session).permit(:email, :password, :remember_me)
  end
end
