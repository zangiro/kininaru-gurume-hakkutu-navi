crumb :root do
  link t("breadcrumbs.top"), root_path
end

crumb :login do
  link t("breadcrumbs.login")
  parent :root
end

crumb :user_new do
  link t("breadcrumbs.user_register")
  parent :root
end

crumb :user_edit do |user|
  link "@#{user.name}さんのアカウント情報"
  parent :root
end

crumb :user_show do |user|
  link "@#{user.name}さんのマイページ", user_path(user)
  parent :root
end

#------------記事関連------------

crumb :post_new do
  link "@新規記事作成", new_post_path
  parent :root
end

crumb :post_index do |user|
  link "@#{user.name}さんの記事一覧", user_posts_path(user)
  parent :user_show, user
end

crumb :post_edit do |user|
  link "@記事編集"
  parent :post_index, user
end

crumb :post_show do |post, area_tags, genre_tags, taste_tags, outher_tags, user, playlist, post_path|
  if post_path == "1"
    link "@#{post.title}"
    parent :post_index, user
  elsif post_path == "2"
    link "@#{post.title}"
    parent :playlist_show, playlist, user
  elsif post_path == "3"
    link "@#{post.title}"
    parent :search_index, area_tags, genre_tags, taste_tags, outher_tags
  elsif post_path == "4"
    link "@#{post.title}"
    parent :like_index, user
  elsif post_path == "5"
    link "@#{post.title}"
    parent :view_history_index, user
  else
    link "@#{post.title}"
    parent :root
  end
end

#--------------プレイリスト関連--------------

crumb :playlist_index do |user|
  link "@#{user.name}さんのプレイリスト一覧", user_playlists_path(user)
  parent :user_show, user
end

crumb :playlist_new do |user|
  link "@プレイリスト作成"
  parent :playlist_index, user
end

crumb :playlist_show do |playlist, user|
  link "#{playlist.title}", playlist_path(playlist)
  parent :playlist_index, user
end

#-----------------------------

crumb :tag_index do
  link "@タグ一覧", tags_path
  parent :root
end

crumb :search_index do |area_tags, genre_tags, taste_tags, outher_tags|
  link "@検索結果", searchs_path(area_tags: area_tags, genre_tags: genre_tags, taste_tags: taste_tags, outher_tags: outher_tags)
  parent :tag_index
end

crumb :like_index do |user|
  link "@いいねした記事", user_likes_path(user)
  parent :user_show, user
end

crumb :view_history_index do |user|
  link "@閲覧履歴", view_histories_path
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
