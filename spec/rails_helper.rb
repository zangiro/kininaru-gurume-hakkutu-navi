# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
# Uncomment the line below in case you have `--require rails_helper` in the `.rspec` file
# that will avoid rails generators crashing because migrations haven't been run yet
# return unless Rails.env.test?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }
# capybara等ファイルの読み込み設定のため、コメントアウトを解除。（spec/support内の.rbファイルをすべて見つけて読み込み）
# sort_by(&:to_s): 見つけたファイルを文字列としてソートしている。これで、ファイルが決まった順序で読み込まれる。
# each { |f| require f }: ソートされたファイルを一つずつrequireで読み込んでいる。これにより、テストに必要な設定やメソッドを使えるようになる。
# ----「Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }」似てるけど意味や処理違う？
# ファイルを取得する方法が異なるだけで、最終的な目的は同じ

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.include FactoryBot::Syntax::Methods
  # specファイルでfactory botが利用できるようする

  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails uses metadata to mix in different behaviours to your tests,
  # for example enabling you to call `get` and `post` in request specs. e.g.:
  #
  #     RSpec.describe UsersController, type: :request do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://rspec.info/features/7-0/rspec-rails
  #
  # You can also this infer these behaviours automatically by location, e.g.
  # /spec/models would pull in the same behaviour as `type: :model` but this
  # behaviour is considered legacy and will be removed in a future version.
  #
  # To enable this behaviour uncomment the line below.
  # config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # システムスペック実行前にテストを動かすブラウザを設定
  config.before(:each, type: :system) do
    # 各テストの前に実行されるブロックを定義

    driven_by :remote_chrome
    #テストをリモートのChromeブラウザで実行するための設定をしている。これにより、ブラウザの操作がテストで行えるようになる

    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    # テストサーバーのホスト名を取得して、Capybaraのサーバーホストに設定している。これで、テストがどのホストで実行されるかを正しく指定してる

    Capybara.server_port = 4444
    # テストサーバーがリッスンするポートを4444に設定している

    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
    # アプリケーションのホストURLを設定している。これにより、テスト中にアクセスするURLが正しく指定される

    Capybara.ignore_hidden_elements = false
    # 隠れた要素を無視しない設定にしている。これにより、テスト中に隠れた要素もチェックすることができるようになる
  end
end
