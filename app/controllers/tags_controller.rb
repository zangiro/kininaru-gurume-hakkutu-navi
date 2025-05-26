class TagsController < ApplicationController
  def index
    @area_tags = AreaTag.joins(posts: :user)
                        .where.not(users: { account_status: 1 })
                        .group("area_tags.name")
                        .select("area_tags.name, COUNT(*) as count")
                        .order("count DESC")
                        .limit(21)
    @genre_tags = GenreTag.joins(posts: :user)
                          .where.not(users: { account_status: 1 })
                          .group("genre_tags.name")
                          .select("genre_tags.name, COUNT(*) as count")
                          .order("count DESC")
                          .limit(21)
    @taste_tags = TasteTag.joins(posts: :user)
                          .where.not(users: { account_status: 1 })
                          .group("taste_tags.name")
                          .select("taste_tags.name, COUNT(*) as count")
                          .order("count DESC")
                          .limit(21)
    @outher_tags = OutherTag.joins(posts: :user)
                            .where.not(users: { account_status: 1 })
                            .group("outher_tags.name")
                            .select("outher_tags.name, COUNT(*) as count")
                            .order("count DESC")
                            .limit(21)
  end

  def replace_area_tags
    @area_tags = AreaTag.joins(posts: :user)
                        .where.not(users: { account_status: 1 })
                        .group("area_tags.name")
                        .select("area_tags.name, COUNT(*) as count")
                        .order("count DESC")
    render "tags/replace_area_tags", content_type: "text/vnd.turbo-stream.html"
  end

  def replace_genre_tags
    @genre_tags = GenreTag.joins(posts: :user)
                          .where.not(users: { account_status: 1 })
                          .group("genre_tags.name")
                          .select("genre_tags.name, COUNT(*) as count")
                          .order("count DESC")
    render "tags/replace_genre_tags", content_type: "text/vnd.turbo-stream.html"
  end

  def replace_taste_tags
    @taste_tags = TasteTag.joins(posts: :user)
                          .where.not(users: { account_status: 1 })
                          .group("taste_tags.name")
                          .select("taste_tags.name, COUNT(*) as count")
                          .order("count DESC")
    render "tags/replace_taste_tags", content_type: "text/vnd.turbo-stream.html"
  end

  def replace_outher_tags
    @outher_tags = OutherTag.joins(posts: :user)
                            .where.not(users: { account_status: 1 })
                            .group("outher_tags.name")
                            .select("outher_tags.name, COUNT(*) as count")
                            .order("count DESC")
    render "tags/replace_outher_tags", content_type: "text/vnd.turbo-stream.html"
  end
end
