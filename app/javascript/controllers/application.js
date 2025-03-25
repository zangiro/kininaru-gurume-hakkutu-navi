import { Application } from "@hotwired/stimulus"
import { Autocomplete } from 'stimulus-autocomplete'
// コンポーネントを読み込むための記述

const application = Application.start()
application.register('autocomplete', Autocomplete) 
// コンポーネントにあるAutocompleteコントローラを使えるようにするための記述
// HTML内でdata-controller="autocomplete"の属性をもつ要素に対して、Autocompleteコントローラの機能が適用される

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
