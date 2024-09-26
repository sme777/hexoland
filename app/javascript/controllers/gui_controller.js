import {
    Controller
  } from "@hotwired/stimulus"
  import {
    OrbitControls
  } from 'three/addons/controls/OrbitControls.js';
  import * as THREE from "three";

export default class extends Controller {

    connect() {
      const guiContainer = document.getElementById('guiContainer');
    
      let [scene, camera, renderer, controls] = this.setupCanvas(guiContainer);
  
      const hexRadius = 1;
      const hexHeight = Math.sqrt(3) * hexRadius;
      const hexGrid = this.createHexCanvas(hexRadius, hexHeight, scene, camera);
  
      // Setup raycaster and mouse
      let raycaster = new THREE.Raycaster();
      let mouse = new THREE.Vector2();
  
      // Add event listener for mouse click
      renderer.domElement.addEventListener('click', (event) => this.onHexClick(event, hexGrid, camera));
  
      this.animate(scene, camera, renderer);
  
      window.addEventListener('resize', () => {
          this.onWindowResize(renderer, camera, guiContainer);
      });
    }

    createHexCanvas(hexRadius, hexHeight, scene, camera) {
      const geometry = this.createHexGeometry(hexRadius);
      const material = new THREE.LineBasicMaterial({ color: 0x000000 });
      const hexGrid = new THREE.Group();
      // Draw hexagonal grid
      const cols = 20;
      const rows = 20;

      for (let row = 0; row < rows; row++) {
          for (let col = 0; col < cols; col++) {
              const hexMesh = new THREE.Line(geometry, material);

              // Calculate the x, y position of each hexagon
              const x = col * (hexRadius * 1.5);
              const y = row * hexHeight + (col % 2 === 0 ? 0 : hexHeight / 2);

              hexMesh.position.set(x, y, 0);
              hexMesh.userData = { row, col };
              hexGrid.add(hexMesh);
          }
      }

      scene.add(hexGrid);
      return hexGrid;
      // const box = new THREE.Box3().setFromObject(hexGrid);
      // const center = new THREE.Vector3();
      // box.getCenter(center);
      // camera.lookAt(center);
      
    }

    create3DHex(position) {
      const hexHeight = 1;  // The height of the hexagonal prism
      const hexRadius = 1;  // The radius of the hexagonal prism
      const hexGeometry = new THREE.CylinderGeometry(hexRadius, hexRadius, hexHeight, 6);
      const hexMaterial = new THREE.MeshBasicMaterial({ color: 0x00ff00 });
      const hexMesh = new THREE.Mesh(hexGeometry, hexMaterial);
  
      // Set the position of the 3D hex to the clicked hex's position
      hexMesh.position.set(position.x, position.y, 0); // Z-axis is set to 0 to match the 2D plane
  
      // Rotate the hexagon so that it's oriented the same way as the 2D hexes
      hexMesh.rotation.x = Math.PI / 2; // Rotate the hex to be flat on the XZ plane
  
      return hexMesh;
  }
  

    createHexGeometry(radius) {
      const geometry = new THREE.BufferGeometry();
      const vertices = [];
      for (let i = 0; i < 6; i++) {
          const angle = (i * Math.PI) / 3; // Divide circle into 6 parts
          const x = radius * Math.cos(angle);
          const y = radius * Math.sin(angle);
          vertices.push(x, y, 0);
      }
      vertices.push(vertices[0], vertices[1], 0); // Close the hexagon loop
      geometry.setAttribute('position', new THREE.Float32BufferAttribute(vertices, 3));
      return geometry;
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


    onHexClick(event, hexGrid, camera) {
      const raycaster = new THREE.Raycaster();
      const mouse = new THREE.Vector2();
  
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