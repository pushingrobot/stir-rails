class ApplicationController < ActionController::Base
    protect_from_forgery :with => :reset_session
    helper_method :current_user, :admin?, :ensure_logged_in

    protected

    def current_user
      if session[:user_id]
        @current_user ||= User.find(session[:user_id])
      else
        @current_user = nil
      end
    rescue
      @current_user = nil
      session[:user_id] = nil
      redirect_to root_path
    end

    def admin?
      @current_user&.admin?
    end

    # def site_admin
    #   @site_admin ||= User.find_by(admin: true)
    # end

    def ensure_logged_in
      redirect_to login_url unless current_user
    end
end
