class UsersController < ApplicationController
  before_action :authenticate_user!
  #load_and_authorize_resource

  def index
    @users=User.where("username LIKE ?","%#{params[:username]}%")
  end

  def show
    @show=User.find(params[:id])
  end

  def home
    @cu=current_user
    @works_pendent=@cu.works.where(accept: false)
    @followings=FollowStore.where(user_id: current_user.id)
    @user_follow=FollowerUser.where("followed_id = ? OR follower_id = ?", @cu.id,@cu.id)
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

 def follow
   @follow=FollowerUser.new
   @follow.followed_id=params[:id]
   @follow.follower_id=current_user.id
   if @follow.followed_id!= @follow.follower_id
     @follow.save
   end
 end

 def unfollow
    @follow=FollowerUser.where(followed_id: params[:id],follower_id: current_user.id).first
    if @follow
      @follow.destroy
    end
 end

end
