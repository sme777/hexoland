import * as THREE from 'three';
import { Panel } from '../models/panel';

export class Hex {
  constructor(radius = 1, height = 2, color = 0xf5e6cb, edgeColor = 0x000000) {
    this.radius = radius;
    this.height = height;
    this.color = color;
    this.edgeColor = edgeColor;
    
    // Create the geometry for the hexagonal shape
    const hexShape = new THREE.Shape();
    for (let i = 0; i < 6; i++) {
      const angle = (i / 6) * Math.PI * 2;
      const x = this.radius * Math.cos(angle);
      const y = this.radius * Math.sin(angle);
      if (i === 0) {
        hexShape.moveTo(x, y);
      } else {
        hexShape.lineTo(x, y);
      }
    }
    hexShape.closePath();

    // Extrude the shape to create a prism
    const extrudeSettings = {
      depth: this.height,
      bevelEnabled: false,
    };
    this.geometry = new THREE.ExtrudeGeometry(hexShape, extrudeSettings);
    this.geometry.center();

    this.material = new THREE.MeshBasicMaterial({ color: this.color, side: THREE.DoubleSide });
    this.mesh = new THREE.Mesh(this.geometry, this.material);

    const edgesGeometry = new THREE.EdgesGeometry(this.geometry);
    const edgesMaterial = new THREE.LineBasicMaterial({ color: this.edgeColor });
    this.edges = new THREE.LineSegments(edgesGeometry, edgesMaterial);

    this.prism = new THREE.Group();
    this.prism.add(this.mesh);
    this.prism.add(this.edges);

    this.addPanels();
  }

  getObject() {
    return this.prism;
  }

  rotate(x, y, z) {
    this.prism.rotation.x += x;
    this.prism.rotation.y += y;
    this.prism.rotation.z += z;
  }

  addPanels() {
    const { rectangularFaces } = this.computeHexPrismFaces(this.radius, this.height);
    let idx = 1
    rectangularFaces.forEach(face => {
      // Calculate the width of the panel based on the distance between two adjacent vertices
      const faceWidth = new THREE.Vector3(face[1].x - face[0].x, face[1].y - face[0].y, face[1].z - face[0].z).length();
      const faceHeight = this.height;
  
      // Calculate the center of the face
      const centerX = (face[0].x + face[1].x + face[2].x + face[3].x) / 4;
      const centerY = (face[0].y + face[1].y + face[2].y + face[3].y) / 4;
      const centerZ = (face[0].z + face[1].z + face[2].z + face[3].z) / 4;
      const centerPosition = new THREE.Vector3(centerX, centerY, centerZ);
  
      // Calculate the face normal for alignment
      const edge1 = new THREE.Vector3(face[1].x - face[0].x, face[1].y - face[0].y, face[1].z - face[0].z);
      const edge2 = new THREE.Vector3(face[3].x - face[0].x, face[3].y - face[0].y, face[3].z - face[0].z);
      const faceNormal = new THREE.Vector3().crossVectors(edge1, edge2).normalize();
      let panel;
      // Create a Panel with the exact width and height
      if (idx == 1) {
        panel = new Panel([centerX - 7.5, centerY - 4.375, centerZ], ["1","0","1","0","1","1","0","0"], faceWidth, faceHeight);
      } else if (idx == 2) {
        panel = new Panel([centerX, centerY - 8.625, centerZ], ["x","x","x","x","x","x","x","x"], faceWidth, faceHeight);
      } else if (idx == 3) {
        panel = new Panel([centerX + 7.5 , centerY - 4.5, centerZ], ["x","x","x","x","x","x","x","x"], faceWidth, faceHeight);
      } else if (idx == 4) {
        panel = new Panel([centerX + 7.5, centerY + 4.5 , centerZ], ["x","x","x","x","x","x","x","x"], faceWidth, faceHeight);
      } else if (idx == 5) {
        panel = new Panel([centerX , centerY + 8.75, centerZ], ["x","x","x","x","x","x","x","x"], faceWidth, faceHeight);
      } else if (idx == 6) {
        panel = new Panel([centerX - 7.5 , centerY + 4.5, centerZ], ["x","x","x","x","x","x","x","x"], faceWidth, faceHeight);
      } 
      
      const panelGroup = panel.createPanel();
      // Align the panel with the outward direction of the face
      panelGroup.position.copy(centerPosition);
      panelGroup.lookAt(centerPosition.clone().add(faceNormal));
      // Offset the panel slightly along the normal to avoid z-fighting
      const offsetDistance = -0.1;  // Adjust this value as needed to reduce shearing
      panelGroup.position.add(faceNormal.clone().multiplyScalar(offsetDistance));

      // Rotate the panel by π/2 around its Z-axis for proper orientation
      panelGroup.rotateZ(Math.PI / 2);
      panelGroup.rotateY(Math.PI);
      // Add the panel to the prism group
      this.prism.add(panelGroup);
      idx += 1
    });
  }

  addPanels2() {
    const { rectangularFaces } = this.computeHexPrismFaces(this.radius, this.height);
  
    rectangularFaces.forEach((face, index) => {
      // Calculate the width and height of each face
      const faceWidth = new THREE.Vector3(face[1].x - face[0].x, face[1].y - face[0].y, face[1].z - face[0].z).length();
      const faceHeight = this.height;
  
      // Calculate the center of the face for panel positioning
      const centerX = (face[0].x + face[1].x + face[2].x + face[3].x) / 4;
      const centerY = (face[0].y + face[1].y + face[2].y + face[3].y) / 4;
      const centerZ = (face[0].z + face[1].z + face[2].z + face[3].z) / 4;
      const centerPosition = new THREE.Vector3(centerX, centerY, centerZ);
  
      // Calculate the face normal for orientation
      const edge1 = new THREE.Vector3(face[1].x - face[0].x, face[1].y - face[0].y, face[1].z - face[0].z);
      const edge2 = new THREE.Vector3(face[3].x - face[0].x, face[3].y - face[0].y, face[3].z - face[0].z);
      const faceNormal = new THREE.Vector3().crossVectors(edge1, edge2).normalize();
  
      // Create the panel with calculated width and height
      const panel = new Panel([centerPosition.x, centerPosition.y, centerPosition.z], ["0", "0", "0", "0", "0", "0", "0", "0"], faceWidth, faceHeight);
      const panelGroup = panel.createPanel();
  
      // Position the panel at the calculated face center
      panelGroup.position.copy(centerPosition);
  
      // Orient the panel to align with the face normal
      panelGroup.lookAt(centerPosition.clone().add(faceNormal));
  
      // Offset the panel slightly along the normal to prevent z-fighting
      const offsetDistance = -0.05;  // Small offset to avoid z-fighting
      panelGroup.position.add(faceNormal.clone().multiplyScalar(offsetDistance));
      panelGroup.rotateZ(Math.PI / 2);
      panelGroup.rotateY(Math.PI);
      // Add the panel to the prism group
      this.prism.add(panelGroup);
    });
  }
  
  

  computeHexPrismFaces(radius = 1, height = 2) {
    const topVertices = [];
    const bottomVertices = [];
    const rectangularFaces = [];
  
    for (let i = 0; i < 6; i++) {
      const angle = (i / 6) * Math.PI * 2;
      const x = radius * Math.cos(angle);
      const y = radius * Math.sin(angle);
  
      topVertices.push({ x: x, y: y, z: height / 2 });
      bottomVertices.push({ x: x, y: y, z: -height / 2 });
    }
  
    for (let i = 0; i < 6; i++) {
      const nextIndex = (i + 1) % 6;
      rectangularFaces.push([
        topVertices[i],
        topVertices[nextIndex],
        bottomVertices[nextIndex],
        bottomVertices[i]
      ]);
    }
  
    return { topVertices, bottomVertices, rectangularFaces };
  }
}
