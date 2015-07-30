class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]
  def new
    @user = User.new
  end

  def create
    if login(session_params[:email], session_params[:password])
      redirect_back_or_to root_path, notice: "Добро пожаловать!"
    else
      @user = User.new(email: session_params[:email])
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
    params.require(:user).permit(:email, :password)
  end
end
