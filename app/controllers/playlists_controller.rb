class PlaylistsController < ApplicationController
  before_action :require_login, only: %i[new create]

  def new
    @playlist = Playlist.new
  end

  def index
    @user = User.find(params[:user_id])
    @playlist = @user.playlists.all
  end

  def show
    @playlist = Playlist.find(params[:id])
    @playlist_posts = @playlist.posts.all
    @user = @playlist.user
  end

  def create
    @playlist = current_user.playlists.new(playlist_params)
    if @playlist.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    playlist = current_user.playlists.find(params[:id])
    playlist.destroy
    redirect_to user_playlists_path(current_user), status: :see_other
  end

  def remove_playlist
    @post = Post.find(params[:id])
    @playlist = Playlist.find(params[:playlist_id])
    @playlist.posts.delete(@post) if @playlist.posts.include?(@post)

    redirect_to playlist_path(@playlist)
  end

  private

  def playlist_params
    params.require(:playlist).permit(:id, :title)
  end
end
