use <kx3-dust-cover.scad>


printable();


module printable() {
    rotate([180, 0, 0]) main();
}

module main() {
    intersection() {
        difference() {
            exterior_volume();
            interior_volume();
        }
            
        label_cut();
    }
}
