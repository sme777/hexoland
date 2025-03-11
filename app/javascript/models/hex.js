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
  materials,
  colors,
  helixRingCount,
  indexMap
} from './constants.js';
import {
  mergeGeometries
} from 'three/examples/jsm/utils/BufferGeometryUtils.js';

export class Hex {
  constructor(title, pos, bonds = {}, helixHeight, ignoreRings) {
    if (Object.entries(bonds).length === 0) {
      this.bonds = null;
    } else {
      this.bonds = this.fillBonds(bonds);
    }
    this.hex = new THREE.Group();
    this.title = title;

    // Define Basic Parameters
    this.helixRadius = helixHeight / 32.0; // 1.5
    this.helixHeight = helixHeight; // 48
    this.halfHelixHeight = this.helixHeight / 2;
    this.quarterHelixHeight = this.helixHeight / 4;
    this.ringTubeRadius = helixHeight / 2400.0; // 0.02;
    this.ignoreRings = ignoreRings;

    this.instancedHelices = this.initializeInstancedHelices();
    this.instancedBonds = this.initializeInstancedBonds(this.bonds);
    this.createHexMesh();
    
    // Center the hex group at the provided position
    this.hex.position.set(pos.x, pos.y, pos.z);

    // Add each instanced mesh to the hex group
    this.hex.add(this.instancedHelices.passive.mesh);
    this.hex.add(this.instancedHelices.s1.mesh);
    this.hex.add(this.instancedHelices.s2.mesh);
    this.hex.add(this.instancedHelices.s3.mesh);
    this.hex.add(this.instancedHelices.s4.mesh);
    this.hex.add(this.instancedHelices.s5.mesh);
    this.hex.add(this.instancedHelices.s6.mesh);

    this.hex.add(this.instancedBonds.replXY.mesh);
    this.hex.add(this.instancedBonds.neutXY.mesh);
    this.hex.add(this.instancedBonds.plugXY.mesh);
    this.hex.add(this.instancedBonds.sockXY.mesh);
    this.hex.add(this.instancedBonds.replZ.mesh);
    this.hex.add(this.instancedBonds.neutZ.mesh);
    this.hex.add(this.instancedBonds.plugZ.mesh);
    this.hex.add(this.instancedBonds.sockZ.mesh);

    if (!this.ignoreRings) {
      this.hex.add(this.instancedHelices.ring.mesh);
    }
    
    // Update all matrices to ensure proper rendering
    this.updateAllInstanceMatrices();
  }

  // Create a Hex THREE.Group Mesh that contains all helices and assosiated bonds
  createHexMesh() {
    hexCoordinates.forEach((coord, index) => {
      let [x, y] = coord;
      x = x * (this.helixHeight / 48.0);
      y = y * (this.helixHeight / 48.0);
      const isSideBondHelix = s2Mask[index] || s4Mask[index] || s6Mask[index];
      const isCoreBondHelix = s1Mask[index] || s3Mask[index] || s5Mask[index];
      const height = isCoreBondHelix ? this.halfHelixHeight : (isSideBondHelix ? this.quarterHelixHeight : this.helixHeight);
      let ringCount;
      if (!this.ignoreRings) {
        ringCount = isCoreBondHelix ? helixRingCount.core : (isSideBondHelix ? helixRingCount.side : helixRingCount.passive);
      }
      let mesh, meshIndex, bondGroup;
      if (isSideBondHelix) {
        if (s2Mask[index]) {
          mesh = this.instancedHelices.s2.mesh;
          meshIndex = this.instancedHelices.s2.index++;
          if (this.bonds !== null) {
            this.addSideBonds(mesh, "S2", s2Mask[index])
            this.addZBonds(mesh, s2Mask[index], true);
          }
        } else if (s4Mask[index]) {
          mesh = this.instancedHelices.s4.mesh;
          meshIndex = this.instancedHelices.s4.index++;
          if (this.bonds !== null) {
            this.addSideBonds(mesh, "S4", s4Mask[index])
            this.addZBonds(mesh, s4Mask[index], true);
          }
        } else if (s6Mask[index]) {
          mesh = this.instancedHelices.s6.mesh;
          meshIndex = this.instancedHelices.s6.index++;
          if (this.bonds !== null) {
            this.addSideBonds(mesh, "S6", s6Mask[index])
            this.addZBonds(mesh, s6Mask[index], true);
          }
        }
      } else if (isCoreBondHelix) {
        if (s1Mask[index]) {
          mesh = this.instancedHelices.s1.mesh;
          meshIndex = this.instancedHelices.s1.index++;
          if (this.bonds !== null) {
            this.addCoreBonds(mesh, "S1", s1Mask[index]);
          }
        } else if (s3Mask[index]) {
          mesh = this.instancedHelices.s3.mesh;
          meshIndex = this.instancedHelices.s3.index++;
          if (this.bonds !== null) {
            this.addCoreBonds(mesh, "S3", s3Mask[index]);
          }
        } else if (s5Mask[index]) {
          mesh = this.instancedHelices.s5.mesh;
          meshIndex = this.instancedHelices.s5.index++;
          if (this.bonds !== null) {
            this.addCoreBonds(mesh, "S5", s5Mask[index]);
          }
        }
      } else {
        mesh = this.instancedHelices.passive.mesh;
        meshIndex = this.instancedHelices.passive.index++;
        if (typeof Zhelices[index] !== 0 && this.bonds !== null) {
          this.addZBonds(mesh, Zhelices[index]);
        }

      }

      if (isCoreBondHelix) {
        const helixMatrix = new THREE.Matrix4();
        helixMatrix.setPosition(x, height + this.helixHeight * 0.5, y);
        mesh.setMatrixAt(meshIndex, helixMatrix);
        // Add Divisions
        if (!this.ignoreRings) {
          for (let i = 0; i < ringCount; i++) {
            const ringMatrix = new THREE.Matrix4();
            const rotationMatrix = new THREE.Matrix4();
            const ringY = (i / (ringCount - 1)) * height + height * 1.5;
            ringMatrix.setPosition(x, ringY, y);
            rotationMatrix.makeRotationX(Math.PI / 2);
            ringMatrix.multiply(rotationMatrix);
            this.instancedHelices.ring.mesh.setMatrixAt(this.instancedHelices.ring.index++, ringMatrix);
          }
        }

      } else if (isSideBondHelix) {
        const helixMatrix1 = new THREE.Matrix4();
        helixMatrix1.setPosition(x, height * 0.5 + this.helixHeight * 0.5, y);
        mesh.setMatrixAt(meshIndex, helixMatrix1);

        const helixMatrix2 = new THREE.Matrix4();
        helixMatrix2.setPosition(x, height * 3.5 + this.helixHeight * 0.5, y);
        mesh.setMatrixAt(meshIndex + 4, helixMatrix2);
        if (!this.ignoreRings) {
          for (let i = 0; i < ringCount; i++) {
            const ringMatrix1 = new THREE.Matrix4();
            const rotationMatrix = new THREE.Matrix4();
            const ringY1 = (i / (ringCount - 1)) * height + height * 5;
            ringMatrix1.setPosition(x, ringY1, y);
            rotationMatrix.makeRotationX(Math.PI / 2);
            ringMatrix1.multiply(rotationMatrix);
            this.instancedHelices.ring.mesh.setMatrixAt(this.instancedHelices.ring.index++, ringMatrix1);
          }

          for (let i = 0; i < ringCount; i++) {
            const ringMatrix2 = new THREE.Matrix4();
            const rotationMatrix = new THREE.Matrix4();
            const ringY2 = (i / (ringCount - 1)) * height + height * 2;
            ringMatrix2.setPosition(x, ringY2, y);
            rotationMatrix.makeRotationX(Math.PI / 2);
            ringMatrix2.multiply(rotationMatrix);
            this.instancedHelices.ring.mesh.setMatrixAt(this.instancedHelices.ring.index++, ringMatrix2);
          }
        }
      } else {
        const helixMatrix = new THREE.Matrix4();
        helixMatrix.setPosition(x, height, y);
        mesh.setMatrixAt(meshIndex, helixMatrix);
        
        if (!this.ignoreRings) {
          for (let i = 0; i < ringCount; i++) {
            const ringMatrix = new THREE.Matrix4();
            const rotationMatrix = new THREE.Matrix4();
            const ringY = (i / (ringCount - 1)) * height + height * 0.5;
            ringMatrix.setPosition(x, ringY, y);
            rotationMatrix.makeRotationX(Math.PI / 2);
            ringMatrix.multiply(rotationMatrix);
            this.instancedHelices.ring.mesh.setMatrixAt(this.instancedHelices.ring.index++, ringMatrix);
          }
        }
      }
    });
    
    // Update all instance matrices
    this.updateAllInstanceMatrices();
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

  calculateBondCounts(bonds) {
    const xySides = ["S1", "S2", "S3", "S4", "S5", "S6"];
    const zSides = ["ZU", "ZD"];
    let repulsiveXYCount = 0, neutralXYCount = 0, attractiveXYPlugCount = 0, attractiveXYSocketCount = 0;
    let repulsiveZCount = 0, neutralZCount = 0, attractiveZPlugCount = 0, attractiveZSocketCount = 0;

    for (const [side, codes] of Object.entries(bonds)) {
      codes.forEach((code, _) => {
        if (code === 0) {
          if (xySides.includes(side)) {
            attractiveXYSocketCount++;
          } else if (zSides.includes(side)) {
            attractiveZSocketCount++;
          }
        } else if (code === 1) {
          if (xySides.includes(side)) {
            attractiveXYPlugCount++;
          } else if (zSides.includes(side)) {
            attractiveZPlugCount++;
          }
        } else if (code === "x") {
          if (xySides.includes(side)) {
            repulsiveXYCount++;
          } else if (zSides.includes(side)) {
            repulsiveZCount++;
          }
        } else if (code === "-") {
          if (xySides.includes(side)) {
            neutralXYCount++;
          } else if (zSides.includes(side)) {
            neutralZCount++;
          }
        }
      });
    }

    return {
      repulsiveXYBond: repulsiveXYCount,
      neutralXYBond: neutralXYCount,
      attractiveXYPlugBond: attractiveXYPlugCount,
      attractiveXYSocketBond: attractiveXYSocketCount,
      repulsiveZBond: repulsiveZCount,
      neutralZBond: neutralZCount,
      attractiveZPlugBond: attractiveZPlugCount,
      attractiveZSocketBond: attractiveZSocketCount,
    }
  }

  getObject() {
    return this.hex;
  }

  getCoreHex() {
    return this.instancedHelices.passive.mesh;
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

  addZBonds(mesh, helix, sideBound = false) {
    let helixTopBond, helixBottomBond;
    let helixTopIndex, helixBottomIndex;
    const zBondIndex = this.zBondToIndex(helix);
    if (!zBondIndex && zBondIndex !== 0) return; // Skip if the helix doesn't have a valid Z bond index
    
    const topBondType = this.bonds["ZU"][zBondIndex];
    const bottomBondType = this.bonds["ZD"][zBondIndex];
    
    // Create the bond meshes based on bond types
    if (topBondType === 1) {
      helixTopBond = this.instancedBonds.plugZ.mesh;
      helixTopIndex = this.instancedBonds.plugZ.index++;
    } else if (topBondType === 0) {
      helixTopBond = this.instancedBonds.sockZ.mesh;
      helixTopIndex = this.instancedBonds.sockZ.index++;
    } else if (topBondType === "-") {
      helixTopBond = this.instancedBonds.neutZ.mesh;
      helixTopIndex = this.instancedBonds.neutZ.index++;
    } else if (topBondType === "x") {
      helixTopBond = this.instancedBonds.replZ.mesh;
      helixTopIndex = this.instancedBonds.replZ.index++;
    }

    if (bottomBondType === 1) {
      helixBottomBond = this.instancedBonds.plugZ.mesh;
      helixBottomIndex = this.instancedBonds.plugZ.index++;
    } else if (bottomBondType === 0) {
      helixBottomBond = this.instancedBonds.sockZ.mesh;
      helixBottomIndex = this.instancedBonds.sockZ.index++;
    } else if (bottomBondType === "-") {
      helixBottomBond = this.instancedBonds.neutZ.mesh;
      helixBottomIndex = this.instancedBonds.neutZ.index++;
    } else if (bottomBondType === "x") {
      helixBottomBond = this.instancedBonds.replZ.mesh;
      helixBottomIndex = this.instancedBonds.replZ.index++;
    }

    // Skip if no bonds to add
    if (!helixTopBond && !helixBottomBond) return;

    // Get helix information
    const helixInfo = this.getHelixCoordinates(helix);
    if (helixInfo.index === -1) return; // Invalid helix
    
    // Small offset to avoid Z-fighting (mesh intersection)
    const bondOffset = 0.4;
    
    // Calculate positions based on helix type and geometry
    const height = mesh.geometry.parameters.height;
    let topY, bottomY;
    
    if (helixInfo.isSide) {
      // Side helices have two quarter-height segments with a gap
      if (sideBound) {
        // Side helices have two cylinders
        topY = this.helixHeight * 1.5; // Top of the upper cylinder
        bottomY = this.helixHeight / 2; // Bottom of the lower cylinder
      } else {
        console.warn('Side helix without sideBound flag set');
        return;
      }
    } else {
      // Passive helices are full height
      topY =  this.helixHeight * 3/2; // Top of passive helix
      bottomY = this.helixHeight * 1/2; // Bottom of passive helix
    }
    
    // Set matrices for top bond
    if (helixTopBond) {
      const topBondMatrix = new THREE.Matrix4();
      topBondMatrix.setPosition(helixInfo.x, topY + bondOffset, helixInfo.y);
      helixTopBond.setMatrixAt(helixTopIndex, topBondMatrix);
      helixTopBond.instanceMatrix.needsUpdate = true;
    }
    
    // Set matrices for bottom bond
    if (helixBottomBond) {
      const bottomBondMatrix = new THREE.Matrix4();
      bottomBondMatrix.makeRotationX(Math.PI); // Flip the bond to face down
      bottomBondMatrix.setPosition(helixInfo.x, bottomY - bondOffset, helixInfo.y);
      helixBottomBond.setMatrixAt(helixBottomIndex, bottomBondMatrix);
      helixBottomBond.instanceMatrix.needsUpdate = true;
    }
  }
  
  // Helper function to get coordinates for a helix
  getHelixCoordinates(helix) {
    for (let i = 0; i < hexCoordinates.length; i++) {
      // Check in each mask array if this position has the target helix
      const isS1 = s1Mask[i] === helix;
      const isS2 = s2Mask[i] === helix;
      const isS3 = s3Mask[i] === helix;
      const isS4 = s4Mask[i] === helix;
      const isS5 = s5Mask[i] === helix;
      const isS6 = s6Mask[i] === helix;
      const isZ = Zhelices[i] === helix;
      
      if (isS1 || isS2 || isS3 || isS4 || isS5 || isS6 || isZ) {
        // Scale coordinates to match the current helix size
        let [x, y] = hexCoordinates[i];
        x = x * (this.helixHeight / 48.0);
        y = y * (this.helixHeight / 48.0);
        
        // Get the helix type
        const isCoreBondHelix = isS1 || isS3 || isS5;
        const isSideBondHelix = isS2 || isS4 || isS6;
        const isPassiveHelix = isZ;
        
        // Return the x, y, z coordinates and the helix type
        return {
          x: x,
          y: y,
          isCore: isCoreBondHelix,
          isSide: isSideBondHelix,
          isPassive: isPassiveHelix,
          index: i
        };
      }
    }
    return {
      x: 0,
      y: 0,
      isCore: false,
      isSide: false,
      isPassive: false,
      index: -1
    }; // Default fallback
  }

  initializeInstancedHelices() {
    // First defien the geomtries
    const helixGeometry = new THREE.CylinderGeometry(this.helixRadius, this.helixRadius, this.helixHeight, 32);
    const halfHelixGeometry = new THREE.CylinderGeometry(this.helixRadius, this.helixRadius, this.helixHeight * 0.25, 32);
    const quartHelixGeometry = new THREE.CylinderGeometry(this.helixRadius, this.helixRadius, this.helixHeight * 0.50, 32);
    const ringGeometry = new THREE.TorusGeometry(this.helixRadius, this.ringTubeRadius, 16, 100);

    // Start with Static Instances Meshes
    const passiveHelixMesh = new THREE.InstancedMesh(helixGeometry, materials.passiveHelix, helixTypeCount.passive);
    const helixColors = new Float32Array(helixTypeCount.passive * 3); // RGB for each instance
    for (let i = 0; i < helixTypeCount.passive; i++) {
      colors[i * 3 + 0] = colors.passive.r; // R
      colors[i * 3 + 1] = colors.passive.g; // G
      colors[i * 3 + 2] = colors.passive.b; // B
    }
    passiveHelixMesh.instanceColor = new THREE.InstancedBufferAttribute(helixColors, 3);

    const side1Mesh = new THREE.InstancedMesh(quartHelixGeometry, materials.side14, helixTypeCount.s1);
    const side2Mesh = new THREE.InstancedMesh(halfHelixGeometry, materials.side25, helixTypeCount.s2);
    const side3Mesh = new THREE.InstancedMesh(quartHelixGeometry, materials.side36, helixTypeCount.s3);
    const side4Mesh = new THREE.InstancedMesh(halfHelixGeometry, materials.side14, helixTypeCount.s4);
    const side5Mesh = new THREE.InstancedMesh(quartHelixGeometry, materials.side25, helixTypeCount.s5);
    const side6Mesh = new THREE.InstancedMesh(halfHelixGeometry, materials.side36, helixTypeCount.s6);

    const ringMesh = new THREE.InstancedMesh(ringGeometry, materials.ring, helixTypeCount.ring);

    // Return Instanced Meshes with Index
    return {
      passive: {
        mesh: passiveHelixMesh,
        index: 0
      },
      s1: {
        mesh: side1Mesh,
        index: 0
      },
      s2: {
        mesh: side2Mesh,
        index: 0
      },
      s3: {
        mesh: side3Mesh,
        index: 0
      },
      s4: {
        mesh: side4Mesh,
        index: 0
      },
      s5: {
        mesh: side5Mesh,
        index: 0
      },
      s6: {
        mesh: side6Mesh,
        index: 0
      },
      ring: {
        mesh: ringMesh,
        index: 0
      }
    }
  }

  initializeInstancedBonds(bonds) {
    // First count the number of bonds required to Instance From (this is dynamic)
    const bondCount = this.calculateBondCounts(bonds);
    const geometries = this.createBondGeometries();
    
    // XY Bonds
    const replXYMesh = new THREE.InstancedMesh(geometries.repulsiveBond, materials.repulsiveXYBond, bondCount.repulsiveXYBond || 1);
    const neutXYMesh = new THREE.InstancedMesh(geometries.neutralBond, materials.neutralXYBond, bondCount.neutralXYBond || 1);
    const plugXYMesh = new THREE.InstancedMesh(geometries.plugBond, materials.attractiveXYBond, bondCount.attractiveXYPlugBond || 1);
    const sockXYMesh = new THREE.InstancedMesh(geometries.socketBond, materials.attractiveXYBond, bondCount.attractiveXYSocketBond || 1);
    
    // Z Bonds
    const replZMesh = new THREE.InstancedMesh(geometries.repulsiveBond, materials.repulsiveZBond, bondCount.repulsiveZBond || 1);
    const neutZMesh = new THREE.InstancedMesh(geometries.neutralBond, materials.neutralZBond, bondCount.neutralZBond || 1);
    const plugZMesh = new THREE.InstancedMesh(geometries.plugBond, materials.attractiveZBond, bondCount.attractiveZPlugBond || 1);
    const sockZMesh = new THREE.InstancedMesh(geometries.socketBond, materials.attractiveZBond, bondCount.attractiveZSocketBond || 1);
    
    // Set visibility to false if there are no instances needed
    if (!bondCount.repulsiveXYBond) replXYMesh.visible = false;
    if (!bondCount.neutralXYBond) neutXYMesh.visible = false;
    if (!bondCount.attractiveXYPlugBond) plugXYMesh.visible = false;
    if (!bondCount.attractiveXYSocketBond) sockXYMesh.visible = false;
    if (!bondCount.repulsiveZBond) replZMesh.visible = false;
    if (!bondCount.neutralZBond) neutZMesh.visible = false;
    if (!bondCount.attractiveZPlugBond) plugZMesh.visible = false;
    if (!bondCount.attractiveZSocketBond) sockZMesh.visible = false;

    return {
      plugXY: {
        mesh: plugXYMesh,
        index: 0,
      },
      sockXY: {
        mesh: sockXYMesh,
        index: 0,
      },
      neutXY: {
        mesh: neutXYMesh,
        index: 0,
      },
      replXY: {
        mesh: replXYMesh,
        index: 0,
      },
      plugZ: {
        mesh: plugZMesh,
        index: 0,
      },
      sockZ: {
        mesh: sockZMesh,
        index: 0,
      },
      neutZ: {
        mesh: neutZMesh,
        index: 0,
      },
      replZ: {
        mesh: replZMesh,
        index: 0,
      },
    }
  }
  // Add Side XY Bonds
  addSideBonds(mesh, side, helix) {
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

    // Create bonds based on helixBondsLeft and helixBondsRight
    let leftBond, rightBond;
    let leftBondIndex, rightBondIndex;

    if (helixBondsLeft === 'x') {
      leftBond = this.instancedBonds.replXY.mesh;
      leftBondIndex = this.instancedBonds.replXY.index++;
    } else if (helixBondsLeft === '-') {
      leftBond = this.instancedBonds.neutXY.mesh;
      leftBondIndex = this.instancedBonds.neutXY.index++;
    } else if (helixBondsLeft === 1) {
      leftBond = this.instancedBonds.plugXY.mesh;
      leftBondIndex = this.instancedBonds.plugXY.index++;
    } else if (helixBondsLeft === 0) {
      leftBond = this.instancedBonds.sockXY.mesh;
      leftBondIndex = this.instancedBonds.sockXY.index++;
    }

    if (helixBondsRight === 'x') {
      rightBond = this.instancedBonds.replXY.mesh;
      rightBondIndex = this.instancedBonds.replXY.index++;
    } else if (helixBondsRight === '-') {
      rightBond = this.instancedBonds.neutXY.mesh;
      rightBondIndex = this.instancedBonds.neutXY.index++;
    } else if (helixBondsRight === 1) {
      rightBond = this.instancedBonds.plugXY.mesh;
      rightBondIndex = this.instancedBonds.plugXY.index++;
    } else if (helixBondsRight === 0) {
      rightBond = this.instancedBonds.sockXY.mesh;
      rightBondIndex = this.instancedBonds.sockXY.index++;
    }

    // Get helix information
    const helixInfo = this.getHelixCoordinates(helix);
    if (helixInfo.index === -1 || !helixInfo.isSide) return; // Invalid or not a side helix
    
    const bondOffset = 0.4;
    const quarterHeight = this.helixHeight * 0.25;
    
    // Side helices have two quarter-height cylinders:
    // - Lower cylinder starts at y=0 and extends to quarterHeight
    // - Upper cylinder starts at y=3*quarterHeight and extends to 4*quarterHeight
    // - The inner gap between cylinders is where we place our bonds
    
    // Position bonds at the inner faces of the cylinders (facing each other)
    if (leftBond) {
      const leftBondMatrix = new THREE.Matrix4();
      // Bond for the bottom face of upper cylinder pointing down
      leftBondMatrix.makeRotationX(Math.PI); // Flip to face down
      leftBondMatrix.setPosition(helixInfo.x, quarterHeight * 5 - bondOffset, helixInfo.y);
      leftBond.setMatrixAt(leftBondIndex, leftBondMatrix);
      leftBond.instanceMatrix.needsUpdate = true;
    }

    if (rightBond) {
      const rightBondMatrix = new THREE.Matrix4();
      // Bond for the top face of lower cylinder pointing up
      rightBondMatrix.setPosition(helixInfo.x, quarterHeight * 3 + bondOffset, helixInfo.y);
      rightBond.setMatrixAt(rightBondIndex, rightBondMatrix);
      rightBond.instanceMatrix.needsUpdate = true;
    }
  }

  // Add Core XY Bonds
  addCoreBonds(mesh, side, helix) {
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
    
    // Create bonds based on helixBondsLeft and helixBondsRight
    let leftBond, rightBond;
    let leftBondIndex, rightBondIndex;

    if (helixBondsLeft === 'x') {
      leftBond = this.instancedBonds.replXY.mesh;
      leftBondIndex = this.instancedBonds.replXY.index++;
    } else if (helixBondsLeft === '-') {
      leftBond = this.instancedBonds.neutXY.mesh;
      leftBondIndex = this.instancedBonds.neutXY.index++;
    } else if (helixBondsLeft === 1) {
      leftBond = this.instancedBonds.plugXY.mesh;
      leftBondIndex = this.instancedBonds.plugXY.index++;
    } else if (helixBondsLeft === 0) {
      leftBond = this.instancedBonds.sockXY.mesh;
      leftBondIndex = this.instancedBonds.sockXY.index++;
    }

    if (helixBondsRight === 'x') {
      rightBond = this.instancedBonds.replXY.mesh;
      rightBondIndex = this.instancedBonds.replXY.index++;
    } else if (helixBondsRight === '-') {
      rightBond = this.instancedBonds.neutXY.mesh;
      rightBondIndex = this.instancedBonds.neutXY.index++;
    } else if (helixBondsRight === 1) {
      rightBond = this.instancedBonds.plugXY.mesh;
      rightBondIndex = this.instancedBonds.plugXY.index++;
    } else if (helixBondsRight === 0) {
      rightBond = this.instancedBonds.sockXY.mesh;
      rightBondIndex = this.instancedBonds.sockXY.index++;
    }

    // Get helix information
    const helixInfo = this.getHelixCoordinates(helix);
    if (helixInfo.index === -1 || !helixInfo.isCore) return; // Invalid or not a core helix
    
    const bondOffset = 0.4;
    const quarterHeight = this.helixHeight * 0.25;
    
    // Core helices have a single half-height cylinder
    // positioned from y=halfHeight to y=helixHeight
    
    // Position bonds at the top and bottom of the core cylinder
    if (leftBond) {
      const leftBondMatrix = new THREE.Matrix4();
      leftBondMatrix.makeRotationX(Math.PI);
      leftBondMatrix.setPosition(helixInfo.x, quarterHeight * 3 - bondOffset, helixInfo.y); // Top of cylinder
      leftBond.setMatrixAt(leftBondIndex, leftBondMatrix);
      leftBond.instanceMatrix.needsUpdate = true;
    }
    
    if (rightBond) {
      const rightBondMatrix = new THREE.Matrix4();
      // rightBondMatrix.makeRotationX(Math.PI); // Flip to face down
      rightBondMatrix.setPosition(helixInfo.x, quarterHeight * 5 + bondOffset, helixInfo.y); // Bottom of cylinder
      rightBond.setMatrixAt(rightBondIndex, rightBondMatrix);
      rightBond.instanceMatrix.needsUpdate = true;
    }
  }

  createRepulsiveBond(color = 0xA91E3B) {
    const spikeRadius = 1.5; // Radius of the spike
    const spikeHeight = 1.5; // Height of the spike
    const baseRadius = 1.5;
    const baseHeight = 0.75;
    const baseGeometry = new THREE.CylinderGeometry(baseRadius, baseRadius, baseHeight, 32);
    const spikeGeometry = new THREE.ConeGeometry(spikeRadius, spikeHeight, 16);
    spikeGeometry.translate(0, baseHeight / 2 + spikeHeight / 2, 0);
    const repulsiveBondGeometry = mergeGeometries([baseGeometry, spikeGeometry]);
    const material = new THREE.MeshStandardMaterial({
      color: color
    });
    return new THREE.Mesh(repulsiveBondGeometry, material);
  }

  createNeutralBond(color = 0xFDB840) {
    const baseRadius = 1.5;
    const baseHeight = 1;
    const baseGeometry = new THREE.CylinderGeometry(baseRadius, baseRadius, baseHeight, 32);
    baseGeometry.translate(0, 0.1, 0);
    const material = new THREE.MeshStandardMaterial({
      color: color
    });
    return new THREE.Mesh(baseGeometry, material);
  }

  createAttractivePlugBond(color = 0x808836) {
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

    const material = new THREE.MeshStandardMaterial({
      color: color
    });

    return new THREE.Mesh(keyAndBase, material);
  }

  createAttractiveSocketBond(color = 0x808836) {
    const baseRadius = 1.5;
    const baseHeight = 1;
    const holeRadius = 0.75;
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
    const material = new THREE.MeshStandardMaterial({
      color: color
    }); // Greenish color for the bond
    const socket = new THREE.Mesh(geometry, material);
    return socket;
  }

  // Return the index if the zBond exists in the map, otherwise return undefined or handle the error as needed
  zBondToIndex(zBond) {
    return indexMap[zBond] !== undefined ? indexMap[zBond] : undefined;
  }
  rotate(x, y, z) {
    this.prism.rotation.x += x;
    this.prism.rotation.y += y;
    this.prism.rotation.z += z;
  }
  
  // Helper method to update all instanced matrices
  updateAllInstanceMatrices() {
    // Update helices
    this.instancedHelices.passive.mesh.instanceMatrix.needsUpdate = true;
    this.instancedHelices.s1.mesh.instanceMatrix.needsUpdate = true;
    this.instancedHelices.s2.mesh.instanceMatrix.needsUpdate = true;
    this.instancedHelices.s3.mesh.instanceMatrix.needsUpdate = true;
    this.instancedHelices.s4.mesh.instanceMatrix.needsUpdate = true;
    this.instancedHelices.s5.mesh.instanceMatrix.needsUpdate = true;
    this.instancedHelices.s6.mesh.instanceMatrix.needsUpdate = true;
    
    if (!this.ignoreRings) {
      this.instancedHelices.ring.mesh.instanceMatrix.needsUpdate = true;
    }
    
    // Update bonds
    this.instancedBonds.replXY.mesh.instanceMatrix.needsUpdate = true;
    this.instancedBonds.neutXY.mesh.instanceMatrix.needsUpdate = true;
    this.instancedBonds.plugXY.mesh.instanceMatrix.needsUpdate = true;
    this.instancedBonds.sockXY.mesh.instanceMatrix.needsUpdate = true;
    this.instancedBonds.replZ.mesh.instanceMatrix.needsUpdate = true;
    this.instancedBonds.neutZ.mesh.instanceMatrix.needsUpdate = true;
    this.instancedBonds.plugZ.mesh.instanceMatrix.needsUpdate = true;
    this.instancedBonds.sockZ.mesh.instanceMatrix.needsUpdate = true;
  }
}