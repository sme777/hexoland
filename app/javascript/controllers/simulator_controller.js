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


export default class extends Controller {

  connect() {
    const guiContainer = document.getElementById('guiContainer');

    let [scene, camera, renderer, controls] = this.setupCanvas(guiContainer);
    // Variables
    const numSides = 6;
    const sideWidth = 52.71;
    const sideHeight = 78.06;
    const helixWidth = 6.2;
    const helixHeight = 58.52;
    const attractiveBondWidth = 3; // Narrow and long
    const attractiveBondHeight = 12; // Long for attractive bonds
    const neutralBondWidth = helixWidth; // Neutral bond width matches helix width
    const neutralBondHeight = 3; // Short height for neutral bonds
    const repulsiveBondWidth = 8; // Double size for the "T" shape
    const colors = {
      helix: 0xF0E5D1, // light color for helices
      bondAttractive: 0x808836, // green for attractive bonds
      bondNeutral: 0xFDB840, // yellow for neutral bonds
      bondRepulsive: 0xA91E3B, // red for repulsive bonds
      side: 0xDBB5B4, // light color for sides
      border: 0x6D4E32 // border color for all rectangles
    };

    // Panel positions with no gaps between panels
    const sidePositions = [
      [-sideWidth * 1.5, -sideHeight / 2, 0], // Panel 1
      [-sideWidth / 2, -sideHeight / 2, 0], // Panel 2
      [sideWidth / 2, -sideHeight / 2, 0], // Panel 3
      [-sideWidth * 1.5, sideHeight / 2, 0], // Panel 4
      [-sideWidth / 2, sideHeight / 2, 0], // Panel 5
      [sideWidth / 2, sideHeight / 2, 0], // Panel 6
    ];

    // Sample bond data for each panel
    const bondData = [
      [0, 1, 'x', 0, 0, 1, 'x', 0], // Panel 1
      [1, 0, 'x', 1, 0, 'x', 1, 0], // Panel 2
      [0, 'x', 1, 0, 1, 'x', 0, 1], // Panel 3
      [1, 'x', 0, 1, 'x', 0, 1, 0], // Panel 4
      [0, 1, 0, 'x', 1, 0, 'x', 1], // Panel 5
      [1, 0, 1, 'x', 0, 'x', 1, 0], // Panel 6
    ];

    // Helix positions for the center-left and center-right pairs
    const leftCenterX = -sideWidth / 4 - helixWidth / 2; // Left pair centered in left half
    const rightCenterX = sideWidth / 4 - helixWidth / 2; // Right pair centered in right half

    // Bond positions for each end of each helix
    const bondOffsets = [
      [leftCenterX, helixHeight / 2 + neutralBondHeight / 2], // Top of left-center left helix
      [leftCenterX, -helixHeight / 2 - neutralBondHeight / 2], // Bottom of left-center left helix
      [leftCenterX + helixWidth, helixHeight / 2 + neutralBondHeight / 2], // Top of left-center right helix
      [leftCenterX + helixWidth, -helixHeight / 2 - neutralBondHeight / 2], // Bottom of left-center right helix
      [rightCenterX, helixHeight / 2 + neutralBondHeight / 2], // Top of right-center left helix
      [rightCenterX, -helixHeight / 2 - neutralBondHeight / 2], // Bottom of right-center left helix
      [rightCenterX + helixWidth, helixHeight / 2 + neutralBondHeight / 2], // Top of right-center right helix
      [rightCenterX + helixWidth, -helixHeight / 2 - neutralBondHeight / 2] // Bottom right-center right helix
    ];

    // Ground plane to receive shadows
    const groundGeometry = new THREE.PlaneGeometry(200, 200);
    const groundMaterial = new THREE.ShadowMaterial({
      opacity: 0.2
    });
    const ground = new THREE.Mesh(groundGeometry, groundMaterial);
    ground.rotation.x = -Math.PI / 2; // Rotate to be horizontal
    ground.position.y = -10;
    ground.receiveShadow = true; // Enable shadow receiving on ground
    scene.add(ground);

    // Helper function to create a rectangle mesh with border
    function createRectangleWithBorder(width, height, color, borderColor) {
      const group = new THREE.Group();

      // Rectangle body
      const geometry = new THREE.PlaneGeometry(width, height);
      const material = new THREE.MeshBasicMaterial({
        color
      });
      const rectangle = new THREE.Mesh(geometry, material);
      group.add(rectangle);

      // Border
      const edges = new THREE.EdgesGeometry(geometry);
      const lineMaterial = new THREE.LineBasicMaterial({
        color: borderColor
      });
      const border = new THREE.LineSegments(edges, lineMaterial);
      group.add(border);

      return group;
    }

    // Import CSG functions


    // Helper function to create a "T"-shaped bond with only an outer border around the "T" (excluding inner lines)
    function createTBond(size, color, borderColor, rotation = 0) {
      const group = new THREE.Group();

      // Material for the T shape
      const material = new THREE.MeshBasicMaterial({
        color
      });

      console.log(color)
      // Vertical part of T
      const verticalGeometry = new THREE.PlaneGeometry(size / 3, size * 1.5);
      const verticalMesh = new THREE.Mesh(verticalGeometry, material);
      group.add(verticalMesh);

      // Horizontal part of T
      const horizontalGeometry = new THREE.PlaneGeometry(size, size / 3);
      const horizontalMesh = new THREE.Mesh(horizontalGeometry, material);
      horizontalMesh.position.set(0, (size / 3) * 1.75, 0); // Position the horizontal top above the vertical part
      group.add(horizontalMesh);


      // Apply rotation if specified
      group.rotation.z = rotation;

      return group;
    }




    // Create sides and add bonds based on bondData
    for (let i = 0; i < numSides; i++) {
      const side = createRectangleWithBorder(sideWidth, sideHeight, colors.side, colors.border);
      side.position.set(...sidePositions[i]);
      scene.add(side);

      // Left pair of helices centered in the left half of the panel
      const helixLeft1 = createRectangleWithBorder(helixWidth, helixHeight, colors.helix, colors.border);
      helixLeft1.position.set(sidePositions[i][0] + leftCenterX, sidePositions[i][1], 0.1);
      scene.add(helixLeft1);

      const helixLeft2 = createRectangleWithBorder(helixWidth, helixHeight, colors.helix, colors.border);
      helixLeft2.position.set(sidePositions[i][0] + leftCenterX + helixWidth, sidePositions[i][1], 0.1);
      scene.add(helixLeft2);

      // Right pair of helices centered in the right half of the panel
      const helixRight1 = createRectangleWithBorder(helixWidth, helixHeight, colors.helix, colors.border);
      helixRight1.position.set(sidePositions[i][0] + rightCenterX, sidePositions[i][1], 0.1);
      scene.add(helixRight1);

      const helixRight2 = createRectangleWithBorder(helixWidth, helixHeight, colors.helix, colors.border);
      helixRight2.position.set(sidePositions[i][0] + rightCenterX + helixWidth, sidePositions[i][1], 0.1);
      scene.add(helixRight2);

      // Add bonds based on bondData[i]
      bondData[i].forEach((bond, index) => {
        let bondMesh;
        const isBottom = index % 2 === 1; // Identify bottom bonds

        switch (bond) {
          case 1:
            bondMesh = createRectangleWithBorder(attractiveBondWidth, attractiveBondHeight, colors.bondAttractive, colors.border); // Long and narrow for attractive bond
            break;
          case 'x':
            bondMesh = createTBond(repulsiveBondWidth, colors.bondRepulsive, colors.border, isBottom ? Math.PI : 0); // T shape for repulsive bond, rotated 180° for bottom bonds
            break;
          default:
            bondMesh = createRectangleWithBorder(neutralBondWidth, neutralBondHeight, colors.bondNeutral, colors.border); // Short and wide for neutral bond
        }

        // Position each bond at the exact top or bottom of each helix based on bondOffsets
        bondMesh.position.set(
          sidePositions[i][0] + bondOffsets[index][0],
          sidePositions[i][1] + bondOffsets[index][1],
          0.1
        );

        scene.add(bondMesh);
      });
    }
    // Instantiate a hexagonal prism with desired dimensions
    const hexPrism = new Hex(10, 30, 0xf5e6cb, 0x000000);
    scene.add(hexPrism.getObject());
    // Lighting (optional)
    const light = new THREE.DirectionalLight(0xffffff, 1);
    light.position.set(5, 5, 5).normalize();
    scene.add(light);

    // Camera position
    camera.position.z = 200;


    this.animate(scene, camera, renderer);

    window.addEventListener('resize', () => {
      this.onWindowResize(renderer, camera, guiContainer);
    });
  }

  setupCanvas(canvas) {
    const parentDiv = canvas.parentElement; // Get the parent div (the Bootstrap column)
    const width = parentDiv.clientWidth;
    const height = parentDiv.clientHeight;

    const scene = new THREE.Scene();
    scene.background = new THREE.Color(0xF1D3CE);

    const camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer();
    renderer.setSize(width, height);
    canvas.appendChild(renderer.domElement);
    camera.position.z = 30;

    const controls = new OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;
    controls.dampingFactor = 0.25;
    controls.enableZoom = true;

    return [scene, camera, renderer, controls];
  }

  onWindowResize(renderer, camera, container) {
    // Update the camera aspect ratio and projection matrix
    camera.aspect = container.clientWidth / container.clientHeight;
    camera.updateProjectionMatrix();

    // Update the renderer size
    renderer.setSize(container.clientWidth, container.clientHeight);

    // Ensure the renderer's pixel ratio is correct (useful for high-DPI displays)
    renderer.setPixelRatio(window.devicePixelRatio);
  }

  animate(scene, camera, renderer) {
    const animateLoop = () => {
      requestAnimationFrame(animateLoop);
      renderer.render(scene, camera);
    };
    animateLoop(); // Start the loop
  }
}