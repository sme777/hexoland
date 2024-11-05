import * as THREE from 'three';

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

    // Create the material for the prism faces
    this.material = new THREE.MeshBasicMaterial({ color: this.color, side: THREE.DoubleSide });
    this.mesh = new THREE.Mesh(this.geometry, this.material);

    // Create black edges for the prism
    const edgesGeometry = new THREE.EdgesGeometry(this.geometry);
    const edgesMaterial = new THREE.LineBasicMaterial({ color: this.edgeColor });
    this.edges = new THREE.LineSegments(edgesGeometry, edgesMaterial);

    // Create a group to hold both the mesh and the edges
    this.prism = new THREE.Group();
    this.prism.add(this.mesh);
    this.prism.add(this.edges);
  }

  // Method to get the prism object
  getObject() {
    return this.prism;
  }

  // Method to add rotation (optional)
  rotate(x, y, z) {
    this.prism.rotation.x += x;
    this.prism.rotation.y += y;
    this.prism.rotation.z += z;
  }
}