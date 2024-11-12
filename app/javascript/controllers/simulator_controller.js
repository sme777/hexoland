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
import {
  GLTFLoader
} from 'three/examples/jsm/loaders/GLTFLoader.js';

import {
  setupCanvas,
  onWindowResize,
  animate
} from './canvas_utils';

export default class extends Controller {

  connect() {
    const guiContainer = document.getElementById('guiContainer');

    let [scene, camera, renderer, controls] = setupCanvas(guiContainer);

    // Define the bond configurations for each side of the hexagon
    // const hexBondData = {
    //   "S1": ['1', '1', 'x', '1', 'x', '1', '1', '1'],
    //   "S2": ['1', '0', '1', '1', '0', '1', '1', '0'],
    //   "S3": ['1', '1', '0', '1', '1', '0', '1', '1'],
    //   "S4": ['0', 'x', '1', '0', 'x', '1', '0', '1'],
    //   "S5": ['x', '1', '1', '0', 'x', '1', '0', '1'],
    //   "S6": ['x', '1', '0', '1', 'x', '0', '1', '1']
    // };

    // // Create the hexagonal prism with the specified bond data for each side
    // const hex1 = new Hex(10, 25, 0xf5e6cb, 0x000000, hexBondData);

    // const hex2 = new Hex(10, 25, 0xf5e6cb, 0x000000, hexBondData);

    // const hex3 = new Hex(10, 25, 0xf5e6cb, 0x000000, hexBondData);

    // // Position the hex at the center of the scene
    // hex1.getObject().position.set(0, 0, 0);
    // hex2.getObject().position.set(0, 25, 0);
    // hex3.getObject().position.set(20, 12.5, 0);

    // scene.add(hex1.getObject());
    // scene.add(hex2.getObject());
    // scene.add(hex3.getObject());
    const hex1 = new Hex(25, 0, 0);
    const hex2 = new Hex(45, 0, 32.5);
    const hex3 = new Hex(25, 50.5, 0);
    const hex4 = new Hex(45, 50.5, 32.5);
    // const hex5 = new Hex(25, 90, 0);
    // const hex6 = new Hex(45, 90, 32.5);
    // const hex7 = new Hex(25, 135, 0);
    // const hex8 = new Hex(45, 135, 32.5);
    // const hex9 = new Hex(25, 180, 0);
    // const hex10 = new Hex(45, 180, 32.5);
    scene.add(hex1.getObject());
    scene.add(hex2.getObject());
    scene.add(hex3.getObject());
    scene.add(hex4.getObject());
    // scene.add(hex5.getObject());
    // scene.add(hex6.getObject());
    // scene.add(hex7.getObject());
    // scene.add(hex8.getObject());
    // scene.add(hex9.getObject());
    // scene.add(hex10.getObject());
    // Lighting
    const ambientLight = new THREE.AmbientLight(0xffffff, 2.0);
    scene.add(ambientLight);
    const directionalLight = new THREE.DirectionalLight(0xffffff, 1.0);
    directionalLight.position.set(10, 10, 10);
    scene.add(directionalLight);

    camera.position.z = 500;

    animate(scene, camera, renderer);

    window.addEventListener('resize', () => {
      onWindowResize(renderer, camera, guiContainer);
    });
  }

}