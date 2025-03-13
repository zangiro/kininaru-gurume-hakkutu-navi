class CommentsController < ApplicationController
  def index
    # テスト用インデックス
    @post = Post.find(2)
    @post_comments = @post.comments.includes(:user)
  end

  def create
    @comment = current_user.comments.new(comment_create_params)
    @comment.save
  end

  def edit
    @comment = current_user.comments.find(params[:id])
    render "comments/edit", content_type: "text/vnd.turbo-stream.html"
  end

  def update
    @comment = current_user.comments.find(params[:id])
    if @comment.update(comment_update_params)
      redirect_to root_path
    else
      redirect_to root_path, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private

  def comment_create_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end

  def comment_update_params
    params.require(:comment).permit(:body)
  end
end
