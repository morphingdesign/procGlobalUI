// Futuristic HUD
// by Hans Palacios
// for SCAD ITGM 719 Course
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/** PROJECT DESCRIPTION
    Add description here
    
    --------------------------------------------------------------------------------
    REFERENCED CODE
    Code referenced from online sources are identified with comments and delineated
    with the following syntax:
    
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
        Referenced code located here along with cited web link.
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
        
    --------------------------------------------------------------------------------
    REFERENCED MATH & DATA
    Math and data referenced from online sources are identified with comments and 
    delineated with the following syntax:
    
        // +++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Referenced math formulas and data located here along with cited web link.
        // +++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
            
    --------------------------------------------------------------------------------    
    IMAGES
    
    
**/

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

// Processing Libraries
/**   
**/

import ComputationalGeometry.*;
import controlP5.*;

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

// Global variables
/** The majority of these global variables are used and defined to creat consistency 
    throughout the sketch and its contents built from various classes.  
**/

IsoSkeleton attractorGeo;    // Used to pass through IsoSkeleton
Radar radarSys;              // into Attractor class
Grid bkgdGrid;
Globe earth;

ControlP5 arsenalCP;         // Used to pass through ControlP5
Arsenal arsenalCtrlPanel;    // into Arsenal class

IsoSkeleton skeleton;
IsoWrap wrap;
IsoWrap wrapSmall;

ControlP5 cp5;
ControlP5 cp6;
ControlP5 cp10;
ControlWindow controlWindow;
Canvas cc;

ColorPicker cp;              // UI for global path color

TextStream backText;         // Scrolling text background 

int pathDensity = 100;
int bkgdGridSpace = 20;

color pathColor;            // Color for paths around globe
color attractorColor;       // Color for paths used for strange attractor
color bkgdGridColor = (50);

boolean extraTab = false;
PVector aptSource, aptDestination;

String imgFileNameBase = "images/drone (";
String imgFileNameEnd = ").png";
PImage photo[] = new PImage[48];

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Data

// +++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Data for airports and routes sourced from: https://openflights.org/data.html
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++
Table airports;
Table routes;

// +++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Data for cities sourced from: https://simplemaps.com/data/world-cities
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++
Table cities;

// +++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Data for armory sourced from: 
// https://en.wikipedia.org/wiki/General_Atomics_MQ-9_Reaper
// https://www.af.mil/About-Us/Fact-Sheets/Display/Article/104470/mq-9-reaper/
// https://www.globalsecurity.org/military/systems/aircraft/mq-9-specs.htm
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++
JSONObject armory;

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




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
      pg.rect(x, y, 240, 100);
      pg.fill(255);
      pg.text("This text is drawn by MyCanvas", x,y);
      popMatrix();
  }
}





// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

void setup() {
  size(1920, 1080, P3D);
  frameRate(30);
  airports = loadTable("airports.csv");
  cities = loadTable("worldcities.csv", "header");
  routes = loadTable("routes.csv");
  armory = loadJSONObject("armory.json");

  for(int i=0; i < photo.length ; i++){
     photo[i] = loadImage(imgFileNameBase + (i + 1) + imgFileNameEnd);
  }

  // Create iso-skeleton
  //skeleton = new IsoSkeleton(this);
  attractorGeo = new IsoSkeleton(this);
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

  bkgdGrid = new Grid(bkgdGridColor, bkgdGridSpace);

  backText = new TextStream();                // Setup scrolling back text 
  
  radarSys = new Radar(attractorGeo);
  attractorColor = color(0, 255, 0, 20);

  //int viewNumber = 0;

  arsenalCP = new ControlP5(this);
  arsenalCtrlPanel = new Arsenal(arsenalCP, "test");



  earth = new Globe();

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
      .setPosition(1460, 100)
      .setColorValue(color(0, 255, 0, 255))
      ;
      
  //int sliderTicks1 = 100;
  //pathDensity = sliderTicks1;
  //cp5.addSlider("sliderTicks1")
  cp5.addSlider("pathDensity")
     .setPosition(1460, 180)
     .setSize(260,20)
     .setRange(25,pathDensity)
     .setNumberOfTickMarks(3)
  ;    

  cp5.getController("pathDensity").moveTo("extra");
  //cp5.getController("slider").moveTo("global");
  
  // Tab 'global' is a tab that lies on top of any 
  // other tab and is always visible
  
  
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

void draw() {
  background(0);
  
  // *******************************************************
  // Background grid
  bkgdGrid.rectGrid();            // Figure out why it appears to be drawn on top of everything
  // *******************************************************
   

 
  // *******************************************************
  // Variable management
  pathColor = cp.getColorValue();  // Assign color picker color to pathColor variable
  // *******************************************************
 
  // ******************************************************* 
  //Background content
  radarSys.posRadar();       // Draws the strange attractor in background
  backText.drawStream(40);    // Draws the text stream in background
  // *******************************************************    

  arsenalCtrlPanel.dataStream();
  arsenalCtrlPanel.viewport();
  

  if(extraTab){
    // create a control window canvas and add it to
    // the previously created control window.  
    //cc = new MyCanvas();
    //cc.pre(); // use cc.post(); to draw on top of existing controllers.  
    //cp10.addCanvas(cc); // add the canvas to cp5 
  }  

  pushMatrix();
  earth.drawSphereMask();
  translate(width/2, height/2);
  
  //rotateX(frameCount*0.001);
  //rotateX(mouseY*-0.003);
  if(mouseX > width * 0.25 &&  mouseX < width * 0.75 && mouseY > height * 0.25 && mouseY < height * 0.75){
     rotateY(frameCount * 0.003 + mouseX * 0.003);
     //if(mouseY > height * 0.25 && mouseY < height * 0.75){
        rotateX(mouseY * 0.001);
     //}
  }
  else{
    rotateY(frameCount * 0.003);
  }
  
  
  
  //rotateY(frameCount*0.003 + mouseX*0.003);
  
  
  noStroke();
  stroke(255);
  noFill();
  //skeleton.plot(.05, 0);  // Thickness as parameter
  noStroke();
  fill(0, 0, 0, 255);
  
  wrap.plot();
  
  earth.drawGlobeGeo(400, 10);
  earth.globePaths();
  popMatrix();
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
