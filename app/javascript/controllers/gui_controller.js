import { Controller } from "@hotwired/stimulus"
import * as THREE from "three";

export default class extends Controller {
  connect() {
    console.log("GUI Controller Debugger:")
    this.setup();
  }

  setup() {
    const canvas = document.getElementById('guiCanvas');
    const guiContainer = document.getElementById('guiContainer')
    this.scene = new THREE.Scene();
    this.camera = new THREE.PerspectiveCamera(
        75,
        guiContainer.clientWidth / guiContainer.clientHeight,
        0.1,
        1000
    );

    this.renderer = new THREE.WebGLRenderer({canvas: canvas});
    this.renderer.setSize(guiContainer.clientWidth, guiContainer.clientHeight);
    this.renderer.setClearColor(0xffffff, 1);
    // camera.aspect = window.innerWidth / window.innerHeight;
    // camera.updateProjectionMatrix();

    this.basicCubeGeometry = new THREE.BoxGeometry();
    this.material = new THREE.MeshBasicMaterial({color: 0x000ff0})

    this.mesh = new THREE.Mesh(this.basicCubeGeometry, this.material);
    this.mesh.position.set(0, 0, 0)
    this.scene.add(this.mesh);

    this.camera.position.z = 5;
    
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



  animate() {
    requestAnimationFrame(this.animate.bind(this));

    this.mesh.rotation.x += 0.01;
    this.mesh.rotation.y += 0.01;

    this.renderer.render(this.scene, this.camera)
  }
}
