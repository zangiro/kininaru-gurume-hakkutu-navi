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

    @post_ids = @area_posts.pluck(:id) + @genre_posts.pluck(:id) + @taste_posts.pluck(:id) + @outher_posts.pluck(:id)

    if params[:latest]
      @search_posts = Post.where(id: @post_ids).order(created_at: :desc).page(params[:page]).per(3)
    elsif params[:old]
      @search_posts = Post.where(id: @post_ids).order(created_at: :asc).page(params[:page]).per(3)
    else
      @search_posts = Post.where(id: @post_ids).page(params[:page]).per(12)
    end
    # 簡略化用メソッドを実装したい。現在NoMethodErrorで未実装。記事一覧と同様処理で行けそう

    @post_path = "3"

    # ----------------------おすすめ表示--------------------------

    # ページネーションありでも動作確認

    @maximum_number = Post.how_many_posts?(@search_posts.count)

    # モデルを使わないパターン　最大画像数18
    # if @search_posts.count == 0
    #  @maximum_number = 18
    # elsif @search_posts.count <= 6
    #  @maximum_number = 12
    # elsif @search_posts.count <= 12
    #  @maximum_number = 6
    # else
    #  @maximum_number = 0
    # end

    # テスト用の閲覧履歴のデータを使わないで記事を取得するパターン
    # @recommendations = Post.all.limit(@maximum_number)
    if logged_in?
      @all_users_view_histories = ViewHistory.where.not(user_id: current_user.id).order(created_at: :desc).limit(30)
    else
      @all_users_view_histories = ViewHistory.order(created_at: :desc).limit(30)
    end
    @recommendations = Post.joins(:view_histories).where(view_histories: { id: @all_users_view_histories }).group("posts.id").order("COUNT(posts.id) DESC").limit(@maximum_number)
  end

  def search_by_form
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).page(params[:page]).per(5)
    @word = params.dig(:q, :title_or_dish_description_or_dish_introduction_or_area_tags_name_or_genre_tags_name_or_taste_tags_name_or_outher_tags_name_cont) || []
    # @word = params[:q][:title_...]の形で直接searchs/search_by_formと入力するとエラー出る
    # .digはネストされたハッシュや配列から値を安全に取得するために使う。
    # この場合「:q」が存在しない場合NoMethodErrorになる。.digを使うと「:q」がnilでもエラーにならない。
    @post_path = "2"
  end

  def autocomplete
    @posts = Post.where("title like ?", "%#{params[:q]}%")
    render partial: "autocomplete"
  end
end
