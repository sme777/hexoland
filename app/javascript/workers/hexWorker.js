export default class HexWorker {
  constructor() {
    // Initialize the Web Worker with the worker script
    this.worker = new Worker('/workers/hexWorker.worker.js');
  }

  // Method to perform the neighbor computation
  computeNeighbors(assemblyMap, spacings) {
    return new Promise((resolve) => {
      // Set up the message event listener to capture the worker's response
      this.worker.onmessage = (event) => {
        resolve(event.data); // Resolve the promise with the computed neighbors
      };
      // Post the data to the worker
      this.worker.postMessage({ assemblyMap, spacings });
    });
  }

  // Clean up the worker when done
  terminate() {
    this.worker.terminate();
  }
}
