class Dashboard::SessionsController < Dashboard::BaseController
  def destroy
    logout
    redirect_to home_log_in_path, notice: t(:log_out_message)
  end
end
