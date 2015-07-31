class RegistrationsController < ApplicationController
  skip_before_action :require_login

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    if @user.save
      login(registration_params[:email], registration_params[:password])
      redirect_to root_path, notice: "Поздравляем! Вы зарегистрировались!"
    else
      render :new
    end
  end

  private

  def registration_params
    params.require(:registration).permit(
      :email, :password, :password_confirmation
    )
  end
end
