class TagsController < ApplicationController
  def index
    @area_tags = AreaTag.active_users
                        .group("area_tags.name")
                        .select("area_tags.name, COUNT(*) as count")
                        .order("count DESC")
                        .limit(MAXIMUM_TAG)
    @genre_tags = GenreTag.active_users
                          .group("genre_tags.name")
                          .select("genre_tags.name, COUNT(*) as count")
                          .order("count DESC")
                          .limit(MAXIMUM_TAG)
    @taste_tags = TasteTag.active_users
                          .group("taste_tags.name")
                          .select("taste_tags.name, COUNT(*) as count")
                          .order("count DESC")
                          .limit(MAXIMUM_TAG)
    @outher_tags = OutherTag.active_users
                            .group("outher_tags.name")
                            .select("outher_tags.name, COUNT(*) as count")
                            .order("count DESC")
                            .limit(MAXIMUM_TAG)
  end

  def replace_area_tags
    @area_tags = AreaTag.active_users
                        .group("area_tags.name")
                        .select("area_tags.name, COUNT(*) as count")
                        .order("count DESC")
    render "tags/replace_area_tags", content_type: "text/vnd.turbo-stream.html"
  end

  def replace_genre_tags
    @genre_tags = GenreTag.active_users
                          .group("genre_tags.name")
                          .select("genre_tags.name, COUNT(*) as count")
                          .order("count DESC")
    render "tags/replace_genre_tags", content_type: "text/vnd.turbo-stream.html"
  end

  def replace_taste_tags
    @taste_tags = TasteTag.active_users
                          .group("taste_tags.name")
                          .select("taste_tags.name, COUNT(*) as count")
                          .order("count DESC")
    render "tags/replace_taste_tags", content_type: "text/vnd.turbo-stream.html"
  end

  def replace_outher_tags
    @outher_tags = OutherTag.active_users
                            .group("outher_tags.name")
                            .select("outher_tags.name, COUNT(*) as count")
                            .order("count DESC")
    render "tags/replace_outher_tags", content_type: "text/vnd.turbo-stream.html"
  end
end
