class ResetPasswordsController < ApplicationController
  skip_before_action :require_login

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email(reset_params[:user][:email])
    if @user
      @user.deliver_reset_password_instructions!
      flash[:notice] = "Инструкции были высланы на указанный адрес"
      redirect_to log_in_path
    else
      flash.now[:error] = "Нет пользователя с таким адресом"
      render :new
    end
  end

  def edit
    token = params[:id]
    @user = User.load_from_reset_password_token(token)

    not_authenticated if @user.blank?
  end

  def update
    token = params[:id]
    @user = User.load_from_reset_password_token(token)

    not_authenticated && return if @user.blank?

    @user.password_confirmation = reset_params[:user][:password_confirmation]
    if @user.change_password!(reset_params[:user][:password])
      flash[:notice] = 'Пароль был успешно изменен'
      redirect_to log_in_path
    else
      render :edit
    end
  end

  private

  def reset_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
