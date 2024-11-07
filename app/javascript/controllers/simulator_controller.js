import {
  Controller
} from "@hotwired/stimulus"
import {
  OrbitControls
} from 'three/addons/controls/OrbitControls.js';
import * as THREE from "three";
import {
  Hex
} from "../models/hex"
import {
  Panel
} from "../models/panel"
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js';

import { setupCanvas, onWindowResize, animate } from './canvas_utils';

export default class extends Controller {

  connect() {
    const guiContainer = document.getElementById('guiContainer');

    let [scene, camera, renderer, controls] = setupCanvas(guiContainer);

    // Define the bond configurations for each side of the hexagon
    const hexBondData = {
      "S1": ['1', '1', 'x', '1', 'x', '1', '1', '1'],
      "S2": ['1', '0', '1', '1', '0', '1', '1', '0'],
      "S3": ['1', '1', '0', '1', '1', '0', '1', '1'],
      "S4": ['0', 'x', '1', '0', 'x', '1', '0', '1'],
      "S5": ['x', '1', '1', '0', 'x', '1', '0', '1'],
      "S6": ['x', '1', '0', '1', 'x', '0', '1', '1']
    };

    // Create the hexagonal prism with the specified bond data for each side
    const hex1 = new Hex(10, 25, 0xf5e6cb, 0x000000, hexBondData);

    const hex2 = new Hex(10, 25, 0xf5e6cb, 0x000000, hexBondData);

    const hex3 = new Hex(10, 25, 0xf5e6cb, 0x000000, hexBondData);

    // Position the hex at the center of the scene
    hex1.getObject().position.set(0, 0, 0);
    hex2.getObject().position.set(0, 25, 0);
    hex3.getObject().position.set(20, 12.5, 0);

    scene.add(hex1.getObject());
    scene.add(hex2.getObject());
    scene.add(hex3.getObject());

    // Ground and lighting setup
    const groundGeometry = new THREE.PlaneGeometry(200, 200);
    const groundMaterial = new THREE.ShadowMaterial({
      opacity: 0.2
    });
    const ground = new THREE.Mesh(groundGeometry, groundMaterial);
    ground.rotation.x = -Math.PI / 2;
    ground.position.y = -20; // Positioned further below the hex to avoid overlap
    ground.receiveShadow = true;
    scene.add(ground);

    // Add lighting to the scene
    const light = new THREE.DirectionalLight(0xffffff, 5);
    light.position.set(50, 50, 50);
    scene.add(light);

    // Set the camera to ensure that it views the hex properly from the front
    camera.position.set(0, 0, 60); // Move the camera back and center it on the x and y axes
    camera.lookAt(0, 0, 0); // Make sure the camera is looking at the center

    controls.target.set(0, 0, 0); // Set the OrbitControls to target the center of the scene
    controls.update();


    // const loader = new GLTFLoader();
    // console.log("GLB Loaded")
    // loader.load(
    //   hexModelPath, // Path to the exported .glb/.gltf file
    //   function (gltf) {
    //     const model = gltf.scene;
    //     scene.add(model);  // Add the model to your scene
    //   },
    //   function (xhr) {
    //     console.log((xhr.loaded / xhr.total * 100) + '% loaded');
    //   },
    //   function (error) {
    //     console.error('An error happened', error);
    //   }
    // );


    animate(scene, camera, renderer);

    window.addEventListener('resize', () => {
      onWindowResize(renderer, camera, guiContainer);
    });
  }

}
