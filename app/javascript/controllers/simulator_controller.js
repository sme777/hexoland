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
  setupCanvas,
  onWindowResize,
  animate
} from './canvas_utils';

export default class extends Controller {

  connect() {
    const guiContainer = document.getElementById('guiContainer');

    let [scene, camera, renderer, controls] = setupCanvas(guiContainer);

    // Define the bond configurations for each side of the hexagon
    // const hexBondData = {
    //   "S1": ['1', '1', 'x', '1', 'x', '1', '1', '1'],
    //   "S2": ['1', '0', '1', '1', '0', '1', '1', '0'],
    //   "S3": ['1', '1', '0', '1', '1', '0', '1', '1'],
    //   "S4": ['0', 'x', '1', '0', 'x', '1', '0', '1'],
    //   "S5": ['x', '1', '1', '0', 'x', '1', '0', '1'],
    //   "S6": ['x', '1', '0', '1', 'x', '0', '1', '1']
    // };

    const assemblyMap = JSON.parse(document.getElementById('assembly_code').value);

    const assemblyBlocks = this.parseDesignMap(assemblyMap);
    console.log(assemblyBlocks);
    assemblyBlocks.forEach((block) => {
      console.log(block)
      scene.add(block);
    })

    // Lighting
    const ambientLight = new THREE.AmbientLight(0xffffff, 2.0);
    scene.add(ambientLight);
    const directionalLight = new THREE.DirectionalLight(0xffffff, 1.0);
    directionalLight.position.set(10, 10, 10);
    scene.add(directionalLight);

    camera.position.z = 500;

    animate(scene, camera, renderer);

    window.addEventListener('resize', () => {
      onWindowResize(renderer, camera, guiContainer);
    });
  }

  parseDesignMap(designMap) {
    const structures = Object.keys(designMap)
    const structureAssemblyArray = new Array(structures.length);
    structures.forEach((key, idx) => {
      // console.log(key, designMap[key])
      structureAssemblyArray[idx] = this.assembleDesignMap(designMap[key]);
    });
    return structureAssemblyArray;
  }

  assembleDesignMap(assemblyMap) {
    // console.log(assemblyMap)
    const assemblyBlock = new THREE.Group();

    const startHex = Object.keys(assemblyMap)[0];

    // console.log(assemblyMap[startHex]);

    const startPos = new THREE.Vector3(0, 0, 0);
    const startObject = new Hex(startPos);
    const { horiz, vert, depth } = startObject.getSpacings();
    console.log(horiz, vert)
    assemblyBlock.add(startObject.getObject());

    let lastVisitedMonomer;
    Object.keys(assemblyMap[startHex]).forEach((side) => {
      // console.log(side)
      if (side == "S1") {
        const s1NeighborXPos = startPos.x + vert * 3/4;
        const s1NeighborYPos = startPos.y + horiz * 1/2;
        console.log(startPos.z)
        const s1NeighborZPos = startPos.z;
        const s1Neighbor = new Hex(new THREE.Vector3(s1NeighborXPos, s1NeighborYPos, s1NeighborZPos));
        assemblyBlock.add(s1Neighbor.getObject());
      } else if (side == "S2") {

      } else if (side == "S3") {

      } else if (side == "S4") {

      } else if (side == "S5") {

      } else if (side == "S6") {

      } else if (side == "ZU") {
        
      } else if (side == "ZD") {

      } else {
        console.log("Unknown side!")
      }
    })
    // console.log(assemblyBlock)
    return assemblyBlock;
  }

}