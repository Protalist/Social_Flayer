class SessionsController < Devise::SessionsController

protected

  def after_sign_in_path_for(resource)
    if resource.ban != 0 && !resource.admin?
      if resource.ban >0 && Time.at(resource.ban) < Time.now()
        resource.update(ban: 0)
        flash[:notice]= "this account has been restored :)"
      else
        if resource.ban >0
          flash[:notice] = "This account has been suspended until #{Time.at(resource.ban)} :) "
        else
          flash[:notice] = "This account has been suspended forever :) "
        end
        sign_out resource
      end
      puts "ha eseguito il controllo"
      new_user_session_path
    else
      puts "non ha eseguito il controllo"
      super
    end
   end


end