import { Controller } from "@hotwired/stimulus"
import { JSONEditor } from "vanilla-jsoneditor"

export default class extends Controller {
  connect() {
    const assemblyIds = document.getElementById("assembly_ids").value.split(/\s+/);
    const picklistGeneratorForm = document.getElementById("picklistGeneratorForm");
    for (let i =0; i < assemblyIds.length; i++) {
    
    const jsonData = JSON.parse(document.getElementById(`assembly_${assemblyIds[i]}_code`).value);
    const editor = new JSONEditor({
        target: document.getElementById(`assembly_${assemblyIds[i]}_editor`),
        props: {
            content: {
                json: jsonData,
                mode: 'view' // Set the mode to 'view' to disable editing
            }
        }
    })
    }
    
  }
}
