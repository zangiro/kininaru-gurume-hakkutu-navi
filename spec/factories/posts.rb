FactoryBot.define do
  factory :post do
    title { "記事A" }
    after(:build) do |post|
      post.main_image.attach(io: File.open(Rails.root.join('spec/fixtures/files/1.jpg')), filename: '1.jpg', content_type: 'image/jpeg')
    end
    # postオブジェクトがビルドされた後に実行される処理を定義している
    # post.main_image.attach ... postオブジェクトが作成される際に画像が関連付けられる
    # io: File.open(Rails.root.join(xxx)) ... 指定されたパスのファイルを開いて、その内容を io として渡している。
    #        Rails.root.join は、Railsアプリケーションのルートディレクトリを基準にパスを作成するメソッド。
    #        io として渡す意味は、添付するファイルの内容をストリームとして提供するため。
    #        これにより、Active Storageがそのファイルを読み込んで、main_image に添付できるようになる
    # filename:xxx ... 添付するファイルの名前を指定している。データベースに保存される際に使用される。
    # content_type:xxx ... 添付するファイルのMIMEタイプを指定している。

    association :user
  end
end
