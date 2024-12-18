class TagsController < ApplicationController
  def index
    @area_tags = AreaTag.joins(:posts).distinct.pluck(:name)
    @genre_tags = GenreTag.joins(:posts).distinct.pluck(:name)
    @taste_tags = TasteTag.joins(:posts).distinct.pluck(:name)
    @outher_tags = OutherTag.joins(:posts).distinct.pluck(:name)
  end
end
