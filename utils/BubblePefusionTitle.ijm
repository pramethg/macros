csvPath = File.openDialog("Select timeData.csv");
if (csvPath == "")
    exit("No CSV selected.");

csvText = File.openAsString(csvPath);
lines = split(csvText, "\n");

maxExport = 0;
nIncluded = 0;
for (r = 1; r < lines.length; r++) {
    line = replace(lines[r], "\r", "");
    if (lengthOf(line) < 3)
        continue;

    cols = split(line, ",");
    if (cols.length < 5)
        continue;

    included = parseInt(cols[4]);
    if (included != 1)
        continue;

    exportFrame = parseInt(cols[1]);
    if (isNaN(exportFrame) || exportFrame < 1)
        continue;

    if (exportFrame > maxExport)
        maxExport = exportFrame;
    nIncluded++;
}

if (nIncluded < 1)
    exit("No included frames found in CSV:\n" + csvPath);

timeSecArr = newArray(maxExport + 1);
validArr = newArray(maxExport + 1);

for (r = 1; r < lines.length; r++) {
    line = replace(lines[r], "\r", "");
    if (lengthOf(line) < 3)
        continue;

    cols = split(line, ",");
    if (cols.length < 5)
        continue;

    included = parseInt(cols[4]);
    if (included != 1)
        continue;

    exportFrame = parseInt(cols[1]);
    timeSec = parseFloat(cols[2]);
    if (isNaN(exportFrame) || exportFrame < 1 || isNaN(timeSec))
        continue;

    timeSecArr[exportFrame] = timeSec;
    validArr[exportFrame] = 1;
}

getDimensions(width, height, channels, slices, frames);

run("Duplicate...",
    "title=[Labeled Bubble Perfusion Stack] " +
    "duplicate channels=1-" + channels +
    " slices=1-" + slices +
    " frames=1-" + frames);

run("RGB Color");

getDimensions(width, height, channels, slices, frames);

if (slices != nIncluded)
    print("Warning: stack slices (" + slices +
          ") != included CSV frames (" + nIncluded + ").");

fontSize = 6;
setFont("Arial", fontSize, "bold antialiased");

for (i = 1; i <= slices; i++) {
    setSlice(i);

    if (i > maxExport || validArr[i] != 1) {
        label = "Frame: " + i + " Time: N/A";
    } else {
        timeMin = timeSecArr[i] / 60.0;
        label = "Frame: " + i + " Time: " + d2s(timeMin, 2) + " min";
    }

    makeText(label, 2, 1);
    Roi.setStrokeColor("white");
    Roi.setPosition(i);
    Overlay.addSelection;
}

Overlay.show;
run("Select None");

run("Flatten", "stack");
rename("Labeled Bubble Perfusion Stack (Flattened)");
