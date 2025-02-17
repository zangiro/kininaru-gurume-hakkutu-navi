class ViewHistoriesController < ApplicationController
  before_action :require_login, only: %i[index]

  def index
    @a1 = current_user.view_histories.includes(:post)
    @a2 = current_user.view_history_posts
    #binding.pry
  end
end
