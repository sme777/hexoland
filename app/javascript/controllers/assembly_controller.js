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


export default class extends Controller {
  connect() {
    const assemblyIds = document.getElementById("assembly_ids").value.split(/\s+/);
    for (let i = 0; i < assemblyIds.length; i++) {
      // Set up Code Controller
      const jsonData = JSON.parse(document.getElementById(`assembly_${assemblyIds[i]}_design_code`).value);
      const editor = new JSONEditor({
        target: document.getElementById(`assembly_${assemblyIds[i]}_editor`),
        props: {
          content: {
            json: jsonData,
            mode: 'view' // Set the mode to 'view' to disable editing
          },
          expanded: false
        }
      })

      let guiContainer = document.getElementById(`assembly_${assemblyIds[i]}_gui`);
      let [scene, camera, renderer, controls] = setupCanvas(guiContainer);
      // console.log(assemblyMap)
      const assemblyMap = JSON.parse(document.getElementById(`assembly_${assemblyIds[i]}_assembly_code`).value);    
      const bondMap = JSON.parse(document.getElementById(`assembly_${assemblyIds[i]}_bonds`).value);  
      // console.log(bondMap);
      const hexBlockGroup = new THREE.Group();
      console.log(assemblyMap)
      assemblyMap.forEach((block) => {
        const hexGroup = new THREE.Group();
        block.forEach((monomer) => {
          // console.log(bondMap[monomer.monomer])
          hexGroup.add((new Hex(monomer.monomer, new THREE.Vector3(monomer.position.x, monomer.position.y, monomer.position.z), bondMap[monomer.monomer], 48.0, false)).getObject());
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

}