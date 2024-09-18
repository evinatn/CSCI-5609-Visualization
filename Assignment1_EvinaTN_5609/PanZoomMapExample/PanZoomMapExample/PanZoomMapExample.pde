PanZoomMap panZoomMap; //<>//
Table locationTable;
Table populationTable;

int minPopulation = Integer.MAX_VALUE;
int maxPopulation = Integer.MIN_VALUE;

int highlightedCircleIndex = -1; //for stroke

void setup() {
  size(1600, 900);
  panZoomMap = new PanZoomMap(5.3, 139.0, 10.0, 163.1); 
  //loading csv
  locationTable = loadTable("FSM-municipality-locations.csv", "header");
  populationTable = loadTable("FSM-municipality-populations.csv", "header");

  // min and max population values
  for (TableRow row : populationTable.rows()) {
    int population = row.getInt("Population 2010 Census");
    minPopulation = min(minPopulation, population);
    maxPopulation = max(maxPopulation, population);
  }
}

void draw() {
  background(0);

  fill(117, 117, 117);
  stroke(0);
  rectMode(CORNERS);
  float x1 = panZoomMap.longitudeToScreenX(138.0);
  float y1 = panZoomMap.latitudeToScreenY(5.2);
  float x2 = panZoomMap.longitudeToScreenX(163.1);
  float y2 = panZoomMap.latitudeToScreenY(10.0);
  rect(x1, y1, x2, y2);

  //check if the mouse is over a circle
  boolean isMouseOverCircle = false;

  for (int i = 0; i < locationTable.getRowCount(); i++) {
    String municipality = locationTable.getString(i, "Municipality");
    float latitude = locationTable.getFloat(i, "Latitude");
    float longitude = locationTable.getFloat(i, "Longitude");

    float cx = panZoomMap.longitudeToScreenX(longitude);
    float cy = panZoomMap.latitudeToScreenY(latitude);

    //get population for the current municipality
    int population = getPopulationForMunicipality(municipality);

    // map population to a color based on ranges
    color populationColor = mapPopulationToColor(population);

    //get the area for the current municipality
    int area = getAreaForMunicipality(municipality);

    //map the area to a radius based on ranges
    float radius = mapAreaToRadius(area);

    //check if the mouse is over the current circle
    if (dist(mouseX, mouseY, cx, cy) < radius) {
      isMouseOverCircle = true;
      highlightedCircleIndex = i;
    }

    //municipality name
    textFont(createFont("Arial", 12));
    fill(255);
    textAlign(CENTER, CENTER);
    text(municipality, cx, cy + radius + 10);

    //draw a circle for each municipality with the population-based color
    fill(populationColor);
    ellipseMode(RADIUS);
    ellipse(cx, cy, radius, radius);
  }

  //highlight the circle when the mouse is over it
  if (isMouseOverCircle) {
    highlightCircle();
  }

  // This displays the latitude and longitude under the mouse cursor
  fill(255);
  String s2 = "(" + panZoomMap.screenXtoLongitude(mouseX) + ", " + panZoomMap.screenYtoLatitude(mouseY) + ")";
  text(s2, mouseX, mouseY);

  // Draw legend
  drawLegend();
  fill(255);
  textSize(12);
  textAlign(LEFT, TOP);
  text("Population and Area of Micronesian communities in the year 2010", 10, 10);
}

void mousePressed() {
  panZoomMap.mousePressed();
}

void mouseDragged() {
  panZoomMap.mouseDragged();
}

void mouseWheel(MouseEvent e) {
  panZoomMap.mouseWheel(e);
}

int getPopulationForMunicipality(String municipality) {
 
  TableRow populationRow = populationTable.findRow(municipality, "Municipality");

  if (populationRow != null) {
    return populationRow.getInt("Population 2010 Census");
  }
  return 0;
}

int getAreaForMunicipality(String municipality) {
  TableRow areaRow = populationTable.findRow(municipality, "Municipality");

  if (areaRow != null) {
    return areaRow.getInt("Area");
  }
  return 0;
}

float mapAreaToRadius(int area) {
  //differenct radius for different ranges
  if (area <= 500) {
    return 6;
  } else if (area <= 1500) {
    return 7;
  } else if (area <= 2500) {
    return 8;
  } else if (area <= 3500) {
    return 9;
  } else if (area <= 4500) {
    return 10;
  } else if (area <= 5500) {
    return 11;
  } else if (area <= 6500) {
    return 12;
  } else if (area <= 7500) {
    return 13;
  } else {
    return 15;
  }
}

color mapPopulationToColor(int population) {
 
  if (population <= 1500) {
    return color(224, 243, 219);
  } else if (population <= 3000) {
    return color(168, 221, 181);
  } else if (population <= 6000) {
    return color(78, 179, 211);
  } else {
    return color(8, 104, 172);
  }
}

void drawLegend() {
  int xStart = 50;
  int yStart = 50;
  int rectSize = 20;
  int circleSpacing = 30; 

//Legend for area
  textSize(12);
  fill(255);
  text("Area Size Legend (in sq.km)", xStart, yStart);
  yStart += 20;
  for (int i = 500; i <= 7500; i += 1000) {
    float radius = mapAreaToRadius(i);
    ellipse(xStart - 10, yStart, radius, radius); // Adjusted xStart for circles
    fill(255);
    text(i + " - " + (i + 1000), xStart + 50, yStart); // Adjusted xStart for text
    yStart += circleSpacing; // Use the circleSpacing variable here
  }

  // Legend for population
  yStart += 20; 
  fill(255);
  text("Population Legend", xStart, yStart);
  yStart += 20;
  int[] populationRanges = {0, 1500, 3000, 6000, Integer.MAX_VALUE};
  String[] populationLabels = {"0 - 1500", "1501 - 3000", "3001 - 6000", "6001 and above"};

  for (int i = 0; i < populationRanges.length - 1; i++) {
    float centerX = xStart + 15;
    float centerY = yStart + 10;
    float radius = 10;

    // Set color based on population range
    if (i == 0) {
      fill(color(224, 243, 219)); 
    } else if (i == 1) {
      fill(color(168, 221, 181)); 
    } else if (i == 2) {
      fill(color(78, 179, 211)); 
    } else {
      fill(color(8, 104, 172)); 
    }

    ellipse(centerX - 40, centerY, radius * 2, radius * 2);
    fill(255);
    text(populationLabels[i], xStart + 40, yStart);
    yStart += circleSpacing; 
  }
}

void displayAdditionalInfo(String municipality, int population, int area, float radius, float x, float y) {
  //function to display additional information when hovering
  fill(255);
  textAlign(CENTER, BOTTOM);
  text(municipality + "\nPopulation: " + population + "\nArea: " + area + " sq.km", x, y - radius - 15);
}

// function to highlight the circle under the mouse cursor
void highlightCircle() {
  if (highlightedCircleIndex != -1) {
    // Get the information for the highlighted circle
    String municipality = locationTable.getString(highlightedCircleIndex, "Municipality");
    float latitude = locationTable.getFloat(highlightedCircleIndex, "Latitude");
    float longitude = locationTable.getFloat(highlightedCircleIndex, "Longitude");
    float cx = panZoomMap.longitudeToScreenX(longitude);
    float cy = panZoomMap.latitudeToScreenY(latitude);
    int population = getPopulationForMunicipality(municipality);
    int area = getAreaForMunicipality(municipality);
    float radius = mapAreaToRadius(area);

    
    stroke(255, 100, 100); // Red stroke
    strokeWeight(2);
    noFill();
    ellipse(cx, cy, radius + 5, radius + 5); // Enlarge the circle
    displayAdditionalInfo(municipality, population, area, radius, cx, cy);
  }
}
