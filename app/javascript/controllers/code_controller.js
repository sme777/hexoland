import { Controller } from "@hotwired/stimulus"
import { JSONEditor } from "vanilla-jsoneditor"

export default class extends Controller {
  connect() {
    console.log("Code Controller Debugger:")
    
    const designMapField = document.getElementById("designMap");

    let content = {
      text: undefined,
      json: {
        "Z-4": {
          "building_blocks": null,
          "ignore_generation": false,
          "max_xy_overlap": 0.0,
          "xy_trials": 1,
          "max_z_overlap": 0.0,
          "z_trials": 5,
          "bond_families": {
            "standard": {
              "bonds_attractive": 0,
              "bonds_neutral": 0,
              "bonds_repulsive": 0,
              "bonds_z": 4,
              "min_xy_fe": 0,
              "max_xy_fe": 200,
              "min_z_fe": 86,
              "max_z_fe": 98
            }
          },
          "bond_map": {
            "M1": {
              "ZU": "M2"
            },
            "M2": {
              "ZD": "M1",
              "ZU": "M3"
            },
            "M3": {
              "ZD": "M2",
              "ZU": "M4"
            },
            "M4": {
              "ZD": "M3"
            }
          }
        }
      }
    };
    

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
