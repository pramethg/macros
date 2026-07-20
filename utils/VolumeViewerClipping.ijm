source = getImageID;

startDist = getNumber("Starting distance", 42);
endDist   = getNumber("Ending distance", -129);
nFrames   = getNumber("Number of frames", 240);

movie = 0;
setBatchMode(true);

for (i = 0; i < nFrames; i++) {

    showProgress(i, nFrames);

    d = startDist + (endDist-startDist)*i/(nFrames-1);

    selectImage(source);

    parameters =
        "display_mode=2 interpolation=2 " +
        "bg_r=0 bg_g=0 bg_b=0 lut=0 " +
        "z-aspect=1 sampling=1 " +
        "dist=" + d + " " +
        "axes=0 slices=0 clipping=0 " +
        "scale=3.25 " +
        "angle_x=8 angle_y=0 angle_z=0 " +
        "alphamode=0 width=500 height=650";

    run("Volume Viewer", parameters);

    run("Copy");
    w = getWidth();
    h = getHeight();
    close();

    if (movie == 0) {
        newImage("Clipping Reveal", "16-bit black", w, h, 1);
        movie = getImageID();
    } else {
        selectImage(movie);
        run("Add Slice");
    }

    run("Paste");
}

selectImage(movie);
setSlice(1);
run("Select None");
setBatchMode(false);

run("Animation Options...", "speed=20 loop");