import * as THREE from 'three';
import {
  hexCoordinates,
  helixTypeCount,
  s1Mask,
  s3Mask,
  s5Mask,
  s2Mask,
  s4Mask,
  s6Mask,
  Zhelices,
  materials
} from './constants.js';
import { mergeGeometries } from 'three/examples/jsm/utils/BufferGeometryUtils.js';

export class Hex {
  constructor(title, pos, bonds = {}, helixHeight, ignoreRings) {
    if (Object.entries(bonds).length === 0) {
      this.bonds = null;
    } else {
      this.bonds = this.fillBonds(bonds);
    }
    this.hex = new THREE.Group();
    this.title = title;
    this.helixRadius = helixHeight / 32.0; // 1.5
    this.helixHeight = helixHeight;        // 48
    const halfHelixHeight = this.helixHeight / 2;
    const quarterHelixHeight = this.helixHeight / 4;

    const ringRadius = this.helixRadius;
    const ringTubeRadius = helixHeight / 2400.0; // 0.02;
    const passiveHelixRingCount = 14;
    const coreBoundHelixRingCount = 8;
    const sideBoundHelixRingCount = 4;

    // Geometries
    const ringGeometry = new THREE.TorusGeometry(ringRadius, ringTubeRadius, 16, 100);
    const helixGeometry = new THREE.CylinderGeometry(this.helixRadius, this.helixRadius, this.helixHeight, 32);
    const halfHelixGeometry = new THREE.CylinderGeometry(this.helixRadius, this.helixRadius, this.helixHeight * 0.25, 32);
    const quartHelixGeometry = new THREE.CylinderGeometry(this.helixRadius, this.helixRadius, this.helixHeight * 0.50, 32);

    // Create bond geometries
    const bondGeometries = this.createBondGeometries();

    // Initialize instance meshes for bonds
    // Count the max number of each bond type we might need
    const maxBondCount = this.calculateMaxBondCount();

    // Initialize instanced meshes for each bond type
    const bondMeshes = this.initializeBondInstancedMeshes(bondGeometries, maxBondCount);

    // InstancedMeshes for each type of helix
    this.passiveHelixMesh = new THREE.InstancedMesh(helixGeometry, materials.passiveHelix, helixTypeCount.passive);
    const passiveColor = new THREE.Color(0xF5F7F8)
    // Enable per-instance colors
    const colors = new Float32Array(helixTypeCount.passive * 3); // RGB for each instance
    for (let i = 0; i < helixTypeCount.passive; i++) {
        colors[i * 3 + 0] = passiveColor.r; // R
        colors[i * 3 + 1] = passiveColor.g; // G
        colors[i * 3 + 2] = passiveColor.b; // B
    }
    this.passiveHelixMesh.instanceColor = new THREE.InstancedBufferAttribute(colors, 3);

    const side1Mesh = new THREE.InstancedMesh(quartHelixGeometry, materials.side14, helixTypeCount.s1);
    const side2Mesh = new THREE.InstancedMesh(halfHelixGeometry, materials.side25, helixTypeCount.s2);
    const side3Mesh = new THREE.InstancedMesh(quartHelixGeometry, materials.side36, helixTypeCount.s3);
    const side4Mesh = new THREE.InstancedMesh(halfHelixGeometry, materials.side14, helixTypeCount.s4);
    const side5Mesh = new THREE.InstancedMesh(quartHelixGeometry, materials.side25, helixTypeCount.s5);
    const side6Mesh = new THREE.InstancedMesh(halfHelixGeometry, materials.side36, helixTypeCount.s6);

    // InstancedMesh for rings (shared among all helices)
    let ringMesh;
    if (!ignoreRings) {
      ringMesh = new THREE.InstancedMesh(ringGeometry, materials.ring, helixTypeCount.ring);
    }

    // Counters for each instanced mesh
    let passiveIndex = 0;

    let side1Index = 0;
    let side2Index = 0;
    let side3Index = 0;
    let side4Index = 0;
    let side5Index = 0;
    let side6Index = 0;

    let ringIndex = 0;

    // Counters for bond instanced meshes
    let bondIndices = {
      repulsiveBondIndex: 0,
      neutralBondIndex: 0,
      plugBondIndex: 0,
      socketBondIndex: 0
    };

    // Create each helix and corresponding rings based on coordinates
    hexCoordinates.forEach((coord, index) => {
      let [x, y] = coord;
      x = x * (this.helixHeight / 48.0);
      y = y * (this.helixHeight / 48.0);
      const isSideBondHelix = s2Mask[index] || s4Mask[index] || s6Mask[index];
      const isCoreBondHelix = s1Mask[index] || s3Mask[index] || s5Mask[index];
      const height = isCoreBondHelix ? halfHelixHeight : (isSideBondHelix ? quarterHelixHeight : this.helixHeight);
      let ringCount;
      if (!ignoreRings) {
        ringCount = isCoreBondHelix ? coreBoundHelixRingCount : (isSideBondHelix ? sideBoundHelixRingCount : passiveHelixRingCount);
      }
      let mesh, meshIndex;

      if (isSideBondHelix) {
        if (s2Mask[index]) {      
          mesh = side2Mesh;
          meshIndex = side2Index++;
          if (this.bonds !== null) {
            // Instead of addSideBonds, use our new instanced method
            bondIndices = this.addSideBondsInstanced(bondMeshes, "S2", s2Mask[index], x, height * 1.5, y, 
                                       bondIndices.repulsiveBondIndex, bondIndices.neutralBondIndex, 
                                       bondIndices.plugBondIndex, bondIndices.socketBondIndex);
            
            bondIndices = this.addZBondsInstanced(bondMeshes, s2Mask[index], x, height * 1.5, y, true,
                                   bondIndices.repulsiveBondIndex, bondIndices.neutralBondIndex, 
                                   bondIndices.plugBondIndex, bondIndices.socketBondIndex);
          }
        } else if (s4Mask[index]) {
          mesh = side4Mesh;
          meshIndex = side4Index++;
          if (this.bonds !== null) {
            bondIndices = this.addSideBondsInstanced(bondMeshes, "S4", s4Mask[index], x, height * 1.5, y, 
                                     bondIndices.repulsiveBondIndex, bondIndices.neutralBondIndex, 
                                     bondIndices.plugBondIndex, bondIndices.socketBondIndex);
            
            bondIndices = this.addZBondsInstanced(bondMeshes, s4Mask[index], x, height * 1.5, y, true,
                                   bondIndices.repulsiveBondIndex, bondIndices.neutralBondIndex, 
                                   bondIndices.plugBondIndex, bondIndices.socketBondIndex);
          }
        } else if (s6Mask[index]) {
          mesh = side6Mesh;
          meshIndex = side6Index++;
          if (this.bonds !== null) {
            bondIndices = this.addSideBondsInstanced(bondMeshes, "S6", s6Mask[index], x, height * 1.5, y, 
                                     bondIndices.repulsiveBondIndex, bondIndices.neutralBondIndex, 
                                     bondIndices.plugBondIndex, bondIndices.socketBondIndex);
            
            bondIndices = this.addZBondsInstanced(bondMeshes, s6Mask[index], x, height * 1.5, y, true,
                                   bondIndices.repulsiveBondIndex, bondIndices.neutralBondIndex, 
                                   bondIndices.plugBondIndex, bondIndices.socketBondIndex);
          }
        }
      } else if (isCoreBondHelix) {
        if (s1Mask[index]) {
          mesh = side1Mesh;
          meshIndex = side1Index++;
          if (this.bonds !== null) {
            bondIndices = this.addCoreBondsInstanced(bondMeshes, "S1", s1Mask[index], x, height * 1.5, y, 
                                      bondIndices.repulsiveBondIndex, bondIndices.neutralBondIndex, 
                                      bondIndices.plugBondIndex, bondIndices.socketBondIndex);
          }
        } else if (s3Mask[index]) {
          mesh = side3Mesh;
          meshIndex = side3Index++;
          if (this.bonds !== null) {
            bondIndices = this.addCoreBondsInstanced(bondMeshes, "S3", s3Mask[index], x, height * 1.5, y, 
                                      bondIndices.repulsiveBondIndex, bondIndices.neutralBondIndex, 
                                      bondIndices.plugBondIndex, bondIndices.socketBondIndex);
          }
        } else if (s5Mask[index]) {
          mesh = side5Mesh;
          meshIndex = side5Index++;
          if (this.bonds !== null) {
            bondIndices = this.addCoreBondsInstanced(bondMeshes, "S5", s5Mask[index], x, height * 1.5, y, 
                                      bondIndices.repulsiveBondIndex, bondIndices.neutralBondIndex, 
                                      bondIndices.plugBondIndex, bondIndices.socketBondIndex);
          }
        }
      } else {
        mesh = this.passiveHelixMesh;
        meshIndex = passiveIndex++;
        if (Zhelices[index] !== 0 && this.bonds !== null) {
          bondIndices = this.addZBondsInstanced(bondMeshes, Zhelices[index], x, height * 1.5, y, false,
                                 bondIndices.repulsiveBondIndex, bondIndices.neutralBondIndex, 
                                 bondIndices.plugBondIndex, bondIndices.socketBondIndex);
        } 
      }

      if (isCoreBondHelix) {
        const helixMatrix = new THREE.Matrix4();
        helixMatrix.setPosition(x, height + this.helixHeight * 0.5, y);
        mesh.setMatrixAt(meshIndex, helixMatrix);
        // Add Divisions
        if (!ignoreRings) {
          for (let i = 0; i < ringCount; i++) {
            const ringMatrix = new THREE.Matrix4();
            const rotationMatrix = new THREE.Matrix4();
            const ringY = (i / (ringCount - 1)) * height + height * 1.5;
            ringMatrix.setPosition(x, ringY, y);
            rotationMatrix.makeRotationX(Math.PI / 2);
            ringMatrix.multiply(rotationMatrix);
            ringMesh.setMatrixAt(ringIndex++, ringMatrix);
          }
        }

      } else if (isSideBondHelix) {
        const helixMatrix1 = new THREE.Matrix4();
        helixMatrix1.setPosition(x, height * 0.5 + this.helixHeight * 0.5, y);
        mesh.setMatrixAt(meshIndex, helixMatrix1);

        const helixMatrix2 = new THREE.Matrix4();
        helixMatrix2.setPosition(x, height * 3.5 + this.helixHeight * 0.5, y);
        mesh.setMatrixAt(meshIndex + 4, helixMatrix2);
        if (!ignoreRings) {
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
        }
      } else {
        const helixMatrix = new THREE.Matrix4();
        helixMatrix.setPosition(x, height, y);
        mesh.setMatrixAt(meshIndex, helixMatrix);
        if (!ignoreRings) {
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
      }
    });

    // Center the hex group at the provided position
    this.hex.position.set(pos.x, pos.y, pos.z);

    // Add each instanced mesh to the hex group
    this.hex.add(this.passiveHelixMesh);
    this.hex.add(side1Mesh);
    this.hex.add(side2Mesh);
    this.hex.add(side3Mesh);
    this.hex.add(side4Mesh);
    this.hex.add(side5Mesh);
    this.hex.add(side6Mesh);
    
    // Add bond instanced meshes to the hex group - only add if they have actual instances
    if (this.bondCounts.repulsiveBond > 0) this.hex.add(bondMeshes.repulsiveBond);
    if (this.bondCounts.neutralBond > 0) this.hex.add(bondMeshes.neutralBond);
    if (this.bondCounts.plugBond > 0) this.hex.add(bondMeshes.plugBond);
    if (this.bondCounts.socketBond > 0) this.hex.add(bondMeshes.socketBond);
    
    if (!ignoreRings) {
      this.hex.add(ringMesh);
    }
  }

  getObject() {
    return this.hex;
  }

  getCoreHex() {
    return this.passiveHelixMesh;
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

  // Calculate the exact number of each bond type needed
  calculateExactBondCounts() {
    if (this.bonds === null) {
      return { repulsiveBond: 0, neutralBond: 0, plugBond: 0, socketBond: 0 };
    }
    
    let counts = {
      repulsiveBond: 0,
      neutralBond: 0,
      plugBond: 0,
      socketBond: 0
    };
    
    // Count Z bonds (ZU and ZD)
    for (let i = 0; i < 72; i++) {
      // Upper Z bonds
      if (this.bonds["ZU"][i] === "x") counts.repulsiveBond++;
      else if (this.bonds["ZU"][i] === "-") counts.neutralBond++;
      else if (this.bonds["ZU"][i] === 1) counts.plugBond++;
      else if (this.bonds["ZU"][i] === 0) counts.socketBond++;
      
      // Lower Z bonds
      if (this.bonds["ZD"][i] === "x") counts.repulsiveBond++;
      else if (this.bonds["ZD"][i] === "-") counts.neutralBond++;
      else if (this.bonds["ZD"][i] === 1) counts.plugBond++;
      else if (this.bonds["ZD"][i] === 0) counts.socketBond++;
    }
    
    // Count side bonds (S1 to S6)
    const sideTypes = ["S1", "S2", "S3", "S4", "S5", "S6"];
    
    for (const side of sideTypes) {
      for (let i = 0; i < 8; i++) {
        if (this.bonds[side][i] === "x") counts.repulsiveBond++;
        else if (this.bonds[side][i] === "-") counts.neutralBond++;
        else if (this.bonds[side][i] === 1) counts.plugBond++;
        else if (this.bonds[side][i] === 0) counts.socketBond++;
      }
    }
    
    return counts;
  }

  // Calculate maximum possible number of each bond type
  calculateMaxBondCount() {
    // In the worst case, each helix could have 2 bonds (top/bottom or left/right)
    // and each bond could be of any type
    // This is a conservative estimate to ensure we have enough instances
    return {
      repulsiveBond: 300, // Conservative estimate
      neutralBond: 300,
      plugBond: 300,
      socketBond: 300
    };
  }

  // Create geometries for each bond type
  createBondGeometries() {
    const baseRadius = 1.5;
    const baseHeight = 0.75;
    const spikeRadius = 1.5;
    const spikeHeight = 1.5;
    const keyRadius = 0.75;
    const keyHeight = 1;

    // Repulsive bond (spiky)
    const baseGeometry = new THREE.CylinderGeometry(baseRadius, baseRadius, baseHeight, 32);
    const spikeGeometry = new THREE.ConeGeometry(spikeRadius, spikeHeight, 16);
    spikeGeometry.translate(0, baseHeight / 2 + spikeHeight / 2, 0);
    const repulsiveBondGeometry = mergeGeometries([baseGeometry, spikeGeometry]);

    // Neutral bond (flat cylinder)
    const neutralBaseGeometry = new THREE.CylinderGeometry(baseRadius, baseRadius, 1, 32);
    neutralBaseGeometry.translate(0, 0.1, 0);

    // Attractive plug bond (cylinder with key)
    const keyGeometry = new THREE.CylinderGeometry(keyRadius, keyRadius, keyHeight, 32);
    keyGeometry.translate(0, baseHeight / 2 + keyHeight / 2, 0);
    const plugBondGeometry = mergeGeometries([baseGeometry.clone(), keyGeometry]);

    // Attractive socket bond (cylinder with hole)
    const outerShape = new THREE.Shape();
    outerShape.moveTo(baseRadius, 0);
    outerShape.absarc(0, 0, baseRadius, 0, Math.PI * 2, false, 32);
    const holePath = new THREE.Path();
    holePath.moveTo(keyRadius, 0);
    holePath.absarc(0, 0, keyRadius, 0, Math.PI * 2, true, 32);
    outerShape.holes.push(holePath);
    
    const extrudeSettings = {
      depth: baseHeight,
      bevelEnabled: false,
      curveSegments: 32,
    };
    const socketGeometry = new THREE.ExtrudeGeometry(outerShape, extrudeSettings);
    socketGeometry.rotateX(Math.PI / 2);
    socketGeometry.translate(0, 0.6, 0);

    return {
      repulsiveBond: repulsiveBondGeometry,
      neutralBond: neutralBaseGeometry,
      plugBond: plugBondGeometry,
      socketBond: socketGeometry
    };
  }

  // Initialize instanced meshes for bonds
  initializeBondInstancedMeshes(geometries, counts) {
    const repulsiveMaterial = new THREE.MeshStandardMaterial({ color: 0xA91E3B });
    const neutralMaterial = new THREE.MeshStandardMaterial({ color: 0xFDB840 });
    const attractiveMaterial = new THREE.MeshStandardMaterial({ color: 0x808836 });
    const attractiveSocketMaterial = new THREE.MeshStandardMaterial({ color: 0x808836 });

    // Ensure we have at least 1 instance for each mesh type to avoid Three.js errors
    // If count is 0, we'll create a "dummy" mesh but won't actually use it
    const ensureMinCount = (count) => Math.max(1, count);
    
    return {
      repulsiveBond: new THREE.InstancedMesh(
        geometries.repulsiveBond, 
        repulsiveMaterial, 
        ensureMinCount(counts.repulsiveBond)
      ),
      neutralBond: new THREE.InstancedMesh(
        geometries.neutralBond, 
        neutralMaterial, 
        ensureMinCount(counts.neutralBond)
      ),
      plugBond: new THREE.InstancedMesh(
        geometries.plugBond, 
        attractiveMaterial, 
        ensureMinCount(counts.plugBond)
      ),
      socketBond: new THREE.InstancedMesh(
        geometries.socketBond, 
        attractiveSocketMaterial, 
        ensureMinCount(counts.socketBond)
      )
    };
  }

  // Helper method to set bond instance
  setBondInstance(bondMesh, index, x, y, z, rotateX = 0) {
    const matrix = new THREE.Matrix4();
    matrix.setPosition(x, y, z);
    
    if (rotateX !== 0) {
      const rotationMatrix = new THREE.Matrix4();
      rotationMatrix.makeRotationX(rotateX);
      matrix.multiply(rotationMatrix);
    }
    
    bondMesh.setMatrixAt(index, matrix);
    return index + 1;  // Return the incremented index
  }

  // Add Z bonds using instanced meshes
  addZBondsInstanced(bondMeshes, helix, x, y, z, sideBound = false, 
                    repulsiveIndex, neutralIndex, plugIndex, socketIndex) {
    const height = sideBound ? this.helixHeight * 0.5 : this.helixHeight;
    const topPos = { 
      x: x, 
      y: sideBound ? y + height * 4.5 + 0.4 : y + 0.4, 
      z: z 
    };
    const bottomPos = { 
      x: x, 
      y: sideBound ? y + height * 0.5 - 0.4 : y - height - 0.4, 
      z: z 
    };

    const helixIndex = this.zBondToIndex(helix);
    if (helixIndex !== undefined) {
      // Z Upper Bond
      if (this.bonds["ZU"][helixIndex] === 1) {
        plugIndex = this.setBondInstance(bondMeshes.plugBond, plugIndex, topPos.x, topPos.y, topPos.z);
      } else if (this.bonds["ZU"][helixIndex] === 0) {
        socketIndex = this.setBondInstance(bondMeshes.socketBond, socketIndex, topPos.x, topPos.y, topPos.z);
      } else if (this.bonds["ZU"][helixIndex] === "-") {
        neutralIndex = this.setBondInstance(bondMeshes.neutralBond, neutralIndex, topPos.x, topPos.y, topPos.z);
      } else if (this.bonds["ZU"][helixIndex] === "x") {
        repulsiveIndex = this.setBondInstance(bondMeshes.repulsiveBond, repulsiveIndex, topPos.x, topPos.y, topPos.z);
      }
    }

    // Z Lower Bond
    if (helixIndex !== undefined) {
      if (this.bonds["ZD"][helixIndex] === 1) {
        plugIndex = this.setBondInstance(bondMeshes.plugBond, plugIndex, bottomPos.x, bottomPos.y, bottomPos.z, Math.PI);
      } else if (this.bonds["ZD"][helixIndex] === 0) {
        socketIndex = this.setBondInstance(bondMeshes.socketBond, socketIndex, bottomPos.x, bottomPos.y, bottomPos.z, Math.PI);
      } else if (this.bonds["ZD"][helixIndex] === "-") {
        neutralIndex = this.setBondInstance(bondMeshes.neutralBond, neutralIndex, bottomPos.x, bottomPos.y, bottomPos.z, Math.PI);
      } else if (this.bonds["ZD"][helixIndex] === "x") {
        repulsiveIndex = this.setBondInstance(bondMeshes.repulsiveBond, repulsiveIndex, bottomPos.x, bottomPos.y, bottomPos.z, Math.PI);
      }
    }

    return { repulsiveIndex, neutralIndex, plugIndex, socketIndex };
  }

  // Add side bonds using instanced meshes
  addSideBondsInstanced(bondMeshes, side, helix, x, y, z, 
                       repulsiveIndex, neutralIndex, plugIndex, socketIndex) {
    const helixBonds = this.bonds[side];
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

    const halfHeight = this.helixHeight * 0.25;
    const leftPos = { x: x, y: y + halfHeight * 3.5 - 0.4, z: z };
    const rightPos = { x: x, y: y + halfHeight * 1.5 + 0.4, z: z };

    // Left bond
    if (helixBondsLeft === 'x') {
      repulsiveIndex = this.setBondInstance(bondMeshes.repulsiveBond, repulsiveIndex, leftPos.x, leftPos.y, leftPos.z, Math.PI);
    } else if (helixBondsLeft === '-') {
      neutralIndex = this.setBondInstance(bondMeshes.neutralBond, neutralIndex, leftPos.x, leftPos.y, leftPos.z, Math.PI);
    } else if (helixBondsLeft === 1) {
      plugIndex = this.setBondInstance(bondMeshes.plugBond, plugIndex, leftPos.x, leftPos.y, leftPos.z, Math.PI);
    } else if (helixBondsLeft === 0) {
      socketIndex = this.setBondInstance(bondMeshes.socketBond, socketIndex, leftPos.x, leftPos.y, leftPos.z, Math.PI);
    }

    // Right bond
    if (helixBondsRight === 'x') {
      repulsiveIndex = this.setBondInstance(bondMeshes.repulsiveBond, repulsiveIndex, rightPos.x, rightPos.y, rightPos.z);
    } else if (helixBondsRight === '-') {
      neutralIndex = this.setBondInstance(bondMeshes.neutralBond, neutralIndex, rightPos.x, rightPos.y, rightPos.z);
    } else if (helixBondsRight === 1) {
      plugIndex = this.setBondInstance(bondMeshes.plugBond, plugIndex, rightPos.x, rightPos.y, rightPos.z);
    } else if (helixBondsRight === 0) {
      socketIndex = this.setBondInstance(bondMeshes.socketBond, socketIndex, rightPos.x, rightPos.y, rightPos.z);
    }

    return { repulsiveIndex, neutralIndex, plugIndex, socketIndex };
  }

  // Add core bonds using instanced meshes
  addCoreBondsInstanced(bondMeshes, side, helix, x, y, z, 
                       repulsiveIndex, neutralIndex, plugIndex, socketIndex) {
    const helixBonds = this.bonds[side];
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

    const halfHeight = this.helixHeight * 0.5;
    const leftPos = { x: x, y: y + halfHeight / 2 + 0.4, z: z };
    const rightPos = { x: x, y: y - 0.4, z: z };

    // Left bond
    if (helixBondsLeft === 'x') {
      repulsiveIndex = this.setBondInstance(bondMeshes.repulsiveBond, repulsiveIndex, leftPos.x, leftPos.y, leftPos.z);
    } else if (helixBondsLeft === '-') {
      neutralIndex = this.setBondInstance(bondMeshes.neutralBond, neutralIndex, leftPos.x, leftPos.y, leftPos.z);
    } else if (helixBondsLeft === 1) {
      plugIndex = this.setBondInstance(bondMeshes.plugBond, plugIndex, leftPos.x, leftPos.y, leftPos.z);
    } else if (helixBondsLeft === 0) {
      socketIndex = this.setBondInstance(bondMeshes.socketBond, socketIndex, leftPos.x, leftPos.y, leftPos.z);
    }

    // Right bond
    if (helixBondsRight === 'x') {
      repulsiveIndex = this.setBondInstance(bondMeshes.repulsiveBond, repulsiveIndex, rightPos.x, rightPos.y, rightPos.z, Math.PI);
    } else if (helixBondsRight === '-') {
      neutralIndex = this.setBondInstance(bondMeshes.neutralBond, neutralIndex, rightPos.x, rightPos.y, rightPos.z, Math.PI);
    } else if (helixBondsRight === 1) {
      plugIndex = this.setBondInstance(bondMeshes.plugBond, plugIndex, rightPos.x, rightPos.y, rightPos.z, Math.PI);
    } else if (helixBondsRight === 0) {
      socketIndex = this.setBondInstance(bondMeshes.socketBond, socketIndex, rightPos.x, rightPos.y, rightPos.z, Math.PI);
    }

    // Return updated indices
    return { 
      repulsiveIndex, 
      neutralIndex, 
      plugIndex, 
      socketIndex 
    };
  }
  
  zBondToIndex(zBond) {
    const indexMap = {
      "H21": 0, "H4": 1, "H48": 2, "H60": 3, "H20": 4, "H5": 5, "H59": 6, "H47": 7,
      "H69": 8, "H52": 9, "H61": 10, "H7": 11, "H12": 12, "H6": 13, "H3": 14, "H70": 15,
      "H50": 16, "H43": 17, "H38": 18, "H13": 19, "H37": 20, "H57": 21, "H35": 22, "H39": 23,
      "H25": 24, "H51": 25, "H65": 26, "H36": 27, "H67": 28, "H58": 29, "H32": 30, "H68": 31,
      "H24": 32, "H0": 33, "H8": 34, "H40": 35, "H30": 36, "H33": 37, "H26": 38, "H71": 39,
      "H27": 40, "H10": 41, "H62": 42, "H44": 43, "H63": 44, "H41": 45, "H64": 46, "H34": 47,
      "H42": 48, "H53": 49, "H66": 50, "H16": 51, "H54": 52, "H23": 53, "H18": 54, "H31": 55,
      "H2": 56, "H9": 57, "H1": 58, "H45": 59, "H56": 60, "H14": 61, "H22": 62, "H55": 63,
      "H29": 64, "H11": 65, "H15": 66, "H46": 67, "H49": 68, "H28": 69, "H17": 70, "H19": 71
    }

    // Return the index if the zBond exists in the map, otherwise return undefined or handle the error as needed
    return indexMap[zBond] !== undefined ? indexMap[zBond] : undefined;
}}