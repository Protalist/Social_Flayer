class ProductsController < ApplicationController

  def show
    @product=Product.find(params[:id])
    @store=Store.find(params[:store_id])
  end


  def new
    @product=Product.new
  end

  def create
    @store=Store.find(params[:store_id])
    @product=Product.new(product_params)
    @product.store_id=params[:store_id]
    if @product.save
      redirect_to store_path(@store)
    else
      render 'new'
    end
  end

  def edit
    @product=Product.find(params[:id])
  end


  def update
    @product=Product.find(params[:id])
    if @product.update(product_params)
      redirect_to store_path(params[:store_id])
    else
      render 'edit'
    end
  end

#distrugge il prodotto
  def destroy
    @prod=Product.find(params[:id])
    @prod.destroy
    redirect_to store_path(params[:store_id])
  end


  private
  def product_params
      params.require(:product).permit(:name,:price,:feature,:type_p,:duration_h)
  end

  
end
