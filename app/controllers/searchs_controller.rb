class SearchsController < ApplicationController
  def index
    @area_tags = params[:area_tags] || []
    @genre_tags = params[:genre_tags] || []
    @taste_tags = params[:taste_tags] || []
    @outher_tags = params[:outher_tags] || []

    @area_posts = Post.joins(:user)
                      .joins(:area_tags)
                      .where(area_tags: { name: @area_tags })
                      .where.not(users: { account_status: 1 })
    @genre_posts = Post.joins(:user)
                       .joins(:genre_tags)
                       .where(genre_tags: { name: @genre_tags })
                       .where.not(users: { account_status: 1 })
    @taste_posts = Post.joins(:user)
                       .joins(:taste_tags)
                       .where(taste_tags: { name: @taste_tags })
                       .where.not(users: { account_status: 1 })
    @outher_posts = Post.joins(:user)
                        .joins(:outher_tags)
                        .where(outher_tags: { name: @outher_tags })
                        .where.not(users: { account_status: 1 })

    @post_ids = @area_posts.pluck(:id) + @genre_posts.pluck(:id) + @taste_posts.pluck(:id) + @outher_posts.pluck(:id)

    if params[:latest]
      @search_posts = Post.where(id: @post_ids).order(created_at: :desc).page(params[:page]).per(30)
    elsif params[:old]
      @search_posts = Post.where(id: @post_ids).order(created_at: :asc).page(params[:page]).per(30)
    else
      @search_posts = Post.where(id: @post_ids).page(params[:page]).per(30)
    end
    # 簡略化用メソッドを実装したい。現在NoMethodErrorで未実装。記事一覧と同様処理で行けそう

    @post_path = "3"

    # ----------------------以下おすすめ表示--------------------------
    @maximum_number = Post.how_many_posts?(@search_posts.count)
    # how_many_posts?は@search_postsの数に応じて変数に数字を代入する。
    # おすすめ表示で使用。ヒット数が少なければおおっきい数字を。多ければ0~少ない数字を返す。

    if logged_in?
      @all_users_view_histories = ViewHistory.joins(:user)
                                             .where.not(user_id: current_user.id)
                                             .where.not(users: { account_status: 1 })
                                             .order(created_at: :desc)
                                             .limit(50)
    else
      @all_users_view_histories = ViewHistory.joins(:user)
                                             .where.not(users: { account_status: 1 })
                                             .order(created_at: :desc)
                                             .limit(50)
    end
    # ログインの有無でおすすめとして参照するデータを少し変える。

    @recommendations = Post.joins(:user)
                           .joins(:view_histories)
                           .where(view_histories: { id: @all_users_view_histories })
                           .where.not(users: { account_status: 1 })
                           .group("posts.id")
                           .order("COUNT(posts.id) DESC")
                           .limit(@maximum_number)
    # この変数はおすすめ表示で使用。閲覧履歴を参照してより多く閲覧されてるものを、タグ検索のヒット数が一定以下の場合表示する。
  end

  def search_by_form
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true)
               .joins(:user)
               .where.not(users: { account_status: 1 })
               .page(params[:page])
               .per(30)
    @word = params.dig(:q, :title_or_dish_description_or_dish_introduction_or_area_tags_name_or_genre_tags_name_or_taste_tags_name_or_outher_tags_name_cont) || []
    # @word = params[:q][:title_...]の形で直接searchs/search_by_formと入力するとエラー出る
    # .digはネストされたハッシュや配列から値を安全に取得するために使う。
    # この場合「:q」が存在しない場合NoMethodErrorになる。.digを使うと「:q」がnilでもエラーにならない。
    @post_path = "2"

    # ----------------------以下おすすめ表示--------------------------
    @maximum_number = Post.how_many_posts?(@posts.count)

    if logged_in?
      @all_users_view_histories = ViewHistory.joins(:user)
                                             .where.not(user_id: current_user.id)
                                             .where.not(users: { account_status: 1 })
                                             .order(created_at: :desc)
                                             .limit(50)
    else
      @all_users_view_histories = ViewHistory.joins(:user)
                                             .where.not(users: { account_status: 1 })
                                             .order(created_at: :desc)
                                             .limit(50)
    end

    @recommendations = Post.joins(:user)
                           .joins(:view_histories)
                           .where(view_histories: { id: @all_users_view_histories })
                           .where.not(users: { account_status: 1 })
                           .group("posts.id")
                           .order("COUNT(posts.id) DESC")
                           .limit(@maximum_number)
  end

  def autocomplete
    @posts = Post.joins(:user)
                 .where("title like ?", "%#{params[:q]}%")
                 .where.not(users: { account_status: 1 })
                 .limit(10)
    render partial: "autocomplete"
  end
end
