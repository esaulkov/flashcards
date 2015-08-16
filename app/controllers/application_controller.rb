class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :require_login

  private

  def not_authenticated
    redirect_to log_in_path, alert: t("Not authenticated")
  end

  def set_locale
    locale = case
             when current_user then current_user.locale
             when params[:locale] then session[:locale] = params[:locale]
             when session[:locale] then session[:locale]
             else 
               http_accept_language.compatible_language_from(I18n.available_locales)
             end

    if locale && I18n.available_locales.include?(locale.to_sym)
      session[:locale] = I18n.locale = locale.to_sym
    end
  end
end
