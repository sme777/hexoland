import * as THREE from "three";

export class Panel {
    static SIDE_WIDTH = 52.71;
    static SIDE_HEIGHT = 78.06;
    static HELIX_WIDTH = 6.2;
    static HELIX_HEIGHT = 58.52;
    static ATTR_BOND_WIDTH = 3;
    static ATTR_BOND_HEIGHT = 12;
    static NEUT_BOND_WIDTH = Panel.HELIX_WIDTH;
    static NEUT_BOND_HEIGHT = 3;
    static REPL_BOND_WIDTH = 8;

    static COLORS = {
        helix: 0xF0E5D1,
        bondAttractive: 0x808836,
        bondNeutral: 0xFDB840,
        bondRepulsive: 0xA91E3B,
        side: 0xDBB5B4,
        border: 0x6D4E32
    };

    static BOND_OFFSETS = [
        [-Panel.SIDE_WIDTH / 4 - Panel.HELIX_WIDTH / 2, Panel.HELIX_HEIGHT / 2 + Panel.NEUT_BOND_HEIGHT / 2],
        [-Panel.SIDE_WIDTH / 4 - Panel.HELIX_WIDTH / 2, -Panel.HELIX_HEIGHT / 2 - Panel.NEUT_BOND_HEIGHT / 2],
        [-Panel.SIDE_WIDTH / 4 + Panel.HELIX_WIDTH / 2, Panel.HELIX_HEIGHT / 2 + Panel.NEUT_BOND_HEIGHT / 2],
        [-Panel.SIDE_WIDTH / 4 + Panel.HELIX_WIDTH / 2, -Panel.HELIX_HEIGHT / 2 - Panel.NEUT_BOND_HEIGHT / 2],
        [Panel.SIDE_WIDTH / 4 - Panel.HELIX_WIDTH / 2, Panel.HELIX_HEIGHT / 2 + Panel.NEUT_BOND_HEIGHT / 2],
        [Panel.SIDE_WIDTH / 4 - Panel.HELIX_WIDTH / 2, -Panel.HELIX_HEIGHT / 2 - Panel.NEUT_BOND_HEIGHT / 2],
        [Panel.SIDE_WIDTH / 4 + Panel.HELIX_WIDTH / 2, Panel.HELIX_HEIGHT / 2 + Panel.NEUT_BOND_HEIGHT / 2],
        [Panel.SIDE_WIDTH / 4 + Panel.HELIX_WIDTH / 2, -Panel.HELIX_HEIGHT / 2 - Panel.NEUT_BOND_HEIGHT / 2]
    ];

    constructor(position, bonds) {
        this.position = position;
        this.bonds = bonds;
    }

    createPanel() {
        const panelGroup = new THREE.Group();

        // Create the main panel
        const side = this.createRectangleWithBorder(Panel.SIDE_WIDTH, Panel.SIDE_HEIGHT, Panel.COLORS.side, Panel.COLORS.border);
        side.position.set(...this.position);
        panelGroup.add(side);

        // Create helices
        this.createHelices(panelGroup);

        // Add bonds based on bond data
        this.addBonds(panelGroup);

        return panelGroup;
    }

    createHelices(parentGroup) {
        const leftCenterX = -Panel.SIDE_WIDTH / 4 - Panel.HELIX_WIDTH / 2;
        const rightCenterX = Panel.SIDE_WIDTH / 4 - Panel.HELIX_WIDTH / 2;
        const centerY = this.position[1];

        const helixLeft1 = this.createRectangleWithBorder(Panel.HELIX_WIDTH, Panel.HELIX_HEIGHT, Panel.COLORS.helix, Panel.COLORS.border);
        helixLeft1.position.set(this.position[0] + leftCenterX, centerY, 0.1);
        parentGroup.add(helixLeft1);

        const helixLeft2 = this.createRectangleWithBorder(Panel.HELIX_WIDTH, Panel.HELIX_HEIGHT, Panel.COLORS.helix, Panel.COLORS.border);
        helixLeft2.position.set(this.position[0] + leftCenterX + Panel.HELIX_WIDTH, centerY, 0.1);
        parentGroup.add(helixLeft2);

        const helixRight1 = this.createRectangleWithBorder(Panel.HELIX_WIDTH, Panel.HELIX_HEIGHT, Panel.COLORS.helix, Panel.COLORS.border);
        helixRight1.position.set(this.position[0] + rightCenterX, centerY, 0.1);
        parentGroup.add(helixRight1);

        const helixRight2 = this.createRectangleWithBorder(Panel.HELIX_WIDTH, Panel.HELIX_HEIGHT, Panel.COLORS.helix, Panel.COLORS.border);
        helixRight2.position.set(this.position[0] + rightCenterX + Panel.HELIX_WIDTH, centerY, 0.1);
        parentGroup.add(helixRight2);
    }

    addBonds(parentGroup) {
        this.bonds.forEach((bond, index) => {
            let bondMesh;
            const isBottom = index % 2 === 1;

            switch (bond) {
                case 1:
                case '1':
                    bondMesh = this.createRectangleWithBorder(Panel.ATTR_BOND_WIDTH, Panel.ATTR_BOND_HEIGHT, Panel.COLORS.bondAttractive, Panel.COLORS.border);
                    break;
                case 0:
                case '0':
                    bondMesh = this.createRectangleWithBorder(Panel.NEUT_BOND_WIDTH, Panel.NEUT_BOND_HEIGHT, Panel.COLORS.bondNeutral, Panel.COLORS.border);
                    break;
                case 'x':
                    bondMesh = this.createTBond(Panel.REPL_BOND_WIDTH, Panel.COLORS.bondRepulsive, Panel.COLORS.border, isBottom ? Math.PI : 0);
                    break;
                default:
                    bondMesh = this.createRectangleWithBorder(Panel.NEUT_BOND_WIDTH, Panel.NEUT_BOND_HEIGHT, Panel.COLORS.bondNeutral, Panel.COLORS.border);
            }
            bondMesh.position.set(
                this.position[0] + Panel.BOND_OFFSETS[index][0],
                this.position[1] + Panel.BOND_OFFSETS[index][1],
                0.15
            );

            parentGroup.add(bondMesh);
        });
    }

    createRectangleWithBorder(width, height, color, borderColor) {
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

    createTBond(size, color, borderColor, rotation = 0) {
        const group = new THREE.Group();
        const material = new THREE.MeshBasicMaterial({ color });

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