class ProductsController < ApplicationController
  before_filter :product, only: [:show, :edit ,:update,:destroy]
  load_and_authorize_resource :except => :create


  def show
    @store=Store.find(@product.store_id)
  end


  def new
    @product=Product.new
  end

  def create
    @store=Store.find(params[:store_id])
    @product=@store.products.build(product_params)

    if @product.save
      authorize! :create, @product
      redirect_to store_path(@store.id)
    else
      render 'new'
    end
  end

  def edit
    @product=Product.find(params[:id])
  end


  def update
    @store=Store.find(@product.store_id)
    if @product.update(product_params)
      redirect_to store_path(@store.id)
    else
      render 'edit'
    end
  end

#distrugge il prodotto
  def destroy
    @product.destroy
    redirect_to store_path(@product.store_id)
  end


  private
  def product
    if (Product.ids.include?(params[:id].to_i))
      @product=Product.find(params[:id])
    else
      redirect_to root_path
    end
  end

  def product_params
      params.require(:product).permit(:name,:price,:feature,:type_p,:duration_h)
  end


end
