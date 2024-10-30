import {
  Controller
} from "@hotwired/stimulus"
import {
  OrbitControls
} from 'three/addons/controls/OrbitControls.js';
import * as THREE from "three";
import * as CSG from 'three-csg-ts';

export default class extends Controller {

  connect() {
    const guiContainer = document.getElementById('guiContainer');

    let [scene, camera, renderer, controls] = this.setupCanvas(guiContainer);
// Add ambient and directional light for shadows
const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
scene.add(ambientLight);
const light = new THREE.DirectionalLight(0xffffff, 1);
light.position.set(10, 10, 10);
light.castShadow = true;
scene.add(light);

// Variables
const numSides = 6;
const sideWidth = 52.71;
const sideHeight = 78.06;
const prismRadius = sideWidth / (2 * Math.tan(Math.PI / numSides)); // Radius for hexagonal arrangement
const helixWidth = 6.2;
const helixHeight = 58.52;
const attractiveBondWidth = 3; // Narrow and long
const attractiveBondHeight = 12; // Long for attractive bonds
const neutralBondWidth = helixWidth; // Neutral bond width matches helix width
const neutralBondHeight = 3; // Short height for neutral bonds
const repulsiveBondWidth = 8; // Double size for the "T" shape
const colors = {
  helix: 0xF0E5D1,
  bondAttractive: 0x808836,
  bondNeutral: 0xFDB840,
  bondRepulsive: 0xA91E3B,
  side: 0xDBB5B4,
  border: 0x6D4E32
};

// Sample bond data for each panel
const bondData = [
  [0, 1, 'x', 0, 0, 1, 'x', 0], // Panel 1
  [1, 0, 'x', 1, 0, 'x', 1, 0], // Panel 2
  [0, 'x', 1, 0, 1, 'x', 0, 1], // Panel 3
  [1, 'x', 0, 1, 'x', 0, 1, 0], // Panel 4
  [0, 1, 0, 'x', 1, 0, 'x', 1], // Panel 5
  [1, 0, 1, 'x', 0, 'x', 1, 0]  // Panel 6
];

// Helper function to create a rectangle mesh with border
function createRectangleWithBorder(width, height, color, borderColor) {
  const group = new THREE.Group();
  const geometry = new THREE.PlaneGeometry(width, height);
  const material = new THREE.MeshBasicMaterial({ color });
  const rectangle = new THREE.Mesh(geometry, material);
  group.add(rectangle);

  const edges = new THREE.EdgesGeometry(geometry);
  const lineMaterial = new THREE.LineBasicMaterial({ color: borderColor });
  const border = new THREE.LineSegments(edges, lineMaterial);
  group.add(border);

  return group;
}

// Helper function to create a "T"-shaped bond
function createTBond(size, color, rotation = 0) {
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

  group.rotation.z = rotation;
  return group;
}

// Create hexagonal prism
for (let i = 0; i < numSides; i++) {
  // Calculate angle and position for each panel
  const angle = (i * 2 * Math.PI) / numSides;
  const x = prismRadius * Math.cos(angle);
  const z = prismRadius * Math.sin(angle);
  const panel = createRectangleWithBorder(sideWidth, sideHeight, colors.side, colors.border);

  // Position and rotate each panel
  panel.position.set(x, 0, z);
  panel.rotation.y = -angle; // Rotate panel to face outward
  scene.add(panel);

  // Left pair of helices centered in the left half of the panel
  const helixLeft1 = createRectangleWithBorder(helixWidth, helixHeight, colors.helix, colors.border);
  helixLeft1.position.set(-sideWidth / 4, 0, 0.1);
  panel.add(helixLeft1);

  const helixLeft2 = createRectangleWithBorder(helixWidth, helixHeight, colors.helix, colors.border);
  helixLeft2.position.set(-sideWidth / 4 + helixWidth, 0, 0.1);
  panel.add(helixLeft2);

  // Right pair of helices centered in the right half of the panel
  const helixRight1 = createRectangleWithBorder(helixWidth, helixHeight, colors.helix, colors.border);
  helixRight1.position.set(sideWidth / 4, 0, 0.1);
  panel.add(helixRight1);

  const helixRight2 = createRectangleWithBorder(helixWidth, helixHeight, colors.helix, colors.border);
  helixRight2.position.set(sideWidth / 4 + helixWidth, 0, 0.1);
  panel.add(helixRight2);

  // Add bonds based on bondData[i]
  bondData[i].forEach((bond, index) => {
    let bondMesh;
    const isBottom = index % 2 === 1;

    switch (bond) {
      case 1:
        bondMesh = createRectangleWithBorder(attractiveBondWidth, attractiveBondHeight, colors.bondAttractive, colors.border);
        break;
      case 'x':
        bondMesh = createTBond(repulsiveBondWidth, colors.bondRepulsive, isBottom ? Math.PI : 0);
        break;
      default:
        bondMesh = createRectangleWithBorder(neutralBondWidth, neutralBondHeight, colors.bondNeutral, colors.border);
    }

    // Position bonds at the ends of each helix based on `index`
    const bondOffsetY = index < 4 ? helixHeight / 2 + neutralBondHeight / 2 : -helixHeight / 2 - neutralBondHeight / 2;
    bondMesh.position.set(index % 2 === 0 ? -sideWidth / 4 : sideWidth / 4, bondOffsetY, 0.1);
    panel.add(bondMesh);
  });
}

// Camera position and render function
camera.position.set(100, 100, 100);
camera.lookAt(0, 0, 0);

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