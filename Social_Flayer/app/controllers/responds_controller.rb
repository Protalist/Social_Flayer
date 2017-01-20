class RespondsController < ApplicationController

  def new
    @respond =Respond.new
  end

  def create
    puts "agagagaggag"
    @respond=Respond.new(params.require(:respond).permit(:content))
    @respond.store_id=params[:store_id]
    @respond.comment_id=params[:comment_id]
    if @respond.save
      respond_to do |format|
        format.html {redirect_to store_path(params[:store_id])}
        format.js {}
      end
    else
      render 'responds/form'
    end
  end

  def edit
    @respond=Respond.find(params[:id])
  end

  def update
    @respond=Respond.find(params[:id])
    @respond.update(params.require(:respond).permit(:content))
    redirect_to store_path(params[:store_id])
  end

  def destroy
    @respond=Respond.find(params[:id])
    @respond.destroy
  end

end
