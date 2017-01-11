class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #permette di modificare parametri aggiunti dai programmatori
  before_action :configure_permitted_parameters, if: :devise_controller?

  #permette di modificare i parametri all'interno di devise
  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :surname, :username])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :surname,:username])
  end
end
