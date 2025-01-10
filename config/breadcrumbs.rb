crumb :root do
  link "Home", root_path
end

crumb :login do
  link "@ログイン"
  parent :root
end

crumb :user_new do
  link "@ユーザー登録"
  parent :root
end

crumb :user_edit do |user|
  link "@#{user.name}さんのアカウント情報"
  parent :root
end

crumb :user_show do |user|
  link "#{user.name}さんのマイページ", user_path(user)
  parent :root
end

#------------------------

crumb :post_new do
  link "@新規記事作成", new_post_path
  parent :root
end

crumb :post_index do |user|
  link "@#{user.name}さんの記事一覧", posts_path
  parent :user_show, user
end

crumb :post_edit do |user|
  link "@記事編集"
  parent :post_index, user
end

crumb :post_show do |post, area_tags, genre_tags, taste_tags, outher_tags, user, post_path|
  if post_path == "1"
    link "@#{post.title}"
    parent :post_index, user
  else
    link "@#{post.title}"
    parent :search_index, area_tags, genre_tags, taste_tags, outher_tags
  end
end

#----------------------------

crumb :tag_index do
  link "@タグ一覧", tags_path
  parent :root
end

crumb :search_index do |area_tags, genre_tags, taste_tags, outher_tags|
  link "@検索結果", searchs_path(area_tags: area_tags, genre_tags: genre_tags, taste_tags: taste_tags, outher_tags: outher_tags)
  parent :tag_index
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