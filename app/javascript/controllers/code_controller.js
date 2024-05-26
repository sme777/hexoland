import { Controller } from "@hotwired/stimulus"
import { JSONEditor } from "vanilla-jsoneditor"

export default class extends Controller {
  connect() {
    console.log("Code Controller Debugger:")
    
    const designMapField = document.getElementById("designMap");

    let content = {
      text: undefined,
      json: {
        greeting: 'Hello World'
      }
    }

    const editor = new JSONEditor({
      target: document.getElementById('jsoneditor'),
      props: {
        content,
        onChange: (updatedContent, previousContent, { contentErrors, patchResult }) => {
          // content is an object { json: JSONData } | { text: string }
          if (editor.get()["text"] !== undefined) {
            designMapField.value = editor.get()["text"];
          } else if ((editor.get()["json"] !== undefined)) {
            designMapField.value = JSON.stringify(editor.get()["json"]);
          }
          
          content = updatedContent
        }
      }
    })
  }
}
