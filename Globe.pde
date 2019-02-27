import ComputationalGeometry.*;
import controlP5.*;

// Class for globe and global data construction and animation
class Globe {  
  
  // Class Variables
  IsoWrap earthShell;
  ControlP5 globeClassCP;
  ColorPicker globeClassPathColorPicker;    // UI for global path color
  color globeRingColor = color(0, 0, 0);
  Grid globeRing;
  
  float xOrigin = 0;
  float yOrigin = 0;
  float zOrigin = 0;
  float xPoint, yPoint, zPoint;
  float radius = 400;
  float radiusSmall = 200;
  float phi;
  float theta;
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Used to construct an instance of the Cog object.  The parameters passed through define the type of cog and its behavior
 
  Globe(IsoWrap isoWrap, ControlP5 ctrlP5){
    earthShell = isoWrap;
    globeClassCP = ctrlP5;
    
    globeRing = new Grid(globeRingColor, 5);
    
    PVector[] pts = new PVector[1000];
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
          eShell.addPt(pts[i]);
        }
      }
    }
    
    // Main Earth control panel
    
    // Controls the amount of paths visible in the Earth module
    // The data set "routes" includes a very large number of paths,
    // so this allows user to show only a few or a lot in the UI
    globeClassCP.addSlider("pathDensity")
       .setPosition(1460, 180)
       .setSize(260,20)
       .setRange(25,pathDensity)
       .setNumberOfTickMarks(3)
    ;  
    
    // Color picker for paths on Earth, part of main Earth control panel
    globeClassPathColorPicker = globeClassCP.addColorPicker("picker")
        .setPosition(1460, 100)
        .setColorValue(color(0, 255, 0, 255))
    ;
    
    
  }
   
 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  // *******************************************************
  // Render globe with all data sets
  void renderGlobe(){
    pathColor = globeClassPathColorPicker.getColorValue();  // Assign color picker color to pathColor variable
                                                            // Updates the path color in Earth control panel
                                                            // Needed to be included in draw() to update accordingly
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
       inRadarHotSpot = true;
    }
    else{
      rotateY(frameCount * 0.003);
      inRadarHotSpot = false;
    }
    earthModule.globeShell();
    earthModule.globeGeo(400, 10);
    earthModule.globePaths();
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
  void globeGeo(int radius, int offset){
    for(int i=0; i < cities.getRowCount(); i++){
       float latitude = cities.getFloat(i, "lat");
       float longitude = cities.getFloat(i, "lng");
       PVector aPt = sphereToCart(radians(latitude), radians(longitude));
       aPt.mult(radius);
       stroke(255);
       strokeWeight(1);
       point(aPt.x, aPt.y, aPt.z);
    }  
    for(int i=0; i < airports.getRowCount(); i++){
       float latitude = airports.getFloat(i, 6);
       float longitude = airports.getFloat(i, 7);
       PVector aPt = sphereToCart(radians(latitude), radians(longitude));
       aPt.mult(radius + offset);
       stroke(255, 0, 0);
       strokeWeight(1);
       point(aPt.x, aPt.y, aPt.z);
    }    
  }

  // *******************************************************
  // 
  void globePaths(){
    float lift = 1;
    PVector rise = new PVector(0, 0, 0);
    float projection = 30;
    //for(int i=0; i < routes.getRowCount(); i++){
    //for(int i=0; i < 3000; i++){
    for(int i=0; i < routes.getRowCount(); i+=pathDensity){  
       String source = routes.getString(i, 0);
       String destination = routes.getString(i, 1);
       TableRow srcIteration = airports.findRow(source, 4);
       TableRow destIteration = airports.findRow(destination, 4);
       if(srcIteration != null && destIteration != null){
           String aptCodeSrc = srcIteration.getString(4);
           String aptCodeDest = destIteration.getString(4);
           if(source.equals(aptCodeSrc) && destination.equals(aptCodeDest)){
               noFill();
               float srcLatitude = srcIteration.getFloat(6);
               float srcLongitude = srcIteration.getFloat(7);
               aptSource = sphereToCart(radians(srcLatitude), radians(srcLongitude));
               aptSource = aptSource.mult(410);
               PVector aptSourceAnchor = aptSource.cross(rise);
               float destLatitude = destIteration.getFloat(6);
               float destLongitude = destIteration.getFloat(7);
               aptDestination = sphereToCart(radians(destLatitude), radians(destLongitude));
               aptDestination = aptDestination.mult(410);
               PVector aptDestinationAnchor = aptDestination.cross(rise);
               float midLatitude = srcLatitude + ((destLatitude - srcLatitude) / 2);
               float midLongitude = srcLongitude + ((destLongitude - srcLongitude) / 2);
               PVector aptMidpoint = sphereToCart(radians(midLatitude), radians(midLongitude));
               aptMidpoint = aptMidpoint.mult(410 + projection);
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
    translate(width/2, height/2);
    fill(0);
    strokeWeight(1);
    stroke(255);
    ellipseMode(RADIUS);
    ellipse(0, 0, height/2, height/2);
    globeRing.radialGrid(height, 10, 10, 1, 1, 200, true);
    popMatrix();
  }
}  
