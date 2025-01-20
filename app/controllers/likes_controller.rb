class LikesController < ApplicationController
  def create
    #@board = Board.find(params[:board_id])
    #current_user.bookmark(@board)
    @post = Post.find(params[:post_id])
    current_user.like(@post)
    redirect_to root_path, success: "@"
  end

  def destroy
    #@board = current_user.bookmarks.find(params[:id]).board
    #current_user.unbookmark(@board)
  end
end
