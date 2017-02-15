class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #permette di modificare parametri aggiunti dai programmatori
  before_action :configure_permitted_parameters, if: :devise_controller?

  #risolve l'eccezione  create da can can
  rescue_from CanCan::AccessDenied do |exception|
    if current_user.roles_mask==0
      redirect_to main_app.root_url, :alert => exception.message
    else
      redirect_to store_path(cookies[:last_store]), :alert =>  exception.message
    end
  end

  

  #permette di modificare i parametri all'interno di devise
  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :surname, :username])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :surname,:username])
  end

  add_flash_types :error_comments

end
