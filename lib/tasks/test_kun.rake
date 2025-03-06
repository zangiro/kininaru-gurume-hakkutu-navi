namespace :test_kun do
  desc "テスト、閲覧履歴全削除"
  task test_view_delete: :environment do
    ViewHistory.destroy_all
  end
end
