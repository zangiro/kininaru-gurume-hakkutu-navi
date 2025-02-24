class StaticPagesController < ApplicationController
  def top
    @money = "お金"
    @posts = Post.all.order("created_at DESC").limit(8)
    if logged_in?
      @user = current_user
      @aa = current_user.view_history_posts.order("view_histories.created_at DESC").limit(30)
      @hairetu = AreaTag.joins(:posts).where(posts: { id: @aa }).group('area_tags.id').order('COUNT(area_tags.id) DESC')
      @test = @hairetu.map(&:name)
      @rec1 = Post.joins(:area_tags).where(area_tags: { name: @test }).distinct
      @rec2 = Post.joins(:area_tags).where(area_tags: { name: @test }).where.not(user_id: current_user.id).distinct
      #.limit(@maximum_number)
      #binding.pry
    end
  end
end
