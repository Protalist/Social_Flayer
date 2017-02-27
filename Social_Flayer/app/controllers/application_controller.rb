class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #permette di modificare parametri aggiunti dai programmatori
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :deny_banned

  #risolve l'eccezione  create da can can
  rescue_from CanCan::AccessDenied do |exception|

    if current_user==nil
      redirect_to new_user_session_path, :alert =>  exception.message

    elsif current_user.roles_mask==0
      redirect_to main_app.root_url, :alert => exception.message

    elsif current_user.roles_mask==1 || current_user.roles_mask==2

      if cookies[:last_store] == nil
        current_user.update(roles_mask: 0)
        redirect_to main_app.root_url, :alert =>  exception.message

      else
        redirect_to store_path(cookies[:last_store]), :alert =>  exception.message

      end

    else
      redirect_to new_user_session_path, :alert =>  exception.message

    end
  end

  rescue_from ActionController::RoutingError do |exception|

    if exception.message == "lost_connection"
      render :file => "#{Rails.root}/public/500.html"

    elsif exception.message == "not found"
      render :file => "#{Rails.root}/public/404.html"
    end

  end

  def not_found
      raise ActionController::RoutingError.new('not found')
  end

  #permette di modificare i parametri all'interno di devise
  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :surname, :username, :image])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :surname,:username, :image])
  end
  add_flash_types :error_comments

  protected
  def deny_banned
    if current_user.present? && current_user.ban != 0
      sign_out current_user
      flash[:error] = "This account has been suspended...."
      root_path
    end
  end




end
