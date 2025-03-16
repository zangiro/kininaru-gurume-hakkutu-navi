class CommentsController < ApplicationController
  before_action :require_login, only: %i[create edit update destroy]

  def create
    @comment = current_user.comments.new(comment_create_params)
    @post = @comment.post
    @comment.save
  end

  def edit
    @comment = current_user.comments.find(params[:id])
    render "comments/edit", content_type: "text/vnd.turbo-stream.html"
  end

  def update
    @comment = current_user.comments.find(params[:id])
    @comment.update(comment_update_params)
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  def edit_cancel
    @comment = current_user.comments.find(params[:id])
    render "comments/edit_cancel", content_type: "text/vnd.turbo-stream.html"
  end

  def replace_all_comments
    @post = Post.find(params[:post_id])
    @post_comments = @post.comments.includes(:user).order(updated_at: :desc)
    render "comments/replace_all_comments", content_type: "text/vnd.turbo-stream.html"
  end

  private

  def comment_create_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end

  def comment_update_params
    params.require(:comment).permit(:body)
  end
end
