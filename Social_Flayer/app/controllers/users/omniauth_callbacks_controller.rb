class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
# You need to implement the method below in your model (e.g. app/models/user.rb)
  @user = User.from_omniauth(request.env["omniauth.auth"], flash)
	if @user.persisted?
	  sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    if(flash[:notice]==nil)
	   set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    end
    else
	  session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
   end
   def failure
    redirect_to root_path
   end
end
