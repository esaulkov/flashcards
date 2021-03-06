class Home::SessionsController < Home::BaseController
  def create
    if login(session_params[:email],
             session_params[:password],
             session_params[:remember_me])
      set_locale
      redirect_back_or_to root_path, notice: t(:welcome)
    else
      flash.now[:error] = t(:wrong_login)
      render :new
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password, :remember_me)
  end
end
