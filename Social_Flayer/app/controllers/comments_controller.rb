class CommentsController < ApplicationController
    def new
      @comment=Comment.new
    end

    def create
      @comment=Comment.new(params.require(:comment).permit(:content))
      @comment.user_id=current_user.id
      @comment.store_id=params[:store_id]
      if !@comment.save
        flash[:comm]= @comment.errors.full_messages
      end
      redirect_to store_path(params[:store_id])
    end
    #crea una risposta e crea un messaggio in caso di errore da aggiustare
    def reply
	  @comment=Comment.new(params.require(:comment).permit(:content))
      @comment.user_id=current_user.id
      @comment.store_id=params[:store_id]
      @comment.comment_id=params[:id]
      if !@comment.save
        flash[:comm]= @comment.errors.full_messages
      end
      redirect_to store_path(params[:store_id])
     end

    def edit
      @comment=Comment.find(params[:id])
    end
    def indexReply
		#@replys=Comment.find(params[:id]).replys #cerco il commento a cui ci siamo riferiti e le relative risposte
    end
    def update
      @comment=Comment.find(params[:id])
      @comment.update(params.require(:comment).permit(:content))
      redirect_to store_path(params[:store_id])
    end
end
