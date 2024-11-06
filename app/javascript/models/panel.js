import * as THREE from "three";

export class Panel {

    constructor(position, bonds, width, height) {
        this.position = position;
        this.bonds = bonds;

        this.SIDE_WIDTH = width;
        this.SIDE_HEIGHT = height;
        this.HELIX_WIDTH = height / 12.5;
        this.HELIX_HEIGHT = width / 1.05;
        this.ATTR_BOND_WIDTH = width / 17.5;
        this.ATTR_BOND_HEIGHT = height / 6.5;
        this.NEUT_BOND_WIDTH = this.HELIX_WIDTH;
        this.NEUT_BOND_HEIGHT = height / 26.5;
        this.REPL_BOND_WIDTH = width / 6.5;

        this.COLORS = {
            helix: 0xF0E5D1,
            bondAttractive: 0x808836,
            bondNeutral: 0xFDB840,
            bondRepulsive: 0xA91E3B,
            side: 0xDBB5B4,
            border: 0x6D4E32
        };

        this.BOND_OFFSETS = [
            [-this.SIDE_WIDTH / 4 - this.HELIX_WIDTH / 2, this.HELIX_HEIGHT / 2 + this.NEUT_BOND_HEIGHT / 2],
            [-this.SIDE_WIDTH / 4 - this.HELIX_WIDTH / 2, -this.HELIX_HEIGHT / 2 - this.NEUT_BOND_HEIGHT / 2],
            [-this.SIDE_WIDTH / 4 + this.HELIX_WIDTH / 2, this.HELIX_HEIGHT / 2 + this.NEUT_BOND_HEIGHT / 2],
            [-this.SIDE_WIDTH / 4 + this.HELIX_WIDTH / 2, -this.HELIX_HEIGHT / 2 - this.NEUT_BOND_HEIGHT / 2],
            [this.SIDE_WIDTH / 4 - this.HELIX_WIDTH / 2, this.HELIX_HEIGHT / 2 + this.NEUT_BOND_HEIGHT / 2],
            [this.SIDE_WIDTH / 4 - this.HELIX_WIDTH / 2, -this.HELIX_HEIGHT / 2 - this.NEUT_BOND_HEIGHT / 2],
            [this.SIDE_WIDTH / 4 + this.HELIX_WIDTH / 2, this.HELIX_HEIGHT / 2 + this.NEUT_BOND_HEIGHT / 2],
            [this.SIDE_WIDTH / 4 + this.HELIX_WIDTH / 2, -this.HELIX_HEIGHT / 2 - this.NEUT_BOND_HEIGHT / 2]
        ];
    }

    createPanel() {
        const panelGroup = new THREE.Group();

        // Create the main panel
        const side = this.createRectangleWithBorder(this.SIDE_WIDTH, this.SIDE_HEIGHT, this.COLORS.side, this.COLORS.border);
        side.position.set(...this.position);
        panelGroup.add(side);

        // Create helices
        this.createHelices(panelGroup);

        // Add bonds based on bond data
        this.addBonds(panelGroup);

        return panelGroup;
    }

    createHelices(parentGroup) {
        const leftCenterX = -this.SIDE_WIDTH / 4 - this.HELIX_WIDTH / 2;
        const rightCenterX = this.SIDE_WIDTH / 4 - this.HELIX_WIDTH / 2;
        const centerY = this.position[1];

        const helixLeft1 = this.createRectangleWithBorder(this.HELIX_WIDTH, this.HELIX_HEIGHT, this.COLORS.helix, this.COLORS.border);
        helixLeft1.position.set(this.position[0] + leftCenterX, centerY, 0.1);
        parentGroup.add(helixLeft1);

        const helixLeft2 = this.createRectangleWithBorder(this.HELIX_WIDTH, this.HELIX_HEIGHT, this.COLORS.helix, this.COLORS.border);
        helixLeft2.position.set(this.position[0] + leftCenterX + this.HELIX_WIDTH, centerY, 0.1);
        parentGroup.add(helixLeft2);

        const helixRight1 = this.createRectangleWithBorder(this.HELIX_WIDTH, this.HELIX_HEIGHT, this.COLORS.helix, this.COLORS.border);
        helixRight1.position.set(this.position[0] + rightCenterX, centerY, 0.1);
        parentGroup.add(helixRight1);

        const helixRight2 = this.createRectangleWithBorder(this.HELIX_WIDTH, this.HELIX_HEIGHT, this.COLORS.helix, this.COLORS.border);
        helixRight2.position.set(this.position[0] + rightCenterX + this.HELIX_WIDTH, centerY, 0.1);
        parentGroup.add(helixRight2);
    }

    addBonds(parentGroup) {
        this.bonds.forEach((bond, index) => {
            let bondMesh;
            const isBottom = index % 2 === 1;

            switch (bond) {
                case 1:
                case '1':
                    bondMesh = this.createRectangleWithBorder(this.ATTR_BOND_WIDTH, this.ATTR_BOND_HEIGHT, this.COLORS.bondAttractive, this.COLORS.border);
                    break;
                case 0:
                case '0':
                    bondMesh = this.createRectangleWithBorder(this.NEUT_BOND_WIDTH, this.NEUT_BOND_HEIGHT, this.COLORS.bondNeutral, this.COLORS.border);
                    break;
                case 'x':
                    bondMesh = this.createTBond(this.REPL_BOND_WIDTH, this.COLORS.bondRepulsive, this.COLORS.border, isBottom ? Math.PI : 0);
                    break;
                default:
                    bondMesh = this.createRectangleWithBorder(this.NEUT_BOND_WIDTH, this.NEUT_BOND_HEIGHT, this.COLORS.bondNeutral, this.COLORS.border);
            }
            bondMesh.position.set(
                this.position[0] + this.BOND_OFFSETS[index][0],
                this.position[1] + this.BOND_OFFSETS[index][1],
                0.15
            );

            parentGroup.add(bondMesh);
        });
    }

    createRectangleWithBorder(width, height, color, borderColor) {
        const group = new THREE.Group();
        const geometry = new THREE.PlaneGeometry(width, height);
        const material = new THREE.MeshBasicMaterial({
            color
        });
        const rectangle = new THREE.Mesh(geometry, material);
        group.add(rectangle);

        const edges = new THREE.EdgesGeometry(geometry);
        const lineMaterial = new THREE.LineBasicMaterial({
            color: borderColor
        });
        const border = new THREE.LineSegments(edges, lineMaterial);
        group.add(border);

        return group;
    }

    createTBond(size, color, borderColor, rotation = 0) {
        const group = new THREE.Group();
        const material = new THREE.MeshBasicMaterial({
            color
        });

        const verticalGeometry = new THREE.PlaneGeometry(size / 3, size * 1.5);
        const verticalMesh = new THREE.Mesh(verticalGeometry, material);
        group.add(verticalMesh);

        const horizontalGeometry = new THREE.PlaneGeometry(size, size / 3);
        const horizontalMesh = new THREE.Mesh(horizontalGeometry, material);
        horizontalMesh.position.set(0, (size / 3) * 1.75, 0);
        group.add(horizontalMesh);

        group.rotation.z = rotation;
        return group;
    }
}