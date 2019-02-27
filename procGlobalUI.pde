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
import ComputationalGeometry.*;
import controlP5.*;

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

// Global variables
/** The majority of these global variables are used and defined to creat consistency 
    throughout the sketch and its contents built from various classes.  
**/

Grid bkgdGrid;               // Square grid background
TextStream backText;         // Scrolling text background 
Radar radarModule;           // Radar system
IsoWrap eShell;              // Used to pass through IsoWrap into Globe class
Globe earthModule;           // Earth with data points and paths
ControlP5 earthCP;           // Earth control panel
//ColorPicker earthPathColorPicker;  // UI for global path color
ControlP5 arsenalCP;         // Used to pass through ControlP5 into Arsenal class
Arsenal arsenalModule;       // Arsenal data and viewport
Screen hudScreen;            // HUD graphics in foreground

int pathDensity = 100;
int bkgdGridSpace = 20;

int ctrTopPos = 490;
int ctrSidePos = 360;
int hotSpotStartX;
int hotSpotStartY;
int hotSpotEndX;
int hotSpotEndY;
boolean inRadarHotSpot = false;

// Color scheme
color greenSolid = color(0, 255, 0);
color redSolid = color(255, 0, 0);
color whiteSolid = color(255);

color pathColor;                              // Color for paths around globe
color bkgdGridColor = (50);

PVector aptSource, aptDestination;

String imgFileNameBase = "images/drone (";
String imgFileNameEnd = ").png";
PImage photo[] = new PImage[48];

PFont monoFont;
PFont playFont;

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
JSONArray armory;

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

void setup() {
  size(1920, 1080, P3D);
  frameRate(30);
  
  // *******************************************************
  // Load data sets used in globe and arsenal classes
  airports = loadTable("airports.csv");
  cities = loadTable("worldcities.csv", "header");
  routes = loadTable("routes.csv");
  armory = loadJSONArray("armory.json");
  
  // *******************************************************
  // Load unique fonts used in arsenal and screen classes
  monoFont = createFont("fonts/PT_Mono/PTM55FT.ttf", 14);
  playFont = createFont("fonts/Play/Play-Bold.ttf", 24);
  
  // *******************************************************
  // Load images used in arsenal class
  for(int i=0; i < photo.length ; i++){
     photo[i] = loadImage(imgFileNameBase + (i + 1) + imgFileNameEnd);
  }
 
  // ******************************************************* 
  bkgdGrid = new Grid(bkgdGridColor, bkgdGridSpace);
  backText = new TextStream(); 
  radarModule = new Radar();
  arsenalCP = new ControlP5(this);
  arsenalModule = new Arsenal(arsenalCP); 
  eShell = new IsoWrap(this);
  earthCP = new ControlP5(this);
  earthModule = new Globe(eShell, earthCP);
  hudScreen = new Screen();
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

void draw() {
  background(0);
  
  // *******************************************************
  // Background content
  bkgdGrid.rectGrid();               // Square grid
  backText.renderStream(40);         // Text stream
  
  // *******************************************************    
  // Radar system
  radarModule.renderRadar();     
     
  // *******************************************************   
  // Arsenal data and viewport panels
  arsenalModule.dataStreamBox();     // Text box with data
  arsenalModule.viewport();          // Scrollable 3D view
  
  // *******************************************************  
  // Earth and data points and paths
  earthModule.renderGlobe();
  
  // *******************************************************  
  // HUD screen graphics
  hudScreen.renderGraphics();
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
