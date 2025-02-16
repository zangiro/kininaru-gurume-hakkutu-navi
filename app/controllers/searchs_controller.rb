class SearchsController < ApplicationController
  def index
    @area_tags = params[:area_tags] || []
    @genre_tags = params[:genre_tags] || []
    @taste_tags = params[:taste_tags] || []
    @outher_tags = params[:outher_tags] || []

    @area_posts = Post.joins(:area_tags).where(area_tags: { name: @area_tags })
    @genre_posts = Post.joins(:genre_tags).where(genre_tags: { name: @genre_tags })
    @taste_posts = Post.joins(:taste_tags).where(taste_tags: { name: @taste_tags })
    @outher_posts = Post.joins(:outher_tags).where(outher_tags: { name: @outher_tags })

    @search_posts = (@area_posts + @genre_posts + @taste_posts + @outher_posts).uniq
    @post_path = "3"
    #@area_posts = Post.joins(:area_tags).where(area_tags: { name: @area_tags })
    #@genre_posts = Post.joins(:genre_tags).where(genre_tags: { name: @genre_tags })

    #@search_posts = (@area_posts + @genre_posts)
    @a1 = Post.joins(:area_tags, :genre_tags).where(area_tags: { name: @area_tags })
    #@a1a = Post.joins(:area_tags, :genre_tags).where(area_tags: { name: @area_tags })
    @a2 = Post.joins(:area_tags, :genre_tags).where(area_tags: { name: @area_tags }, genre_tags: { name: @genre_tags })
    #@area_posts = Post.joins(:area_tags).where(area_tags: { name: "鎌倉"})
    #@area_genre_posts = Post.joins(:area_tags, :genre_tags).where(area_tags: { name: "鎌倉"})
    @b1 = Post.joins(:area_tags, :genre_tags).where(area_tags: { name: "関東"}, genre_tags: { name: "木の画像"})
    @b2 = Post.joins(:area_tags, :genre_tags).where('area_tags.name = ? OR genre_tags.name = ?', "関東", "木の画像")
    @b3 = Post.joins(:area_tags).where('area_tags.name = ?', "関東")
    #binding.pry
    #@b4 = Post.joins(:area_tags, :genre_tags).where(area_tags: { name: "関東" }).or(Post.joins(:genre_tags).where(genre_tags: { name: "カレー" }))
    @b5 = Post.joins(:area_tags, :genre_tags).where(area_tags: { name: "関東" })
    #xxx@b6 = Post.joins(:area_tags).where(area_tags: { name: "関東" }).or(area_tags: { name: "さいたま" })
    @b7 = Post.joins(:area_tags).where('area_tags.name = ?', "関東").or(Post.joins(:area_tags).where('area_tags.name = ?', "京都"))
    #xxx@b8 = Post.joins(:area_tags).where('area_tags.name = ?', "関東").or(Post.joins(:genre_tags).where('genre_tags.name = ?', "京都"))
    #xxx@b9 = Post.joins(:area_tags, :genre_tags).where('area_tags.name = ?', "関東").or(Post.joins(:genre_tags).where('genre_tags.name = ?', "京都"))
    @c1 = Post.joins(:area_tags, :genre_tags).where('area_tags.name = ? OR genre_tags.name = ? OR area_tags.name IS NULL OR genre_tags.name IS NULL', '海', 'アイス')

    # エラーでないが取得もできない　　@c2 = Post.joins(:area_tags, :genre_tags).where('area_tags.name = ? AND genre_tags.name IS NULL', '関東')
    # 入力ない場合に対応してない　　@c3 = Post.joins(:area_tags, :genre_tags).where('area_tags.name = ? OR genre_tags.name IS NULL', '関東')
    # 入力ない場合に対応してない　　@c4 = Post.joins(:area_tags, :genre_tags).where('area_tags.name = ?', '関東').where('genre_tags.name IS NULL OR genre_tags.name IS NOT NULL')
    # 入力ない場合に対応してない    @c5 = Post.joins(:area_tags, :genre_tags).where('area_tags.name = ? AND genre_tags.name = ?', '関東','')
    @c5 = Post.joins(:genre_tags).where('genre_tags.name = ?','')
    @c6 = Post.joins(:genre_tags).where('genre_tags.name IS NULL')
    @c7 = Post.where('source IS NULL OR source = ?', '')
    # 入力ない場合に対応してない   @c8 = Post.joins(:genre_tags).where('genre_tags.name IS NULL OR genre_tags.name = ?', '')
    # each文でエラー　　@c9 = Post.joins(:post_genre_tags).joins(:genre_tag).where('genre_tags.name = ?', 'アイス')
  end
end
