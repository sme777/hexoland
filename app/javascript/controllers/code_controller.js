import {
  Controller
} from "@hotwired/stimulus"
import {
  JSONEditor
} from "vanilla-jsoneditor"
import * as THREE from "three";
import {
  OrbitControls
} from 'three/addons/controls/OrbitControls.js';
import {
  STLLoader
} from 'three/examples/jsm/loaders/STLLoader.js';

import {
  setupCanvas,
  onWindowResize,
  animate,
  setupInteractiveControls
} from './canvas_utils';
import {
  Hex
} from "../models/hex";
import {
  HexGroup
} from "../models/hexGroup";
export default class extends Controller {
  connect() {
    console.log("Code Controller Debugger:")

    const designMapField = document.getElementById("designMap");

    let content = {
      text: undefined,
      json: {
        "Z-4": {
          "building_blocks": null,
          "ignore_generation": false,
          "max_xy_overlap": 0.0,
          "xy_trials": 1,
          "max_z_overlap": 0.0,
          "z_trials": 5,
          "bond_families": {
            "standard": {
              "bonds_attractive": 0,
              "bonds_neutral": 0,
              "bonds_repulsive": 0,
              "bonds_z": 4,
              "min_xy_fe": 0,
              "max_xy_fe": 200,
              "min_z_fe": 86,
              "max_z_fe": 98
            }
          },
          "bond_map": {
            "M1": {
              "ZU": "M2"
            },
            "M2": {
              "ZD": "M1",
              "ZU": "M3"
            },
            "M3": {
              "ZD": "M2",
              "ZU": "M4"
            },
            "M4": {
              "ZD": "M3"
            }
          }
        }
      }
    };


    const editor = new JSONEditor({
      target: document.getElementById('jsoneditor'),
      props: {
        content,
        onChange: (updatedContent, previousContent, {
          contentErrors,
          patchResult
        }) => {
          // content is an object { json: JSONData } | { text: string }
          if (editor.get()["text"] !== undefined) {
            designMapField.value = editor.get()["text"];
          } else if ((editor.get()["json"] !== undefined)) {
            designMapField.value = JSON.stringify(editor.get()["json"]);
          }

          content = updatedContent
        }
      }
    });

    this.guiContainer = document.getElementById('guiContainer');

    let [scene, camera, renderer, controls] = setupCanvas(this.guiContainer);
    // console.log(assemblyMap)
    this.scene = scene;
    this.camera = camera;
    this.renderer = renderer;
    const assemblyMap = {};
    const bondMap = {};

    // Make The Variables Globacl
    this.scene = scene;
    this.camera = camera;
    this.renderer = renderer;
    this.controls = controls;

    const hexBlockGroup = new THREE.Group();


    const boundingBox = new THREE.Box3().setFromObject(hexBlockGroup);

    const center = new THREE.Vector3();
    boundingBox.getCenter(center);

    hexBlockGroup.position.sub(center);
    scene.add(hexBlockGroup);
    // Lighting
    const ambientLight = new THREE.AmbientLight(0xffffff, 2.0);
    scene.add(ambientLight);
    const directionalLight = new THREE.DirectionalLight(0xffffff, 1.0);
    directionalLight.position.set(10, 10, 10);
    scene.add(directionalLight);

    camera.position.z = 200;

    this.activeControl = "SELECT";

    animate(scene, camera, renderer);
    window.addEventListener('resize', () => {
      onWindowResize(renderer, camera, guiContainer);
    });

    const uploadFile = async (file, type) => {
      const formData = new FormData();
      formData.append('file', file);
      formData.append('fileType', type);
      try {
        const response = await fetch('/studio/loader', {
          method: 'POST',
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'), // Include CSRF token
          },
          body: formData,
        });

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        // update the EDITOR

        editor.update({
          json: data
        });
      } catch (error) {
        console.error('Error uploading file:', error);
      }
    };


    // Improved voxelization with better interior filling
    const voxelizeSTL = async (file, resolution) => {
      // Show loading indicator if available
      const loadingElement = document.getElementById('loadingIndicator');
      if (loadingElement) loadingElement.style.display = 'block';

      // Start timing for performance measurement
      const startTime = performance.now();

      try {
        const loader = new STLLoader();

        // Read the file using FileReader
        const arrayBuffer = await new Promise((resolve, reject) => {
          const reader = new FileReader();
          reader.onload = () => resolve(reader.result);
          reader.onerror = () => reject(reader.error);
          reader.readAsArrayBuffer(file);
        });

        const stlGeometry = loader.parse(arrayBuffer);
        const stlMesh = new THREE.Mesh(stlGeometry, new THREE.MeshBasicMaterial({
          visible: false
        }));

        // Add to scene temporarily for raycasting
        scene.add(stlMesh);

        // Compute bounding box of the STL geometry
        stlGeometry.computeBoundingBox();
        stlGeometry.computeVertexNormals();
        const bbox = stlGeometry.boundingBox;

        // Calculate dimensions based on resolution
        const width = 24.0 / resolution;
        const horiz = (3.0 / 2.0) * 1.5 * width;
        const vert = Math.sqrt(3) * 1.5 * width;
        const depth = width * 2;

        const horiz3_4 = horiz * 3 / 4.0;
        const horiz3_8 = horiz * 3 / 8.0;
        const vert_div_sqrt3 = vert / Math.sqrt(3);
        const depth_delta = 5.0 / resolution;

        console.log("Voxelization parameters:", {
          resolution,
          width,
          horiz,
          vert,
          depth,
          horiz3_4,
          depth_delta
        });

        // NEW: Create separate collections for surface and interior voxels
        const surfaceVoxels = {};
        const interiorVoxels = {};

        // NEW: Function to get a grid key for a position (for duplicate prevention)
        const getVoxelKey = (x, y, z) => {
          const precision = 10 * resolution; // Scale precision with resolution
          return `${Math.round(x * precision)},${Math.round(y * precision)},${Math.round(z * precision)}`;
        };

        // STEP 1: First pass to identify surface voxels using raycasting
        console.log("Step 1: Identifying surface voxels...");

        // Setup raycaster
        const raycaster = new THREE.Raycaster();
        const directions = [
          new THREE.Vector3(0, -1, 0), // Down
          new THREE.Vector3(0, 1, 0), // Up
          new THREE.Vector3(1, 0, 0), // Right
          new THREE.Vector3(-1, 0, 0), // Left
          new THREE.Vector3(0, 0, 1), // Forward
          new THREE.Vector3(0, 0, -1), // Back

          // Add diagonal rays for better surface detection
          new THREE.Vector3(1, 1, 0).normalize(),
          new THREE.Vector3(-1, 1, 0).normalize(),
          new THREE.Vector3(1, -1, 0).normalize(),
          new THREE.Vector3(-1, -1, 0).normalize()
        ];

        // Add margin to ensure coverage of the entire model
        const margin = horiz * 2;

        // Surface voxel detection
        let surfaceCount = 0;

        for (let x = bbox.min.x - margin; x <= bbox.max.x + margin; x += horiz3_4) {
          for (let z = bbox.min.z - margin; z <= bbox.max.z + margin; z += vert_div_sqrt3) {
            const offsetX = Math.floor((z - bbox.min.z) / vert_div_sqrt3) % 2 === 0 ? 0 : horiz3_8;
            const newX = x + offsetX;

            // Smaller depth steps for better vertical resolution
            const depthStep = (depth + depth_delta) / Math.max(1, resolution / 2);

            for (let y = bbox.min.y - margin; y <= bbox.max.y + margin; y += depthStep) {
              const voxelKey = getVoxelKey(newX, y, z);

              // Skip if already processed
              if (surfaceVoxels[voxelKey] || interiorVoxels[voxelKey]) continue;

              // Check for surface voxel by raycasting
              const hexCenter = new THREE.Vector3(newX, y + depth / 2, z);
              let isSurfaceVoxel = false;

              for (const direction of directions) {
                raycaster.set(hexCenter, direction);
                const intersections = raycaster.intersectObject(stlMesh);

                // If we have a close intersection, it's a surface voxel
                if (intersections.length > 0 && intersections[0].distance < horiz * 0.7) {
                  isSurfaceVoxel = true;
                  break;
                }
              }

              if (isSurfaceVoxel) {
                surfaceVoxels[voxelKey] = {
                  x: newX,
                  y,
                  z
                };
                surfaceCount++;
              }
            }
          }
        }

        console.log(`Found ${surfaceCount} surface voxels`);

        // STEP 2: Identify interior voxels using more accurate inside/outside testing
        console.log("Step 2: Identifying interior voxels...");

        // Create a 3D grid for voxel positions
        // This is critical for the interior filling algorithm
        const gridResolution = Math.max(
          Math.ceil((bbox.max.x - bbox.min.x + 2 * margin) / horiz3_4),
          Math.ceil((bbox.max.y - bbox.min.y + 2 * margin) / depth),
          Math.ceil((bbox.max.z - bbox.min.z + 2 * margin) / vert_div_sqrt3)
        );

        console.log(`Grid resolution: ${gridResolution}x${gridResolution}x${gridResolution}`);

        // Create a 3D grid to track voxel types
        // 0 = not processed, 1 = surface, 2 = interior, 3 = exterior
        const grid = new Array(gridResolution + 2).fill().map(() =>
          new Array(gridResolution + 2).fill().map(() =>
            new Array(gridResolution + 2).fill(0)
          )
        );

        // Helper function to convert world position to grid indices
        const worldToGrid = (x, y, z) => {
          const i = Math.floor((x - (bbox.min.x - margin)) / horiz3_4) + 1;
          const j = Math.floor((y - (bbox.min.y - margin)) / depth) + 1;
          const k = Math.floor((z - (bbox.min.z - margin)) / vert_div_sqrt3) + 1;
          return [
            Math.max(0, Math.min(gridResolution + 1, i)),
            Math.max(0, Math.min(gridResolution + 1, j)),
            Math.max(0, Math.min(gridResolution + 1, k))
          ];
        };

        // Helper function to convert grid indices to world position
        const gridToWorld = (i, j, k) => {
          const x = (bbox.min.x - margin) + (i - 1) * horiz3_4;
          const y = (bbox.min.y - margin) + (j - 1) * depth;
          const z = (bbox.min.z - margin) + (k - 1) * vert_div_sqrt3;

          // Apply hex grid offset
          const offsetX = (k - 1) % 2 === 0 ? 0 : horiz3_8;

          return [x + offsetX, y, z];
        };

        // Mark surface voxels in the grid
        Object.values(surfaceVoxels).forEach(voxel => {
          const [i, j, k] = worldToGrid(voxel.x, voxel.y, voxel.z);
          grid[i][j][k] = 1; // 1 = surface
        });

        // IMPROVED ALGORITHM: Fill interior space using flood fill from the outside

        // Step 2a: Mark the outer boundary as exterior
        const queue = [];

        // Start from the grid boundary
        for (let i = 0; i <= gridResolution + 1; i++) {
          for (let j = 0; j <= gridResolution + 1; j++) {
            for (let k = 0; k <= gridResolution + 1; k++) {
              if (i === 0 || i === gridResolution + 1 ||
                j === 0 || j === gridResolution + 1 ||
                k === 0 || k === gridResolution + 1) {
                if (grid[i][j][k] === 0) { // If not already a surface voxel
                  grid[i][j][k] = 3; // 3 = exterior
                  queue.push([i, j, k]);
                }
              }
            }
          }
        }

        // Step 2b: Flood fill from the outside to mark all exterior space
        console.log("Performing flood fill to identify exterior space...");

        // Adjacent cell offsets for 6-connectivity
        const neighbors = [
          [1, 0, 0],
          [-1, 0, 0],
          [0, 1, 0],
          [0, -1, 0],
          [0, 0, 1],
          [0, 0, -1]
        ];

        while (queue.length > 0) {
          const [i, j, k] = queue.shift();

          // Check all 6 adjacent cells
          for (const [di, dj, dk] of neighbors) {
            const ni = i + di;
            const nj = j + dj;
            const nk = k + dk;

            // Skip if out of bounds
            if (ni < 0 || ni > gridResolution + 1 ||
              nj < 0 || nj > gridResolution + 1 ||
              nk < 0 || nk > gridResolution + 1) {
              continue;
            }

            // If not visited and not a surface voxel
            if (grid[ni][nj][nk] === 0) {
              grid[ni][nj][nk] = 3; // Mark as exterior
              queue.push([ni, nj, nk]);
            }
          }
        }

        // Step 2c: Identify interior voxels (cells not marked as surface or exterior)
        console.log("Identifying interior voxels...");
        let interiorCount = 0;

        for (let i = 1; i <= gridResolution; i++) {
          for (let j = 1; j <= gridResolution; j++) {
            for (let k = 1; k <= gridResolution; k++) {
              if (grid[i][j][k] === 0) { // Not processed = interior
                // Convert grid position to world coordinates
                const [x, y, z] = gridToWorld(i, j, k);
                const voxelKey = getVoxelKey(x, y, z);

                // Verify this is truly inside the mesh with raycasting
                const hexCenter = new THREE.Vector3(x, y + depth / 2, z);

                // Cast rays in 3 primary directions and count intersections
                let insideCount = 0;
                const testDirs = [
                  new THREE.Vector3(1, 0, 0),
                  new THREE.Vector3(0, 1, 0),
                  new THREE.Vector3(0, 0, 1)
                ];

                for (const dir of testDirs) {
                  raycaster.set(hexCenter, dir);
                  const intersections = raycaster.intersectObject(stlMesh);

                  // Using even-odd rule: odd number of intersections means inside
                  if (intersections.length % 2 === 1) {
                    insideCount++;
                  }
                }

                // If majority of rays indicate inside, consider it an interior voxel
                if (insideCount >= 2) {
                  interiorVoxels[voxelKey] = {
                    x,
                    y,
                    z
                  };
                  interiorCount++;

                  // Mark as interior in the grid
                  grid[i][j][k] = 2; // 2 = interior
                } else {
                  // If not truly inside, mark as exterior
                  grid[i][j][k] = 3;
                }
              }
            }
          }
        }

        console.log(`Found ${interiorCount} interior voxels`);

        // STEP 3: Fix gaps between layers for better connectivity
        console.log("Step 3: Filling gaps for better connectivity...");
        const extraVoxels = {};
        let extraCount = 0;

        // Examine the grid for disconnected regions
        for (let i = 1; i <= gridResolution; i++) {
          for (let j = 1; j <= gridResolution; j++) {
            for (let k = 1; k <= gridResolution; k++) {
              // Only look at empty spaces
              if (grid[i][j][k] === 3) { // Exterior voxel
                // Count the number of interior or surface neighbors
                let solidNeighbors = 0;

                for (const [di, dj, dk] of neighbors) {
                  const ni = i + di;
                  const nj = j + dj;
                  const nk = k + dk;

                  if (ni >= 0 && ni <= gridResolution + 1 &&
                    nj >= 0 && nj <= gridResolution + 1 &&
                    nk >= 0 && nk <= gridResolution + 1) {
                    if (grid[ni][nj][nk] === 1 || grid[ni][nj][nk] === 2) {
                      solidNeighbors++;
                    }
                  }
                }

                // If surrounded by enough solid voxels, fill the gap
                if (solidNeighbors >= 4) { // Threshold can be adjusted
                  const [x, y, z] = gridToWorld(i, j, k);
                  const voxelKey = getVoxelKey(x, y, z);

                  if (!surfaceVoxels[voxelKey] && !interiorVoxels[voxelKey] && !extraVoxels[voxelKey]) {
                    extraVoxels[voxelKey] = {
                      x,
                      y,
                      z
                    };
                    extraCount++;

                    // Mark in the grid
                    grid[i][j][k] = 2; // Mark as interior
                  }
                }
              }
            }
          }
        }

        console.log(`Added ${extraCount} voxels to fill gaps`);

        // STEP 4: Combine all voxels and create the final model
        console.log("Step 4: Creating final voxel model...");
        let hexCount = 0;
        let hexPositions = [];

        // Add surface voxels
        Object.values(surfaceVoxels).forEach(voxel => {
          hexCount++;
          hexPositions.push([`hex#${hexCount}`, [voxel.x, voxel.y, voxel.z]]);
        });

        // Add interior voxels
        Object.values(interiorVoxels).forEach(voxel => {
          hexCount++;
          hexPositions.push([`hex#${hexCount}`, [voxel.x, voxel.y, voxel.z]]);
        });

        // Add gap-filling voxels
        Object.values(extraVoxels).forEach(voxel => {
          hexCount++;
          hexPositions.push([`hex#${hexCount}`, [voxel.x, voxel.y, voxel.z]]);
        });

        console.log(`Creating voxel group with ${hexCount} total voxels...`);

        // Clean up temporary geometry
        scene.remove(stlMesh);

        // Create voxel group using existing HexGroup class
        const voxelGroup = (new HexGroup(hexCount, hexPositions, depth, true)).getObject();

        // Center the model
        const box = new THREE.Box3().setFromObject(voxelGroup);
        const center = new THREE.Vector3();
        box.getCenter(center);
        voxelGroup.position.sub(center);
        voxelGroup.position.set(-center.x, -center.y, -center.z);
        scene.add(voxelGroup);

        // Add the original STL model with transparency
        const originalMaterial = new THREE.MeshStandardMaterial({
          color: 0xA6CDC6,
          transparent: true,
          opacity: 0.4
        });
        const originalMesh = new THREE.Mesh(stlGeometry, originalMaterial);
        originalMesh.position.sub(center);
        originalMesh.position.set(-center.x, -center.y, -center.z);
        scene.add(originalMesh);

        // Update UI with voxel count
        document.getElementById("voxelCount").textContent = hexCount;

        // Calculate and display processing time
        const endTime = performance.now();
        const processingTime = ((endTime - startTime) / 1000).toFixed(2);
        const timeElement = document.getElementById('processingTime');
        if (timeElement) timeElement.textContent = `${processingTime}s`;

      } catch (error) {
        console.error("Error voxelizing STL:", error);
        alert("Error processing file. See console for details.");
      } finally {
        // Hide loading indicator
        if (loadingElement) loadingElement.style.display = 'none';
      }
    };

    /**
     * Voxelize an OBJ file
     * @param {File} file - The OBJ file to voxelize
     * @param {number} resolution - Resolution factor 
     */
    const voxelizeOBJ = async (file, resolution) => {
      // Display loading indicator if available
      const loadingElement = document.getElementById('loadingIndicator');
      if (loadingElement) loadingElement.style.display = 'block';

      try {
        const loader = new THREE.OBJLoader();

        // Read the file as text
        const text = await new Promise((resolve, reject) => {
          const reader = new FileReader();
          reader.onload = () => resolve(reader.result);
          reader.onerror = () => reject(reader.error);
          reader.readAsText(file);
        });

        // Parse the OBJ
        const objModel = loader.parse(text);

        // Extract geometry from the loaded object
        let objGeometry = null;

        objModel.traverse(function (child) {
          if (child instanceof THREE.Mesh) {
            // If multiple geometries, merge them
            if (objGeometry === null) {
              objGeometry = child.geometry.clone();
            } else {
              const tempGeometry = child.geometry.clone();
              // Use BufferGeometryUtils to merge geometries if available
              if (THREE.BufferGeometryUtils) {
                objGeometry = THREE.BufferGeometryUtils.mergeBufferGeometries([objGeometry, tempGeometry]);
              } else {
                console.warn("BufferGeometryUtils not available, using first geometry only");
              }
            }
          }
        });

        if (!objGeometry) {
          throw new Error("No valid geometry found in OBJ file");
        }

        // Create a temporary mesh for raycasting
        const tempMesh = new THREE.Mesh(objGeometry, new THREE.MeshBasicMaterial({
          visible: false
        }));

        // Now use the same voxelization approach as for STL
        // The rest would be identical to the voxelizeSTL function
        // For brevity, this could call a shared implementation

        alert("OBJ support is under development. Please use STL files for now.");

      } catch (error) {
        console.error("Error voxelizing OBJ:", error);
        alert("Error processing the OBJ file. See console for details.");
      } finally {
        // Hide loading indicator
        if (loadingElement) loadingElement.style.display = 'none';
      }
    };

    // const voxelizeSTL = async (file, resolution) => {
    //   const loader = new STLLoader();

    //   // Read the file using FileReader
    //   const arrayBuffer = await new Promise((resolve, reject) => {
    //     const reader = new FileReader();
    //     reader.onload = () => resolve(reader.result);
    //     reader.onerror = () => reject(reader.error);
    //     reader.readAsArrayBuffer(file);
    //   });

    //   const stlGeometry = loader.parse(arrayBuffer);
    //   const stlMesh = new THREE.Mesh(stlGeometry, new THREE.MeshBasicMaterial({
    //     visible: false
    //   }));

    //   // Compute bounding box of the STL geometry
    //   stlGeometry.computeBoundingBox();
    //   stlGeometry.computeVertexNormals();
    //   const bbox = stlGeometry.boundingBox;

    //   // Higher Resolution Means Lower Width
    //   // Resolution 1 = 24nm; Resolution 2 = 12nm; ...
    //   const width = 24.0 / resolution;
    //   const horiz = (3.0 / 2.0) * 1.5 * width;
    //   const vert = Math.sqrt(3) * 1.5 * width;
    //   const depth = width * 2;

    //   const horiz3_4 = horiz * 3 / 4.0;
    //   const horiz3_8 = horiz * 3 / 8.0;
    //   const vert_div_sqrt3 = vert / Math.sqrt(3);
    //   const depth_delta = 5.0 / resolution;

    //   let counter = 0;

    //   const raycaster = new THREE.Raycaster();
    //   const directions = [
    //     new THREE.Vector3(0, -1, 0), // Downward ray
    //     new THREE.Vector3(0, 1, 0), // Upward ray
    //     new THREE.Vector3(1, 0, 0), // Horizontal rays
    //     new THREE.Vector3(-1, 0, 0),
    //     new THREE.Vector3(0, 0, 1),
    //     new THREE.Vector3(0, 0, -1),
    //   ];

    //   let hexCount = 0;
    //   let hexPositions = new Array();

    //   for (let x = bbox.min.x; x <= bbox.max.x; x += horiz3_4) {
    //     for (let z = bbox.min.z; z <= bbox.max.z; z += vert_div_sqrt3) {
    //       for (let y = bbox.min.y; y <= bbox.max.y; y += depth + depth_delta) {
    //         const offsetX = Math.floor((z - bbox.min.z) / vert_div_sqrt3) % 2 === 0 ? 0 : horiz3_8;
    //         const newX = x + offsetX;

    //         const newHex = (new Hex(`hex#${hexCount}`, new THREE.Vector3(newX, y, z), {}, depth, true)).getObject();
    //         const hexCenter = new THREE.Vector3(newX, y + depth / 2, z);
    //         let intersects = false;

    //         for (const direction of directions) {
    //           raycaster.set(hexCenter, direction.normalize());
    //           const intersection = raycaster.intersectObject(stlMesh);
    //           if (intersection.length > 0) {
    //             intersects = true;
    //             break;
    //           }
    //         }

    //         if (intersects) {
    //           hexCount += 1;
    //           hexPositions.push([`hex#${hexCount}`, new Array(newX, y, z)])
    //         }
    //       }
    //     }
    //   }

    //   const voxelGroup = (new HexGroup(hexCount, hexPositions, depth, true)).getObject();

    //   const box = new THREE.Box3().setFromObject(voxelGroup);
    //   const center = new THREE.Vector3();
    //   box.getCenter(center);
    //   voxelGroup.position.sub(center);
    //   voxelGroup.position.set(-center.x, -center.y, -center.z);
    //   this.scene.add(voxelGroup);

    //   document.getElementById("voxelCount").textContent = hexCount;


    //   // Add the original STL model on top of the voxelized version
    //   const originalMaterial = new THREE.MeshStandardMaterial({
    //     color: 0xA6CDC6
    //   });
    //   const originalMesh = new THREE.Mesh(stlGeometry, originalMaterial);
    //   originalMesh.position.sub(center);      
    //   originalMesh.position.set(-center.x, -center.y, -center.z);
    //   scene.add(originalMesh);
    // };


    // Upload Sequence File (Inverse Design)
    document.getElementById('sequenceLoader').addEventListener('change', (event) => {
      const file = event.target.files[0];
      if (file) {
        uploadFile(file, "csv");
      }
    });

    // Upload JSON HexLand file
    document.getElementById('hexlandLoader').addEventListener('change', (event) => {
      const file = event.target.files[0];
      if (file) {
        uploadFile(file, "json");
      }
    });
    // setupGUI

    document.getElementById('stlobjLoader').addEventListener('change', (event) => {
      const file = event.target.files[0];
      const resolution = 4.0;
      const filename = file["name"];

      if (filename.endsWith(".stl")) {
        voxelizeSTL(file, resolution);
      } else if (filename.endsWith(".stl")) {
        voxelizeOBJ(file, resolution);
      } else {
        alert("Unknown File Type. Please Re-Upload!")
      }
    });

    // Get references to the DOM elements
    const rangeInput = document.getElementById('voxelResolution');
    const rangeLabel = document.getElementById('rangeLabel');
    const progressBar = document.getElementById('progressBar');

    // Update the label and progress bar dynamically
    rangeInput.addEventListener('input', function () {
      const value = rangeInput.value; // Get current range value
      rangeLabel.textContent = value; // Update the label
      progressBar.style.width = `${value}%`; // Update progress bar width
      progressBar.setAttribute('aria-valuenow', value); // Update accessibility value
    });


    setupInteractiveControls(this.activeControl, this.guiContainer, this.scene);
  }





}