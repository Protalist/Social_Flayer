class CommentsController < ApplicationController
    before_filter :comment, only: [:edit,:indexReply ,:update,:destroy]
    load_and_authorize_resource :except => [:create, :reply]
    def new
      @comment=Comment.new
      render :file => "#{Rails.root}/public/404.html"
    end

    def create
      @comment=Comment.new(comment_params)
      @comment.user_id=current_user.id
      @comment.store_id=params[:store_id]
      authorize! :create, @comment
      if !@comment.save
        flash[:error_comment]= "commento non creato"
      end
      redirect_to store_path(params[:store_id])
    end

    #crea una risposta e crea un messaggio in caso di errore da aggiustare
    def reply
	    @comment=Comment.new(comment_params)
      @comment.user_id=current_user.id
      @comment.store_id=params[:store_id]
      @comment.comment_id=params[:id]
      authorize! :reply, @comment
      if @comment.save
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

    end

    def indexReply
		    @replys=@comment.replys #cerco il commento a cui ci siamo riferiti e le relative risposte
        respond_to do |format|
          format.html {render :file => "#{Rails.root}/public/404.html"}
          format.js {}
        end
    end

    def update
      @comment.update(comment_params)
      redirect_to store_path(params[:store_id])
    end

    def destroy
      @comment.destroy
      respond_to do |format|
        format.html {redirect_to store_path(params[:store_id])}
        format.js {}
      end
    end

    private

    def comment
      if (Comment.ids.include?(params[:id].to_i))
        @comment=Comment.find(params[:id])
      else
        redirect_to root_path
      end
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
