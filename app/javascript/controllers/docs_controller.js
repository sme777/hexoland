import {
  Controller
} from "@hotwired/stimulus"
import hljs from 'highlight.js';
import javascript from 'highlight.js/lib/languages/javascript';
import * as THREE from "three";

export default class extends Controller {
  connect() {
    hljs.registerLanguage('javascript', javascript);

    this.setupCodeBlocks();

    const simpleBlockCanvas = document.getElementById('simpleBlockCanvasContainer');
    const hierarchicalBlockCanvas = document.getElementById('hierarchicalBlockCanvasContainer');
    // console.log(hierarchicalBlockCanvas)
    let [scene1, camera1, renderer1, cube1] = this.setupCanvases(simpleBlockCanvas);
    // console.log(scene1, camera1, renderer1)
    let [scene2, camera2, renderer2, cube2] = this.setupCanvases(hierarchicalBlockCanvas);
    // console.log(scene2, camera2, renderer2)
    this.animate(scene1, camera1, renderer1, cube1);


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
    scene2.add(ground);

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
      scene2.add(side);

      // Left pair of helices centered in the left half of the panel
      const helixLeft1 = createRectangleWithBorder(helixWidth, helixHeight, colors.helix, colors.border);
      helixLeft1.position.set(sidePositions[i][0] + leftCenterX, sidePositions[i][1], 0.1);
      scene2.add(helixLeft1);

      const helixLeft2 = createRectangleWithBorder(helixWidth, helixHeight, colors.helix, colors.border);
      helixLeft2.position.set(sidePositions[i][0] + leftCenterX + helixWidth, sidePositions[i][1], 0.1);
      scene2.add(helixLeft2);

      // Right pair of helices centered in the right half of the panel
      const helixRight1 = createRectangleWithBorder(helixWidth, helixHeight, colors.helix, colors.border);
      helixRight1.position.set(sidePositions[i][0] + rightCenterX, sidePositions[i][1], 0.1);
      scene2.add(helixRight1);

      const helixRight2 = createRectangleWithBorder(helixWidth, helixHeight, colors.helix, colors.border);
      helixRight2.position.set(sidePositions[i][0] + rightCenterX + helixWidth, sidePositions[i][1], 0.1);
      scene2.add(helixRight2);

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

        scene2.add(bondMesh);
      });
    }

    // Camera position
    camera2.position.z = 200;

    this.animate(scene2, camera2, renderer2, cube2);

    // Handle resizing
    window.addEventListener('resize', () => {
      this.onWindowResize(renderer1, camera1, simpleBlockCanvas);
      this.onWindowResize(renderer2, camera2, hierarchicalBlockCanvas);
    });
  }

  setupCanvases(canvas) {
    const parentDiv = canvas.parentElement; // Get the parent div (the Bootstrap column)
    const width = parentDiv.clientWidth;
    const height = parentDiv.clientHeight;

    const scene = new THREE.Scene();
    scene.background = new THREE.Color(0xF1D3CE);

    const camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer();
    renderer.setSize(width, height);
    canvas.appendChild(renderer.domElement);
    camera.position.z = 100;

    // Create a cube with the specified color
    const geometry = new THREE.BoxGeometry(20, 20, 20);
    const material = new THREE.MeshBasicMaterial({
      color: 0x3A6D8C
    });
    const cube = new THREE.Mesh(geometry, material);
    scene.add(cube);

    return [scene, camera, renderer, cube];
  }

  animate(scene, camera, renderer, cube) {
    const animateLoop = () => {
      requestAnimationFrame(animateLoop);
      // Spin the cube
      cube.rotation.x += 0.001;
      cube.rotation.y += 0.001;

      renderer.render(scene, camera);
    };
    animateLoop(); // Start the loop
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

  setupCodeBlocks() {
    let simpleBlock = {
      "2x7M": {
        "building_blocks": null,
        "ignore_generation": false,
        "bonds_attractive": 4,
        "bonds_neutral": 4,
        "bonds_repulsive": 0,
        "bonds_z": 4,
        "min_xy_fe": 45,
        "max_xy_fe": 53,
        "min_z_fe": 90,
        "max_z_fe": 96,
        "bond_map": {
          "M1A": {
            "S1": "M5A",
            "S2": "M4A",
            "S3": "M2A",
            "ZU": "M1B"

          },
          "M2A": {
            "S1": "M4A",
            "S2": "M3A",
            "S6": "M1A",
            "ZU": "M2B"
          },
          "M3A": {
            "S1": "M7A",
            "S5": "M2A",
            "S6": "M4A",
            "ZU": "M3B"
          },
          "M4A": {
            "S1": "M6A",
            "S2": "M7A",
            "S3": "M3A",
            "S4": "M2A",
            "S5": "M1A",
            "S6": "M5A",
            "ZU": "M4B"
          },
          "M5A": {
            "S2": "M6A",
            "S3": "M4A",
            "S4": "M1A",
            "ZU": "M5B"
          },
          "M6A": {
            "S3": "M7A",
            "S4": "M4A",
            "S5": "M5A",
            "ZU": "M6B"
          },
          "M7A": {
            "S4": "M3A",
            "S5": "M4A",
            "S6": "M6A",
            "ZU": "M7B"
          },
          "M1B": {
            "S1": "M5B",
            "S2": "M4B",
            "S3": "M2B",
            "ZD": "M1A"

          },
          "M2B": {
            "S1": "M4B",
            "S2": "M3B",
            "S6": "M1B",
            "ZD": "M2A"
          },
          "M3B": {
            "S1": "M7B",
            "S5": "M2B",
            "S6": "M4B",
            "ZD": "M3A"
          },
          "M4B": {
            "S1": "M6B",
            "S2": "M7B",
            "S3": "M3B",
            "S4": "M2B",
            "S5": "M1B",
            "S6": "M5B",
            "ZD": "M4A"
          },
          "M5B": {
            "S2": "M6B",
            "S3": "M4B",
            "S4": "M1B",
            "ZD": "M5A"
          },
          "M6B": {
            "S3": "M7B",
            "S4": "M4B",
            "S5": "M5B",
            "ZD": "M6A"
          },
          "M7B": {
            "S4": "M3B",
            "S5": "M4B",
            "S6": "M6B",
            "ZD": "M7A"
          }
        }
      }
    }

    let hierarchicalBlock = {
      "2x2(2x7M)": {
        "building_blocks": [
          ["2x7M", 4]
        ],
        "ignore_generation": false,
        "bonds_attractive": 2,
        "bonds_neutral": 2,
        "bonds_repulsive": 0,
        "bonds_z": 1,
        "min_xy_fe": 0,
        "max_xy_fe": 100,
        "min_z_fe": 0,
        "max_z_fe": 100,
        "bond_map": {
          "2x7M#1-2x7M#2": {
            "M1B#1": {
              "ZU": "M1A#2"
            },
            "M2B#1": {
              "ZU": "M2A#2"
            },
            "M3B#1": {
              "ZU": "M3A#2"
            },
            "M4B#1": {
              "ZU": "M4A#2"
            },
            "M5B#1": {
              "ZU": "M5A#2"
            },
            "M6B#1": {
              "ZU": "M6A#2"
            },
            "M7B#1": {
              "ZU": "M7A#2"
            },
            "M1A#2": {
              "ZD": "M1B#1"
            },
            "M2A#2": {
              "ZD": "M2B#1"
            },
            "M3A#2": {
              "ZD": "M3B#1"
            },
            "M4A#2": {
              "ZD": "M4B#1"
            },
            "M5A#2": {
              "ZD": "M5B#1"
            },
            "M6A#2": {
              "ZD": "M6B#1"
            },
            "M7A#2": {
              "ZD": "M7B#1"
            }
          },
          "2x7M#3-2x7M#4": {
            "M1B#3": {
              "ZU": "M1A#4"
            },
            "M2B#3": {
              "ZU": "M2A#4"
            },
            "M3B#3": {
              "ZU": "M3A#4"
            },
            "M4B#3": {
              "ZU": "M4A#4"
            },
            "M5B#3": {
              "ZU": "M5A#4"
            },
            "M6B#3": {
              "ZU": "M6A#4"
            },
            "M7B#3": {
              "ZU": "M7A#4"
            },
            "M1A#4": {
              "ZD": "M1B#3"
            },
            "M2A#4": {
              "ZD": "M2B#3"
            },
            "M3A#4": {
              "ZD": "M3B#3"
            },
            "M4A#4": {
              "ZD": "M4B#3"
            },
            "M5A#4": {
              "ZD": "M5B#3"
            },
            "M6A#4": {
              "ZD": "M6B#3"
            },
            "M7A#4": {
              "ZD": "M7B#3"
            }
          },
          "2x7M#1-2x7M#3": {
            "M2A#1": {
              "S3": "M5A#3"
            },
            "M3A#1": {
              "S3": "M6A#3",
              "S4": "M5A#3"
            },
            "M2B#1": {
              "S3": "M5B#3"
            },
            "M3B#1": {
              "S3": "M6B#3",
              "S4": "M5B#3"
            },
            "M5A#3": {
              "S1": "M3A#1",
              "S6": "M2A#1"
            },
            "M6A#3": {
              "S6": "M3A#1"
            },
            "M5B#3": {
              "S1": "M3B#1",
              "S6": "M2B#1"
            },
            "M6B#3": {
              "S6": "M3B#1"
            }
          },
          "2x7M#2-2x7M#4": {
            "M2A#2": {
              "S3": "M5A#4"
            },
            "M3A#2": {
              "S3": "M6A#4",
              "S4": "M5A#4"
            },
            "M2B#2": {
              "S3": "M5B#4"
            },
            "M3B#2": {
              "S3": "M6B#4",
              "S4": "M5B#4"
            },
            "M5A#4": {
              "S1": "M3A#2",
              "S6": "M2A#2"
            },
            "M6A#4": {
              "S6": "M3A#2"
            },
            "M5B#4": {
              "S1": "M3B#2",
              "S6": "M2B#2"
            },
            "M6B#4": {
              "S6": "M3B#2"
            }
          }
        }
      },

      "2x7M": {
        "building_blocks": null,
        "ignore_generation": true,
        "bonds_attractive": 4,
        "bonds_neutral": 4,
        "bonds_repulsive": 0,
        "bonds_z": 4,
        "min_xy_fe": 44,
        "max_xy_fe": 53,
        "min_z_fe": 90,
        "max_z_fe": 96,
        "bond_map": {
          "M1A": {
            "S1": "M5A",
            "S2": "M4A",
            "S3": "M2A",
            "ZU": "M1B"

          },
          "M2A": {
            "S1": "M4A",
            "S2": "M3A",
            "S6": "M1A",
            "ZU": "M2B"
          },
          "M3A": {
            "S1": "M7A",
            "S5": "M2A",
            "S6": "M4A",
            "ZU": "M3B"
          },
          "M4A": {
            "S1": "M6A",
            "S2": "M7A",
            "S3": "M3A",
            "S4": "M2A",
            "S5": "M1A",
            "S6": "M5A",
            "ZU": "M4B"
          },
          "M5A": {
            "S2": "M6A",
            "S3": "M4A",
            "S4": "M1A",
            "ZU": "M5B"
          },
          "M6A": {
            "S3": "M7A",
            "S4": "M4A",
            "S5": "M5A",
            "ZU": "M6B"
          },
          "M7A": {
            "S4": "M3A",
            "S5": "M4A",
            "S6": "M6A",
            "ZU": "M7B"
          },
          "M1B": {
            "S1": "M5B",
            "S2": "M4B",
            "S3": "M2B",
            "ZD": "M1A"

          },
          "M2B": {
            "S1": "M4B",
            "S2": "M3B",
            "S6": "M1B",
            "ZD": "M2A"
          },
          "M3B": {
            "S1": "M7B",
            "S5": "M2B",
            "S6": "M4B",
            "ZD": "M3A"
          },
          "M4B": {
            "S1": "M6B",
            "S2": "M7B",
            "S3": "M3B",
            "S4": "M2B",
            "S5": "M1B",
            "S6": "M5B",
            "ZD": "M4A"
          },
          "M5B": {
            "S2": "M6B",
            "S3": "M4B",
            "S4": "M1B",
            "ZD": "M5A"
          },
          "M6B": {
            "S3": "M7B",
            "S4": "M4B",
            "S5": "M5B",
            "ZD": "M6A"
          },
          "M7B": {
            "S4": "M3B",
            "S5": "M4B",
            "S6": "M6B",
            "ZD": "M7A"
          }
        }
      }
    }


    // Stringify and pretty-print the JSON data
    simpleBlock = JSON.stringify(simpleBlock, null, 2);

    hierarchicalBlock = JSON.stringify(hierarchicalBlock, null, 2);

    // Set the pretty JSON to the container
    document.getElementById('preCodeSimple').textContent = simpleBlock;


    document.getElementById('preCodeHierarchical').textContent = hierarchicalBlock;

    // Initialize Highlight.js
    hljs.highlightAll({
      language: 'javascript'
    });

  }
}