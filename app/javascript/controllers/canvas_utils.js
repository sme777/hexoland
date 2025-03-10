import * as THREE from 'three';
import {
    OrbitControls
  } from 'three/addons/controls/OrbitControls.js';
  
export function setupCanvas(canvas) {
    const parentDiv = canvas.parentElement;
    const width = parentDiv.clientWidth;
    const height = parentDiv.clientHeight;

    const scene = new THREE.Scene();
    scene.background = new THREE.Color(0xFFFFFF); // F8EDE3

    const camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer({
        antialias: true
    });
    renderer.setSize(width, height);
    canvas.appendChild(renderer.domElement);

    const controls = new OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;
    controls.dampingFactor = 0.25;
    controls.enableZoom = true;
    console.log(
        renderer
        )
    return [
        scene,
        camera,
        renderer,
        controls
    ];
}


export function onWindowResize(renderer, camera, container) {
    // Update the camera aspect ratio and projection matrix
    camera.aspect = container.clientWidth / container.clientHeight;
    camera.updateProjectionMatrix();

    // Update the renderer size
    renderer.setSize(container.clientWidth, container.clientHeight);

    // Ensure the renderer's pixel ratio is correct (useful for high-DPI displays)
    renderer.setPixelRatio(window.devicePixelRatio);
}

export function animate(scene, camera, renderer) {
    const animateLoop = () => {
        requestAnimationFrame(animateLoop);
        renderer.render(scene, camera);
    };
    animateLoop(); // Start the loop
}


export function setupInteractiveControls(activeControl, guiContainer, scene) {
    const selectControl = document.getElementById("selectionControl");
    const additionControl = document.getElementById("additionControl");
    const deletionControl = document.getElementById("deletionControl");
    const alignmentControl = document.getElementById("alignmentControl");
    const cameraControl = document.getElementById("cameraControl");

    selectControl.addEventListener('click', () => {
      selectControl.classList.add('active');

      additionControl.classList.remove('active');
      deletionControl.classList.remove('active');
      alignmentControl.classList.remove('active');
      cameraControl.classList.remove('active');
      activeControl = "SELECT";
    })

    additionControl.addEventListener('click', () => {
      additionControl.classList.add('active');

      selectControl.classList.remove('active');
      deletionControl.classList.remove('active');
      alignmentControl.classList.remove('active');
      cameraControl.classList.remove('active');
      activeControl = "ADD";
    })

    deletionControl.addEventListener('click', () => {
      deletionControl.classList.add('active');

      selectControl.classList.remove('active');
      additionControl.classList.remove('active');
      alignmentControl.classList.remove('active');
      cameraControl.classList.remove('active');
      activeControl = "REMOVE";
    })

    alignmentControl.addEventListener('click', () => {
      alignmentControl.classList.add('active');

      selectControl.classList.remove('active');
      additionControl.classList.remove('active');
      deletionControl.classList.remove('active');
      cameraControl.classList.remove('active');
      activeControl = "ALIGN";
    })

    cameraControl.addEventListener('click', () => {
        cameraControl.classList.add('active');
  
        selectControl.classList.remove('active');
        additionControl.classList.remove('active');
        deletionControl.classList.remove('active');
        alignmentControl.classList.remove('active');
        activeControl = "CAMERA";



      })

    guiContainer.addEventListener('dblclick', (e) => {
      if (activeControl === "ADD") {

        scene.add((new Hex("Empty", new THREE.Vector3(0, 0, 0), {})).getObject());
      }
    })
  }



  