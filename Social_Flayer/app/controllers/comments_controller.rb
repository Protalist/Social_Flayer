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

    def edit
      @comment=Comment.find(params[:id])
    end

    def update
      @comment=Comment.find(params[:id])
      @comment.update(params.require(:comment).permit(:content))
      redirect_to store_path(params[:store_id])
    end
end
