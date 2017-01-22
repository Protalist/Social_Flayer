class StoresController < ApplicationController
before_action :store, only: [:show, :edit, :update,:destroy,:upvote,:downvote,:follow,:unfollow]

  def show
    @show=@store
    @products=@show.products
    @comments=@show.comments.where("comment_id IS NULL")
  end

  def new
    @store=Store.new
  end

  def create
    @store=Store.new(store_params)
    @store.owner_id=current_user.id
    if @store.save
      @admin_stores= Work.new()
      @admin_stores.store_id=@store.id
      @admin_stores.user_id=current_user.id
      @admin_stores.accept=true
      @admin_stores.save
      puts @admin_stores
      current_user.update(roles_mask: 1)
      cookies[:last_Store]=@role
      redirect_to store_path(@store)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @store.update(store_params)
      redirect_to store_path(@store)
    else
      render 'edit'
    end
  end

  def destroy
    @store.destroy
    current_user.update(roles_mask: 0)
    redirect_to root_path
  end

  def index
    @stores=Store.all
  end
  def upvote
    @store.upvote_from current_user
    redirect_to store_path(@store)
  end

  def downvote
    @store.downvote_from current_user
    redirect_to store_path(@store)
  end

  def addadmin
    @name=params[:admin][:username]
    puts params[:id]
    @user=User.where("username =?",@name)
    if @user.count!=0
      puts @user[0].id
      @work=Work.new()
      @work.user_id=@user[0].id
      @work.store_id=params[:id]
      @work.accept=false
      if ! @work.save
        flash[:errors]="non si può aggiungere l'utente"
      else
        flash[:errors]="mandata richiesta"
      end
    else
      flash[:errors]="utente non esiste"
    end
    redirect_to store_path(params[:id])
  end                                                           

  
  def follow
     @follow=FollowStore.new()
     @follow.store_id=params[:id]
     @follow.user_id=current_user.id
     @follow.save 
     respond_to do |format|
		format.html (redirect_to store_path(@store))
		format.js{}
	 end
  end
	
  
  def unfollow
     @follow=FollowStore.where(store_id: params[:id], user_id: current_user.id).destroy_all
     
     
     respond_to do |format|
		format.html (redirect_to store_path(@store))
		format.js{}
	 end
     
     
     
  end
  def choose_yes
    @work=Work.where(user_id: current_user.id,store_id: params[:id])
    @work.update(accept: true)
    current_user.update(roles_mask:  2)
    redirect_to store_path(params[:id])
  end

  def choose_no
    @work=Work.where(user_id: current_user.id,store_id: params[:id])
    @work[0].destroy
    redirect_to root_path
  end


  protected
  #funzione che seatta un parametro
  def store
    if (Store.all.ids.include?(params[:id].to_i))
      @store=Store.find(params[:id])
    else
      redirect_to root_path
    end
  end
  #
  def store_params
    params.require(:store).permit(:name,:location)
  end
end
