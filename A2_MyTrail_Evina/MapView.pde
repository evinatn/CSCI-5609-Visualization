public class MapView extends View {
    private MapModel model;
    private PImage img;
    private PanZoomPage panZoomPage;
    private float imgScale;
    private float zoom = 1.0;
  public float translateX = 0.0;
  public float translateY = 0.0;
  float aspect;
 PImage[] pointImages;
    public MapView(MapModel model, int x, int y, int w, int h) {
        super(x, y, w, h);
        this.model = model;
        img = model.getMap().getColorImage();
        panZoomPage = new PanZoomPage(x, y, w, h);
        panZoomPage.fitPageOnScreen();

        if (img.width > img.height) {
            imgScale = 1.0 / img.width;
        } else {
            imgScale = 1.0 / img.height;
        }
        String[] imagePaths = {
            "pinklake1.jpg",
            "mica.jpg",
            "park.jpg",
            "emaybe.jpg",
            "kingsmere.jpg",
            "waterfall.jpg"
        };
        pointImages = new PImage[imagePaths.length];
        for (int i = 0; i < imagePaths.length; i++) {
            pointImages[i] = loadImage(imagePaths[i]);
        } }
    public void drawView() {
    // Draw the map using the panZoomPage
    float imageX = panZoomPage.pageXtoScreenX(0.5);
    float imageY = panZoomPage.pageYtoScreenY(0.5);

    pushMatrix();
    translate(imageX, imageY);
    scale(1.0 * panZoomPage.pageLengthToScreenLength(1.0) * imgScale);
    translate(-img.width / 2, -img.height / 2);
    image(img, 0, 0);
    popMatrix();

  // Define points A, B, C, D, E, F using pixel coordinates
    float[] pointsX = {219, 241, 220, 184, 171, 175};
    float[] pointsY = {283, 248, 237, 266, 258, 253};
    String[] pointNames = {"Pink Lake", "Chemin de la Mine", "Gatineau Park Visitor Centre", "Gatineu Park P7", "Mackenzie King", "Sentier de la Chute"};
    
  // Draw circles at specified points
  stroke(255,255,0);
    //fill(255,255,0); // color for circles
    for (int i = 0; i < pointsX.length; i++) {
        float xCoord = panZoomPage.pageXtoScreenX(map(pointsX[i], 0, img.width, 0, 1));
        float yCoord = panZoomPage.pageYtoScreenY(map(pointsY[i], 0, img.height, 0, 1));
        fill(255,255,0);
        ellipse(xCoord, yCoord, 4, 4); // Draw circles
       fill(255);
        textSize(12);
       // textAlign(CENTER, BOTTOM);
        text(pointNames[i], xCoord, yCoord + 15);
        if (dist(mouseX, mouseY, xCoord, yCoord) < 4) {
            // If it is, display the corresponding image
            image(pointImages[i], xCoord, yCoord);
        }
    }
    
  // Draw legend for points
    fill(255,255,0);
    ellipse(13, 20, 4, 4);
    textSize(12);
    fill(255);
    text("Points of Interest", 25, 25);

    // Draw lines connecting the points
    strokeWeight(2);
    // Draw Blue line for A-B-C
    stroke(0, 0, 255);
    line(10, 40, 20, 40);
    //textSize(12);
    fill(255);
   // text("Pink Lake Trail", 25, 45);
    // Draw different color line for C-D-E-F
    stroke(178, 102, 255);
    line(10, 60, 20, 60);
   // textSize(12);
   // text("Waterfall Trail", 25, 65);
    // Draw lines connecting the points
    strokeWeight(2);
    // Draw Blue line for A-B-C
    stroke(0, 0, 255);
    line(panZoomPage.pageXtoScreenX(map(pointsX[0], 0, img.width, 0, 1)), panZoomPage.pageYtoScreenY(map(pointsY[0], 0, img.height, 0, 1)),
            panZoomPage.pageXtoScreenX(map(pointsX[1], 0, img.width, 0, 1)), panZoomPage.pageYtoScreenY(map(pointsY[1], 0, img.height, 0, 1)));
    line(panZoomPage.pageXtoScreenX(map(pointsX[1], 0, img.width, 0, 1)), panZoomPage.pageYtoScreenY(map(pointsY[1], 0, img.height, 0, 1)),
            panZoomPage.pageXtoScreenX(map(pointsX[2], 0, img.width, 0, 1)), panZoomPage.pageYtoScreenY(map(pointsY[2], 0, img.height, 0, 1)));
    // Draw different color line for C-D-E-F
    stroke(178, 102, 255);
    //fill(178,102,255);
    line(panZoomPage.pageXtoScreenX(map(pointsX[2], 0, img.width, 0, 1)), panZoomPage.pageYtoScreenY(map(pointsY[2], 0, img.height, 0, 1)),
            panZoomPage.pageXtoScreenX(map(pointsX[3], 0, img.width, 0, 1)), panZoomPage.pageYtoScreenY(map(pointsY[3], 0, img.height, 0, 1)));
    line(panZoomPage.pageXtoScreenX(map(pointsX[3], 0, img.width, 0, 1)), panZoomPage.pageYtoScreenY(map(pointsY[3], 0, img.height, 0, 1)),
            panZoomPage.pageXtoScreenX(map(pointsX[4], 0, img.width, 0, 1)), panZoomPage.pageYtoScreenY(map(pointsY[4], 0, img.height, 0, 1)));
    line(panZoomPage.pageXtoScreenX(map(pointsX[4], 0, img.width, 0, 1)), panZoomPage.pageYtoScreenY(map(pointsY[4], 0, img.height, 0, 1)),
            panZoomPage.pageXtoScreenX(map(pointsX[5], 0, img.width, 0, 1)), panZoomPage.pageYtoScreenY(map(pointsY[5], 0, img.height, 0, 1)));

    // Draw legend for trails
    stroke(0, 0, 255);
    line(10, 40, 20, 40);
    textSize(12);
    fill(255);
    text("Pink Lake Trail", 25, 45);
    stroke(178, 102, 255);
    line(10, 60, 20, 60);
    textSize(12);
    fill(255);
    text("Waterfall Trail", 25, 65);
    fill(255);
    textSize(14);
    text("Zoom in and hover over points to see images!", 520, 25);
          stroke(255,0,0);
    line(mouseX,0, mouseX,h);
    line(0,mouseY, w,mouseY);
    fill(255,255,255);
    textSize(20);
    int imgX = screenXtoImageX(mouseX);
    int imgY = screenYtoImageY(mouseY);
    if (imgX >= 0 && imgX < img.width && imgY >= 0 && imgY < img.height) {
      text("" + imgX + ", " + imgY , mouseX+50, mouseY+50);
    }
    fill(0,0,0);
    stroke(0,0,0);    
    
    
  }
  // Use the screen position to get the x value of the image
  public int screenXtoImageX(int screenX) {
    float x = panZoomPage.screenXtoPageX(screenX);
    return (int)((x-0.5 + img.width*imgScale/2)*img.width/(img.width*imgScale));
  }
  
   // Use the screen position to get the y value of the image
  public int screenYtoImageY(int screenY) {
    float y = panZoomPage.screenYtoPageY(screenY);
    return (int)((y-0.5 + img.height*imgScale/2)*img.height/(img.height*imgScale));
  }
}
