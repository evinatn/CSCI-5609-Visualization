public class HistogramView extends View {
    private MapModel model;
    private PImage colormap;

    public HistogramView(MapModel model, int x, int y, int w, int h) {
        super(x, y, w, h);
        this.model = model;
        colormap = loadImage("cm2.png"); // Update with the correct path to your colormap image
        colormap.loadPixels();
    }

   public void drawView() {
    // Set background to black
    background(0);
  
    // Text label
    fill(255);
    text("Histogram View", x + 30, y + 30);

    int[] histogram = model.getHistogram();
    int maxCount = Arrays.stream(histogram).max().orElse(0);
    int histogramHeight = h - 70; // Adjust as needed
    int histogramY = y + h - 20; // Adjust as needed
  
    // Define boundaries for the histogram and colormap
    int boundaryX = x + 20; // Adjust the left boundary
    int boundaryY = y + 20; // Adjust the top boundary
    int boundaryWidth = w - 40; // Adjust the width
    int boundaryHeight = h - 90; // Adjust the height
  
  //fill(0,0,255);
    // Draw histogram
    stroke(255);
    for (int i = 0; i < histogram.length; i++) {
    int barHeight = (int) map(histogram[i], 0, maxCount, 0, histogramHeight);
    int barX = boundaryX + i * (boundaryWidth / histogram.length); // Adjust the x position
    int barY = histogramY - barHeight; // Adjust the y position
  
    // Sample colormap color based on histogram value
    int colormapX = (int) map(i, 0, histogram.length, 0, colormap.width); // Adjust based on colormap size
    int colorSample = colormap.pixels[colormapX];
  
    // Set fill color based on histogram value
    fill(0);
    rect(barX, barY, boundaryWidth / histogram.length, barHeight);
}
    // Draw colormap
    int colormapHeight = 40; // Adjust as needed
    int colormapY = histogramY - 1; // Adjust to position below histogram
    image(colormap, boundaryX, colormapY, boundaryWidth, colormapHeight);
}

}
