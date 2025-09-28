import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "existing"]

  previewImage() {
    const input = this.inputTarget
    const preview = this.previewTarget
    const existing = this.existingTarget
    const files = input.files

    if (existing) {existing.style.display = 'none';}

    if (files.length > 0) {
      const reader = new FileReader()
  
      reader.onload = (e) => {preview.innerHTML = `<img src="${e.target.result}" style="max-width: 200px; max-height: 200px;">`;}
      // onloadはFileReaderのプロパティの一つ。ファイルの読み込みが完了したときに呼ばれるイベントハンドラーを設定するためのもの
      // 「preview.innerHTML」ビューで設定された「data-preview-target="preview"」を対象に中身を新しいHTMLに置き換えている
      // 「e.target.result」には、読み込んだファイルのデータが格納されていて、これをsrc属性に設定することで、画像がブラウザで表示されるようになる
  
      reader.readAsDataURL(files[0])
      // readAsDataURLは、FileReaderオブジェクトのメソッドの一つ。指定されたファイルを読み込み内容をデータURL形式で取得するために使う
      // ファイルの内容を非同期に読み込み、読み込みが完了するとonloadイベントが発火する
    }
  }
}
