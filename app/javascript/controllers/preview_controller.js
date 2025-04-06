import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "existing"]

  previewImage() {
    const input = this.inputTarget
    const preview = this.previewTarget
    const existing = this.existingTarget
    const files = input.files   
    // HTMLの<input type="file">要素から選択されたファイルの配列を取得できる
    // 直接ビューに<input type="file">はないが「form.file_field :avatar」がそれを生成するRailsのヘルパーメソッド

    if (existing) {existing.style.display = 'none';}
    // 編集時、既存の画像は初期表示。この処理で非表示にする。

    if (files.length > 0) {
      const reader = new FileReader()
      // new FileReaderを使うために特別な準備は必要ない。FileReaderはブラウザが提供するAPIだから、JavaScriptを実行できる環境があればすぐに使える。
      // FileReaderテーブルみたいなのは不必要
  
      reader.onload = (e) => {preview.innerHTML = `<img src="${e.target.result}">`;}
      // onloadはFileReaderのプロパティの一つ。ファイルの読み込みが完了したときに呼ばれるイベントハンドラーを設定するためのもの。
      // ファイルの読み込みが成功したときに、指定された関数（ここではアロー関数）が実行される
      // 「(e) => { ... }」はアロー関数の定義。eはイベントオブジェクトで、読み込みが完了したファイルに関する情報を持っている。
      // 「preview.innerHTML」ビューで設定された「data-preview-target="preview"」を対象に中身を新しいHTMLに置き換えている
      // 「e.target.result」には、読み込んだファイルのデータが格納されていて、これをsrc属性に設定することで、画像がブラウザで表示されるようになる
  
      reader.readAsDataURL(files[0])
      // readAsDataURLは、FileReaderオブジェクトのメソッドの一つ。指定されたファイルを読み込み内容をデータURL形式で取得するために使う
      // ファイルの内容を非同期に読み込み、読み込みが完了するとonloadイベントが発火する
    }
  }
}
