// Class for globe and global data construction and animation
class Globe {  
  
  // Class Variables
  IsoWrap earthShell;
  
  ControlP5 globeClassCP;
  Textlabel globeClassTextTitle;            // Title text
  Textlabel globeClassTextDesc;             // Description text
  ColorPicker globeClassCityColorPicker;    // UI for global cities color
  ColorPicker globeClassAptColorPicker;     // UI for global airports color
  ColorPicker globeClassPathColorPicker;    // UI for global path color
  CheckBox globeClassDataCheckBox;          // UI for global data visibility
  Knob globeClassScaleKnob;                 // UI for global scale
  Knob globeClassDataOffsetKnob;            // UI for global data offset distance
  Knob globeClassPathOffsetKnob;            // UI for global path offset distance
  Knob globeClassPathDetailKnob;            // UI for global path density
  
  Grid globeRing;
  
  PVector[] pts = new PVector[1000];
  
  float xOrigin = 0;
  float yOrigin = 0;
  float zOrigin = 0;
  float xPoint, yPoint, zPoint;
  float radius = 400;
  float offset = 0;
  float projection = 30;
  float dataPtScale = 1;
  float radiusSmall = 200;
  float phi;
  float theta;
  
  float knobYPos = 330;
  
  String title = ("GLOBAL VIEW CONTROL PANEL");
  String description = ("Visualize global network of airports and flight paths using \n the following control panel and settings.");
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // 
 
  Globe(IsoWrap isoWrap, ControlP5 ctrlP5){
    earthShell = isoWrap;
    globeClassCP = ctrlP5;
    globeRing = new Grid();
    
    //PVector[] pts = new PVector[1000];
    for (int i=0; i<pts.length; i++) {
      phi = random(PI * -1, PI);
      theta = random(TWO_PI * -1, TWO_PI);
         xPoint = xOrigin + (radius * sin(phi) * cos(theta));
         yPoint = yOrigin + (radius * sin(phi) * sin(theta));
         zPoint = zOrigin + (radius * cos(phi));
         //println(xPoint + " , " + yPoint + " , " + zPoint);
         pts[i] = new PVector(xPoint, yPoint, zPoint);
    }  
    for (int i=0; i<pts.length; i++) {
      for (int j=i+1; j<pts.length; j++) {
        if (pts[i].dist( pts[j] ) < 50) {
          earthShell.addPt(pts[i]);
        }
      }
    }    
    
    // Main Earth control panel
    
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

    // 
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
    

    
    //
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
        .setPosition(1560, 270)
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
        .setPosition(1560, 195)
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
       rotateX(mouseY * 0.001);
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
     rect(0, 0, 340, 400);
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
    float lift = 1;
    PVector rise = new PVector(0, 0, 0);
    //for(int i=0; i < routes.getRowCount(); i++){
    //for(int i=0; i < 3000; i++){
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
               float dist = PVector.dist(aptSource, aptDestination);
           }        
       }
    }
  }

  // *******************************************************
  // 
  PVector sphereToCart(float lat, float lon){
    // Algorithms for mapping spherical coordinates to three-dimensional Cartesian
    // coordinates derived from the following resource link:
    // https://www.mathworks.com/help/matlab/ref/sph2cart.html
    // Formulas from this reference were then converted to align elevation to latitude
    // and azimuth to longitude
    PVector vNew = new PVector(-cos(lat) * cos(lon), -sin(lat), cos(lat) * sin(lon));
    return vNew;
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
