crumb :root do
  link raw('<i class="bi bi-house"></i>'), root_path
end
# rawメソッドを使うことでHTMLがそのままレンダリング
# rawを使うときは注意が必要で、不正なHTMLが混入しないように気をつける必要ある

crumb :login do
  link t("breadcrumbs.login")
  parent :root
end

crumb :user_new do
  link t("breadcrumbs.user_register")
  parent :root
end

crumb :user_edit do |user|
  link t("breadcrumbs.user_edit", name: user.name)
  parent :root
end

crumb :user_show do |user|
  link t("breadcrumbs.user_show", name: user.name), user_path(user)
  parent :root
end

crumb :policy do
  link t("breadcrumbs.policy")
  parent :root
end

crumb :terms do
  link t("breadcrumbs.terms")
  parent :root
end

crumb :search_by_form do |word|
  link t("breadcrumbs.search_results"), search_by_form_searchs_path(q: { title_or_dish_description_or_dish_introduction_or_area_tags_name_or_genre_tags_name_or_taste_tags_name_or_outher_tags_name_cont: word })
  parent :root
end

crumb :password_resets do
  link t("breadcrumbs.password_resets")
  parent :root
end

#------------記事関連------------

crumb :post_new do
  link t("breadcrumbs.post_new"), new_post_path
  parent :root
end

crumb :post_index do |user|
  link t("breadcrumbs.post_index"), user_posts_path(user)
  parent :user_show, user
end

crumb :post_edit do |user|
  link t("breadcrumbs.post_edit")
  parent :post_index, user
end

crumb :post_show do |post, area_tags, genre_tags, taste_tags, outher_tags, user, word, post_path|
  title = post.title.length > 13 ? truncate(post.title, length: 13, omission: "...") : post.title
  # truncateはRailsのヘルパーメソッドで文字列を指定した長さで切り詰める機能がある。lengthで文字数を指定
  # omissionは、切り詰めた際に追加する文字列を指定するためのオプション
  if post_path == "1"
    link title
    parent :post_index, user
  elsif post_path == "2"
    link title
    parent :search_by_form, word
  elsif post_path == "3"
    link title
    parent :search_index, area_tags, genre_tags, taste_tags, outher_tags
  elsif post_path == "4"
    link title
    parent :like_index, user
  elsif post_path == "5"
    link title
    parent :view_history_index, user
  else
    link title
    parent :root
  end
end

#-----------------------------

crumb :tag_index do
  link t("breadcrumbs.tags_index"), tags_path
  parent :root
end

crumb :search_index do |area_tags, genre_tags, taste_tags, outher_tags|
  link t("breadcrumbs.search_results"), searchs_path(area_tags: area_tags, genre_tags: genre_tags, taste_tags: taste_tags, outher_tags: outher_tags)
  parent :tag_index
end

crumb :like_index do |user|
  link t("breadcrumbs.liked_posts_index"), user_likes_path(user)
  parent :user_show, user
end

crumb :view_history_index do |user|
  link t("breadcrumbs.view_histories"), view_histories_path
  parent :user_show, user
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
