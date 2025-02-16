import {
  Controller
} from "@hotwired/stimulus"
import {
  JSONEditor
} from "vanilla-jsoneditor"
import * as THREE from "three";
import {
  OrbitControls
} from 'three/addons/controls/OrbitControls.js';
import {
  STLLoader
} from 'three/examples/jsm/loaders/STLLoader.js';

import {
  setupCanvas,
  onWindowResize,
  animate,
  setupInteractiveControls
} from './canvas_utils';
import {
  Hex
} from "../models/hex";
import {
  HexGroup
} from "../models/hexGroup";
export default class extends Controller {
  connect() {
    console.log("Code Controller Debugger:")

    const designMapField = document.getElementById("designMap");

    let content = {
      text: undefined,
      json: {
        "Z-4": {
          "building_blocks": null,
          "ignore_generation": false,
          "max_xy_overlap": 0.0,
          "xy_trials": 1,
          "max_z_overlap": 0.0,
          "z_trials": 5,
          "bond_families": {
            "standard": {
              "bonds_attractive": 0,
              "bonds_neutral": 0,
              "bonds_repulsive": 0,
              "bonds_z": 4,
              "min_xy_fe": 0,
              "max_xy_fe": 200,
              "min_z_fe": 86,
              "max_z_fe": 98
            }
          },
          "bond_map": {
            "M1": {
              "ZU": "M2"
            },
            "M2": {
              "ZD": "M1",
              "ZU": "M3"
            },
            "M3": {
              "ZD": "M2",
              "ZU": "M4"
            },
            "M4": {
              "ZD": "M3"
            }
          }
        }
      }
    };


    const editor = new JSONEditor({
      target: document.getElementById('jsoneditor'),
      props: {
        content,
        onChange: (updatedContent, previousContent, {
          contentErrors,
          patchResult
        }) => {
          // content is an object { json: JSONData } | { text: string }
          if (editor.get()["text"] !== undefined) {
            designMapField.value = editor.get()["text"];
          } else if ((editor.get()["json"] !== undefined)) {
            designMapField.value = JSON.stringify(editor.get()["json"]);
          }

          content = updatedContent
        }
      }
    });

    this.guiContainer = document.getElementById('guiContainer');

    let [scene, camera, renderer, controls] = setupCanvas(this.guiContainer);
    // console.log(assemblyMap)
    this.scene = scene;
    this.camera = camera;
    this.renderer = renderer;
    const assemblyMap = {};
    const bondMap = {};

    // Make The Variables Globacl
    this.scene = scene;
    this.camera = camera;
    this.renderer = renderer;
    this.controls = controls;

    const hexBlockGroup = new THREE.Group();


    const boundingBox = new THREE.Box3().setFromObject(hexBlockGroup);

    const center = new THREE.Vector3();
    boundingBox.getCenter(center);

    hexBlockGroup.position.sub(center);
    scene.add(hexBlockGroup);
    // Lighting
    const ambientLight = new THREE.AmbientLight(0xffffff, 2.0);
    scene.add(ambientLight);
    const directionalLight = new THREE.DirectionalLight(0xffffff, 1.0);
    directionalLight.position.set(10, 10, 10);
    scene.add(directionalLight);

    camera.position.z = 200;

    this.activeControl = "SELECT";

    animate(scene, camera, renderer);
    window.addEventListener('resize', () => {
      onWindowResize(renderer, camera, guiContainer);
    });

    const uploadFile = async (file, type) => {
      const formData = new FormData();
      formData.append('file', file);
      formData.append('fileType', type);
      try {
        const response = await fetch('/studio/loader', {
          method: 'POST',
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'), // Include CSRF token
          },
          body: formData,
        });

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        // update the EDITOR

        editor.update({
          json: data
        });
      } catch (error) {
        console.error('Error uploading file:', error);
      }
    };

    const voxelizeSTL = async (file, resolution) => {
      const loader = new STLLoader();

      // Read the file using FileReader
      const arrayBuffer = await new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = () => resolve(reader.result);
        reader.onerror = () => reject(reader.error);
        reader.readAsArrayBuffer(file);
      });

      const stlGeometry = loader.parse(arrayBuffer);
      const stlMesh = new THREE.Mesh(stlGeometry, new THREE.MeshBasicMaterial({
        visible: false
      }));

      // Compute bounding box of the STL geometry
      stlGeometry.computeBoundingBox();
      stlGeometry.computeVertexNormals();
      const bbox = stlGeometry.boundingBox;

      // Higher Resolution Means Lower Width
      // Resolution 1 = 24nm; Resolution 2 = 12nm; ...
      const width = 24.0 / resolution;
      const horiz = (3.0 / 2.0) * 1.5 * width;
      const vert = Math.sqrt(3) * 1.5 * width;
      const depth = width * 2;

      const horiz3_4 = horiz * 3 / 4.0;
      const horiz3_8 = horiz * 3 / 8.0;
      const vert_div_sqrt3 = vert / Math.sqrt(3);
      const depth_delta = 5.0 / resolution;
      
      let counter = 0;

      const raycaster = new THREE.Raycaster();
      const directions = [
        new THREE.Vector3(0, -1, 0), // Downward ray
        new THREE.Vector3(0, 1, 0), // Upward ray
        new THREE.Vector3(1, 0, 0), // Horizontal rays
        new THREE.Vector3(-1, 0, 0),
        new THREE.Vector3(0, 0, 1),
        new THREE.Vector3(0, 0, -1),
      ];

      let hexCount = 0;
      let hexPositions = new Array();

      for (let x = bbox.min.x; x <= bbox.max.x; x += horiz3_4) {
        for (let z = bbox.min.z; z <= bbox.max.z; z += vert_div_sqrt3) {
          for (let y = bbox.min.y; y <= bbox.max.y; y += depth + depth_delta) {
            const offsetX = Math.floor((z - bbox.min.z) / vert_div_sqrt3) % 2 === 0 ? 0 : horiz3_8;
            const newX = x + offsetX;

            const newHex = (new Hex(`hex#${hexCount}`, new THREE.Vector3(newX, y, z), {}, depth, true)).getObject();
            const hexCenter = new THREE.Vector3(newX, y + depth / 2, z);
            let intersects = false;

            for (const direction of directions) {
              raycaster.set(hexCenter, direction.normalize());
              const intersection = raycaster.intersectObject(stlMesh);
              if (intersection.length > 0) {
                intersects = true;
                break;
              }
            }

            if (intersects) {
              hexCount += 1;
              hexPositions.push([`hex#${hexCount}`, new Array(newX, y, z)])
            }
          }
        }
      }
      
      const voxelGroup = (new HexGroup(hexCount, hexPositions, depth, true)).getObject();

      const box = new THREE.Box3().setFromObject(voxelGroup);
      const center = new THREE.Vector3();
      box.getCenter(center);
      voxelGroup.position.sub(center);
      voxelGroup.position.set(-center.x, -center.y, -center.z);
      this.scene.add(voxelGroup);

      document.getElementById("voxelCount").textContent = hexCount;


      // Add the original STL model on top of the voxelized version
      const originalMaterial = new THREE.MeshStandardMaterial({
        color: 0xA6CDC6
      });
      const originalMesh = new THREE.Mesh(stlGeometry, originalMaterial);
      originalMesh.position.sub(center);      
      originalMesh.position.set(-center.x, -center.y, -center.z);
      scene.add(originalMesh);
    };

    const voxelizeOBJ = async (file, resolution) => {

    };

    // Upload Sequence File (Inverse Design)
    document.getElementById('sequenceLoader').addEventListener('change', (event) => {
      const file = event.target.files[0];
      if (file) {
        uploadFile(file, "csv");
      }
    });

    // Upload JSON HexLand file
    document.getElementById('hexlandLoader').addEventListener('change', (event) => {
      const file = event.target.files[0];
      if (file) {
        uploadFile(file, "json");
      }
    });
    // setupGUI

    document.getElementById('stlobjLoader').addEventListener('change', (event) => {
      const file = event.target.files[0];
      const resolution = 3.0;
      const filename = file["name"];

      if (filename.endsWith(".stl")) {
        voxelizeSTL(file, resolution);
      } else if (filename.endsWith(".stl")) {
        voxelizeOBJ(file, resolution);
      } else {
        alert("Unknown File Type. Please Re-Upload!")
      }
    });

    // Get references to the DOM elements
    const rangeInput = document.getElementById('voxelResolution');
    const rangeLabel = document.getElementById('rangeLabel');
    const progressBar = document.getElementById('progressBar');

    // Update the label and progress bar dynamically
    rangeInput.addEventListener('input', function () {
      const value = rangeInput.value; // Get current range value
      rangeLabel.textContent = value; // Update the label
      progressBar.style.width = `${value}%`; // Update progress bar width
      progressBar.setAttribute('aria-valuenow', value); // Update accessibility value
    });


    setupInteractiveControls(this.activeControl, this.guiContainer, this.scene);
  }


  


}