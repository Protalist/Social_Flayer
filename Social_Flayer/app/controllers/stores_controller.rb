class StoresController < ApplicationController
before_action :store, only: [:show, :edit, :update,:destroy,:upvote,:downvote]

  def show
    @show=@store
    @products=@show.products
  end

  def new
    @store=Store.new
  end

  def create
    @store=Store.new(store_params)
    @store.owner_id=current_user.id
    @admin_stores= Work.new()
    @admin_stores.store_id=@store.id
    @admin_stores.user_id=current_user.id
    @admin_stores.accept=true
    @admin_stores.save

    if @store.save
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



  protected
  #funzione che seatta un parametro
  def store
    if (Store.all.ids.include?(params[:id]))
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
