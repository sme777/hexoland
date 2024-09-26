import {
  Controller
} from "@hotwired/stimulus"
import {
  OrbitControls
} from 'three/addons/controls/OrbitControls.js';
import * as THREE from "three";

export default class extends Controller {
  connect() {
    console.log("Hexagonal Grid Controller:")
    const canvas = document.getElementById('guiCanvas');
    const guiContainer = document.getElementById('guiContainer');
    // this.hexRadius = 1;  // Set the radius for each hexagon
    // this.hexagons = [];
    // this.mouse = new THREE.Vector2();
    // this.raycaster = new THREE.Raycaster();

    // this.setup();
    // this.createHexagonalGrid(5);  // Create a grid with radius 5 (ring count)
    // this.addEventListeners();
    const parentDiv = guiContainer.parentElement; // Get the parent div (the Bootstrap column)
    const width = parentDiv.clientWidth;
    const height = parentDiv.clientHeight;


    const scene = new THREE.Scene();
    scene.background = new THREE.Color(0xF1D3CE);

    const camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer();
    renderer.setSize(width, height);
    guiContainer.appendChild(renderer.domElement);

    camera.position.z = 10;

    // Parameters for the hexagonal grid
    const radius = 1; // Radius of each hexagon
    const hexHeight = Math.sqrt(3) * radius; // Height of the hexagon

    // Create a single hexagon geometry
    function createHexagonGeometry(radius) {
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

    const hexGeometry = createHexagonGeometry(radius);
    const hexMaterial = new THREE.LineBasicMaterial({ color: 0x000000 });

    // Draw hexagonal grid
    const cols = 10;
    const rows = 10;

    for (let row = 0; row < rows; row++) {
        for (let col = 0; col < cols; col++) {
            const hexMesh = new THREE.Line(hexGeometry, hexMaterial);

            // Calculate the x, y position of each hexagon
            const x = col * (radius * 1.5);
            const y = row * hexHeight + (col % 2 === 0 ? 0 : hexHeight / 2);

            hexMesh.position.set(x, y, 0);
            scene.add(hexMesh);
        }
    }

    // Animation loop
    function animate() {
        requestAnimationFrame(animate);
        renderer.render(scene, camera);
    }

    animate();

    // Handle resizing
    window.addEventListener('resize', () => {
        const width = window.innerWidth;
        const height = window.innerHeight;
        renderer.setSize(width, height);
        camera.aspect = width / height;
        camera.updateProjectionMatrix();
    });
  }

  setup() {
    this.scene = new THREE.Scene();
    this.camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    this.camera.position.set(0, 50, 100);

    this.renderer = new THREE.WebGLRenderer({
      antialias: true
    });
    this.renderer.setSize(window.innerWidth, window.innerHeight);
    document.getElementById('guiContainer').appendChild(this.renderer.domElement);

    this.controls = new OrbitControls(this.camera, this.renderer.domElement);
    this.controls.enableDamping = true;
    this.controls.dampingFactor = 0.25;
    this.controls.enableZoom = true;
  }

  addEventListeners() {
    window.addEventListener('resize', (e) => { this.onWindowResize(e) }, false);
    document.addEventListener('mousemove', (e) => { this.onDocumentMouseMove(e) }, false);
    document.addEventListener('mousedown', (e) => { this.onDocumentMouseDown(e) }, false);
    document.addEventListener('mouseup', (e) => { this.onDocumentMouseUp(e) }, false);

    this.setRendererSize();
    this.animate();
  }

  setRendererSize() {
    this.renderer.setSize(window.innerWidth, window.innerHeight);
    this.camera.aspect = window.innerWidth / window.innerHeight;
    this.camera.updateProjectionMatrix();
  }

  animate() {
    requestAnimationFrame(this.animate.bind(this));
    this.controls.update();
    this.renderer.render(this.scene, this.camera);
  }

  createHexagonGeometry(radius) {
    const hexGeometry = new THREE.CylinderGeometry(radius, radius, 0.2, 6);  // Hexagon as a cylinder
    hexGeometry.rotateX(Math.PI / 2); // Lay the hexagon flat on the XY plane
    return hexGeometry;
  }

  createHexagon(color = 0x00ff00) {
    const hexGeometry = this.createHexagonGeometry(this.hexRadius);
    const hexMaterial = new THREE.MeshBasicMaterial({ color });
    const hexMesh = new THREE.Mesh(hexGeometry, hexMaterial);
    return hexMesh;
  }

  // Convert axial (q, r) coordinates to Cartesian (x, y) coordinates
  axialToCartesian(q, r) {
    const x = this.hexRadius * 3/2 * q;  // Horizontal spacing
    const y = this.hexRadius * Math.sqrt(3) * (r + q / 2);  // Vertical spacing with staggered rows
    return new THREE.Vector3(x, y, 0);
  }

  // Create hexagonal grid based on axial coordinates
  createHexagonalGrid(radius) {
    for (let q = -radius; q <= radius; q++) {
      for (let r = -radius; r <= radius; r++) {
        if (Math.abs(q + r) <= radius) {  // Ensure that we stay within the hexagonal boundary
          const position = this.axialToCartesian(q, r);
          const hexMesh = this.createHexagon(0x00ffff);
          hexMesh.position.set(position.x, position.y, position.z);
          this.scene.add(hexMesh);
          this.hexagons.push(hexMesh);
        }
      }
    }
  }

  onDocumentMouseMove(event) {
    event.preventDefault();
    this.mouse.x = (event.clientX / window.innerWidth) * 2 - 1;
    this.mouse.y = -(event.clientY / window.innerHeight) * 2 + 1;
  }

  onDocumentMouseDown(event) {
    event.preventDefault();

    this.raycaster.setFromCamera(this.mouse, this.camera);
    const intersects = this.raycaster.intersectObjects(this.hexagons);
    if (intersects.length > 0) {
      const intersectedObject = intersects[0];
      const intersectedPos = intersectedObject.point;

      // Create a new hexagon voxel at the clicked position
      const newHex = this.createHexagon(0xff0000);  // Red color for the new voxel
      newHex.position.set(intersectedPos.x, intersectedPos.y + 0.2, intersectedPos.z);
      this.scene.add(newHex);
    }
  }

  onDocumentMouseUp(event) {
    event.preventDefault();
    this.selectedHexagon = null;
  }

  onWindowResize() {
    this.camera.aspect = window.innerWidth / window.innerHeight;
    this.camera.updateProjectionMatrix();
    this.renderer.setSize(window.innerWidth, window.innerHeight);
  }
}
