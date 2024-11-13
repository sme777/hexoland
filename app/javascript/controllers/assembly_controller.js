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

      let guiContainer = document.getElementById(`assembly_${assemblyIds[i]}_gui`)
      let [scene, camera, renderer, controls] = setupCanvas(guiContainer);

      const worker = new HexWorker();
      const spacings = this.getSpacings();

      worker.computeNeighbors(jsonData, spacings).then((assemblyBlocks) => {
        const hexBlockGroup = new THREE.Group();
        // console.log(assemblyBlocks)
        assemblyBlocks.forEach((block) => {
          // console.log(block)
          const hexGroup = new THREE.Group();
          block.forEach((monomer) => {
            const hex = (new Hex(new THREE.Vector3(monomer.position.x, monomer.position.y, monomer.position.z))).getObject();
            hexGroup.add(hex);
          })
          hexBlockGroup.add(hexGroup);
        });

        const boundingBox = new THREE.Box3().setFromObject(hexBlockGroup);
        const center = new THREE.Vector3();
        boundingBox.getCenter(center);
        hexBlockGroup.position.sub(center);
        scene.add(hexBlockGroup);

        const ambientLight = new THREE.AmbientLight(0xffffff, 2.0);
        scene.add(ambientLight);
        const directionalLight = new THREE.DirectionalLight(0xffffff, 1.0);
        directionalLight.position.set(10, 10, 10);
        scene.add(directionalLight);

        camera.position.z = 200;
        
      });
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