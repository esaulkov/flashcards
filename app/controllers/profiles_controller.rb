class ProfilesController < ApplicationController
  def edit
  end

  def update
    if current_user.update(profile_params)
      flash[:notice] = "Профиль успешно изменен"
      redirect_to edit_profile_path
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:email, :password, :password_confirmation)
  end
end
