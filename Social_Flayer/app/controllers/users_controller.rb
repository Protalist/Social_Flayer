class UsersController < ApplicationController
  before_action :user,:only => [:show,:follow,:unfollow]
  before_action :authenticate_user!
  load_and_authorize_resource :except => :home


  def index
    @users=User.where("username LIKE ?","%#{params[:username]}%")
  end

  def show
     @show=@user
  end

  def home
      authorize! :home, User
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
      @segue_prodotto=[]
      @followed.each do |f|
        @commenti_followed+=User.find(f.followed_id).comments
        @cosa_fanno+=FollowStore.where(user_id: f.followed_id)
        @vote+=ActsAsVotable::Vote.where(voter_id: f.followed_id)
        @segue_prodotto+= FollowProduct.where(user_id: f.followed_id)
      end
      @list=(@commenti_followed+@cosa_fanno+@replys+@products+@vote+@segue_prodotto).sort!{|a,b| a.updated_at <=> b.updated_at}.reverse

  end

  def back
    current_user.update(roles_mask: 0)
    redirect_to root_path
  end

  def change
   @role=params.fetch(:store_id,{})
   if @role == ""
     redirect_to root_path
   else
     cookies[:last_store]=@role
     @store=Store.find(@role)
     if @store.owner_id==current_user.id
       current_user.update(roles_mask: 1)
       redirect_to store_path(@role)
     elsif !Work.where(store_id: @role, user_id: current_user.id).exists?
       redirect_to root_path
     else
       current_user.update(roles_mask: 2)
       redirect_to store_path(@role)
     end
   end
 end

 def follow
   @follow=FollowerUser.new
   @follow.followed_id=params[:id]
   @follow.follower_id=current_user.id
   if @follow.save
     respond_to do |format|
       format.html {redirect_to user_path(@user.id)}
       format.js {}
     end
   else
     respond_to do |format|
       format.html {redirect_to user_path(@user.id)}
       format.js {render "shared/nothing"}
     end
   end
 end
 def updatefollow
   respond_to do |format|
        format.html {redirect_to user_path(@user.id)}
        format.js {}
      end
 end
 def unfollow
    @follow=FollowerUser.where(followed_id: params[:id],follower_id: current_user.id).first
    if @follow
      @follow.destroy
      respond_to do |format|
        format.html {redirect_to user_path(@user.id)}
        format.js {}
      end
    else
      respond_to do |format|
        format.html {redirect_to user_path(@user.id)}
        format.js {render "shared/nothing"}
      end
    end
 end

 private

 def user
   if (User.ids.include?(params[:id].to_i))
     @user=User.find(params[:id])
   else
     redirect_to root_path
   end
 end

end
