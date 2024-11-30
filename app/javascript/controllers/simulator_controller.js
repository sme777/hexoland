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
  JSONEditor
} from "vanilla-jsoneditor"
import {
  setupCanvas,
  onWindowResize
  // animate
} from './canvas_utils';

export default class extends Controller {

  connect() {

    const jsonData = JSON.parse(document.getElementById(`assembly_design_code`).value);
    const editor = new JSONEditor({
      target: document.getElementById(`assembly_editor`),
      props: {
        content: {
          json: jsonData,
          mode: 'view' // Set the mode to 'view' to disable editing
        }
      }
    })

    const guiContainer = document.getElementById('guiContainer');

    let [scene, camera, renderer, controls] = setupCanvas(guiContainer);

    // set up raycasting
    this.raycaster = new THREE.Raycaster();
    this.mouse = new THREE.Vector2();
    this.camera = camera;
    this.scene = scene;
    this.renderer = renderer;

    this.titleElement = document.createElement('div');
    this.titleElement.style.position = 'absolute';
    this.titleElement.style.padding = '5px 10px';
    this.titleElement.style.background = 'rgba(0, 0, 0, 0.7)';
    this.titleElement.style.color = 'white';
    this.titleElement.style.borderRadius = '5px';
    this.titleElement.style.display = 'none';
    document.body.appendChild(this.titleElement);


    const assemblyMap = JSON.parse(document.getElementById('assembly_code').value);
    const hexBondData = JSON.parse(document.getElementById('bond_map').value);


    this.hexBlockGroup = new THREE.Group();
    this.hexBlockGroup.userData.title = "Sam's World";
    assemblyMap.forEach((block) => {
      const hexGroup = new THREE.Group();
      block.forEach((monomer) => {
        hexGroup.add((new Hex(monomer.monomer, new THREE.Vector3(monomer.position.x, monomer.position.y, monomer.position.z), hexBondData[monomer.monomer])).getObject());
      })
      this.hexBlockGroup.add(hexGroup);
    })

    const boundingBox = new THREE.Box3().setFromObject(this.hexBlockGroup);

    const center = new THREE.Vector3();
    boundingBox.getCenter(center);

    this.hexBlockGroup.position.sub(center);
    scene.add(this.hexBlockGroup);
    // Lighting
    const ambientLight = new THREE.AmbientLight(0xffffff, 2.0);
    scene.add(ambientLight);
    const directionalLight = new THREE.DirectionalLight(0xffffff, 1.0);
    directionalLight.position.set(10, 10, 10);
    scene.add(directionalLight);

    camera.position.z = 500;

    this.animate();

    window.addEventListener('resize', () => {
      onWindowResize(renderer, camera, guiContainer);
    });

    window.addEventListener('mousemove', (event) => {
      // Convert mouse position to normalized device coordinates
      this.mouse.x = (event.clientX / window.innerWidth) * 2 - 1;
      this.mouse.y = -(event.clientY / window.innerHeight) * 2 + 1;

      // Update the title position
      this.titleElement.style.left = `${event.clientX + 10}px`;
      this.titleElement.style.top = `${event.clientY + 10}px`;
    });
  }

  onHover() {
    // Cast a ray from the camera to the mouse position
    this.raycaster.setFromCamera(this.mouse, this.camera);

    // Check intersections with the hexes
    const intersects = this.raycaster.intersectObjects(this.hexBlockGroup.children, true); // 'true' checks all descendants

    if (intersects.length > 0) {
      let object = intersects[0].object;

      while (object.parent && object.parent !== this.hexBlockGroup) {
        object = object.parent;
    }

      // If the object is a direct child of the top group, it's the second-level group
      if (object.parent === this.hexBlockGroup) {
          // Display the title
          this.titleElement.style.display = 'block';
          this.titleElement.textContent = object.userData.title || 'Unknown';

          // Highlight all children of the second-level group
          object.traverse((child) => {
              if (child.isMesh) {
                  console.log(child)
                  child.material.emissive = new THREE.Color(0xffa500); // Highlight color
              }
          });
      }
    } else {
      // Hide the title and remove highlights
      this.titleElement.style.display = 'none';

      this.scene.traverse((child) => {
        if (child.isMesh && child.material.emissive) {
          child.material.emissive = new THREE.Color(0x000000); // Reset highlight
        }
      });
    }
  }

  parseDesignMap(designMap) {
    const structures = Object.keys(designMap)
    const structureAssemblyArray = new Array(structures.length);
    structures.forEach((key, idx) => {
      structureAssemblyArray[idx] = this.assembleDesignMap(designMap[key]);
    });
    return structureAssemblyArray;
  }

  animate() {
    const animateLoop = () => {
        requestAnimationFrame(animateLoop);
        
        this.onHover();

        this.renderer.render(this.scene, this.camera);
    };
    animateLoop(); // Start the loop
  }

  assembleDesignMap(assemblyMap) {
    const assemblyBlock = new THREE.Group();
    let monomerMap = this.constructMonomerMap(assemblyMap);
    const startObject = new Hex(new THREE.Vector3(0, 0, 0));
    const {
      horiz,
      vert,
      depth
    } = startObject.getSpacings();

    Object.keys(assemblyMap).forEach((monomer) => {
      if (monomerMap[monomer] === false) {
        const startPos = new THREE.Vector3(0, 0, 0);
        const startHex = new Hex(new THREE.Vector3(startPos.x, startPos.y, startPos.z));
        assemblyBlock.add(startHex.getObject());
        monomerMap[monomer] = startPos;
      }

      Object.keys(assemblyMap[monomer]).forEach((side) => {
        const hexPos = monomerMap[monomer];
        if (side == "S1") {
          if (monomerMap[assemblyMap[monomer][side][0]] === false) {
            const s1NeighborXPos = hexPos.x + horiz * 3 / 4;
            const s1NeighborYPos = hexPos.y;
            const s1NeighborZPos = hexPos.z
            const s1Neighbor = new Hex(new THREE.Vector3(s1NeighborXPos, s1NeighborYPos, s1NeighborZPos));
            assemblyBlock.add(s1Neighbor.getObject());
            monomerMap[assemblyMap[monomer][side][0]] = new THREE.Vector3(s1NeighborXPos, s1NeighborYPos, s1NeighborZPos);
          }
        } else if (side == "S2") {
          if (monomerMap[assemblyMap[monomer][side][0]] === false) {
            const s2NeighborXPos = hexPos.x + horiz * 3 / 8;
            const s2NeighborYPos = hexPos.y;
            const s2NeighborZPos = hexPos.z - vert / Math.sqrt(3);
            const s2Neighbor = new Hex(new THREE.Vector3(s2NeighborXPos, s2NeighborYPos, s2NeighborZPos));
            assemblyBlock.add(s2Neighbor.getObject());
            monomerMap[assemblyMap[monomer][side][0]] = new THREE.Vector3(s2NeighborXPos, s2NeighborYPos, s2NeighborZPos);
          }
        } else if (side == "S3") {
          if (monomerMap[assemblyMap[monomer][side][0]] === false) {
            const s3NeighborXPos = hexPos.x + (horiz * 3 / 8 - horiz * 3 / 4);
            const s3NeighborYPos = hexPos.y;
            const s3NeighborZPos = hexPos.z - vert / Math.sqrt(3);
            const s3Neighbor = new Hex(new THREE.Vector3(s3NeighborXPos, s3NeighborYPos, s3NeighborZPos));
            assemblyBlock.add(s3Neighbor.getObject());
            monomerMap[assemblyMap[monomer][side][0]] = new THREE.Vector3(s3NeighborXPos, s3NeighborYPos, s3NeighborZPos);
          }
        } else if (side == "S4") {
          if (monomerMap[assemblyMap[monomer][side][0]] === false) {
            const s4NeighborXPos = hexPos.x - horiz * 3 / 4;
            const s4NeighborYPos = hexPos.y;
            const s4NeighborZPos = hexPos.z
            const s4Neighbor = new Hex(new THREE.Vector3(s4NeighborXPos, s4NeighborYPos, s4NeighborZPos));
            assemblyBlock.add(s4Neighbor.getObject());
            monomerMap[assemblyMap[monomer][side][0]] = new THREE.Vector3(s4NeighborXPos, s4NeighborYPos, s4NeighborZPos);
          }
        } else if (side == "S5") {
          if (monomerMap[assemblyMap[monomer][side][0]] === false) {
            const s5NeighborXPos = hexPos.x + horiz * 3 / 8;
            const s5NeighborYPos = hexPos.y;
            const s5NeighborZPos = hexPos.z + vert / Math.sqrt(3);
            const s5Neighbor = new Hex(new THREE.Vector3(s5NeighborXPos, s5NeighborYPos, s5NeighborZPos));
            assemblyBlock.add(s5Neighbor.getObject());
            monomerMap[assemblyMap[monomer][side][0]] = new THREE.Vector3(s5NeighborXPos, s5NeighborYPos, s5NeighborZPos);
          }
        } else if (side == "S6") {
          if (monomerMap[assemblyMap[monomer][side][0]] === false) {
            const s6NeighborXPos = hexPos.x - (horiz * 3 / 8 - horiz * 3 / 4);
            const s6NeighborYPos = hexPos.y;
            const s6NeighborZPos = hexPos.z + vert / Math.sqrt(3);
            const s6Neighbor = new Hex(new THREE.Vector3(s6NeighborXPos, s6NeighborYPos, s6NeighborZPos));
            assemblyBlock.add(s6Neighbor.getObject());
            monomerMap[assemblyMap[monomer][side][0]] = new THREE.Vector3(s6NeighborXPos, s6NeighborYPos, s6NeighborZPos);
          }
        } else if (side == "ZU") {
          if (monomerMap[assemblyMap[monomer][side][0]] === false) {
            const zUNeighborXPos = hexPos.x;
            const zUNeighborYPos = hexPos.y + depth + 0.5;
            const zUNeighborZPos = hexPos.z;
            const zUNeighbor = new Hex(new THREE.Vector3(zUNeighborXPos, zUNeighborYPos, zUNeighborZPos));
            assemblyBlock.add(zUNeighbor.getObject());
            monomerMap[assemblyMap[monomer][side][0]] = new THREE.Vector3(zUNeighborXPos, zUNeighborYPos, zUNeighborZPos);
          }
        } else if (side == "ZD") {
          if (monomerMap[assemblyMap[monomer][side][0]] === false) {
            const zDNeighborXPos = hexPos.x;
            const zDNeighborYPos = hexPos.y - (depth + 0.5);
            const zDNeighborZPos = hexPos.z;
            const zDNeighbor = new Hex(new THREE.Vector3(zDNeighborXPos, zDNeighborYPos, zDNeighborZPos));
            assemblyBlock.add(zDNeighbor.getObject());
            monomerMap[assemblyMap[monomer][side][0]] = new THREE.Vector3(zDNeighborXPos, zDNeighborYPos, zDNeighborZPos);
          }
        }
      })
    })
    return assemblyBlock;
  }

  constructMonomerMap(assemblyMap) {
    let monomerMap = {}
    Object.keys(assemblyMap).forEach((monomer) => {
      monomerMap[monomer] = false;
    })
    return monomerMap;
  }
}