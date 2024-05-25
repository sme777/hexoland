import { Controller } from "@hotwired/stimulus"
import { JSONEditor } from "vanilla-jsoneditor"

export default class extends Controller {
  connect() {
    console.log("Studio Controller Debugger:")
    // console.log(JSONEditor)
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
          console.log('onChange', { updatedContent, previousContent, contentErrors, patchResult })
          content = updatedContent
        }
      }
    })
  }
}
