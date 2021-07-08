class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  include SessionsHelper
  def ensure_current_user
    if logged_in?
      unless current_user.id == params[:id].to_i || current_user.admin == true
        flash[:notice] = '権限がありません'
        redirect_to tasks_path
      end
    else
      redirect_to new_user_path, notice: 'ログインが必要です'
    end
  end
end
