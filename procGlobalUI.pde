import ComputationalGeometry.*;
import controlP5.*;


IsoSkeleton skeleton;
IsoWrap wrap;
IsoWrap wrapSmall;

ControlP5 cp5;
ControlP5 cp6;
ControlP5 cp10;
ControlWindow controlWindow;
Canvas cc;
ColorPicker cp;

// Data sourced from:
// https://openflights.org/data.html
Table airports;

// Data sourced from:
// https://openflights.org/data.html
Table routes;

JSONArray airport;
JSONArray airRoutes;


// Data sourced from:
// https://simplemaps.com/data/world-cities
Table cities;

boolean extraTab = false;
PVector aptSource, aptDestination;



// MyCanvas, your Canvas render class
class MyCanvas extends Canvas {

  int x, y;
  int mx = 0;
  int my = 0;
  public void setup(PGraphics pg) {
    x = 100;
    y = 200;
  }  

  public void update(PApplet p) {
    mx = p.mouseX;
    my = p.mouseY;
  }

  public void draw(PGraphics pg) {
    

      pushMatrix();
      pg.fill(100);
      //pg.rect(mx-20, y-20, 240, 100);
      pg.rect(x, y, 240, 100);
      pg.fill(255);
      pg.text("This text is drawn by MyCanvas", x,y);
      popMatrix();
    

  }
}







void setup() {
  size(1920, 1080, P3D);
  frameRate(30);
  airports = loadTable("airports.csv");
  cities = loadTable("worldcities.csv", "header");
  routes = loadTable("routes.csv");
  airport = loadJSONArray("airport.json");
  airRoutes = loadJSONArray("routes.json");

  // Create iso-skeleton
  //skeleton = new IsoSkeleton(this);
  wrap = new IsoWrap(this);
  wrapSmall = new IsoWrap(this);
  cp5 = new ControlP5(this);
  cp10 = new ControlP5(this);
  
  float xOrigin = 0;
  float yOrigin = 0;
  float zOrigin = 0;
  float xPoint, yPoint, zPoint;
  float radius = 400;
  float radiusSmall = 200;
  float phi;
  float theta;





  

  // By default all controllers are stored inside Tab 'default' 
  // add a second tab with name 'extra'
  cp5.addTab("extra")
     .setSize(100,50)
     .setColorBackground(color(0, 160, 100))
     .setColorLabel(color(255))
     .setColorActive(color(255,128,0))
  ;

  // if you want to receive a controlEvent when
  // a  tab is clicked, use activeEvent(true)
  
  cp5.getTab("default")
     .setPosition(100,50)
     .activateEvent(true)
     .setLabel("my default tab")
     .setId(1)
  ;

  cp5.getTab("extra")
     .activateEvent(true)
     .setId(2)
     
     
  ;

  int sliderTicks1 = 98;
  cp5.addSlider("sliderTicks1")
     .setPosition(100, 140)
     .setSize(300,20)
     .setRange(0,sliderTicks1)
     .setNumberOfTickMarks(6)
  ;

  cp5.getController("sliderTicks1").moveTo("extra");
  //cp5.getController("slider").moveTo("global");
  
  // Tab 'global' is a tab that lies on top of any 
  // other tab and is always visible
  
  
  
  
  

  // Create points to make the network
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
        //skeleton.addEdge(pts[i], pts[j]);
        wrap.addPt(pts[i]);
      }
    }
  }
  
  
  
  
  // Create points to make the network
  PVector[] ptsSmall = new PVector[1000];
  for (int i=0; i<ptsSmall.length; i++) {
    phi = random(PI * -1, PI);
    theta = random(TWO_PI * -1, TWO_PI);
       xPoint = xOrigin + (radiusSmall * sin(phi) * cos(theta));
       yPoint = yOrigin + (radiusSmall * sin(phi) * sin(theta));
       zPoint = zOrigin + (radiusSmall * cos(phi));
       ptsSmall[i] = new PVector(xPoint, yPoint, zPoint);
  }  

  for (int i=0; i<ptsSmall.length; i++) {
    for (int j=i+1; j<ptsSmall.length; j++) {
      if (ptsSmall[i].dist( ptsSmall[j] ) < 50) {
        wrapSmall.addPt(ptsSmall[i]);
      }
    }
  }
  
  cp6 = new ControlP5(this);
  cp = cp6.addColorPicker("picker")
      .setPosition(1400, 100)
      .setColorValue(color(255, 128, 0, 128))
      ;
  
}

void draw() {
  background(0);
  pushMatrix();
  int bkgdGridXSpace = 20;
  int bkgdGridYSpace = 20;
  int bkgdGridXOrigin = 0;
  int bkgdGridYOrigin = 0;
  color bkgdGridColor = (50);
  strokeWeight(1);
  stroke(bkgdGridColor);
  translate(bkgdGridXOrigin, bkgdGridYSpace);
  // Horizontal Lines
  for(int i=0; i < height; i+=bkgdGridYSpace){
     line(0, i, width, i);
  }
  // Vertical Lines
  for(int i=0; i < width; i+=bkgdGridXSpace){
     line(i, 0, i, height);
  }
  popMatrix();
  //lights();  


  
  
  if(extraTab){
    // create a control window canvas and add it to
    // the previously created control window.  
    //cc = new MyCanvas();
    //cc.pre(); // use cc.post(); to draw on top of existing controllers.  
    //cp10.addCanvas(cc); // add the canvas to cp5 
  }
    
    
    
  //****************************************  
  // The following code is for the Matrix UI
  
  
  pushMatrix();
  translate(20, 0);
  noFill();
  stroke(0, 0, 0);
  smooth(4);
  
  //noLoop();
  
  int multiplier = 40;
  int numOfCurves = height / multiplier;
  int curveOffset = height / numOfCurves;
  
  drawCurveArray(numOfCurves, curveOffset, 200);
  drawCurveArray(numOfCurves, curveOffset, 150);
  drawCurveArray(numOfCurves, curveOffset, 100);
  drawCurveArray(numOfCurves, curveOffset, 50);     
  popMatrix();  
    
    
    
    
  //****************************************    

  pushMatrix();
  noStroke();
  fill(0, 0, 0, 255);
  translate(width / 6, height / 2);
  //shearY(PI*8/9);
  rotateY(frameCount*0.006 + 0.003);
  //wrapSmall.plot();
  //globe(200, 0);
  popMatrix();    

  

  
  

  
  pushMatrix();
  translate(width/2, height/2);
  //rotateX(frameCount*0.001);
  rotateX(mouseY*-0.003);
  rotateY(frameCount*0.001 + mouseX*0.003);
  
  //float zm = 450;
  //float sp = 0.01 * frameCount;
  //camera(zm * cos(sp), zm * sin(sp), zm, 0, 0, 0, 0, 0, -1);
  //camera(zm * cos(sp), zm * sin(sp), zm, 0, 0, 0, 0, 0, -1);
  
  noStroke();
  stroke(255);
  noFill();
  //skeleton.plot(.05, 0);  // Thickness as parameter
  noStroke();
  fill(0, 0, 0, 255);
  wrap.plot();
  globe(400, 10);
  globePaths();
  popMatrix();
  

  
}


void globe(int radius, int offset){
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




void globePaths(){
  float lift = 1;
  PVector rise = new PVector(0, 0, 0);
  float projection = 30;
  //for(int i=0; i < routes.getRowCount(); i++){
  for(int i=0; i < 3000; i++){  
     String source = routes.getString(i, 0);
     String destination = routes.getString(i, 1);
     println(source + " , " + destination);
     TableRow srcIteration = airports.findRow(source, 4);
     TableRow destIteration = airports.findRow(destination, 4);
     println(srcIteration + " , " + destIteration);
     if(srcIteration != null && destIteration != null){
         String aptCodeSrc = srcIteration.getString(4);
         String aptCodeDest = destIteration.getString(4);
         println(aptCodeSrc + " , " + aptCodeDest);
         if(source.equals(aptCodeSrc) && destination.equals(aptCodeDest)){
             noFill();
             float srcLatitude = srcIteration.getFloat(6);
             float srcLongitude = srcIteration.getFloat(7);
             aptSource = sphereToCart(radians(srcLatitude), radians(srcLongitude));
             aptSource = aptSource.mult(410);
             PVector aptSourceAnchor = aptSource.cross(rise);
             //PVector aptSourceAnchor = aptSource.cross(rise);
             //aptSource.mult(lift);
             float destLatitude = destIteration.getFloat(6);
             float destLongitude = destIteration.getFloat(7);
             aptDestination = sphereToCart(radians(destLatitude), radians(destLongitude));
             aptDestination = aptDestination.mult(410);
             PVector aptDestinationAnchor = aptDestination.cross(rise);
             //PVector aptDestinationAnchor = aptDestination.cross(rise);
             //aptDestination.mult(lift);
             float midLatitude = srcLatitude + ((destLatitude - srcLatitude) / 2);
             float midLongitude = srcLongitude + ((destLongitude - srcLongitude) / 2);
             PVector aptMidpoint = sphereToCart(radians(midLatitude), radians(midLongitude));
             aptMidpoint = aptMidpoint.mult(410 + projection);
             //stroke(0, 255, 0);
             stroke(cp.getColorValue());
             strokeWeight(1);
             //bezierDetail(50);
             //bezier(aptSource.x, aptSource.y, aptSource.z, aptSourceAnchor.x, aptSourceAnchor.y, aptSourceAnchor.z, aptMidpoint.x, aptMidpoint.y, aptMidpoint.z, aptDestinationAnchor.x, aptDestinationAnchor.y, aptDestinationAnchor.z, aptDestination.x, aptDestination.y, aptDestination.z);
             beginShape();
               
               curveVertex(aptSourceAnchor.x, aptSourceAnchor.y, aptSourceAnchor.z);
               curveVertex(aptSource.x, aptSource.y, aptSource.z);
               curveVertex(aptMidpoint.x, aptMidpoint.y, aptMidpoint.z);
               curveVertex(aptDestination.x, aptDestination.y, aptDestination.z);
               curveVertex(aptDestinationAnchor.x, aptDestinationAnchor.y, aptDestinationAnchor.z);
               
             endShape();
             println(i);
             println(source + " , " + destination);
             println(srcIteration + " , " + destIteration);
             println(destLatitude + " , " + destLongitude);
             print(aptSource + " , " + aptSourceAnchor);
             //println(aptSource);
             float dist = PVector.dist(aptSource, aptDestination);
             //println(dist); 
         }        
     }
  }
}





PVector sphereToCart(float lat, float lon){
  // Algorithms for mapping spherical coordinates to three-dimensional Cartesian
  // coordinates derived from the following resource link:
  // https://www.mathworks.com/help/matlab/ref/sph2cart.html
  // Formulas from this reference were then converted to align elevation to latitude
  // and azimuth to longitude
  PVector vNew = new PVector(-cos(lat) * cos(lon), -sin(lat), cos(lat) * sin(lon));
  return vNew;
}




void keyPressed() {
  switch(key) {
    case('1'):
    // method A to change color
    cp.setArrayValue(new float[] {0, 255, 0, 255});
    break;
    case('2'):
    // method B to change color
    cp.setColorValue(color(255, 0, 0, 255));
    break;
  }
}




// The following functions are for the Matrix UI

void drawCurveArray(int numOfCurves, int offset, int alpha){
  for(int i=0; i < numOfCurves; i++){
    pushMatrix();
    translate(0, (i * offset));
    drawCurve(alpha);
    popMatrix();
  }
  
}

void drawCurve(int alpha){
  int scalar = 10;
  int arrayLength = (width/4)/scalar + scalar;
  int shift;
  
  noFill();
  stroke(0, 0, 0);
  noStroke();
  strokeWeight(0.3);
  
  float xList[] = new float[arrayLength];
  float yList[] = new float[arrayLength];
  
  for(int i=0; i < arrayLength; i++){
     shift = int(random(0, 2));
     xList[i] = scalar * i;
     yList[i] = scalar * (sin(i) + shift);
  }
  beginShape();
  //curveVertex(0, 0);
  //curveVertex(0, 0);
  curveVertex(xList[0], yList[0]);
  curveVertex(xList[0], yList[0]);
  
  for(int i=1; i < arrayLength; i++){
     curveVertex(xList[i], yList[i]);
     println(xList[i], yList[i]);
  }

  
  
  curveVertex(xList[xList.length-1], yList[yList.length-1]);
  println(xList[xList.length-1], yList[yList.length-1]);
  
  endShape();
  
  
  
  char[] alphabet = new char[26];
  for(int i = 0; i < 26; i++){
    alphabet[i] = (char)(65 + i);
  }
  
  char[] glyph = new char[95];
  for(int i = 0; i < 95; i++){
    glyph[i] = (char)(33 + i);
  }
  
  for(int i=0; i < arrayLength; i++){
     if(yList[i] > yList[0]){
       noStroke();
       fill(153, 0, 0);
       noFill();
       ellipse(xList[i], yList[i], 3, 3);
       
       textSize(10);
       textAlign(CENTER, CENTER);
       fill(153, 0, 0);
       
       fill(39, 255, 8, alpha);
       text(glyph[int(random(0, 95))], xList[i], yList[i]);
       
     }
  }
}
