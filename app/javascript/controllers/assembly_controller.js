import {
  Controller
} from "@hotwired/stimulus"
import {
  JSONEditor
} from "vanilla-jsoneditor"
import {
  Hex
} from "../models/hex"
import * as THREE from "three";
import {
  setupCanvas,
  onWindowResize,
  animate
} from './canvas_utils';

export default class extends Controller {
  connect() {
    const assemblyIds = document.getElementById("assembly_ids").value.split(/\s+/);
    const picklistGeneratorForm = document.getElementById("picklistGeneratorForm");
    // console.log(assemblyIds.length)
    for (let i = 0; i < assemblyIds.length; i++) {

      // Set up Code Controller
      const jsonData = JSON.parse(document.getElementById(`assembly_${assemblyIds[i]}_code`).value);
      const editor = new JSONEditor({
        target: document.getElementById(`assembly_${assemblyIds[i]}_editor`),
        props: {
          content: {
            json: jsonData,
            mode: 'view' // Set the mode to 'view' to disable editing
          }
        }
      })

      // Set up GUI Controller
      // console.log("Starting up GUI Controller")
      let guiContainer = document.getElementById(`assembly_${assemblyIds[i]}_gui`)
      // console.log(guiContainer)
      let [scene, camera, renderer, controls] = setupCanvas(guiContainer);


      const assemblyBlocks = this.parseDesignMap(jsonData);
      const hexGroup = new THREE.Group();
      assemblyBlocks.forEach((block) => {
        hexGroup.add(block);
      })

      const boundingBox = new THREE.Box3().setFromObject(hexGroup);

      const center = new THREE.Vector3();
      boundingBox.getCenter(center);

      hexGroup.position.sub(center);
      scene.add(hexGroup);
      // Lighting
      const ambientLight = new THREE.AmbientLight(0xffffff, 2.0);
      scene.add(ambientLight);
      const directionalLight = new THREE.DirectionalLight(0xffffff, 1.0);
      directionalLight.position.set(10, 10, 10);
      scene.add(directionalLight);

      camera.position.z = 200;
      // Define the bond configurations for each side of the hexagon
      // let hexBondData = {
      //   "S1": ['1', '1', 'x', '1', 'x', '1', '1', '1'],
      //   "S2": ['1', '0', '1', '1', '0', '1', '1', '0'],
      //   "S3": ['1', '1', '0', '1', '1', '0', '1', '1'],
      //   "S4": ['0', 'x', '1', '0', 'x', '1', '0', '1'],
      //   "S5": ['x', '1', '1', '0', 'x', '1', '0', '1'],
      //   "S6": ['x', '1', '0', '1', 'x', '0', '1', '1']
      // };
      animate(scene, camera, renderer);

      window.addEventListener('resize', () => {
        onWindowResize(renderer, camera, guiContainer);
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