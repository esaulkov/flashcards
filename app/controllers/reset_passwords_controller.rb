class ResetPasswordsController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  skip_before_action :require_login

  def new
  end

  def create
    @user = User.find_by_email(reset_params[:email])
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
    not_authenticated if @user.blank?
  end

  def update
    not_authenticated && return if @user.blank?

    @user.password_confirmation = reset_params[:password_confirmation]
    if @user.change_password!(reset_params[:password])
      flash[:notice] = "Пароль был успешно изменен"
      redirect_to log_in_path
    else
      render :edit
    end
  end

  private

  def set_user
    token = params[:id]
    @user = User.load_from_reset_password_token(token)
  end

  def reset_params
    params.require(:reset).permit(:email, :password, :password_confirmation)
  end
end
