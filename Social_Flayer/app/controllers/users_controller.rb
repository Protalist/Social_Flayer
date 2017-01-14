class UsersController < ApplicationController
  before_action :authenticate_user!
  #load_and_authorize_resource


  def home
    @cu=current_user
  end

  def back
    current_user.update(roles_mask: 0)
    redirect_to root_path
  end

  def change
   @role=params.require(:store_id)
   cookies[:last_Store]=@role
   @store=Store.find(@role)
   if @store.owner_id==current_user.id
   current_user.update(roles_mask: 1)
   else
     current_user.update(roles_mask: 2)
   end
   redirect_to store_path(@role)
 end

end
