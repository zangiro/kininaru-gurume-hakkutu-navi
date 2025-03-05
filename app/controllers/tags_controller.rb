class TagsController < ApplicationController
  def index
    @area_tags = AreaTag.joins(:posts).group(:name).select("name, COUNT(*) as count").order("count DESC").limit(3)
    @genre_tags = GenreTag.joins(:posts).group(:name).select("name, COUNT(*) as count")
    @taste_tags = TasteTag.joins(:posts).group(:name).select("name, COUNT(*) as count")
    @outher_tags = OutherTag.joins(:posts).group(:name).select("name, COUNT(*) as count")
  end

  def replace_area_tags
    @area_tags = AreaTag.joins(:posts).group(:name).select("name, COUNT(*) as count").order("count DESC")
    render "tags/replace_area_tags", content_type: "text/vnd.turbo-stream.html"
  end
end
