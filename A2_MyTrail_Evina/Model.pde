// ---------------------------------------------------------
// The MapModel class holds all the information necessary
// for working with an elevation map.  This class is application
// independent and should be separate from graphics and interaction
// logic.
// ---------------------------------------------------------
import java.util.Arrays;
// Model class for holding information
import processing.core.PImage;

public class MapModel {
    private ElevationMap map;
    private int[] histogram;
    private PImage colormapImage;

    public MapModel(String heightMapFilePath) {
        PImage heightMap = loadImage(heightMapFilePath);
        //PImage colormap = loadImage(colormapFilePath);
       
        map = new ElevationMap(heightMap, 0.0, 1.0);
        calculateHistogram();
      
       colormapImage = loadImage("cm1.png");
       colormapImage.loadPixels();
       applyColormapToImage();
       
    }

    public ElevationMap getMap() {
        return map;
    }

    public int[] getHistogram() {
        return histogram;
    }
      

    private void calculateHistogram() {
        int[] heights = new int[256]; // Assuming 8-bit grayscale image
        PImage colorImage = map.getColorImage();
        colorImage.loadPixels();
        for (int i = 0; i < colorImage.pixels.length; i++) {
            int brightness = (int)brightness(colorImage.pixels[i]);
            heights[brightness]++;
        }
        histogram = heights;
        //println("Histogram calculated:", Arrays.toString(histogram));
    }
private void applyColormapToImage() {
        PImage colorImage = map.getColorImage();
        colorImage.loadPixels();
        for (int i = 0; i < colorImage.pixels.length; i++) {
            int brightness = (int) red(colorImage.pixels[i]);
            colorImage.pixels[i] = colormapImage.pixels[brightness];
        }
        colorImage.updatePixels();
    }
};


// Defines an elevation map for working with terrain
public class ElevationMap {
  private PImage heightMap;
  private PImage colorImage;
  private float low;
  private float high;
  
  // The heightmap image defines the width and height and the low and high allows the user to specify the elevation range.
  // The elevation map also holds a color image that can be edited with getColor(x,y) and setColor(x,y,c)
  public ElevationMap(PImage heightMap, float low, float high) {
    this.heightMap = heightMap;
    this.low = low;
    this.high = high;
    colorImage = new PImage(heightMap.width, heightMap.height);
    //colorImage=loadImage("C:/Users/tnevi/Downloads/cm2.png");
    colorImage.copy(heightMap, 0, 0, heightMap.width, heightMap.height, 0, 0, heightMap.width, heightMap.height);
    heightMap.loadPixels();
    colorImage.loadPixels();
  }
  
  // Get the map width
  public int getWidth() {
    return heightMap.width;
  }
  
  // Get the map height
  public int getHeight() {
    return heightMap.height;
  }
  
   public float getLow() {
        return low;
    }
  
    // Get the high value from the image
    public float getHigh() {
        return high;
    }
  // Get the elevation at a point in the map
  public float getElevation(int x, int y) {
    float normalizedElevation = 1.0*red(heightMap.pixels[x + y*heightMap.width])/255.0;
    return lerp(low, high, normalizedElevation);
  }
  
  // Get the color image for drawing and editing purposes
  public PImage getColorImage() {
    return colorImage;
  }
  
  // Get the color at a point in the map
  public color getColor(int x, int y) {
    return colorImage.pixels[x + y*heightMap.width];
  }
  
  // Sets the color at a point in the map
  public void setColor(int x, int y, color c) {
    colorImage.pixels[x + y*heightMap.width] = c;
  }
}
