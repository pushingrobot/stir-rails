class HomeController < ApplicationController
  before_action :ensure_logged_in

  def index
    if current_user&.admin?
      redirect_to admin_users_path
    else
      @devices = current_user.devices.active
    end
  end

  def setup
  end

end
