import {
  Controller
} from "@hotwired/stimulus"
import {
  OrbitControls
} from 'three/addons/controls/OrbitControls.js';

import * as THREE from "three";

export default class extends Controller {
  connect() {
    console.log("GUI Controller Debugger:")
    const canvas = document.getElementById('guiCanvas');
    const guiContainer = document.getElementById('guiContainer')
    this.hexRadius = 10;


    this.setup();
    this.createHexagonalGrid(10, 10);
    this.addEventListeners();
  }

  setup() {


    // let scene, camera, renderer, controls;
    this.hexagons = [];
    this.selectedHexagon = null;
    this.mouse = new THREE.Vector2()
    this.raycaster = new THREE.Raycaster();


    this.scene = new THREE.Scene();
    this.camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    this.camera.position.set(0, 50, 100);

    this.renderer = new THREE.WebGLRenderer({
      antialias: true
    });
    this.renderer.setSize(window.innerWidth, window.innerHeight);
    document.body.appendChild(this.renderer.domElement);

    this.controls = new OrbitControls(this.camera, this.renderer.domElement);
    this.controls.enableDamping = true;
    this.controls.dampingFactor = 0.25;
    this.controls.enableZoom = true;

    // createHexagonalGrid(10, 10);

  }

  addEventListeners() {

    window.addEventListener('resize', (e) => {this.onWindowResize(e)}, false);
    document.addEventListener('mousemove', (e) => { this.onDocumentMouseMove(e)}, false);
    document.addEventListener('mousedown', (e) => {this.onDocumentMouseDown(e)}, false);
    document.addEventListener('mouseup', (e) => {this.onDocumentMouseUp(e)}, false);

    window.addEventListener('resize', () => {
      this.setRendererSize();
    });
    this.setRendererSize();
    this.animate();
  }

  // Function to set the size of the renderer
  setRendererSize() {
    this.renderer.setSize(guiContainer.clientWidth, guiContainer.clientHeight);
    this.camera.aspect = guiContainer.clientWidth / guiContainer.clientHeight;
    this.camera.updateProjectionMatrix();
  }



  // animate() {
  // requestAnimationFrame(this.animate.bind(this));

  // // this.mesh.rotation.x += 0.01;
  // // this.mesh.rotation.y += 0.01;

  // this.renderer.render(this.scene, this.camera)
  animate() {
    requestAnimationFrame(this.animate.bind(this));

    if (this.selectedHexagon) {
      this.raycaster.setFromCamera(this.mouse, this.camera);
      const planeZ = new THREE.Plane(new THREE.Vector3(0, 0, 1), 0);
      const intersection = new THREE.Vector3();
      this.raycaster.ray.intersectPlane(planeZ, intersection);
      this.selectedHexagon.position.set(intersection.x, intersection.y, this.selectedHexagon.position.z);
    }

    this.controls.update();
    this.renderer.render(this.scene, this.camera);
  }

  createHexagonGeometry(radius) {
    const shape = new THREE.Shape();
    for (let i = 0; i < 6; i++) {
      shape.lineTo(radius * Math.cos((i * Math.PI) / 3), radius * Math.sin((i * Math.PI) / 3));
    }
    shape.closePath();
    return new THREE.ShapeGeometry(shape);
  }

  createHexagonalGrid(rows, cols) {
    const hexHeight = Math.sqrt(3) * this.hexRadius;
    const hexWidth = 2 * this.hexRadius;
    for (let row = 0; row < rows; row++) {
      for (let col = 0; col < cols; col++) {
        const x = col * hexWidth * 0.75;
        const y = row * hexHeight + (col % 2) * (hexHeight / 2);
        const hexGeometry = this.createHexagonGeometry(this.hexRadius);
        const hexMaterial = new THREE.MeshBasicMaterial({
          color: 0x00ff00,
          side: THREE.DoubleSide
        });
        const hexMesh = new THREE.Mesh(hexGeometry, hexMaterial);
        hexMesh.position.set(x, y, 0);
        this.scene.add(hexMesh);
        this.hexagons.push(hexMesh);
      }
    }
  }

  onWindowResize() {
    this.camera.aspect = window.innerWidth / window.innerHeight;
    this.camera.updateProjectionMatrix();
    this.renderer.setSize(window.innerWidth, window.innerHeight);
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
      this.selectedHexagon = intersects[0].object;
    }
  }

  onDocumentMouseUp(event) {
    event.preventDefault();
    this.selectedHexagon = null;
  }

}