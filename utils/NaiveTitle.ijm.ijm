getDimensions(width, height, channels, slices, frames);

run("Duplicate...",
    "title=[Labeled Stack Power Doppler] " +
    "duplicate channels=1-" + channels +
    " slices=1-" + slices +
    " frames=1-" + frames);

run("RGB Color");

getDimensions(width, height, channels, slices, frames);

fontSize = 6;
setFont("Arial", fontSize, "bold antialiased");

for (i = 1; i <= slices; i++) {
    setSlice(i);

    label = "Frame: " + i;
    makeText(label, 2, 1);

    Roi.setStrokeColor("white");
    Roi.setPosition(i);
    Overlay.addSelection;
}

Overlay.show;
run("Select None");