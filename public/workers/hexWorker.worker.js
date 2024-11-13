// hexWorker.worker.js

self.onmessage = (event) => {
  const { assemblyMap, spacings } = event.data;
  const result = computeNeighbors(assemblyMap, spacings);
  self.postMessage(result);
};

function computeNeighbors(designMap, spacings) {
  const structures = Object.keys(designMap);
  const structureAssemblyArray = new Array(structures.length);

  for (let i = 0; i < structures.length; i++) {
    const key = structures[i];
    structureAssemblyArray[i] = assembleDesignMap(designMap[key], spacings);
  }

  return structureAssemblyArray;
}

function assembleDesignMap(assemblyMap, spacings) {
  const { horiz, vert, depth } = spacings;
  const horiz3_4 = horiz * 3 / 4;
  const horiz3_8 = horiz * 3 / 8;
  const vertDivSqrt3 = vert / Math.sqrt(3);

  const assemblyBlock = [];
  const monomerMap = constructMonomerMap(assemblyMap);

  const startPos = { x: 0, y: 0, z: 0 };

  // Process each monomer in the assembly
  for (const monomer in assemblyMap) {
    if (!monomerMap[monomer]) {
      monomerMap[monomer] = { ...startPos };
      assemblyBlock.push({ position: { ...startPos }, monomer });
    }

    const hexPos = monomerMap[monomer];
    const sides = assemblyMap[monomer];

    // Calculate each neighbor position
    for (const side in sides) {
      const neighbor = sides[side][0];
      if (monomerMap[neighbor]) continue;

      let neighborPos;
      switch (side) {
        case "S1":
          neighborPos = { x: hexPos.x + horiz3_4, y: hexPos.y, z: hexPos.z };
          break;
        case "S2":
          neighborPos = { x: hexPos.x + horiz3_8, y: hexPos.y, z: hexPos.z - vertDivSqrt3 };
          break;
        case "S3":
          neighborPos = { x: hexPos.x - horiz3_8, y: hexPos.y, z: hexPos.z - vertDivSqrt3 };
          break;
        case "S4":
          neighborPos = { x: hexPos.x - horiz3_4, y: hexPos.y, z: hexPos.z };
          break;
        case "S5":
          neighborPos = { x: hexPos.x + horiz3_8, y: hexPos.y, z: hexPos.z + vertDivSqrt3 };
          break;
        case "S6":
          neighborPos = { x: hexPos.x - horiz3_8, y: hexPos.y, z: hexPos.z + vertDivSqrt3 };
          break;
        case "ZU":
          neighborPos = { x: hexPos.x, y: hexPos.y + depth + 0.5, z: hexPos.z };
          break;
        case "ZD":
          neighborPos = { x: hexPos.x, y: hexPos.y - (depth + 0.5), z: hexPos.z };
          break;
      }

      if (neighborPos) {
        monomerMap[neighbor] = neighborPos;
        assemblyBlock.push({ position: neighborPos, monomer: neighbor });
      }
    }
  }

  return assemblyBlock;
}

function constructMonomerMap(assemblyMap) {
  const monomerMap = {};
  for (const monomer in assemblyMap) {
    monomerMap[monomer] = false;
  }
  return monomerMap;
}
