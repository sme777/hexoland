class Hex {
    constructor(q, r, s) {
        console.assert(q + r + s === 0);
        this.q = q;
        this.r = r;
        this.s = s;
    }

    // Calculate the length (distance to origin) of a hex
    length() {
        return Math.floor((Math.abs(this.q) + Math.abs(this.r) + Math.abs(this.s)) / 2);
    }    
    
    // Calculate the distance between this hex and another hex
    distanceTo(other) {
        const deltaQ = this.q - other.q;
        const deltaR = this.r - other.r;
        const deltaS = this.s - other.s;
        // Create a new hex with the differences in coordinates
        const deltaHex = new Hex(deltaQ, deltaR, deltaS);
        // Return the length (distance to origin) of the deltaHex
        return deltaHex.length();
    }

    static add(hex1, hex2) {
        return new Hex(hex1.q + hex2.q, hex1.r + hex2.r, hex1.s + hex2.s);
    }

    static sub(hex1, hex2) {
        return new Hex(hex1.q - hex2.q, hex1.r - hex2.r, hex1.s - hex2.s);
    }

    static mul(hex, k) {
        return new Hex(hex.q * k, hex.r * k, hex.s * k);
    }

    static eq(hex1, hex2) {
        return hex1.q === hex2.q && hex1.r === hex2.r && hex1.s === hex2.s
    }

}