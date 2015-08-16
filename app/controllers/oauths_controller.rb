class OauthsController < ApplicationController
  skip_before_action :require_login
  before_action :require_login, only: :destroy

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    if @user = login_from(provider)
      redirect_back_or_to root_path, notice: t("Welcome")
    else
      if logged_in?
        link_account(provider)
        redirect_to edit_profile_path
      else
        create_account(provider)
        redirect_to logged_in? ? root_path : log_in_path
      end
    end
  end

  def destroy
    provider = params[:provider]

    authentication = current_user.authentications.find_by_provider(provider)
    if authentication.present?
      authentication.destroy
      flash[:notice] = t("Github account was unlinked")
    else
      flash[:error] = t("Github account is upsent")
    end

    redirect_to edit_profile_path
  end

  private

  def link_account(provider)
    if @user = add_provider_to_user(provider)
      flash[:notice] = t("Github account was linked")
    else
      flash[:error] = t("Unable to link Github account")
    end
  end

  def create_account(provider)
    if @user = create_from(provider)
      reset_session
      auto_login(@user)
      flash[:notice] = t("Registration with Github account")
    else
      flash[:error] = t("Registration with Github account failed")
    end
  end

  def auth_params
    params.permit(:code, :provider)
  end
end
