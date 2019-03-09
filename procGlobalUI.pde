// Futuristic HUD
// by Hans Palacios
// for SCAD ITGM 719 Course
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/** PROJECT DESCRIPTION
    This interactive sketch is composed of an initial splash screen followed by a 
    main workspace screen.  It is intended to provide a framework for a futuristic 
    HUD as part of an global aerial security system game interface.  The splash 
    screen is a dynamic and interactive display of math formulas used to create 
    point geometry.  It also includes a button for activating the main workspace
    screen.  The main workspace is a dashboard/HUD for managing global aerial 
    security, namely airports and flight paths, which can be monitored in the 
    center of the screen.  Its visual display controls are at the top right of the 
    screen.  The security network integrates the use of an arsenal of reconnaissance 
    drones, listed in the dropdown menu on the left of the screen. At the moment, 
    only 3 are listed and 1 has data and a visual display, located at the bottom 
    left corner of the screen. The visual display of the drone has a slider to view
    the drone from different angles.  The radar system at the bottom right can be 
    linked to a drone once it has been deployed for use.
    
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
    The PNG images used for the safe content within this program and located in the
    accompanying 'data' folder were created by Hans Palacios.  Each were modeled, 
    textured, and rendered in SideFX Houdini.
    
**/

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

// Processing Libraries
import ComputationalGeometry.*;     // Library for use with 3D meshes
import controlP5.*;                 // Library for use with UI elements

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

// Global variables
/** The majority of these global variables are used and defined to creat consistency 
    throughout the sketch and its contents built from various classes.  
**/

Grid bkgdGrid;                       // Square grid background
TextStream backText;                 // Scrolling text background 
Radar radarModule;                   // Radar system
IsoWrap eShell;                      // Used to pass through IsoWrap into Globe class
Globe earthModule;                   // Earth with data points and paths
ControlP5 earthCP;                   // Used to pass through ControlP5 into Earth class
ControlP5 radarCP;                   // Used to pass through ControlP5 into Radar class
ControlP5 arsenalCP;                 // Used to pass through ControlP5 into Arsenal class
Arsenal arsenalModule;               // Arsenal data and viewport
Screen hudScreen;                    // HUD graphics in foreground
MathGeo abstractGeo;                 // 3D geometry created using complex math
ControlP5 pwrCP;                     // Used to pass through ControlP5 into Screen class

int pathDensity = 100;               // Defines the iteration for the airport data for loop
int tangoDensity = 10;               // Defines the density of tango points in the radar
int ctrTopPos = 490;                 // Top offset value for use with defining hot spot
int ctrSidePos = 360;                // Side offset value for use with defining hot spot
int hotSpotStartX;                   // X position for start of hot spot
int hotSpotStartY;                   // Y position for start of hot spot
int hotSpotEndX;                     // X position for end of hot spot
int hotSpotEndY;                     // Y position for end of hot spot
boolean inGlobalHotSpot = false;     // Defines state for use when mouse is in hotspot
boolean programOn = false;           // Defines state for when main program is activated
boolean programRunning = false;      // Defines state for when main program is running

// Color scheme
color greenSolid = color(0, 255, 0); 
color redSolid = color(255, 0, 0);   
color whiteSolid = color(255);       
color blackSolid = color(0);   

color whiteAlpha10 = color(255, 10);
color whiteAlpha20 = color(255, 20);
color whiteAlpha50 = color(255, 50); 

color pathColor;                     // Color for paths around globe
color cityColor;                     // Color for world cities
color aptColor;                      // Color for airport locations
color tangoColor;                    // Color for radar tango points

PVector aptSource, aptDestination;   // Vectors derived from airport dat using Lat/Long

String[] arsenalList = {             // List of arsenal, aligned with data in armory.json
  "MQ-9A Reaper", 
  "RQ-1 Predator", 
  "GNAT-750"
  };                                 

String imgFileNameBase = "images/drone (";    // String prefix for calling the image files
String imgFileNameEnd = ").png";     // String suffix for calling the image files
int numOfFrames = 48;                // Define number of frames used for image array
PImage photo[] = new PImage[numOfFrames];     // Array for encapsulating accompanying PNG images
                                     // Images located in the accompanying "data" folder

PFont monoFont;                      // Unique fonts used in the program
PFont playFont;                      // Font files located in the accompanying "data" folder
                                     // Fonts sourced from Google Fonts:
                                     // https://fonts.google.com/specimen/PT+Mono
                                     // https://fonts.google.com/specimen/Play

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Data
// Data files are located in the accompany "data" folder

// +++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Data for airports and routes sourced from: https://openflights.org/data.html
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++
Table airports;
Table routes;

// +++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Data for cities sourced from: https://simplemaps.com/data/world-cities
// License for use of this free version of database is
// located in the accompanying "data" folder.
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++
Table cities;

// +++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Data for arsenal sourced from: 
// https://en.wikipedia.org/wiki/General_Atomics_MQ-9_Reaper
// https://www.af.mil/About-Us/Fact-Sheets/Display/Article/104470/mq-9-reaper/
// https://www.globalsecurity.org/military/systems/aircraft/mq-9-specs.htm
// JSONArray used because it stores a collection of separate JSON objects, each with their own
// pair of name and value.
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++
JSONArray arsenal;

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

void setup() {
  size(1920, 1080, P3D);
  frameRate(30);
  
  // *******************************************************
  // Load data sets used in globe and arsenal classes
  airports = loadTable("airports.csv");
  cities = loadTable("worldcities.csv", "header");
  routes = loadTable("routes.csv");
  arsenal = loadJSONArray("arsenal.json");
  
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
  bkgdGrid = new Grid();                    // Square grid background
  backText = new TextStream();              // Scrolling text background 
  arsenalCP = new ControlP5(this);          // Used to pass through ControlP5 into Arsenal class
  arsenalModule = new Arsenal(arsenalCP);   // Arsenal data and viewport
  eShell = new IsoWrap(this);               // Used to pass through IsoWrap into Globe class
  radarCP = new ControlP5(this);            // Radar system control panel
  radarModule = new Radar(radarCP);         // Radar system
  earthCP = new ControlP5(this);            // Earth control panel
  earthModule = new Globe(eShell, earthCP); // Earth with data points and paths
  pwrCP = new ControlP5(this);              // Used to pass through ControlP5 into Screen class
  abstractGeo = new MathGeo();              // 3D geometry created using complex math
  hudScreen = new Screen(pwrCP);            // HUD graphics in foreground  
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

void draw() {
  background(0);
  // ******************************************************* 
  // Static HUD screen graphics
  hudScreen.renderStaticGraphics();  
  
  if(programOn){                            // Boolean set with ControlP5 power toggle on intro screen
    // *******************************************************
    // Main program content
    bkgdGrid.rectGrid(width/2, whiteAlpha20, 20);       // Small square grid
    bkgdGrid.rectGrid(width/2, whiteAlpha50, 140);      // Large square grid
    backText.renderStream(40);              // Background text stream
    arsenalModule.dataTextBox();            // Text box with data
    arsenalModule.viewport();               // Scrollable 3D view
    radarModule.viewport();                 // UI for managing radar system
    radarModule.renderRadar();              // Radar system
    earthModule.viewport();                 // UI for managing earth data
    earthModule.renderGlobe();              // Earth data points and 3D view
    hudScreen.renderRunGraphics();          // HUD graphics when running
  }
  else{
    // ******************************************************* 
    // Content before main program starts
    bkgdGrid.rectGrid(0, whiteAlpha10, 20);  // Small square grid
    bkgdGrid.rectGrid(0, whiteAlpha20, 140); // Large square grid
    hudScreen.renderPreGraphics();           // HUD screen graphics when program is off
    abstractGeo.geoHelicoid();               // Rotating and interactive geo shape
    abstractGeo.geoTrefoil();                // Rotating geo shape 
  }
  
}
