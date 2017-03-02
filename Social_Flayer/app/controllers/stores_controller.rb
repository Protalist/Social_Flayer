class StoresController < ApplicationController
  before_action :store, only: [:show, :edit, :update,:destroy,:upvote,:downvote,:follow,:unfollow,:create_photo]
  load_and_authorize_resource :except => :create

  def show
    @show=@store
    @products=@show.products
    @comments=@show.comments.where("comment_id IS NULL")
    render 'show'
  end

  def new
    @store=Store.new
  end

  def create
    @store=Store.new(store_params)
    authorize! :create, @store
    @store.owner_id=current_user.id
    if @store.save
      @admin_stores= Work.new()
      @admin_stores.store_id=@store.id
      @admin_stores.user_id=current_user.id
      @admin_stores.accept=true
      @admin_stores.save

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
    @distance=Hash.new
    @like=Hash.new
    @stores=Store.search(params)
    distance=0
    @stores.each do |store|

        distance=store.distance_from(params[:location])
      @distance[store]=distance
      @like[store]=store.get_upvotes.count
    end

    if(params[:view]=='like')
      render 'index2'
    elsif (params[:view]=='distance')
      render 'index2'
    else
      render 'index'
    end
  end

  def upvote
    @store.upvote_from current_user
    redirect_to store_path(@store.id)
  end

  def downvote
    @store.downvote_from current_user
    redirect_to store_path(@store.id)
  end

  def addadmin
    @name=params[:admin][:username]
    @user=User.where("username =?",@name)
    if @user.count!=0
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
      format.html {redirect_to store_path(@store.id)}
		  format.js{}
	   end
  end


  def unfollow
     @follow=FollowStore.where(store_id: params[:id], user_id: current_user.id).destroy_all
     respond_to do |format|
		  format.html {redirect_to store_path(@store.id)}
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
    @work.destroy_all
    redirect_to root_path
  end

  def change_admin
    user=params[:user_id]
    store=@store
    if Work.where(user_id: user, store_id: store.id).exists?
      store.update(owner_id: user)
      current_user.update(roles_mask: 2)
    else
      flash[:error]="non puoi nominare questo utente"
    end
    redirect_to store_path(store.id)
  end

  def leave_store
    user=current_user
    store=params[:id]
    if Work.where(user_id: current_user.id, store_id: store).exists?
      Work.where(user_id: current_user.id, store_id: store).destroy_all
      current_user.update(roles_mask: 0)
    end
    redirect_to root_path
  end


  def show_photo
    if PhotoStore.where(id: params[:picture_id]).exists?
      @photo=PhotoStore.find(params[:picture_id])
      render 'show_photo'
    else
      redirect_to root_path
    end
  end

  def new_photo
  end

  def create_photo
      pic=@store.pictures.build(params.fetch(:picture, {}).permit(:image))
      if pic.save
        flash[:alert]="riuscito"
          redirect_to store_path(@store.id)
      else
        flash[:alert]= "non riuscito"
        render "new_photo"
      end
  end

  def destroy_photo
    if !PhotoStore.where(id: params[:picture_id], store_id: @store.id).exists?
      flash[:alert]="non esiste la foto"
    else
      PhotoStore.where(id: params[:picture_id], store_id: @store.id).destroy_all
    end
    redirect_to store_path(@store.id)
  end

  protected
  #funzione che seatta un parametro
  def store
    if (Store.ids.include?(params[:id].to_i))
      @store=Store.find(params[:id])
    else
      redirect_to root_path
    end
  end
  #
  def store_params
    params.require(:store).permit(:name,:location, :image)
  end
end
