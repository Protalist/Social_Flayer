class CommentsController < ApplicationController
    before_action :comment, only: [:edit,:indexReply ,:update,:destroy]

    def new
      @comment=Comment.new
    end

    def create
      @comment=Comment.new(comment_params)
      @comment.user_id=current_user.id
      @comment.store_id=params[:store_id]
      if @comment.save
        redirect_to store_path(params[:store_id])
      else
        render 'new'
      end
    end
    #crea una risposta e crea un messaggio in caso di errore da aggiustare
    def reply
	    @comment=Comment.new(comment_params)
      @comment.user_id=current_user.id
      @comment.store_id=params[:store_id]
      @comment.comment_id=params[:id]
      if @comment.save
        respond_to do |format|
          format.html {redirect_to store_path(params[:store_id])}
          format.js {}
        end
      else
        render 'comments/form',comment: @comment , path:reply_store_comment_path(params[:store_id],params[:id])
      end

     end

    def edit
    end

    def indexReply
		    @replys=@comment.replys #cerco il commento a cui ci siamo riferiti e le relative risposte
    end

    def update
      @comment=Comment.find(params[:id])
      @comment.update(comment_params)
      redirect_to store_path(params[:store_id])
    end

    def destroy
      @comment=Comment.find(params[:id])
      @comment.destroy
    end

    private

    def comment
      if (Comment.all.ids.include?(params[:id].to_i))
        @comment=Comment.find(params[:id])
      else
        redirect_to root_path
      end
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
