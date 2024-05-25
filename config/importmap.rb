# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js"
pin "three-js" # @79.0.0
pin "three" # @0.164.1
pin "vanilla-jsoneditor" # @0.23.4
pin "@codemirror/autocomplete", to: "@codemirror--autocomplete.js" # @6.16.0
pin "@codemirror/commands", to: "@codemirror--commands.js" # @6.5.0
pin "@codemirror/lang-json", to: "@codemirror--lang-json.js" # @6.0.1
pin "@codemirror/language", to: "@codemirror--language.js" # @6.10.1
pin "@codemirror/lint", to: "@codemirror--lint.js" # @6.8.0
pin "@codemirror/search", to: "@codemirror--search.js" # @6.5.6
pin "@codemirror/state", to: "@codemirror--state.js" # @6.4.1
pin "@codemirror/view", to: "@codemirror--view.js" # @6.26.3
pin "@fortawesome/free-regular-svg-icons", to: "@fortawesome--free-regular-svg-icons.js" # @6.5.2
pin "@fortawesome/free-solid-svg-icons", to: "@fortawesome--free-solid-svg-icons.js" # @6.5.2
pin "@lezer/common", to: "@lezer--common.js" # @1.2.1
pin "@lezer/highlight", to: "@lezer--highlight.js" # @1.2.0
pin "@lezer/json", to: "@lezer--json.js" # @1.0.2
pin "@lezer/lr", to: "@lezer--lr.js" # @1.4.0
pin "@replit/codemirror-indentation-markers", to: "@replit--codemirror-indentation-markers.js" # @6.5.1
pin "ajv" # @8.13.0
pin "codemirror-wrapped-line-indent" # @1.0.8
pin "crelt" # @1.0.6
pin "fast-deep-equal" # @3.1.3
pin "immutable-json-patch" # @6.0.1
pin "jmespath" # @0.16.0
pin "json-schema-traverse" # @1.0.0
pin "json-source-map" # @0.6.1
pin "jsonrepair" # @3.8.0
pin "lodash-es" # @4.17.21
pin "memoize-one" # @6.0.0
pin "natural-compare-lite" # @1.4.0
pin "style-mod" # @4.1.2
pin "uri-js" # @4.4.1
pin "vanilla-picker" # @2.12.3
pin "w3c-keyname" # @2.2.8
