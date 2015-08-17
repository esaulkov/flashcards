class ProfilesController < ApplicationController
  def edit
  end

  def update
    if current_user.update(profile_params)
      set_locale
      flash[:notice] = t(:profile_was_changed)
      redirect_to edit_profile_path
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:profile).
      permit(:email, :locale, :password, :password_confirmation)
  end
end
