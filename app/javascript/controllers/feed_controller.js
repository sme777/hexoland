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
    const assembly_type_ids = ["feed_assembly_ids", "popular_assembly_ids", "experimental_assembly_ids"]
    const assembly_types = ["feed", "popular", "experimental"]
    for (let t = 0; t < assembly_type_ids.length; t++) {
      // console.log(document.getElementById(assembly_types[t]).value.split(/\s+/))
      const assemblyIds = document.getElementById(assembly_type_ids[t]).value.split(/\s+/);
      // console.log(assemblyIds)
      for (let i = 0; i < assemblyIds.length; i++) {
        const guiContainer = document.getElementById(`${assembly_types[t]}_assembly_${assemblyIds[i]}_gui`);
        console.log(guiContainer)
        let [scene, camera, renderer, controls] = setupCanvas(guiContainer);

        const assemblyMap = JSON.parse(document.getElementById(`${assembly_types[t]}_assembly_${assemblyIds[i]}_code`).value);
        const bondMap = JSON.parse(document.getElementById(`${assembly_types[t]}_assembly_${assemblyIds[i]}_bonds`).value);
        // console.log(assemblyMap, bondMap);
        const hexBlockGroup = new THREE.Group();
        assemblyMap.forEach((block) => {
          const hexGroup = new THREE.Group();
          block.forEach((monomer) => {
            hexGroup.add((new Hex(monomer.monomer, new THREE.Vector3(monomer.position.x, monomer.position.y, monomer.position.z), bondMap[monomer.monomer])).getObject());
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
}