class StaticPagesController < ApplicationController
  def top
    if logged_in? && current_user.view_history_posts.present?
      @current_user_view_histories = current_user.view_history_posts.order("view_histories.created_at DESC").limit(30)
      @area_tags = AreaTag.joins(:posts).where(posts: { id: @current_user_view_histories }).group("area_tags.id").order("COUNT(area_tags.id) DESC").limit(5)
      @words = @area_tags.map(&:name)
      # この処理で@area_tagsのAreaTagの情報のnameカラムで["word1","word2","word3"]という配列を作る
      @recommendations = Post.joins(:area_tags).where(area_tags: { name: @words }).where.not(user_id: current_user.id).distinct.limit(8)
    else
      @all_user_view_histories = Post.joins(:view_histories).order("view_histories.created_at DESC").limit(30)
      @area_tags = AreaTag.joins(:posts).where(posts: { id: @all_user_view_histories }).group("area_tags.id").order("COUNT(area_tags.id) DESC").limit(5)
      @words = @area_tags.map(&:name)
      @recommendations = Post.joins(:area_tags).where(area_tags: { name: @words }).distinct.limit(8)
    end
  end
end
