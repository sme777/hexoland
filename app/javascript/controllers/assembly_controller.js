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

      // Set up GUI Controller
      // console.log("Starting up GUI Controller")
      let guiContainer = document.getElementById(`assembly_${assemblyIds[i]}_gui`)
      // console.log(guiContainer)
      let [scene, camera, renderer, controls] = setupCanvas(guiContainer);

      // Define the bond configurations for each side of the hexagon
      let hexBondData = {
        "S1": ['1', '1', 'x', '1', 'x', '1', '1', '1'],
        "S2": ['1', '0', '1', '1', '0', '1', '1', '0'],
        "S3": ['1', '1', '0', '1', '1', '0', '1', '1'],
        "S4": ['0', 'x', '1', '0', 'x', '1', '0', '1'],
        "S5": ['x', '1', '1', '0', 'x', '1', '0', '1'],
        "S6": ['x', '1', '0', '1', 'x', '0', '1', '1']
      };

      let hex1 = new Hex(10, 25, 0xf5e6cb, 0x000000, hexBondData);

      hex1.getObject().position.set(0, 0, 0);
      // console.log(hex1.getObject())
      scene.add(hex1.getObject());

      // Ground and lighting setup
      let groundGeometry = new THREE.PlaneGeometry(200, 200);
      let groundMaterial = new THREE.ShadowMaterial({
        opacity: 0.2
      });
      let ground = new THREE.Mesh(groundGeometry, groundMaterial);
      ground.rotation.x = -Math.PI / 2;
      ground.position.y = -20; // Positioned further below the hex to avoid overlap
      ground.receiveShadow = true;
      scene.add(ground);

      // Add lighting to the scene
      let light = new THREE.DirectionalLight(0xffffff, 1);
      light.position.set(5, 5, 5);
      scene.add(light);

      // Set the camera to ensure that it views the hex properly from the front
      camera.position.set(0, 0, 60); // Move the camera back and center it on the x and y axes
      camera.lookAt(0, 0, 0); // Make sure the camera is looking at the center

      controls.target.set(0, 0, 0); // Set the OrbitControls to target the center of the scene
      controls.update();
      // console.log("calling animate now")
      animate(scene, camera, renderer);

      window.addEventListener('resize', () => {
        onWindowResize(renderer, camera, guiContainer);
      });
    }
  }
}