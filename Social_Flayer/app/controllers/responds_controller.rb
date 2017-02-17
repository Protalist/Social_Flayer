class RespondsController < ApplicationController

  def new
    @respond =Respond.new
  end

  def create

    @respond=Respond.new(respond_params)
    @respond.store_id=params[:store_id]
    @respond.comment_id=params[:comment_id]
    authorize! :create, @respond
    if @respond.save
      respond_to do |format|
        format.html {redirect_to store_path(params[:store_id])}
        format.js {}
      end
    else
       respond_to do |format|
          format.html {redirect_to store_path(params[:store_id])}
          format.js {render "shared/nothing"}
      end
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
    respond_to do |format|
        format.html {redirect_to store_path(params[:store_id])}
        format.js {}
    end
  end


    private

    def respond
      if (Respond.ids.include?(params[:id].to_i))
        @respond=Respond.find(params[:id])
      else
        redirect_to root_path
      end
    end
    def respond_params
      
      params.require(:respond).permit(:content)
    end
end

