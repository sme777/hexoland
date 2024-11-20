import * as THREE from 'three';
import { hexCoordinates, helixTypeCount, s1Mask, s3Mask, s5Mask, s2Mask, s4Mask, s6Mask } from './constants.js';

export class Hex {
  constructor(pos, bonds={}) {
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
      side14: new THREE.MeshStandardMaterial({ color: 0xD1E9F6 }),
      side25: new THREE.MeshStandardMaterial({ color: 0xF6EACB }),
      side36: new THREE.MeshStandardMaterial({ color: 0xF1D3CE }),
      passiveHelix: new THREE.MeshStandardMaterial({ color: 0xF5F7F8 }),
      ring: new THREE.MeshStandardMaterial({ color: 0xaaaaaa }),
      repulsiveBond: new THREE.MeshStandardMaterial({}),
      neutralBond: new THREE.MeshStandardMaterial({}),
      attractiveSocketBond: new THREE.MeshStandardMaterial({}),
      attractivePlugBond: new THREE.MeshStandardMaterial({})
    }
    // Geometries
    const helixGeometry = new THREE.CylinderGeometry(this.helixRadius, this.helixRadius, this.helixHeight, 32);
    const halfHelixGeometry = new THREE.CylinderGeometry(this.helixRadius, this.helixRadius, this.helixHeight * 0.50, 32);
    const quartHelixGeometry = new THREE.CylinderGeometry(this.helixRadius, this.helixRadius, this.helixHeight * 0.25, 32);

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

      const isSideBondHelix = s1Mask[index] || s3Mask[index] || s5Mask[index];
      const isCoreBondHelix = s2Mask[index] || s4Mask[index] || s6Mask[index];
      const height = isCoreBondHelix ? halfHelixHeight : (isSideBondHelix ? quarterHelixHeight : this.helixHeight);
      const ringCount = isCoreBondHelix ? coreBoundHelixRingCount : (isSideBondHelix ? sideBoundHelixRingCount : passiveHelixRingCount);

      let mesh, meshIndex;

      if (isCoreBondHelix) {
        if (s2Mask[index]) {
          mesh = side2Mesh;
          meshIndex = side2Index++;
        } else if (s4Mask[index]) {
          mesh = side4Mesh;
          meshIndex = side4Index++;
        } else if (s6Mask[index]) {
          mesh = side6Mesh;
          meshIndex = side6Index++;
        }
      } else if (isSideBondHelix) {
        if (s1Mask[index]) {
          mesh = side1Mesh;
          meshIndex = side1Index++;
        } else if (s3Mask[index]) {
          mesh = side3Mesh;
          meshIndex = side3Index++;
        } else if (s5Mask[index]) {
          mesh = side5Mesh;
          meshIndex = side5Index++;
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
          const ringY = (i / (ringCount - 1)) * height + height *1.5;
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
    return {horiz, vert, depth };
  }

  rotate(x, y, z) {
    this.prism.rotation.x += x;
    this.prism.rotation.y += y;
    this.prism.rotation.z += z;
  }

}
