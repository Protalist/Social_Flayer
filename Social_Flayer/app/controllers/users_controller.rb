class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  #load_and_authorize_resource

  def index
    @users=User.where("username LIKE ?","%#{params[:username]}%")
  end

  def show
    if User.all.ids.include?(params[:id].to_i)
      @show=User.find(params[:id])
      render 'users/show'
    else
      redirect_to root_path
    end
  end

  def home
    @cu=current_user
    @works_pendent=@cu.works.where(accept: false)
    @followings=FollowStore.where(user_id: current_user.id)
    @user_follow=FollowerUser.where("followed_id = ? OR follower_id = ?", @cu.id,@cu.id)
    @store_follow=Store.joins(" join follow_stores, users ON users.id = follow_stores.user_id and follow_stores.store_id=stores.id").where("users.id = ?", @cu.id)
    @products=[]
    @responds=[]
    @store_follow.each do |f|
        @products+=f.products
        @responds+=f.responds
    end
    @comments=@cu.comments
    @replys=[]
    @comments.each do |f|
      @replys+=f.replys+f.responds
    end
    @cosa_fanno=[]
    @followed=@user_follow.where(follower_id: @cu.id)
    @commenti_followed=[]
    @vote=[]
    @followed.each do |f|
      @commenti_followed+=User.find(f.followed_id).comments
      @cosa_fanno+=FollowStore.where(user_id: f.followed_id)
      @vote+= @vote+=ActsAsVotable::Vote.where(voter_id: f.followed_id)
    end
    @list=(@commenti_followed+@cosa_fanno+@replys+@products+@vote).sort!{|a,b| a.updated_at <=> b.updated_at}.reverse
  end
  def back
    current_user.update(roles_mask: 0)
    redirect_to root_path
  end

  def change
   @role=params.require(:store_id)
   cookies[:last_store]=@role
   @store=Store.find(@role)
   if @store.owner_id==current_user.id
   current_user.update(roles_mask: 1)

   elsif !Work.where(store_id: @role, user_id: current_user.id).exist?
     redirect_to home
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
