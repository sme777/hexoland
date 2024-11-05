import * as THREE from 'three';

// Panel class
export class Panel {
  constructor(position, bondData, colors, helixWidth, helixHeight, bondOffsets) {
    this.position = position;
    this.bondData = bondData;
    this.colors = colors;
    this.helixWidth = helixWidth;
    this.helixHeight = helixHeight;
    this.bondOffsets = bondOffsets;
    this.group = new THREE.Group();

    this.createPanel();
  }

  // Helper to create a rectangle with a border
  createRectangleWithBorder(width, height, color, borderColor) {
    const group = new THREE.Group();

    // Rectangle body
    const geometry = new THREE.PlaneGeometry(width, height);
    const material = new THREE.MeshBasicMaterial({ color });
    const rectangle = new THREE.Mesh(geometry, material);
    group.add(rectangle);

    // Border
    const edges = new THREE.EdgesGeometry(geometry);
    const lineMaterial = new THREE.LineBasicMaterial({ color: borderColor });
    const border = new THREE.LineSegments(edges, lineMaterial);
    group.add(border);

    return group;
  }

  // Helper to create a "T"-shaped bond
  createTBond(size, color, borderColor, rotation = 0) {
    const group = new THREE.Group();
    const material = new THREE.MeshBasicMaterial({ color });

    // Vertical part of T
    const verticalGeometry = new THREE.PlaneGeometry(size / 3, size * 1.5);
    const verticalMesh = new THREE.Mesh(verticalGeometry, material);
    group.add(verticalMesh);

    // Horizontal part of T
    const horizontalGeometry = new THREE.PlaneGeometry(size, size / 3);
    const horizontalMesh = new THREE.Mesh(horizontalGeometry, material);
    horizontalMesh.position.set(0, (size / 3) * 1.75, 0);
    group.add(horizontalMesh);

    // Apply rotation if specified
    group.rotation.z = rotation;

    return group;
  }

  // Create the panel with helices and bonds
  createPanel() {
    const leftCenterX = -this.helixWidth * 1.5; // Adjusted for placement
    const rightCenterX = this.helixWidth * 0.5;

    // Create helices and bonds based on bondData
    this.bondData.forEach((bond, index) => {
      let bondMesh;
      const isBottom = index % 2 === 1;
      const bondOffset = this.bondOffsets[index];

      switch (bond) {
        case 1:
          bondMesh = this.createRectangleWithBorder(3, 12, this.colors.bondAttractive, this.colors.border);
          break;
        case 'x':
          bondMesh = this.createTBond(8, this.colors.bondRepulsive, this.colors.border, isBottom ? Math.PI : 0);
          break;
        default:
          bondMesh = this.createRectangleWithBorder(this.helixWidth, 3, this.colors.bondNeutral, this.colors.border);
      }

      // Position each bond at the exact top or bottom of each helix based on bondOffsets
      bondMesh.position.set(bondOffset[0], bondOffset[1], 0.1);
      this.group.add(bondMesh);
    });

    // Left pair of helices
    const helixLeft1 = this.createRectangleWithBorder(this.helixWidth, this.helixHeight, this.colors.helix, this.colors.border);
    helixLeft1.position.set(leftCenterX, 0, 0.1);
    this.group.add(helixLeft1);

    const helixLeft2 = this.createRectangleWithBorder(this.helixWidth, this.helixHeight, this.colors.helix, this.colors.border);
    helixLeft2.position.set(leftCenterX + this.helixWidth, 0, 0.1);
    this.group.add(helixLeft2);

    // Right pair of helices
    const helixRight1 = this.createRectangleWithBorder(this.helixWidth, this.helixHeight, this.colors.helix, this.colors.border);
    helixRight1.position.set(rightCenterX, 0, 0.1);
    this.group.add(helixRight1);

    const helixRight2 = this.createRectangleWithBorder(this.helixWidth, this.helixHeight, this.colors.helix, this.colors.border);
    helixRight2.position.set(rightCenterX + this.helixWidth, 0, 0.1);
    this.group.add(helixRight2);

    this.group.position.set(...this.position);
  }

  // Method to get the panel group
  getObject() {
    return this.group;
  }
}

// Hexagon class
class Hexagon {
  constructor(panelsData, colors, helixWidth, helixHeight, bondOffsets) {
    this.panels = [];
    this.colors = colors;
    this.helixWidth = helixWidth;
    this.helixHeight = helixHeight;
    this.bondOffsets = bondOffsets;
    this.group = new THREE.Group();

    this.createHexagon(panelsData);
  }

  createHexagon(panelsData) {
    const sidePositions = [
      [-52.71 * 1.5, -78.06 / 2, 0],
      [-52.71 / 2, -78.06 / 2, 0],
      [52.71 / 2, -78.06 / 2, 0],
      [-52.71 * 1.5, 78.06 / 2, 0],
      [-52.71 / 2, 78.06 / 2, 0],
      [52.71 / 2, 78.06 / 2, 0]
    ];

    sidePositions.forEach((position, index) => {
      const panel = new Panel(position, panelsData[`S${index + 1}`], this.colors, this.helixWidth, this.helixHeight, this.bondOffsets);
      this.panels.push(panel);
      this.group.add(panel.getObject());
    });
  }

  // Method to get the hexagon group
  getObject() {
    return this.group;
  }
}
