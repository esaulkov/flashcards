class ProfilesController < ApplicationController
  before_action :set_user

  def edit
  end

  def update
    if @user.update(profile_params)
      redirect_to edit_profile_path(@user), notice: "Профиль успешно изменен"
    else
      render :edit
    end
  end

  private

  def set_user
    @user = params[:id] ? User.find(params[:id]) : current_user
  end

  def profile_params
    params.require(:profile).permit(:email, :password, :password_confirmation)
  end
end
