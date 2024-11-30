import * as THREE from 'three';
import {
  hexCoordinates,
  helixTypeCount,
  s1Mask,
  s3Mask,
  s5Mask,
  s2Mask,
  s4Mask,
  s6Mask
} from './constants.js';
import { mergeGeometries } from 'three/examples/jsm/utils/BufferGeometryUtils.js';

export class Hex {
  constructor(pos, bonds = {}) {
    // console.log(bonds);
    this.bonds = this.fillBonds(bonds);
    this.hex = new THREE.Group();
    this.helixRadius = 1.5;
    this.helixHeight = 50;
    const halfHelixHeight = this.helixHeight / 2;
    const quarterHelixHeight = this.helixHeight / 4;

    const ringRadius = this.helixRadius;
    const ringTubeRadius = 0.02;
    const passiveHelixRingCount = 14;
    const coreBoundHelixRingCount = 8;
    const sideBoundHelixRingCount = 4;

    const materials = {
      side14: new THREE.MeshStandardMaterial({
        color: 0xD1E9F6
      }),
      side25: new THREE.MeshStandardMaterial({
        color: 0xF6EACB
      }),
      side36: new THREE.MeshStandardMaterial({
        color: 0xF1D3CE
      }),
      passiveHelix: new THREE.MeshStandardMaterial({
        color: 0xF5F7F8
      }),
      ring: new THREE.MeshStandardMaterial({
        color: 0xaaaaaa
      }),
      repulsiveBond: new THREE.MeshStandardMaterial({}),
      neutralBond: new THREE.MeshStandardMaterial({}),
      attractiveSocketBond: new THREE.MeshStandardMaterial({}),
      attractivePlugBond: new THREE.MeshStandardMaterial({})
    }
    // Geometries
    const helixGeometry = new THREE.CylinderGeometry(this.helixRadius, this.helixRadius, this.helixHeight, 32);
    const halfHelixGeometry = new THREE.CylinderGeometry(this.helixRadius, this.helixRadius, this.helixHeight * 0.25, 32);
    const quartHelixGeometry = new THREE.CylinderGeometry(this.helixRadius, this.helixRadius, this.helixHeight * 0.50, 32);

    // this.hex.add(lockBond);
    const ringGeometry = new THREE.TorusGeometry(ringRadius, ringTubeRadius, 16, 100);

    // InstancedMeshes for each type of helix
    const passiveHelixMesh = new THREE.InstancedMesh(helixGeometry, materials.passiveHelix, helixTypeCount.passive);
    const side1Mesh = new THREE.InstancedMesh(quartHelixGeometry, materials.side14, helixTypeCount.s1);
    const side2Mesh = new THREE.InstancedMesh(halfHelixGeometry, materials.side25, helixTypeCount.s2);
    const side3Mesh = new THREE.InstancedMesh(quartHelixGeometry, materials.side36, helixTypeCount.s3);
    const side4Mesh = new THREE.InstancedMesh(halfHelixGeometry, materials.side14, helixTypeCount.s4);
    const side5Mesh = new THREE.InstancedMesh(quartHelixGeometry, materials.side25, helixTypeCount.s5);
    const side6Mesh = new THREE.InstancedMesh(halfHelixGeometry, materials.side36, helixTypeCount.s6);

    // InstancedMesh for rings (shared among all helices)
    const ringMesh = new THREE.InstancedMesh(ringGeometry, materials.ring, helixTypeCount.ring);

    // Counters for each instanced mesh
    let passiveIndex = 0;

    let side1Index = 0;
    let side2Index = 0;
    let side3Index = 0;
    let side4Index = 0;
    let side5Index = 0;
    let side6Index = 0;

    let ringIndex = 0;
    // Create each helix and corresponding rings based on coordinates
    hexCoordinates.forEach((coord, index) => {
      const [x, y] = coord;

      const isSideBondHelix = s2Mask[index] || s4Mask[index] || s6Mask[index];
      const isCoreBondHelix = s1Mask[index] || s3Mask[index] || s5Mask[index];
      const height = isCoreBondHelix ? halfHelixHeight : (isSideBondHelix ? quarterHelixHeight : this.helixHeight);
      const ringCount = isCoreBondHelix ? coreBoundHelixRingCount : (isSideBondHelix ? sideBoundHelixRingCount : passiveHelixRingCount);

      let mesh, meshIndex, bondGroup;

      if (isSideBondHelix) {
        if (s2Mask[index]) {      
          mesh = side2Mesh;
          meshIndex = side2Index++;
          bondGroup = this.addSideBonds(mesh, "S2", s2Mask[index])
          bondGroup.position.set(x, height * 1.5, y)
          this.hex.add(bondGroup);
        } else if (s4Mask[index]) {
          mesh = side4Mesh;
          meshIndex = side4Index++;
          bondGroup = this.addSideBonds(mesh, "S4", s4Mask[index])
          bondGroup.position.set(x, height * 1.5, y)
          this.hex.add(bondGroup);
        } else if (s6Mask[index]) {
          mesh = side6Mesh;
          meshIndex = side6Index++;
          bondGroup = this.addSideBonds(mesh, "S6", s6Mask[index])
          bondGroup.position.set(x, height * 1.5, y)
          this.hex.add(bondGroup);
        }
      } else if (isCoreBondHelix) {
        if (s1Mask[index]) {
          mesh = side1Mesh;
          meshIndex = side1Index++;
          bondGroup = this.addCoreBonds(mesh, "S1", s1Mask[index])
          bondGroup.position.set(x, height * 1.5, y)
          this.hex.add(bondGroup);
        } else if (s3Mask[index]) {
          mesh = side3Mesh;
          meshIndex = side3Index++;
          bondGroup = this.addCoreBonds(mesh, "S3", s3Mask[index])
          bondGroup.position.set(x, height * 1.5, y)
          this.hex.add(bondGroup);
        } else if (s5Mask[index]) {
          mesh = side5Mesh;
          meshIndex = side5Index++;
          bondGroup = this.addCoreBonds(mesh, "S5", s5Mask[index]);
          bondGroup.position.set(x, height * 1.5, y);
          this.hex.add(bondGroup);
        }
      } else {
        mesh = passiveHelixMesh;
        meshIndex = passiveIndex++;
      }

      if (isCoreBondHelix) {
        const helixMatrix = new THREE.Matrix4();
        helixMatrix.setPosition(x, height + this.helixHeight * 0.5, y);
        mesh.setMatrixAt(meshIndex, helixMatrix);
        // Add Divisions
        for (let i = 0; i < ringCount; i++) {
          const ringMatrix = new THREE.Matrix4();
          const rotationMatrix = new THREE.Matrix4();
          const ringY = (i / (ringCount - 1)) * height + height * 1.5;
          ringMatrix.setPosition(x, ringY, y);
          rotationMatrix.makeRotationX(Math.PI / 2);
          ringMatrix.multiply(rotationMatrix);
          ringMesh.setMatrixAt(ringIndex++, ringMatrix);
        }

      } else if (isSideBondHelix) {
        const helixMatrix1 = new THREE.Matrix4();
        helixMatrix1.setPosition(x, height * 0.5 + this.helixHeight * 0.5, y);
        mesh.setMatrixAt(meshIndex, helixMatrix1);

        const helixMatrix2 = new THREE.Matrix4();
        helixMatrix2.setPosition(x, height * 3.5 + this.helixHeight * 0.5, y);
        mesh.setMatrixAt(meshIndex + 4, helixMatrix2);

        for (let i = 0; i < ringCount; i++) {
          const ringMatrix1 = new THREE.Matrix4();
          const rotationMatrix = new THREE.Matrix4();
          const ringY1 = (i / (ringCount - 1)) * height + height * 5;
          ringMatrix1.setPosition(x, ringY1, y);
          rotationMatrix.makeRotationX(Math.PI / 2);
          ringMatrix1.multiply(rotationMatrix);
          ringMesh.setMatrixAt(ringIndex++, ringMatrix1);
        }

        for (let i = 0; i < ringCount; i++) {
          const ringMatrix2 = new THREE.Matrix4();
          const rotationMatrix = new THREE.Matrix4();
          const ringY2 = (i / (ringCount - 1)) * height + height * 2;
          ringMatrix2.setPosition(x, ringY2, y);
          rotationMatrix.makeRotationX(Math.PI / 2);
          ringMatrix2.multiply(rotationMatrix);
          ringMesh.setMatrixAt(ringIndex++, ringMatrix2);
        }
      } else {
        const helixMatrix = new THREE.Matrix4();
        helixMatrix.setPosition(x, height, y);
        mesh.setMatrixAt(meshIndex, helixMatrix);

        for (let i = 0; i < ringCount; i++) {
          const ringMatrix = new THREE.Matrix4();
          const rotationMatrix = new THREE.Matrix4();
          const ringY = (i / (ringCount - 1)) * height + height * 0.5;
          ringMatrix.setPosition(x, ringY, y);
          rotationMatrix.makeRotationX(Math.PI / 2);
          ringMatrix.multiply(rotationMatrix);
          ringMesh.setMatrixAt(ringIndex++, ringMatrix);
        }
      }

    });

    // Center the hex group at the provided position
    
    this.hex.position.set(pos.x, pos.y, pos.z);

    // Add each instanced mesh to the hex group
    // this.
    this.hex.add(passiveHelixMesh);
    this.hex.add(side1Mesh);
    this.hex.add(side2Mesh);
    this.hex.add(side3Mesh);
    this.hex.add(side4Mesh);
    this.hex.add(side5Mesh);
    this.hex.add(side6Mesh);
    this.hex.add(ringMesh);
  }

  getObject() {
    return this.hex;
  }

  getSpacings() {
    const depth = this.helixHeight;
    const horiz = 3.0 / 2.0 * this.helixRadius * 24;
    const vert = Math.sqrt(3) * this.helixRadius * 24;
    return {
      horiz,
      vert,
      depth
    };
  }

  fillBonds(bonds) {
    const sides = ["S1", "S2", "S3", "S4", "S5", "S6", "ZU", "ZD"];

    sides.forEach(key => {
      if (!bonds.hasOwnProperty(key)) {
        if (key === "ZU" || key === "ZD") {
          bonds[key] = Array(72).fill('x');
        } else {
          bonds[key] = Array(8).fill('x');
        }
        
      }
    });
    return bonds;
  }

  addSideBonds(mesh, side, helix) {
    const helixBonds = this.bonds[side];
    const sideBondGroup = new THREE.Group();
    let helixBondsLeft, helixBondsRight;

    // Determine helixBondsLeft and helixBondsRight based on helix
    if (helix === "H54" || helix === "H40" || helix === "H68") {
        helixBondsLeft = helixBonds[0];
        helixBondsRight = helixBonds[1];
    } else if (helix === "H53" || helix === "H39" || helix === "H67") {
        helixBondsLeft = helixBonds[2];
        helixBondsRight = helixBonds[3];
    } else if (helix === "H50" || helix === "H36" || helix === "H64") {
        helixBondsLeft = helixBonds[4];
        helixBondsRight = helixBonds[5];
    } else if (helix === "H49" || helix === "H35" || helix === "H63") {
        helixBondsLeft = helixBonds[6];
        helixBondsRight = helixBonds[7];
    }

    // Create bonds based on helixBondsLeft and helixBondsRight
    let leftBond, rightBond;

    if (helixBondsLeft === 'x') {
        leftBond = this.createRepulsiveBond();
    } else if (helixBondsLeft === '-') {
        leftBond = this.createNeutralBond();
    } else if (helixBondsLeft === 1) {
        leftBond = this.createAttractivePlugBond();
    } else if (helixBondsLeft === 0) {
        leftBond = this.createAttractiveSocketBond();
    }

    if (helixBondsRight === 'x') {
        rightBond = this.createRepulsiveBond();
    } else if (helixBondsRight === '-') {
        rightBond = this.createNeutralBond();
    } else if (helixBondsRight === 1) {
        rightBond = this.createAttractivePlugBond();
    } else if (helixBondsRight === 0) {
        rightBond = this.createAttractiveSocketBond();
    }

    // Position bonds at the top and bottom of the cylinder
    const halfHeight = mesh.geometry.parameters.height;
    leftBond.position.set(mesh.position.x, mesh.position.y + halfHeight * 3.5 - 0.4, mesh.position.z); // Top
    rightBond.position.set(mesh.position.x, mesh.position.y + halfHeight * 1.5 + 0.4, mesh.position.z); // Bottom

    // Rotate the right bond to face downward
    leftBond.rotation.x = Math.PI; // 180 degrees around the X-axis

    // Add bonds to the group
    sideBondGroup.add(leftBond);
    sideBondGroup.add(rightBond);

    return sideBondGroup;
}


  addCoreBonds(mesh, side, helix) {
    const helixBonds = this.bonds[side];
    const sideBondGroup = new THREE.Group();
    let helixBondsLeft, helixBondsRight;

    // Determine helixBondsLeft and helixBondsRight based on helix
    if (helix === "H61" || helix === "H47" || helix === "H33") {
        helixBondsLeft = helixBonds[0];
        helixBondsRight = helixBonds[1];
    } else if (helix === "H60" || helix === "H46" || helix === "H32") {
        helixBondsLeft = helixBonds[2];
        helixBondsRight = helixBonds[3];
    } else if (helix === "H57" || helix === "H43" || helix === "H71") {
        helixBondsLeft = helixBonds[4];
        helixBondsRight = helixBonds[5];
    } else if (helix === "H56" || helix === "H42" || helix === "H70") {
        helixBondsLeft = helixBonds[6];
        helixBondsRight = helixBonds[7];
    }
    console.log(helixBondsLeft, helixBondsRight)
    // Create bonds based on helixBondsLeft and helixBondsRight
    let leftBond, rightBond;

    if (helixBondsLeft === 'x') {
        leftBond = this.createRepulsiveBond();
    } else if (helixBondsLeft === '-') {
        leftBond = this.createNeutralBond();
    } else if (helixBondsLeft === 1) {
        leftBond = this.createAttractivePlugBond();
    } else if (helixBondsLeft === 0) {
        leftBond = this.createAttractiveSocketBond();
    }

    if (helixBondsRight === 'x') {
        rightBond = this.createRepulsiveBond();
    } else if (helixBondsRight === '-') {
        rightBond = this.createNeutralBond();
    } else if (helixBondsRight === 1) {
        rightBond = this.createAttractivePlugBond();
    } else if (helixBondsRight === 0) {
        rightBond = this.createAttractiveSocketBond();
    }

    // Position bonds at the top and bottom of the cylinder
    const halfHeight = mesh.geometry.parameters.height;
    leftBond.position.set(mesh.position.x, mesh.position.y + this.helixHeight / 2 + 0.4, mesh.position.z); // Top
    rightBond.position.set(mesh.position.x, mesh.position.y - 0.4, mesh.position.z); // Bottom

    // Rotate the right bond to face downward
    rightBond.rotation.x = Math.PI; // 180 degrees around the X-axis

    // Add bonds to the group
    sideBondGroup.add(leftBond);
    sideBondGroup.add(rightBond);

    return sideBondGroup;
  }

  createRepulsiveBond() {
    const spikeRadius = 1.5; // Radius of the spike
    const spikeHeight = 1.5; // Height of the spike
    const baseRadius = 1.5; 
    const baseHeight = 0.75; 
    const baseGeometry = new THREE.CylinderGeometry(baseRadius, baseRadius, baseHeight, 32);
    const spikeGeometry = new THREE.ConeGeometry(spikeRadius, spikeHeight, 16);
    spikeGeometry.translate(0, baseHeight / 2 + spikeHeight / 2, 0); 
    const repulsiveBondGeometry = mergeGeometries([baseGeometry, spikeGeometry]);
    const material = new THREE.MeshStandardMaterial({ color: 0xA91E3B });
    return new THREE.Mesh(repulsiveBondGeometry, material);
  }

  createNeutralBond() {
    const baseRadius = 2; // Radius of the cylinder base
    const baseHeight = 1; // Height of the cylinder base
    const baseGeometry = new THREE.CylinderGeometry(baseRadius, baseRadius, baseHeight, 32);
    const material = new THREE.MeshStandardMaterial({ color: 0xFDB840 });
    return new THREE.Mesh(baseGeometry, material);
  }

  createAttractivePlugBond() {
    const baseRadius = 1.5; 
    const baseHeight = 0.75; 
    const keyRadius = 0.75;
    const keyHeight = 1; 

    // Create the flat base (cylinder)
    const baseGeometry = new THREE.CylinderGeometry(baseRadius, baseRadius, baseHeight, 32);

    // Create the key (rectangular prism)
    const keyGeometry = new THREE.CylinderGeometry(keyRadius, keyRadius, keyHeight, 32);

    keyGeometry.translate(0, baseHeight / 2 + keyHeight / 2, 0); 

    const keyAndBase = mergeGeometries([baseGeometry, keyGeometry]);

    const material = new THREE.MeshStandardMaterial({ color: 0x808836 }); 

    return new THREE.Mesh(keyAndBase, material);
  }

  createAttractiveSocketBond() {
    const baseRadius = 1.5; // Radius of the base cylinder
    const baseHeight = 1; // Height of the base cylinder
    const holeRadius = 0.75; // Radius of the hole
    const outerShape = new THREE.Shape();

    // Outer circle (base of the cylinder)
    outerShape.moveTo(baseRadius, 0);
    outerShape.absarc(0, 0, baseRadius, 0, Math.PI * 2, false, 32);

    // Inner circle (hole)
    const holePath = new THREE.Path();
    holePath.moveTo(holeRadius, 0);
    holePath.absarc(0, 0, holeRadius, 0, Math.PI * 2, true, 32); // True for counterclockwise

    // Subtract the inner circle (hole) from the outer shape
    outerShape.holes.push(holePath);

    // Extrude the shape into a 3D geometry
    const extrudeSettings = {
      depth: baseHeight,
      bevelEnabled: false,
      curveSegments: 32,
    };
    const geometry = new THREE.ExtrudeGeometry(outerShape, extrudeSettings);
    geometry.rotateX(Math.PI / 2);
    geometry.translate(0, 0.6, 0);
    // Create the material and mesh
    const material = new THREE.MeshStandardMaterial({ color: 0x808836 }); // Greenish color for the bond
    const socket = new THREE.Mesh(geometry, material);
    return socket;
  }
  
  
  rotate(x, y, z) {
    this.prism.rotation.x += x;
    this.prism.rotation.y += y;
    this.prism.rotation.z += z;
  }

}