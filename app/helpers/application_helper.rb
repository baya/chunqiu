module ApplicationHelper

    module Auth

    def authenticate_user
      if current_user.blank?
        redirect_to login_url
      end  
    end

    def current_user
      @current_user ||= User.find_by_id(session[:user_id])
    end

    def current_user=(user)
      if user.present?
        @current_user = user
        session[:user_id] = user.id
      else
        @current_user = nil
        session[:user_id] = nil
      end  
    end  

  end

end
