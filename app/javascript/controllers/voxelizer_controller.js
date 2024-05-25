import { Controller } from "@hotwired/stimulus"
import * as THREE from "three";

export default class extends Controller {
  connect() {
    console.log("Voxelizer Controller Debugger:")
    console.log("Basic THREEJS Setup")
    this.setup();
  }

  setup() {
    const canvas = document.getElementById('voxelizerCanvas');
    const voxelizerContainer = document.getElementById('voxelizerContainer')
    this.scene = new THREE.Scene();
    this.camera = new THREE.PerspectiveCamera(
        75,
        voxelizerContainer.clientWidth / voxelizerContainer.clientHeight,
        0.1,
        1000
    );

    this.renderer = new THREE.WebGLRenderer({canvas: canvas});
    this.renderer.setSize(voxelizerContainer.clientWidth, voxelizerContainer.clientHeight);
    // camera.aspect = window.innerWidth / window.innerHeight;
    // camera.updateProjectionMatrix();

    this.basicCubeGeometry = new THREE.BoxGeometry();
    this.material = new THREE.MeshBasicMaterial({color: 0xff0000})

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
        this.renderer.setSize(voxelizerContainer.clientWidth, voxelizerContainer.clientHeight);
        this.camera.aspect = voxelizerContainer.clientWidth / voxelizerContainer.clientHeight;
        this.camera.updateProjectionMatrix();
    }



  animate() {
    requestAnimationFrame(this.animate.bind(this));

    this.mesh.rotation.x += 0.01;
    this.mesh.rotation.y += 0.01;

    this.renderer.render(this.scene, this.camera)
  }
}
