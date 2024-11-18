import * as THREE from 'three';
import { Panel } from '../models/panel';

export class Hex {
  constructor(pos, bonds={}) {
    this.hex = new THREE.Group();
    this.helixRadius = 1.5;
    this.helixHeight = 50;

    const halfHelixHeight = this.helixHeight / 2;
    const quarterHelixHeight = this.helixHeight / 4;

    const ringRadius = this.helixRadius;
    const ringTubeRadius = 0.01;
    const passiveHelixRingCount = 14;
    const coreBoundHelixRingCount = 8;
    const sideBoundHelixRingCount = 4;

    const repulsiveEnd = new THREE.MeshStandardMaterial({

    })

    const neutralEnd = new THREE.MeshStandardMaterial({

    })

    const attractiveOutEnd = new THREE.MeshStandardMaterial({

    })


    const attractiveInEnd = new THREE.MeshStandardMaterial({
      
    })

    const side14GroupMaterial = new THREE.MeshStandardMaterial({
      color: 0xD1E9F6
    });

    const side25GroupMaterial = new THREE.MeshStandardMaterial({
      color: 0xF6EACB
    });

    const side36GroupMaterial = new THREE.MeshStandardMaterial({
      color: 0xF1D3CE
    });

    const passiveHelix = new THREE.MeshStandardMaterial({
      color: 0xF5F7F8
    });
    const ringMaterial = new THREE.MeshStandardMaterial({
      color: 0xaaaaaa
    });

    const coordinates = [
      [31.67, 22.93],
      [9.4, 21.07],
      [22.13, 43.07],
      [41.13, 21.07],
      [31.67, 26.6],
      [12.6, 22.93],
      [37.93, 22.93],
      [18.93, 44.93],
      [22.13, 6.47],
      [31.67, 37.53],
      [41.13, 17.4],
      [9.4, 28.47],
      [18.93, 37.53],
      [12.6, 26.6],
      [9.4, 17.4],
      [18.93, 4.6],
      [28.47, 43.07],
      [9.4, 39.4],
      [6.2, 26.6],
      [22.13, 39.4],
      [6.2, 22.93],
      [41.13, 28.47],
      [3.07, 17.4],
      [3.07, 28.47],
      [28.47, 17.4],
      [28.47, 39.4],
      [31.67, 11.93],
      [3.07, 21.07],
      [28.47, 6.47],
      [37.93, 26.6],
      [9.4, 10.13],
      [25.27, 4.6],
      [31.67, 15.53],
      [18.93, 15.53],
      [9.4, 32.13],
      [3.07, 32.13],
      [15.73, 10.13],
      [37.93, 11.93],
      [25.27, 15.67],
      [34.73, 10.13],
      [25.27, 11.93],
      [15.73, 32.13],
      [37.93, 15.53],
      [12.6, 37.53],
      [6.2, 11.93],
      [6.2, 33.93],
      [15.73, 6.47],
      [6.2, 15.53],
      [6.2, 37.53],
      [34.87, 39.4],
      [28.47, 10.13],
      [28.47, 32.13],
      [37.93, 37.53],
      [34.73, 17.4],
      [34.87, 32.13],
      [12.6, 11.93],
      [12.6, 15.53],
      [12.6, 33.93],
      [15.73, 17.4],
      [15.73, 39.4],
      [41.13, 32.13],
      [25.33, 37.53],
      [34.73, 21.07],
      [37.93, 33.87],
      [18.93, 11.93],
      [18.93, 33.93],
      [25.27, 33.87],
      [15.73, 43.07],
      [25.27, 44.93],
      [22.13, 10.13],
      [31.67, 33.87],
      [34.87, 28.47]
    ];

    const s1Mask = [
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 1, 1,
      0, 0, 0, 1, 0, 0, 0, 0,
      0, 0, 0, 1, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ];
    const s3Mask = [
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 1, 0, 0, 1,
      0, 0, 0, 0, 0, 1, 0, 1,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ];
    const s5Mask = [
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      1, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 1, 0, 0, 1, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 1, 0, 0, 0
    ];

    const s2Mask = [
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 1,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 1, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 1, 0, 1, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ];

    const s4Mask = [
      0, 0, 0, 1, 0, 0, 0, 0,
      0, 0, 1, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 1, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 1, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ];

    const s6Mask = [
      0, 0, 0, 0, 0, 0, 0, 1,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 1, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      1, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 1, 0, 0, 0, 0
    ];

    // Create each helix and corresponding rings based on coordinates
    coordinates.forEach((coord, index) => {
      const [x, y] = coord;

      // Determine height based on material
      const iscoreBondHelix = s1Mask[index] === 1 || s3Mask[index] === 1 || s5Mask[index] === 1;
      const issideBondHelix = s2Mask[index] === 1 || s4Mask[index] === 1 || s6Mask[index] === 1;
      const height = iscoreBondHelix ? halfHelixHeight : (issideBondHelix ? quarterHelixHeight : this.helixHeight);
      const ringCount = iscoreBondHelix ? coreBoundHelixRingCount : (issideBondHelix ? sideBoundHelixRingCount : passiveHelixRingCount);

      if (issideBondHelix) {
        const helixGeometry = new THREE.CylinderGeometry(this.helixRadius, this.helixRadius, height, 32);

        const color = s2Mask[index] === 1 ? side25GroupMaterial : (s4Mask[index] === 1 ? side14GroupMaterial : side36GroupMaterial);

        const helix1 = new THREE.Mesh(helixGeometry, color);
        const helix2 = new THREE.Mesh(helixGeometry, color);

        helix1.position.set(x, 3.5 * height, y);
        helix2.position.set(x, 0.5 * height, y);

        this.hex.add(helix1);
        this.hex.add(helix2);

        // Create multiple encapsulating rings along the height of the helix
        for (let i = 0; i < ringCount; i++) {
          const ringGeometry = new THREE.TorusGeometry(ringRadius, ringTubeRadius, 16, 100);
          const ring = new THREE.Mesh(ringGeometry, ringMaterial);
          const ringY = (i / (ringCount - 1)) * height

          ring.position.set(x, ringY, y);
          ring.rotation.x = Math.PI / 2; 
          this.hex.add(ring);
        }

        // Create multiple encapsulating rings along the height of the helix
        for (let i = 0; i < ringCount; i++) {
          const ringGeometry = new THREE.TorusGeometry(ringRadius, ringTubeRadius, 16, 100);
          const ring = new THREE.Mesh(ringGeometry, ringMaterial);
          const ringY = (i / (ringCount - 1)) * height + 3 * height;
          ring.position.set(x, ringY, y);
          ring.rotation.x = Math.PI / 2;
          this.hex.add(ring);
        }

      } else {
        // Create the helix (cylinder) with adjusted height
        const helixGeometry = new THREE.CylinderGeometry(this.helixRadius, this.helixRadius, height, 32);
        let color;
        if (iscoreBondHelix) {
          color = s1Mask[index] === 1 ? side14GroupMaterial : (s3Mask[index] === 1 ? side36GroupMaterial : side25GroupMaterial);
        } else {
          color = passiveHelix;
        }
        const helix = new THREE.Mesh(helixGeometry, color);

        if (iscoreBondHelix) {
          helix.position.set(x, height, y);
        } else {
          helix.position.set(x, height / 2, y);
        }

        this.hex.add(helix);

        // Create multiple encapsulating rings along the height of the helix
        for (let i = 0; i < ringCount; i++) {
          const ringGeometry = new THREE.TorusGeometry(ringRadius, ringTubeRadius, 16, 100);
          const ring = new THREE.Mesh(ringGeometry, ringMaterial);
          // Distribute rings evenly along the height of the cylinder
          let ringY;
          if (iscoreBondHelix) {
            ringY = (i / (ringCount - 1)) * height + height / 2;
          } else {
            ringY = (i / (ringCount - 1)) * height;
          }
          // Position each ring around the cylinder and rotate to lie in the xz-plane
          ring.position.set(x, ringY, y);
          ring.rotation.x = Math.PI / 2; 
          this.hex.add(ring);
        }
      }

    });
    this.hex.position.set(pos.x, pos.y, pos.z);
  }

  getObject() {
    return this.hex;
  }

  getSpacings() {
    // const width = 2 * this.helixRadius * 32;
    // const height = Math.sqrt(3) * this.helixRadius * 32;
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
