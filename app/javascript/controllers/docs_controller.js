import { Controller } from "@hotwired/stimulus"
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
    const material = new THREE.MeshBasicMaterial({ color: 0x3A6D8C });
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
    animateLoop();  // Start the loop
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
    hljs.highlightAll({ language: 'javascript' });

  }
}
