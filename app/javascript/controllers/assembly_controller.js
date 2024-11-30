import {
  Controller
} from "@hotwired/stimulus"
import {
  JSONEditor
} from "vanilla-jsoneditor"
import {
  Hex
} from "../models/hex"
import * as THREE from "three";
import {
  setupCanvas,
  onWindowResize,
  animate
} from './canvas_utils';

import HexWorker from "../workers/hexWorker";
console.log(HexWorker)
export default class extends Controller {
  connect() {
    const assemblyIds = document.getElementById("assembly_ids").value.split(/\s+/);
    const picklistGeneratorForm = document.getElementById("picklistGeneratorForm");
    // console.log(assemblyIds.length)
    for (let i = 0; i < assemblyIds.length; i++) {

      // Set up Code Controller
      const jsonData = JSON.parse(document.getElementById(`assembly_${assemblyIds[i]}_design_code`).value);
      const editor = new JSONEditor({
        target: document.getElementById(`assembly_${assemblyIds[i]}_editor`),
        props: {
          content: {
            json: jsonData,
            mode: 'view' // Set the mode to 'view' to disable editing
          }
        }
      })

      let guiContainer = document.getElementById(`assembly_${assemblyIds[i]}_gui`)
      let [scene, camera, renderer, controls] = setupCanvas(guiContainer);
      // console.log(assemblyMap)
      const assemblyMap = JSON.parse(document.getElementById(`assembly_${assemblyIds[i]}_assembly_code`).value);    
      const bondMap = JSON.parse(document.getElementById(`assembly_${assemblyIds[i]}_bonds`).value);  
      const hexBlockGroup = new THREE.Group();
      assemblyMap.forEach((block) => {
        const hexGroup = new THREE.Group();
        block.forEach((monomer) => {
          hexGroup.add((new Hex(monomer.monomer, new THREE.Vector3(monomer.position.x, monomer.position.y, monomer.position.z), bondMap)).getObject());
        })
        hexBlockGroup.add(hexGroup);
      })

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
    }
  }

  getSpacings() {
    const startObject = new Hex(new THREE.Vector3(0, 0, 0));
    return startObject.getSpacings();
  }

}