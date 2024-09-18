public class ElevationPathView extends View {
    private MapModel model;
    private String[] pointNames = {"A", "B", "C", "D", "E", "F"};

    public ElevationPathView(MapModel model, int x, int y, int w, int h) {
        super(x, y, w, h);
        this.model = model;
    }

    public void drawView() {
        fill(255);
        text("Elevation Path View", x + 50, y + 50);

        // Define the coordinates for points A to F
        int[][] coordinates = {
                {226, 563},
                {247, 574},
                {225, 508},
                {190, 589},
                {177, 581},
                {181, 576}
        };

        // Get the elevations of points A to F
        float[] elevations = new float[coordinates.length];
        for (int i = 0; i < coordinates.length; i++) {
            int x = coordinates[i][0];
            int y = coordinates[i][1];
            elevations[i] = model.getMap().getElevation(x, y); // Cast float to int
        }

        // Calculate the y-axis range to ensure full visibility
        float maxElevation = getMaxElevation(elevations);
        float minElevation = getMinElevation(elevations);
        float yRange = maxElevation - minElevation;

        // Calculate the x-coordinates for drawing the line graph
        float stepSize = (float) (w - 40) / (coordinates.length - 1); // Leave some margin
        float xStart = x + 20; // Leave some margin

        // Draw the line graph
        stroke(255, 0, 0);
        for (int i = 1; i < coordinates.length; i++) {
            float xEnd = x + 20 + i * stepSize; // Leave some margin
            float yStart = y + h - (elevations[i - 1] - minElevation) / yRange * (h - 40); // Adjust for y-axis range
            float yEnd = y + h - (elevations[i] - minElevation) / yRange * (h - 40); // Adjust for y-axis range
            line(xStart, yStart, xEnd, yEnd);
            xStart = xEnd;
        }

        // Draw labels for point names and heights below the graph
        //textAlign(CENTER, TOP);
        fill(255);
    for (int i = 0; i < coordinates.length; i++) {
        float labelX = x + 20 + i * stepSize - textWidth(pointNames[i]) / 2; // Center text horizontally
        float labelY = y + h - 20; // Leave some margin
        text(pointNames[i] + "", labelX, labelY);
        }
    }

    // Helper method to get the maximum elevation from an array of elevations
    private float getMaxElevation(float[] elevations) {
        float maxElevation = Float.MIN_VALUE;
        for (float elevation : elevations) {
            if (elevation > maxElevation) {
                maxElevation = elevation;
            }
        }
        return maxElevation;
    }

    // Helper method to get the minimum elevation from an array of elevations
    private float getMinElevation(float[] elevations) {
        float minElevation = Float.MAX_VALUE;
        for (float elevation : elevations) {
            if (elevation < minElevation) {
                minElevation = elevation;
            }
        }
        return minElevation;
    }
}
