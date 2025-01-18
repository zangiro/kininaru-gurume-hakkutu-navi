class TagsController < ApplicationController
  def index
    @area_tags = AreaTag.joins(:posts).group(:name).select("name, COUNT(*) as count")
    @genre_tags = GenreTag.joins(:posts).group(:name).select("name, COUNT(*) as count")
    @taste_tags = TasteTag.joins(:posts).group(:name).select("name, COUNT(*) as count")
    @outher_tags = OutherTag.joins(:posts).group(:name).select("name, COUNT(*) as count")
  end
end
