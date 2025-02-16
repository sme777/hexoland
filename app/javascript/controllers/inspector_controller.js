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
import {
  JSONEditor
} from "vanilla-jsoneditor"
import {
  setupCanvas,
  onWindowResize,
  setupInteractiveControls
  // animate
} from './canvas_utils';
import * as bootstrap from "bootstrap";

export default class extends Controller {

  connect() {

    const jsonData = JSON.parse(document.getElementById(`assembly_design_code`).value);
    let content = {
      text: undefined,
      json: jsonData
    }
    const designMapField = document.getElementById("designMap");
    // let content = 
    const editor = new JSONEditor({
      target: document.getElementById(`assembly_editor`),
      props: {
        content,
        onChange: (updatedContent, previousContent, { contentErrors, patchResult }) => {
          // content is an object { json: JSONData } | { text: string }
          if (editor.get()["text"] !== undefined) {
            designMapField.value = editor.get()["text"];
          } else if ((editor.get()["json"] !== undefined)) {
            designMapField.value = JSON.stringify(editor.get()["json"]);
          }
          
          content = updatedContent
        }
      }
    })
    this.container = document.getElementById('guiContainer');

    let [scene, camera, renderer, controls] = setupCanvas(this.container);

    // set up raycasting
    this.raycaster = new THREE.Raycaster();
    this.mouse = new THREE.Vector2();
    this.camera = camera;
    this.scene = scene;
    this.renderer = renderer;

    this.titleElement = document.createElement('div');
    this.titleElement.style.position = 'absolute';
    this.titleElement.style.padding = '5px 10px';
    this.titleElement.style.background = 'rgba(0, 0, 0, 0.7)';
    this.titleElement.style.color = 'white';
    this.titleElement.style.borderRadius = '5px';
    this.titleElement.style.display = 'none';
    document.body.appendChild(this.titleElement);


    const assemblyMap = JSON.parse(document.getElementById('assembly_code').value);
    const hexBondData = JSON.parse(document.getElementById('bond_map').value);
    // console.log(hexBondData)
    this.hexBlocks = []
    assemblyMap.forEach((block) => {
      // const hexGroup = new THREE.Group();
      block.forEach((monomer) => {
        this.hexBlocks.push((new Hex(monomer.monomer, new THREE.Vector3(monomer.position.x, monomer.position.y, monomer.position.z), hexBondData[monomer.monomer], 48.0)));
        // console.log(hexBondData[monomer.monomer]);
      })
      // this.hexBlocks.push(hexGroup);
    })

    const hexBlockGroup = new THREE.Group()
    this.hexBlocks.forEach(hex => hexBlockGroup.add(hex.getObject()));

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

    camera.position.z = 150;

    this.animate();

    window.addEventListener('resize', () => {
      onWindowResize(renderer, camera, this.container);
    });

    window.addEventListener('mousemove', (event) => {
      const rect = this.container.getBoundingClientRect();
      // Convert mouse position to normalized device coordinates
      this.mouse.x = ((event.clientX - rect.left) / rect.width) * 2 - 1;
      this.mouse.y = -((event.clientY - rect.top) / rect.height) * 2 + 1;

      // Update the title position
      this.titleElement.style.left = `${event.clientX + 10}px`;
      this.titleElement.style.top = `${event.clientY + 10}px`;
    });

    // form submission
    this.activeControl = "SELECT";
    setupInteractiveControls(this.activeControl, this.container, this.scene);


    const captureBtn = document.getElementById('captureSelectedBtn');
    captureBtn.addEventListener('click', () => this.handleCapture());


  }

  async handleCapture() {
    const modal = document.getElementById('cameraControlsModal');
    const bsModal = bootstrap.Modal.getInstance(modal);
    
    try {
      // Show loading state
      this.updateCaptureStatus('Preparing capture...', 'info');
      
      // Get selected sides based on UI state
      const selectedSides = this.getSelectedSides();
      
      // Capture screenshots for all selected hexagons
      const results = await this.captureHexagons(selectedSides);
      
      // Hide modal
      bsModal.hide();
      
      // Process results (e.g., download or display)
      this.processResults(results);
      
    } catch (error) {
      console.error('Capture error:', error);
      this.updateCaptureStatus('Error capturing screenshots', 'danger');
    }
  }

  getSelectedSides() {
    // Check if we're in "All" or "Custom" mode
    const isAllMode = document.getElementById('all-tab').classList.contains('active');
    
    if (isAllMode) {
      // Return all sides if in "All" mode
      return {
        lateral: [0, 1, 2, 3, 4, 5],
        top: true,
        bottom: true
      };
    }
    
    // Get global side settings if custom mode
    return {
      lateral: Array.from({ length: 6 }, (_, i) => {
        return document.getElementById(`side${i + 1}`).checked ? i : null;
      }).filter(side => side !== null),
      top: document.getElementById('topView').checked,
      bottom: document.getElementById('bottomView').checked
    };
  }


  async captureHexagons(selectedSides) {
    const results = [];
    const totalCaptures = this.hexBlocks.length;
    
    // Create a renderer for screenshots
    const renderer = new THREE.WebGLRenderer({
      antialias: true,
      alpha: true,
      preserveDrawingBuffer: true
    });
    renderer.setSize(1024, 1024); // High resolution captures
    
    // Create camera for screenshots
    const camera = new THREE.PerspectiveCamera(50, 1, 0.1, 1000);
    
    // Create separate scene for captures
    const captureScene = new THREE.Scene();
    captureScene.background = new THREE.Color(0xffffff);
    
    // Add lighting
    const ambientLight = new THREE.AmbientLight(0xffffff, 1.6);
    
    // Main directional light (frontal)
    const mainLight = new THREE.DirectionalLight(0xffffff, 2.0);
    
    // Fill light from the opposite side
    const fillLight = new THREE.DirectionalLight(0xffffff, 1.2);
    
    // Top light for better surface definition
    const topLight = new THREE.DirectionalLight(0xffffff, 1.5);
    topLight.position.set(0, 1, 0);
    
    captureScene.add(ambientLight, mainLight, fillLight, topLight);
    
    for (let i = 0; i < this.hexBlocks.length; i++) {
      const hexagon = this.hexBlocks[i];
      const hexagonScreenshots = [];
      
      // Update progress
      this.updateCaptureStatus(
        `Capturing hexagon ${i + 1} of ${totalCaptures}...`, 
        'info'
      );
      
      // Clone hexagon for capture
      console.log(hexagon);
      const hexClone = hexagon.getObject().clone();
      captureScene.add(hexClone);
      
      // Get bounding box for camera positioning
      const boundingBox = new THREE.Box3().setFromObject(hexClone);
      const center = boundingBox.getCenter(new THREE.Vector3());
      const size = boundingBox.getSize(new THREE.Vector3());
      
      // Calculate camera distance
      const maxDim = Math.max(size.x, size.y, size.z);
      const fov = camera.fov * (Math.PI / 180);
      const cameraDistance = Math.abs(maxDim / Math.sin(fov / 2) / 2);
      
      // Capture lateral sides
      for (const sideIndex of selectedSides.lateral) {
        const angle = (sideIndex * 60) * (Math.PI / 180);
        
        // Position camera for lateral view
        camera.position.x = center.x + cameraDistance * Math.cos(angle);
        camera.position.y = center.y;
        camera.position.z = center.z + cameraDistance * Math.sin(angle);
        camera.lookAt(center);
        
        // Update main and fill light positions
        mainLight.position.copy(camera.position);
        
        // Position fill light opposite to main light
        fillLight.position.set(
            -camera.position.x,
            camera.position.y,
            -camera.position.z
        );
        
        // Render and capture
        renderer.render(captureScene, camera);
        const screenshot = renderer.domElement.toDataURL('image/png');
        
        hexagonScreenshots.push({
          type: 'lateral',
          side: sideIndex + 1,
          angle: sideIndex * 60,
          dataURL: screenshot
        });
      }
      
      // Capture top view if selected
      if (selectedSides.top) {
        camera.position.set(center.x, center.y + cameraDistance, center.z);
        camera.lookAt(center);
        mainLight.position.copy(camera.position);
        fillLight.position.set(center.x, center.y - cameraDistance, center.z);
        
        renderer.render(captureScene, camera);
        hexagonScreenshots.push({
          type: 'top',
          dataURL: renderer.domElement.toDataURL('image/png')
        });
      }
      
      // Capture bottom view if selected
      if (selectedSides.bottom) {
        camera.position.set(center.x, center.y - cameraDistance, center.z);
        camera.lookAt(center);
        mainLight.position.copy(camera.position);
        fillLight.position.set(center.x, center.y + cameraDistance, center.z);
        
        renderer.render(captureScene, camera);
        hexagonScreenshots.push({
          type: 'bottom',
          dataURL: renderer.domElement.toDataURL('image/png')
        });
      }
      
      // Clean up
      captureScene.remove(hexClone);
      
      // Add to results
      results.push({
        hexagonId: hexagon.title,
        screenshots: hexagonScreenshots
      });
    }
    
    // Final cleanup
    renderer.dispose();
    
    return results;
  }

  updateCaptureStatus(message, type = 'info') {
    const statusEl = document.createElement('div');
    statusEl.className = `alert alert-${type} position-fixed bottom-0 end-0 m-3`;
    statusEl.textContent = message;
    document.body.appendChild(statusEl);
    
    setTimeout(() => statusEl.remove(), 3000);
  }

  processResults(results) {
    // Create a container for all screenshots
    const captureContainer = document.getElementById('captureContainer');
    if (!captureContainer) {
      console.error('Capture container not found');
      return;
    }

    // Clear existing content
    captureContainer.innerHTML = '';
    
    // Create a container for all screenshots
    const resultsContainer = document.createElement('div');
    
    results.forEach(hexResult => {
      const hexDiv = document.createElement('div');
      hexDiv.className = 'card mb-4';
      
      hexDiv.innerHTML = `
        <div class="card-header">
          <h5 class="card-title mb-0">${hexResult.hexagonId}</h5>
        </div>
        <div class="card-body">
          <div class="row row-cols-2 row-cols-md-4 g-3 screenshots-grid">
            ${hexResult.screenshots.map(screenshot => `
              <div class="col">
                <div class="card h-100">
                  <img src="${screenshot.dataURL}" class="card-img-top" alt="Screenshot">
                  <div class="card-footer text-muted small">
                    ${screenshot.type === 'lateral' 
                      ? `Side ${screenshot.side} (${screenshot.angle}°)` 
                      : `${screenshot.type} view`}
                  </div>
                </div>
              </div>
            `).join('')}
          </div>
        </div>
        <div class="card-footer">
          <button class="btn btn-primary btn-sm download-all">
            <i class="bi bi-download me-2"></i>Download All
          </button>
        </div>
      `;
      
      // Add download handler
      hexDiv.querySelector('.download-all').addEventListener('click', () => {
        hexResult.screenshots.forEach(screenshot => {
          const link = document.createElement('a');
          link.download = `${hexResult.hexagonId}_${screenshot.type}${
            screenshot.type === 'lateral' ? `_side${screenshot.side}` : ''
          }.png`;
          link.href = screenshot.dataURL;
          link.click();
        });
      });
      
      resultsContainer.appendChild(hexDiv);
    });
    
    // Append results to the specified container
    captureContainer.appendChild(resultsContainer);
  }


  onHover() {
    // Cast a ray from the camera to the mouse position
    this.raycaster.setFromCamera(this.mouse, this.camera);

    let hoverHex = null;
    let hexTitle = null;
    this.hexBlocks.forEach((hex) => {
      const instancedMesh = hex.getCoreHex();
      const intersects = this.raycaster.intersectObject(instancedMesh, true);

      if (intersects.length > 0) {
        hoverHex = instancedMesh
        hexTitle = hex.title;
      }
    });

    if (hoverHex) {
      this.highlightAllInstances(hoverHex);
      this.titleElement.style.display = 'block';
      this.titleElement.textContent = `${hexTitle}`;

    }

    this.hexBlocks.forEach((hex) => {
      const instancedMesh = hex.getCoreHex();

      if (instancedMesh != hoverHex) {
        this.resetAllInstances(instancedMesh);
      }
    });

  }

  resetAllInstances(instancedMesh) {
    const count = instancedMesh.count;
    const defaultColor = new THREE.Color(0xF5F7F8); // Default color (green)

    // Reset all instance colors
    for (let i = 0; i < count; i++) {
        instancedMesh.instanceColor.setXYZ(i, defaultColor.r, defaultColor.g, defaultColor.b);
    }

    instancedMesh.instanceColor.needsUpdate = true;

    // Remove emissive glow
    instancedMesh.material.emissive = new THREE.Color(0x000000); // No emissive color
    instancedMesh.material.emissiveIntensity = 0;
    instancedMesh.material.needsUpdate = true;
  }

  highlightAllInstances(instancedMesh) {
    // Ensure the material supports emissive property
    instancedMesh.material.emissive = new THREE.Color(0xF6F7C4); // Emissive highlight color
    instancedMesh.material.emissiveIntensity = 0.3;
    
    const count = instancedMesh.count; // Number of instances
    const highlightColor = new THREE.Color(0xF6F7C4); // Highlight color

    for (let i = 0; i < count; i++) {
      instancedMesh.instanceColor.setXYZ(i, highlightColor.r, highlightColor.g, highlightColor.b);
    }

    // Mark the instanceColor buffer for update
    instancedMesh.instanceColor.needsUpdate = true;

    // Ensure the material updates
    instancedMesh.material.needsUpdate = true;
  }

  parseDesignMap(designMap) {
    const structures = Object.keys(designMap)
    const structureAssemblyArray = new Array(structures.length);
    structures.forEach((key, idx) => {
      structureAssemblyArray[idx] = this.assembleDesignMap(designMap[key]);
    });
    return structureAssemblyArray;
  }

  animate() {
    const animateLoop = () => {
      requestAnimationFrame(animateLoop);

      this.onHover();

      this.renderer.render(this.scene, this.camera);
    };
    animateLoop(); // Start the loop
  }

  assembleDesignMap(assemblyMap) {
    const assemblyBlock = new THREE.Group();
    let monomerMap = this.constructMonomerMap(assemblyMap);
    const startObject = new Hex(new THREE.Vector3(0, 0, 0));
    const {
      horiz,
      vert,
      depth
    } = startObject.getSpacings();

    Object.keys(assemblyMap).forEach((monomer) => {
      if (monomerMap[monomer] === false) {
        const startPos = new THREE.Vector3(0, 0, 0);
        const startHex = new Hex(new THREE.Vector3(startPos.x, startPos.y, startPos.z));
        assemblyBlock.add(startHex.getObject());
        monomerMap[monomer] = startPos;
      }

      Object.keys(assemblyMap[monomer]).forEach((side) => {
        const hexPos = monomerMap[monomer];
        if (side == "S1") {
          if (monomerMap[assemblyMap[monomer][side][0]] === false) {
            const s1NeighborXPos = hexPos.x + horiz * 3 / 4;
            const s1NeighborYPos = hexPos.y;
            const s1NeighborZPos = hexPos.z
            const s1Neighbor = new Hex(new THREE.Vector3(s1NeighborXPos, s1NeighborYPos, s1NeighborZPos));
            assemblyBlock.add(s1Neighbor.getObject());
            monomerMap[assemblyMap[monomer][side][0]] = new THREE.Vector3(s1NeighborXPos, s1NeighborYPos, s1NeighborZPos);
          }
        } else if (side == "S2") {
          if (monomerMap[assemblyMap[monomer][side][0]] === false) {
            const s2NeighborXPos = hexPos.x + horiz * 3 / 8;
            const s2NeighborYPos = hexPos.y;
            const s2NeighborZPos = hexPos.z - vert / Math.sqrt(3);
            const s2Neighbor = new Hex(new THREE.Vector3(s2NeighborXPos, s2NeighborYPos, s2NeighborZPos));
            assemblyBlock.add(s2Neighbor.getObject());
            monomerMap[assemblyMap[monomer][side][0]] = new THREE.Vector3(s2NeighborXPos, s2NeighborYPos, s2NeighborZPos);
          }
        } else if (side == "S3") {
          if (monomerMap[assemblyMap[monomer][side][0]] === false) {
            const s3NeighborXPos = hexPos.x + (horiz * 3 / 8 - horiz * 3 / 4);
            const s3NeighborYPos = hexPos.y;
            const s3NeighborZPos = hexPos.z - vert / Math.sqrt(3);
            const s3Neighbor = new Hex(new THREE.Vector3(s3NeighborXPos, s3NeighborYPos, s3NeighborZPos));
            assemblyBlock.add(s3Neighbor.getObject());
            monomerMap[assemblyMap[monomer][side][0]] = new THREE.Vector3(s3NeighborXPos, s3NeighborYPos, s3NeighborZPos);
          }
        } else if (side == "S4") {
          if (monomerMap[assemblyMap[monomer][side][0]] === false) {
            const s4NeighborXPos = hexPos.x - horiz * 3 / 4;
            const s4NeighborYPos = hexPos.y;
            const s4NeighborZPos = hexPos.z
            const s4Neighbor = new Hex(new THREE.Vector3(s4NeighborXPos, s4NeighborYPos, s4NeighborZPos));
            assemblyBlock.add(s4Neighbor.getObject());
            monomerMap[assemblyMap[monomer][side][0]] = new THREE.Vector3(s4NeighborXPos, s4NeighborYPos, s4NeighborZPos);
          }
        } else if (side == "S5") {
          if (monomerMap[assemblyMap[monomer][side][0]] === false) {
            const s5NeighborXPos = hexPos.x + horiz * 3 / 8;
            const s5NeighborYPos = hexPos.y;
            const s5NeighborZPos = hexPos.z + vert / Math.sqrt(3);
            const s5Neighbor = new Hex(new THREE.Vector3(s5NeighborXPos, s5NeighborYPos, s5NeighborZPos));
            assemblyBlock.add(s5Neighbor.getObject());
            monomerMap[assemblyMap[monomer][side][0]] = new THREE.Vector3(s5NeighborXPos, s5NeighborYPos, s5NeighborZPos);
          }
        } else if (side == "S6") {
          if (monomerMap[assemblyMap[monomer][side][0]] === false) {
            const s6NeighborXPos = hexPos.x - (horiz * 3 / 8 - horiz * 3 / 4);
            const s6NeighborYPos = hexPos.y;
            const s6NeighborZPos = hexPos.z + vert / Math.sqrt(3);
            const s6Neighbor = new Hex(new THREE.Vector3(s6NeighborXPos, s6NeighborYPos, s6NeighborZPos));
            assemblyBlock.add(s6Neighbor.getObject());
            monomerMap[assemblyMap[monomer][side][0]] = new THREE.Vector3(s6NeighborXPos, s6NeighborYPos, s6NeighborZPos);
          }
        } else if (side == "ZU") {
          if (monomerMap[assemblyMap[monomer][side][0]] === false) {
            const zUNeighborXPos = hexPos.x;
            const zUNeighborYPos = hexPos.y + depth + 0.5;
            const zUNeighborZPos = hexPos.z;
            const zUNeighbor = new Hex(new THREE.Vector3(zUNeighborXPos, zUNeighborYPos, zUNeighborZPos));
            assemblyBlock.add(zUNeighbor.getObject());
            monomerMap[assemblyMap[monomer][side][0]] = new THREE.Vector3(zUNeighborXPos, zUNeighborYPos, zUNeighborZPos);
          }
        } else if (side == "ZD") {
          if (monomerMap[assemblyMap[monomer][side][0]] === false) {
            const zDNeighborXPos = hexPos.x;
            const zDNeighborYPos = hexPos.y - (depth + 0.5);
            const zDNeighborZPos = hexPos.z;
            const zDNeighbor = new Hex(new THREE.Vector3(zDNeighborXPos, zDNeighborYPos, zDNeighborZPos));
            assemblyBlock.add(zDNeighbor.getObject());
            monomerMap[assemblyMap[monomer][side][0]] = new THREE.Vector3(zDNeighborXPos, zDNeighborYPos, zDNeighborZPos);
          }
        }
      })
    })
    return assemblyBlock;
  }

  constructMonomerMap(assemblyMap) {
    let monomerMap = {}
    Object.keys(assemblyMap).forEach((monomer) => {
      monomerMap[monomer] = false;
    })
    return monomerMap;
  }
}