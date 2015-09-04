class Dashboard::OauthsController < Dashboard::BaseController
  def destroy
    provider = params[:provider]

    authentication = current_user.authentications.find_by_provider(provider)
    if authentication.present?
      authentication.destroy
      flash[:notice] = t(:github_account_was_unlinked)
    else
      flash[:error] = t(:github_account_is_upsent)
    end

    redirect_to edit_dashboard_profile_path
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end
end
