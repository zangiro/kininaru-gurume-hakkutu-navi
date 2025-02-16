class PlaylistsController < ApplicationController
  before_action :require_login, only: %i[new create destroy remove_playlist]

  def new
    @playlist = Playlist.new
    @user = current_user
  end

  def index
    @user = User.find(params[:user_id])
    @playlist = @user.playlists.all.page(params[:page]).per(5)
  end

  def show
    @playlist = Playlist.find(params[:id])
    @playlist_posts = @playlist.posts.all
    @user = @playlist.user
    @post_path = "2"
  end

  def create
    @user = current_user
    @playlist = current_user.playlists.new(playlist_params)
    if @playlist.save
      redirect_to user_playlists_path(current_user), success: "@プレイリストの作成をしました"
    else
      flash.now[:danger] = "@新規作成失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    playlist = current_user.playlists.find(params[:id])
    playlist.destroy
    flash[:success] = "@プレイリストを削除しました"
    redirect_to user_playlists_path(current_user), status: :see_other
  end

  def remove_playlist
    @post = Post.find(params[:id])
    @playlist = Playlist.find(params[:playlist_id])
    @playlist.posts.delete(@post) if @playlist.posts.include?(@post)

    redirect_to playlist_path(@playlist), success: "@登録を削除しました"
  end

  private

  def playlist_params
    params.require(:playlist).permit(:id, :title)
  end
end
