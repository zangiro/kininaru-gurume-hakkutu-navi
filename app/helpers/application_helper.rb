module ApplicationHelper
  def page_title(title = "")   # メソッドが呼ばれたときに引数が渡されなかった場合に、デフォルトで空の文字列を使う意味
    @base_title = "気になるグルメ発掘ナビ"
    title.present? ? "#{title} | #{@base_title}" : @base_title
  end

  def default_meta_tags
    {
      site: "気になるグルメ発掘ナビ",
      title: "気になるグルメ発掘ナビ",
      reverse: true,
      charset: "utf-8",
      description: "今なにを食べたいかは二の次。まずはどんな美味しいグルメが私達の周りにあるかから始めませんか？お手軽操作で幅広いグルメ情報収集を目的としたアプリです。",
      keywords: "料理,グルメ,見た目,発掘,画像",
      canonical: "https://kininaru-gurume.com",
      separator: "|",
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: "https://kininaru-gurume.com",
        image: image_url("ogp.png"),
        local: "ja-JP"
      },
      twitter: {
        card: "summary",
        site: "@bfkjs8",
        image: image_url("ogp.png")
      }
    }
  end
end
