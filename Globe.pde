// Class for globe, global data, and globe control panel construction and animation
class Globe {  
  
  // Class Variables
  Grid globeRing;                          // Used to create ring border geometry around globe
  IsoWrap earthShell;                      // Used to pass through IsoWrap into this class
  ControlP5 globeClassCP;                  // Used to pass through Control P5 into this class
  Textlabel globeClassTextTitle;           // Title text for UI control panel
  Textlabel globeClassTextDesc;            // Description text for UI control panel
  ColorPicker globeClassCityColorPicker;   // UI control for global cities color
  ColorPicker globeClassAptColorPicker;    // UI control for global airports color
  ColorPicker globeClassPathColorPicker;   // UI control for global path color
  CheckBox globeClassDataCheckBox;         // UI control for global data visibility
  Knob globeClassScaleKnob;                // UI control for global scale
  Knob globeClassDataOffsetKnob;           // UI control for global data offset distance
  Knob globeClassPathOffsetKnob;           // UI control for global path offset distance
  Knob globeClassPathDetailKnob;           // UI control for global path density
  PVector[] pts = new PVector[1000];       // Declare vector array for use with globe mesh
  float radius = 400;                      // Radius of globe
  float offset = 0;                        // Perpendicular distance from globe surface for airports
  float projection = 30;                   // Perpendicular distance from globe surface for flight paths
  float dataPtScale = 1;                   // Sets the stroke weight for data points around globe
  float knobYPos = 290;                    // Y-position for consistent placement of all CtrlP5 knobs
  String title = ("GLOBAL VIEW CONTROL PANEL");                            // Title text
  String description = ("Visualize global network of airports and flight paths using"
                       + "\n the following control panel and settings.");  // Description text
    
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Create sphere mesh, global data points, boundary rings, and globe control panel
  Globe(IsoWrap isoWrap, ControlP5 ctrlP5){
    earthShell = isoWrap;                  // Pass through IsoWrap into this class
    globeClassCP = ctrlP5;                 // Pass through ControlP5 into this class
    globeRing = new Grid();                // Construct new Grid() for creating ring geometry
    
    // Loop to iteratively define coordinates for each vector used for creating sphere mesh
    for (int i=0; i<pts.length; i++) {
      float xOrigin = 0;                       // Sets centerpoint x-value of globe to 0  
      float yOrigin = 0;                       // Sets centerpoint y-value of globe to 0
      float zOrigin = 0;                       // Sets centerpoint z-value of globe to 0
      float xPoint, yPoint, zPoint;            // Declare x-, y-, z-values for use in conversion formula
      
      // +++++++++++++++++++++++++++++++++++++++++++++++++++++++
      // Formula for converting spherical to Cartesian coordinates source citation below:
      // https://en.wikipedia.org/wiki/Spherical_coordinate_system
      // Formula is used to create the x, y, z points using radius, theta, and phi
      float theta = random(PI * -1, PI);       // Random theta values derived from between range
      float phi = random(TWO_PI * -1, TWO_PI); // Random phi values derived from between range
      xPoint = xOrigin + (radius * sin(theta) * cos(phi));
      yPoint = yOrigin + (radius * sin(theta) * sin(phi));
      zPoint = zOrigin + (radius * cos(theta));
      // +++++++++++++++++++++++++++++++++++++++++++++++++++++++
      
      pts[i] = new PVector(xPoint, yPoint, zPoint);  // Add vectors to array using created x, y, z values
    }  
    for (int i=0; i<pts.length; i++) {          
      for (int j=i+1; j<pts.length; j++) {     
        if (pts[i].dist( pts[j] ) < 50) {      // Loop & nested loop to add vectors from array to the
          earthShell.addPt(pts[i]);            // ....addPt method used to prepare sphere mesh
        }
      }
    }    
    
    // Globe control panel using ControlP5 elements
    globeClassTextTitle = globeClassCP.addTextlabel("titleText")
        .setPosition(1560, 40)
        .setText(title)
        .setColorValue(greenSolid)
        .setVisible(false)
    ;
    globeClassTextDesc = globeClassCP.addTextlabel("descText")
        .setPosition(1560, 52)
        .setText(description)
        .setColorValue(greenSolid)
        .setVisible(false)
    ;
    globeClassDataCheckBox = globeClassCP.addCheckBox("checkBox")
        .setPosition(1560, 80)
        .setColorBackground(whiteSolid)
        .setColorForeground(redSolid)
        .setColorActive(greenSolid)
        .setColorLabel(greenSolid)
        .setSize(20, 20)
        .setItemsPerRow(3)
        .setSpacingColumn(60)
        .setSpacingRow(20)
        .addItem("Airports", 0)
        .addItem("Flight Paths", 1)
        .activate(1)
        .setVisible(false)
    ;          
    globeClassScaleKnob = globeClassCP.addKnob("dataScale")
        .setPosition(1560, knobYPos)
        .setRange(0,5)
        .setValue(1)
        .setRadius(30)
        .setNumberOfTickMarks(5)
        .setTickMarkLength(2)
        .snapToTickMarks(true)
        .setColorForeground(whiteSolid)
        .setColorBackground(blackSolid)
        .setColorActive(redSolid)
        .setColorLabel(greenSolid)
        .setDragDirection(Knob.HORIZONTAL)
        .setLabel("City Scale")
        .setVisible(false)
    ; 
    globeClassDataOffsetKnob = globeClassCP.addKnob("dataOffset")
        .setPosition(1640, knobYPos)
        .setRange(0,20)
        .setValue(10)
        .setRadius(30)
        .setNumberOfTickMarks(5)
        .setTickMarkLength(2)
        .snapToTickMarks(false)
        .setColorForeground(whiteSolid)
        .setColorBackground(blackSolid)
        .setColorActive(redSolid)
        .setColorLabel(greenSolid)
        .setDragDirection(Knob.HORIZONTAL)
        .setLabel("Data Offset")
        .setVisible(false)
    ;  
    globeClassPathOffsetKnob = globeClassCP.addKnob("pathOffset")
        .setPosition(1720, knobYPos)
        .setRange(10,40)
        .setValue(30)
        .setRadius(30)
        .setNumberOfTickMarks(5)
        .setTickMarkLength(2)
        .snapToTickMarks(false)
        .setColorForeground(whiteSolid)
        .setColorBackground(blackSolid)
        .setColorActive(redSolid)
        .setColorLabel(greenSolid)
        .setDragDirection(Knob.HORIZONTAL)
        .setLabel("Path Projection")
        .setVisible(false)
    ; 
    // Controls the amount of paths visible in the Earth module
    // The data set "routes" includes a very large number of paths,
    // so this allows user to show only a few or a lot in the UI
    globeClassPathDetailKnob = globeClassCP.addKnob("pathDensity")
       .setPosition(1800, knobYPos)
       .setRange(25,pathDensity)
       .setValue(100)
       .setRadius(30)
       .setNumberOfTickMarks(5)
       .setTickMarkLength(2)
       .snapToTickMarks(false)
       .setColorForeground(whiteSolid)
       .setColorBackground(blackSolid)
       .setColorActive(redSolid)
       .setColorLabel(greenSolid)
       .setDragDirection(Knob.HORIZONTAL)
       .setLabel("Path Detail")
       .setVisible(false)
    ;  
    // Color picker for paths on Earth, part of main Earth control panel
    globeClassPathColorPicker = globeClassCP.addColorPicker("pathPicker")
        .setPosition(1560, 230)
        .setSize(260, 60)
        .setColorLabel(greenSolid)
        .setColorValue(color(0, 255, 0, 100))      // Defines the starting color of the data paths
        .showBar()
        .setBarHeight(10)
        .enableCollapse()
        .close()
        .setLabel("Flight Path Color Selector")
        .setVisible(false)
    ;    
    // Color picker for paths on Earth, part of main Earth control panel
    globeClassAptColorPicker = globeClassCP.addColorPicker("aptPicker")
        .setPosition(1560, 175)
        .setSize(260, 60)
        .setColorLabel(greenSolid)
        .setColorValue(color(255, 0, 0, 255))      // Defines the starting color of the airport locations
        .showBar()
        .setBarHeight(10)
        .enableCollapse()
        .close()
        .setLabel("Airport Location Color Selector")
        .setVisible(false)
    ;      
    // Color picker for paths on Earth, part of main Earth control panel
    globeClassCityColorPicker = globeClassCP.addColorPicker("cityPicker")
        .setPosition(1560, 120)
        .setSize(260, 60)
        .setColorLabel(greenSolid)
        .setColorValue(color(255, 255, 255, 255))      // Defines the starting color of the cities
        .showBar()
        .setBarHeight(10)
        .enableCollapse()
        .close()
        .setLabel("City Location Color Selector")
        .setVisible(false)
    ;
  }
 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  // *******************************************************
  // Render globe with all data sets
  void renderGlobe(){
    pushMatrix();
    earthModule.drawSphereMask();
    translate(width/2, height/2);
    
    hotSpotStartX = width/2 - ctrTopPos;
    hotSpotStartY = height/2 - ctrSidePos;
    hotSpotEndX = width/2 + ctrTopPos;
    hotSpotEndY = height/2 + ctrSidePos;
    
    if(mouseX > hotSpotStartX &&  mouseX < hotSpotEndX && mouseY > hotSpotStartY && mouseY < hotSpotEndY){  
       rotateY(frameCount * 0.003 + mouseX * 0.003);
       rotateX(mouseY * 0.003);
       inGlobalHotSpot = true;
    }
    else{
      rotateY(frameCount * 0.003);
      inGlobalHotSpot = false;
    }
    
    dataPtScale = globeClassScaleKnob.getValue();
    offset = globeClassDataOffsetKnob.getValue();
    projection = globeClassPathOffsetKnob.getValue();
    pathColor = globeClassPathColorPicker.getColorValue();  // Assign color picker color to pathColor variable
                                                            // Updates the path color in Earth control panel
                                                            // Needed to be included in draw() to update accordingly
    cityColor = globeClassCityColorPicker.getColorValue();
    aptColor = globeClassAptColorPicker.getColorValue();
    
    earthModule.globeShell();
    earthModule.globeGeo();
    
    if(globeClassDataCheckBox.getArrayValue(0) == 1){
       earthModule.globeData();  
    }
    
    if(globeClassDataCheckBox.getArrayValue(1) == 1){
       earthModule.globePaths();
    }
    
    popMatrix();
  }
  
  // *******************************************************
  // 
  void viewport(){
     globeClassTextTitle.setVisible(true);
     globeClassTextDesc.setVisible(true);
     globeClassCityColorPicker.setVisible(true);
     globeClassAptColorPicker.setVisible(true);
     globeClassPathColorPicker.setVisible(true);
     globeClassDataCheckBox.setVisible(true);
     globeClassScaleKnob.setVisible(true);
     globeClassDataOffsetKnob.setVisible(true);
     globeClassPathOffsetKnob.setVisible(true);
     globeClassPathDetailKnob.setVisible(true);
    
     pushMatrix();
     translate(1540, 20);
     fill(blackSolid);
     stroke(greenSolid);
     strokeWeight(1);
     rect(0, 0, 340, 360);
     popMatrix();
  }
  
  
  // *******************************************************
  // 
  void globeShell(){
    noFill();
    noStroke();
    fill(0, 0, 0, 255);
    eShell.plot();
  }
  
  // *******************************************************
  // 
  void globeGeo(){
    for(int i=0; i < cities.getRowCount(); i++){
       float latitude = cities.getFloat(i, "lat");
       float longitude = cities.getFloat(i, "lng");
       PVector aPt = sphereToCart(radians(latitude), radians(longitude));
       aPt.mult(radius);
       stroke(cityColor);
       strokeWeight(dataPtScale);
       point(aPt.x, aPt.y, aPt.z);
    }  
  }

  // *******************************************************
  // 
  void globeData(){
    for(int i=0; i < airports.getRowCount(); i++){
       float latitude = airports.getFloat(i, 6);
       float longitude = airports.getFloat(i, 7);
       PVector aPt = sphereToCart(radians(latitude), radians(longitude));
       aPt.mult(radius + offset);
       stroke(aptColor);
       strokeWeight(1);
       point(aPt.x, aPt.y, aPt.z);
    }   
  }
    
  // *******************************************************
  // 
  void globePaths(){
    PVector rise = new PVector(0, 0, 0);
    for(int i=0; i < routes.getRowCount(); i+=pathDensity){  
       String source = routes.getString(i, 0);
       String destination = routes.getString(i, 1);
       TableRow srcIteration = airports.findRow(source, 4);
       TableRow destIteration = airports.findRow(destination, 4);
       if(srcIteration != null && destIteration != null){          // Check to verify data line item is valid
           String aptCodeSrc = srcIteration.getString(4);
           String aptCodeDest = destIteration.getString(4);
           if(source.equals(aptCodeSrc) && destination.equals(aptCodeDest)){
               noFill();
               float srcLatitude = srcIteration.getFloat(6);
               float srcLongitude = srcIteration.getFloat(7);
               aptSource = sphereToCart(radians(srcLatitude), radians(srcLongitude));
               aptSource = aptSource.mult(radius + offset);
               PVector aptSourceAnchor = aptSource.cross(rise);
               float destLatitude = destIteration.getFloat(6);
               float destLongitude = destIteration.getFloat(7);
               aptDestination = sphereToCart(radians(destLatitude), radians(destLongitude));
               aptDestination = aptDestination.mult(410);
               PVector aptDestinationAnchor = aptDestination.cross(rise);
               float midLatitude = srcLatitude + ((destLatitude - srcLatitude) / 2);
               float midLongitude = srcLongitude + ((destLongitude - srcLongitude) / 2);
               PVector aptMidpoint = sphereToCart(radians(midLatitude), radians(midLongitude));
               aptMidpoint = aptMidpoint.mult(radius + offset + projection);
               stroke(pathColor);
               strokeWeight(1);
               beginShape();
                 curveVertex(aptSourceAnchor.x, aptSourceAnchor.y, aptSourceAnchor.z);
                 curveVertex(aptSource.x, aptSource.y, aptSource.z);
                 curveVertex(aptMidpoint.x, aptMidpoint.y, aptMidpoint.z);
                 curveVertex(aptDestination.x, aptDestination.y, aptDestination.z);
                 curveVertex(aptDestinationAnchor.x, aptDestinationAnchor.y, aptDestinationAnchor.z);
               endShape();
           }        
       }
    }
  }

  // *******************************************************
  // Returns vector from latitute/longitude conversion to Cartesian coordinate system
  PVector sphereToCart(float lat, float lon){
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Algorithms for mapping latitude/longitude coordinates to three-dimensional Cartesian
    // coordinates derived from the following resource link:
    // https://www.mathworks.com/help/matlab/ref/sph2cart.html
    // Formulas from this reference were then converted to align elevation to latitude and
    // azimuth to longitude
    PVector vNew = new PVector(-cos(lat) * cos(lon), -sin(lat), cos(lat) * sin(lon));
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++
    return vNew;    // Returns vector as output for this method
  }
  
  // *******************************************************
  // 
  void drawSphereMask(){
    pushMatrix();
    translate(width/2, height/2, 0);
    fill(0);
    strokeWeight(1);
    stroke(255, 100);
    ellipseMode(RADIUS);
    ellipse(0, 0, height/2, height/2);
    globeRing.radialGrid(height-10, -5, 10, 1, 1, whiteSolid, 100, true);
    globeRing.radialGrid(height-20, -5, 5, 1, 1, whiteSolid, 100, true);
    globeRing.radialGrid(height-20, 5, 1, 1, 1, whiteSolid, 100, true);
    popMatrix();
  }
  
  // *******************************************************
  // 
    
}  
