import { Controller } from "@hotwired/stimulus"
import { JSONEditor } from "vanilla-jsoneditor"
import * as THREE from "three";
import {
  OrbitControls
} from 'three/addons/controls/OrbitControls.js';
import {
  setupCanvas,
  onWindowResize,
  animate
} from './canvas_utils';
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
    });

    const guiContainer = document.getElementById('guiContainer');
    
      let [scene, camera, renderer, controls] = setupCanvas(guiContainer);
      // console.log(assemblyMap)
      const assemblyMap = {};    
      const bondMap = {};  
      // console.log(bondMap);
      const hexBlockGroup = new THREE.Group();
      // assemblyMap.forEach((block) => {
      //   const hexGroup = new THREE.Group();
      //   block.forEach((monomer) => {
      //     hexGroup.add((new Hex(monomer.monomer, new THREE.Vector3(monomer.position.x, monomer.position.y, monomer.position.z), bondMap[monomer.monomer])).getObject());
      //   })
      //   hexBlockGroup.add(hexGroup);
      // })

      const boundingBox = new THREE.Box3().setFromObject(hexBlockGroup);

      const center = new THREE.Vector3();
      boundingBox.getCenter(center);

      hexBlockGroup.position.sub(center);
      scene.add(hexBlockGroup);
      // Lighting
      const ambientLight = new THREE.AmbientLight(0xffffff, 2.0);
      scene.add(ambientLight);
      const directionalLight = new THREE.DirectionalLight(0xffffff, 1.0);
      directionalLight.position.set(10, 10, 10);
      scene.add(directionalLight);

      camera.position.z = 200;

      animate(scene, camera, renderer);
      window.addEventListener('resize', () => {
        onWindowResize(renderer, camera, guiContainer);
      });


    const uploadFile = async (file, type) => {
      const formData = new FormData();
      formData.append('file', file);
      formData.append('fileType', type);
      try {
        const response = await fetch('/studio/loader', {
          method: 'POST',
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'), // Include CSRF token
          },
          body: formData,
        });
    
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
    
        const data = await response.json();
        // update the EDITOR

        editor.update({ json: data });
      } catch (error) {
        console.error('Error uploading file:', error);
      }
    };
    
    // Upload Sequence File (Inverse Design)
    document.getElementById('sequenceLoader').addEventListener('change', (event) => {
      const file = event.target.files[0];
      if (file) {
        uploadFile(file, "csv");
      }
    });

    // Upload JSON HexLand file
    document.getElementById('hexlandLoader').addEventListener('change', (event) => {
      const file = event.target.files[0];
      if (file) {
        uploadFile(file, "json");
      }
    });


  }

  
}
