class OauthsController < ApplicationController
  skip_before_filter :require_login
  before_filter :require_login, only: :destroy

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    if @user = login_from(provider)
      redirect_back_or_to root_path, notice: "Добро пожаловать!"
    else
      if logged_in?
        link_account(provider)
        flash[:notice] = "Вы успешно подключили Github аккаунт"
        redirect_to edit_profile_path
      else
        begin
          @user = create_from(provider)
          reset_session
          auto_login(@user)
          flash[:notice] = "Вы зарегистрировались при помощи GitHub аккаунта"
          redirect_to root_path
        rescue
          flash[:error] = "Не удалось войти с использованием GitHub аккаунта"
          redirect_to log_in_path
        end
      end
    end
  end

  def destroy
    provider = params[:provider]

    authentication = current_user.authentications.find_by_provider(provider)
    if authentication.present?
      authentication.destroy
      flash[:notice] = "Ваш GitHub аккаунт успешно отключен от Вашего профиля"
    else
      flash[:error] = "У Вас нет подключенного GitHub аккаунта"
    end

    redirect_to edit_profile_path
  end

  private

  def link_account(provider)
    if @user = add_provider_to_user(provider)
      flash[:notice] = "Ваш GitHub аккаунт успешно подключен"
    else
      flash[:error] = "При подключении GitHub аккаунта возникли проблемы"
    end
  end

  def auth_params
    params.permit(:code, :provider)
  end
end
