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

export default class extends Controller {

  connect() {
    const guiContainer = document.getElementById('guiContainer');

    let [scene, camera, renderer, controls] = this.setupCanvas(guiContainer);

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
    const light = new THREE.DirectionalLight(0xffffff, 1);
    light.position.set(5, 5, 5);
    scene.add(light);

    // Set the camera to ensure that it views the hex properly from the front
    camera.position.set(0, 0, 60); // Move the camera back and center it on the x and y axes
    camera.lookAt(0, 0, 0); // Make sure the camera is looking at the center

    controls.target.set(0, 0, 0); // Set the OrbitControls to target the center of the scene
    controls.update();

    this.animate(scene, camera, renderer);

    window.addEventListener('resize', () => {
      this.onWindowResize(renderer, camera, guiContainer);
    });
  }

  setupCanvas(canvas) {
    const parentDiv = canvas.parentElement; // Get the parent div (the Bootstrap column)
    const width = parentDiv.clientWidth;
    const height = parentDiv.clientHeight;

    const scene = new THREE.Scene();
    scene.background = new THREE.Color(0xF1D3CE);

    const camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer({ antialias: true });
    renderer.setSize(width, height);
    canvas.appendChild(renderer.domElement);

    const controls = new OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;
    controls.dampingFactor = 0.25;
    controls.enableZoom = true;

    return [scene, camera, renderer, controls];
  }

  onWindowResize(renderer, camera, container) {
    // Update the camera aspect ratio and projection matrix
    camera.aspect = container.clientWidth / container.clientHeight;
    camera.updateProjectionMatrix();

    // Update the renderer size
    renderer.setSize(container.clientWidth, container.clientHeight);

    // Ensure the renderer's pixel ratio is correct (useful for high-DPI displays)
    renderer.setPixelRatio(window.devicePixelRatio);
  }

  animate(scene, camera, renderer) {
    const animateLoop = () => {
      requestAnimationFrame(animateLoop);
      renderer.render(scene, camera);
    };
    animateLoop(); // Start the loop
  }
}
