class TagsController < ApplicationController
  def index
    @area_tags = AreaTag.joins(:posts).group(:name).select("name, COUNT(*) as count").order("count DESC").limit(21)
    @genre_tags = GenreTag.joins(:posts).group(:name).select("name, COUNT(*) as count").order("count DESC").limit(21)
    @taste_tags = TasteTag.joins(:posts).group(:name).select("name, COUNT(*) as count").order("count DESC").limit(21)
    @outher_tags = OutherTag.joins(:posts).group(:name).select("name, COUNT(*) as count").order("count DESC").limit(21)
  end

  def replace_area_tags
    @area_tags = AreaTag.joins(:posts).group(:name).select("name, COUNT(*) as count").order("count DESC")
    render "tags/replace_area_tags", content_type: "text/vnd.turbo-stream.html"
  end

  def replace_genre_tags
    @genre_tags = GenreTag.joins(:posts).group(:name).select("name, COUNT(*) as count").order("count DESC")
    render "tags/replace_genre_tags", content_type: "text/vnd.turbo-stream.html"
  end

  def replace_taste_tags
    @taste_tags = TasteTag.joins(:posts).group(:name).select("name, COUNT(*) as count").order("count DESC")
    render "tags/replace_taste_tags", content_type: "text/vnd.turbo-stream.html"
  end

  def replace_outher_tags
    @outher_tags = OutherTag.joins(:posts).group(:name).select("name, COUNT(*) as count").order("count DESC")
    render "tags/replace_outher_tags", content_type: "text/vnd.turbo-stream.html"
  end
end
