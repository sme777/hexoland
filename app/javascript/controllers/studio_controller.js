import { Controller } from "@hotwired/stimulus"
// import JSONEditor

export default class extends Controller {
  connect() {
    console.log("hello")
    // const container = document.getElementById("jsoneditor")
    // const options = {}
    // const editor = new JSONEditor(container, options)

    // // set json
    // const initialJson = {
    //     "Array": [1, 2, 3],
    //     "Boolean": true,
    //     "Null": null,
    //     "Number": 123,
    //     "Object": {"a": "b", "c": "d"},
    //     "String": "Hello World"
    // }
    // editor.set(initialJson)

    // // get json
    // const updatedJson = editor.get()
  }
}
