# CapybaraにリモートChromeドライバーを登録する処理をしている
Capybara.register_driver :remote_chrome do |app|
  # remote_chromeという名前で新しいドライバーを登録している。

  options = Selenium::WebDriver::Chrome::Options.new
  # Chromeのオプションを設定するための新しいオプションオブジェクトを作成している

  options.add_argument('no-sandbox')
  # サンドボックスモードを無効にするオプションを追加している。これにより、特定の環境での動作を改善できることがある

  options.add_argument('headless')
  # ヘッドレスモードでChromeを起動するオプションを追加している。これにより、ブラウザのUIを表示せずにバックグラウンドでテストを実行できる

  options.add_argument('disable-gpu')
  # GPUハードウェアを無効にするオプションを追加している。特にヘッドレスモードでは、これが必要なことが多い

  options.add_argument('window-size=1680,1050')
  # Chromeウィンドウのサイズを指定している。テストの際の画面サイズを統一するために役立つ

  Capybara::Selenium::Driver.new(app, browser: :remote, url: ENV['SELENIUM_DRIVER_URL'], capabilities: options)
  # 上記で設定したオプションを使って、リモートのSeleniumサーバーに接続するドライバーを作成している。
end
