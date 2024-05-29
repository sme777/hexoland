import { Controller } from "@hotwired/stimulus"
import * as THREE from "three";
import { STLLoader } from 'three/addons/loaders/STLLoader.js';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';


function voxelizeGeometry(geometry, voxelSize, scene) {
  const boundingBox = geometry.boundingBox;
  const width = boundingBox.max.x - boundingBox.min.x;
  const height = boundingBox.max.y - boundingBox.min.y;
  const depth = boundingBox.max.z - boundingBox.min.z;

  const numVoxelsX = Math.ceil(width / voxelSize);
  const numVoxelsY = Math.ceil(height / voxelSize);
  const numVoxelsZ = Math.ceil(depth / voxelSize);

  const stlMesh = new THREE.Mesh(geometry, new THREE.MeshBasicMaterial());
  const hexRadius = voxelSize / Math.sqrt(3);

  for (let i = 0; i < numVoxelsX; i++) {
    for (let j = 0; j < numVoxelsY; j++) {
      for (let k = 0; k < numVoxelsZ; k++) {
        const voxelCenter = new THREE.Vector3(
          boundingBox.min.x + i * voxelSize + voxelSize / 2,
          boundingBox.min.y + j * voxelSize + voxelSize / 2,
          boundingBox.min.z + k * voxelSize + voxelSize / 2,
        );

        if (isPointInsideGeometry(voxelCenter, stlMesh)) {
          addHexVoxel(voxelCenter, hexRadius, voxelSize, scene);
        }
      }
    }
  }
}

function isPointInsideGeometry(point, mesh) {
  const raycaster = new THREE.Raycaster();
  raycaster.set(point, new THREE.Vector3(1, 0, 0));
  const intersects = raycaster.intersectObject(mesh);
  return intersects.length % 2 !== 0;
}

function addHexVoxel(center, radius, height, scene) {
  const hexGeometry = new THREE.CylinderGeometry(radius, radius, height, 6);
  const material = new THREE.MeshLambertMaterial({ color: 0xCDE8E5 });
  const hexMesh = new THREE.Mesh(hexGeometry, material);
  hexMesh.position.copy(center);
  console.log(hexMesh);
  scene.add(hexMesh);
}

export default class extends Controller {
  connect() {

    const fileLoaderMask = document.getElementById("fileLoaderMask");
    const fileLoaderField = document.getElementById("fileLoaderField");
    const fileDownLoaderMask = document.getElementById("fileDownloaderMask");
    const fileDownLoader = document.getElementById("fileDownloader");
    const voxelSize = 5;

    this.setup();

    fileLoaderMask.addEventListener("click", () => {
      fileLoaderField.click();
      
    })

    fileLoaderField.addEventListener("change", (e) => {
      this.handleFileUpload(e, this.scene, voxelSize);
    })

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
    this.renderer.setClearColor(0xffffff, 1);

    this.camera.position.z = 250;
    const controls = new OrbitControls(this.camera, this.renderer.domElement);
    this.scene.add( new THREE.HemisphereLight( 0x8d7c7c, 0x494966, 3 ) );
    
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
  

  handleFileUpload(event, scene, voxelSize) {
    const file = event.target.files[0];
    const material = new THREE.MeshLambertMaterial( { color: 0xd5d5d5, specular: 0x494949, shininess: 200 } );
    if (file) {
        const reader = new FileReader();
        reader.onload = function(event) {
            const contents = event.target.result;
            const loader = new STLLoader();
            const geometry = loader.parse(contents);
            geometry.computeBoundingBox();

            // Center the geometry
            const boundingBox = geometry.boundingBox;
            const centerX = (boundingBox.max.x + boundingBox.min.x) / 2;
            const centerY = (boundingBox.max.y + boundingBox.min.y) / 2;
            const centerZ = (boundingBox.max.z + boundingBox.min.z) / 2;

            geometry.translate(-centerX, -centerY, -centerZ);

            console.log(voxelizeGeometry(geometry, voxelSize, scene));
        };
        reader.readAsArrayBuffer(file);
    }
  }


  animate() {
    requestAnimationFrame(this.animate.bind(this));

    this.renderer.render(this.scene, this.camera)
  }
}
