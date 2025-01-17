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

export class HexGroup {
    constructor(hexCount, hexPositions, helixHeight, ignoreRings) {

        // Geometries
        this.helixRadius = helixHeight / 32.0;
        this.helixHeight = helixHeight;
        const halfHelixHeight = this.helixHeight / 2;
        const quarterHelixHeight = this.helixHeight / 4;

        const helixGeometry = new THREE.CylinderGeometry(this.helixRadius, this.helixRadius, this.helixHeight, 32);
        const halfHelixGeometry = new THREE.CylinderGeometry(this.helixRadius, this.helixRadius, this.helixHeight * 0.25, 32);
        const quartHelixGeometry = new THREE.CylinderGeometry(this.helixRadius, this.helixRadius, this.helixHeight * 0.50, 32);


        const passiveHelixMesh = new THREE.InstancedMesh(helixGeometry, materials.passiveHelix, helixTypeCount.passive * hexCount);
        const passiveColor = new THREE.Color(0xF5F7F8)
        // Enable per-instance colors
        const colors = new Float32Array(helixTypeCount.passive * hexCount * 3); // RGB for each instance
        for (let i = 0; i < (helixTypeCount.passive * hexCount); i++) {
            colors[i * 3 + 0] = passiveColor.r; // R
            colors[i * 3 + 1] = passiveColor.g; // G
            colors[i * 3 + 2] = passiveColor.b; // B
        }
        passiveHelixMesh.instanceColor = new THREE.InstancedBufferAttribute(colors, 3);

        console.log(helixTypeCount.passive * hexCount);
        console.log(helixTypeCount.passive);

        console.log(helixTypeCount.s1 * hexCount);
        console.log(helixTypeCount.s1);
        const side1Mesh = new THREE.InstancedMesh(quartHelixGeometry, materials.side14, helixTypeCount.s1 * hexCount);
        const side2Mesh = new THREE.InstancedMesh(halfHelixGeometry, materials.side25, helixTypeCount.s2 * hexCount);
        const side3Mesh = new THREE.InstancedMesh(quartHelixGeometry, materials.side36, helixTypeCount.s3 * hexCount);
        const side4Mesh = new THREE.InstancedMesh(halfHelixGeometry, materials.side14, helixTypeCount.s4 * hexCount);
        const side5Mesh = new THREE.InstancedMesh(quartHelixGeometry, materials.side25, helixTypeCount.s5 * hexCount);
        const side6Mesh = new THREE.InstancedMesh(halfHelixGeometry, materials.side36, helixTypeCount.s6 * hexCount);

        // Counters for each instanced mesh
        let passiveIndex = 0;
        let side1Index = 0;
        let side2Index = 0;
        let side3Index = 0;
        let side4Index = 0;
        let side5Index = 0;
        let side6Index = 0;

        this.hexGroup = new THREE.Group();
        // [[hex1, [x1, y1, z1]], [hex2, [x2, y2, z2]], ...]
        hexPositions.forEach((content, _) => {
            // console.log(name);
            // console.log(positions);
            let [name, positions] = content;
            let [posX, posY, posZ] = positions;
            const newHex = new THREE.Group();
            hexCoordinates.forEach((coord, index) => {
                let [x, y] = coord;
                x = x * (this.helixHeight / 48.0);
                y = y * (this.helixHeight / 48.0);
                const isSideBondHelix = s2Mask[index] || s4Mask[index] || s6Mask[index];
                const isCoreBondHelix = s1Mask[index] || s3Mask[index] || s5Mask[index];
                const height = isCoreBondHelix ? halfHelixHeight : (isSideBondHelix ? quarterHelixHeight : this.helixHeight);

                let mesh, meshIndex, bondGroup;

                if (isSideBondHelix) {
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
                } else if (isCoreBondHelix) {
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
                    helixMatrix.setPosition(x + posX, height + this.helixHeight * 0.5 + posY, y + posZ);
                    mesh.setMatrixAt(meshIndex, helixMatrix);

                } else if (isSideBondHelix) {
                    const helixMatrix1 = new THREE.Matrix4();
                    helixMatrix1.setPosition(x + posX, height * 0.5 + this.helixHeight * 0.5 + posY, y + posZ);
                    mesh.setMatrixAt(meshIndex, helixMatrix1);

                    const helixMatrix2 = new THREE.Matrix4();
                    helixMatrix2.setPosition(x + posX, height * 3.5 + this.helixHeight * 0.5 + posY, y + posZ);
                    mesh.setMatrixAt(meshIndex + 4 * hexCount, helixMatrix2);
                } else {
                    const helixMatrix = new THREE.Matrix4();
                    helixMatrix.setPosition(x + posX, height + posY, y + posZ);
                    mesh.setMatrixAt(meshIndex, helixMatrix);

                }
            });
            // Center the hex group at the provided position
            newHex.position.set(posX, posY, posZ);
            // Add each instanced mesh to the hex group
            newHex.add(passiveHelixMesh);
            newHex.add(side1Mesh);
            newHex.add(side2Mesh);
            newHex.add(side3Mesh);
            newHex.add(side4Mesh);
            newHex.add(side5Mesh);
            newHex.add(side6Mesh);

            this.hexGroup.add(newHex);
        });
    }

    getObject() {
        return this.hexGroup;
      }
}