class StaticPagesController < ApplicationController
  def top
    if logged_in? && current_user.view_history_posts.present?
      @current_user_view_histories = current_user.view_history_posts.order("view_histories.created_at DESC")
                                                                    .active_users
                                                                    .limit(MAXIMUM_VIEW_HISTORY)
      @area_tags = AreaTag.joins(:posts)
                          .where(posts: { id: @current_user_view_histories })
                          .active_users
                          .group("area_tags.id")
                          .order("COUNT(area_tags.id) DESC")
                          .limit(REFERENCE_TAG)
      # 閲覧履歴を参照。そのなかから最も多いタグを元におすすめを算出する準備

      @words = @area_tags.map(&:name)
      # この処理で@area_tagsのAreaTagの情報のnameカラムで["word1","word2","word3"]という配列を作る

      @recommendations = Post.joins(:area_tags)
                             .where(area_tags: { name: @words })
                             .where.not(user_id: current_user.id)
                             .active_users
                             .distinct.limit(SMAXIMUM_TOPPAGE_POST)
    else
      @all_user_view_histories = Post.joins(:view_histories)
                                     .order("view_histories.created_at DESC")
                                     .active_users
                                     .limit(MAXIMUM_VIEW_HISTORY)
      @area_tags = AreaTag.joins(:posts)
                          .where(posts: { id: @all_user_view_histories })
                          .active_users
                          .group("area_tags.id")
                          .order("COUNT(area_tags.id) DESC")
                          .limit(REFERENCE_TAG)
      @words = @area_tags.map(&:name)
      @recommendations = Post.joins(:area_tags)
                             .where(area_tags: { name: @words })
                             .active_users
                             .distinct.limit(SMAXIMUM_TOPPAGE_POST)
    end
  end
end
