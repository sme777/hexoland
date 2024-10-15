import { Controller } from "@hotwired/stimulus"
import {
    OrbitControls
  } from 'three/addons/controls/OrbitControls.js';
  import * as THREE from "three";
export default class extends Controller {

    connect() {
        const guiContainer = document.getElementById('guiContainer');
    
        let [scene, camera, renderer, controls] = this.setupCanvas(guiContainer);
        
  
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
        const renderer = new THREE.WebGLRenderer();
        renderer.setSize(width, height);
        canvas.appendChild(renderer.domElement);
        camera.position.z = 30;
    
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
          animateLoop();  // Start the loop
        }
}