// Class for radar system construction and animation
class Radar {
  
  // Class Variables
  Grid radarRing;                           // Used to create ring geometry for radar system
  ControlP5 radarClassCP;                   // Used to pass through Control P5 into this class
  Textlabel radarClassTextTitle;            // Title text for UI control panel
  Textlabel radarClassTextDesc;             // Description text for UI control panel
  ColorPicker radarClassTangoColorPicker;   // UI control for tango point color
  Knob radarClassTangoScaleKnob;            // UI control for tango point scale
  Knob radarClassTangoDensityKnob;          // UI control for tango point density
  String title = ("RADAR SYSTEM CONTROL PANEL");                           // Title text
  String description = ("Visualize global network of airports and flight paths using \n"
                        + "the following control panel and settings.");    // Description text
  float knobRowYPos = 530;                  // Y-position for consistent placement of all CtrlP5 knobs
  int rotateAngle = 1;                      // Starting rotate angle for radar scan rotation
  int radarRadius = 200;                    // Radar radius for consistency across methods
  int radarDiameter = radarRadius * 2;      // Radar diameter for consistency across methods
  int maxTango = 20;                        // Defines max number of vectors generated within
  PVector ptPos[] = new PVector[maxTango];  // ....this vector array. Max tango variable
                                            // updates with tango density CtrlP5 knob.    
  float tangoPtRadius = 1;                  // Sets initial tango point radius; updated with CtrlP5 knob
  int alphaOne = 0;                         // Sets lower range of alpha value for tango points
  int alphaLast = 600;                      // Sets upper range of alpha value for tango points; set to
                                            // ....a value beyond 255 to prolong its duration at opaque

  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Used to construct the radar system
  Radar(ControlP5 ctrlP5){                  
    radarRing = new Grid();                 // Construct new Grid() for creating ring geometry
    radarClassCP = ctrlP5;                  // Pass through ControlP5 into this class
    
    // Radar system control panel using ControlP5 elements
    radarClassTextTitle = radarClassCP.addTextlabel("titleText")  // Construct radar title text
        .setPosition(1560, 420)             // Position title at top of control panel
        .setText(title)                     // Set text to string variable "title"
        .setColorValue(greenSolid)          // Set color of text
        .setVisible(false)                  // Hide slider for intro screen and link it to the
    ;                                       // ....visibility of the main page screen
    radarClassTextDesc = radarClassCP.addTextlabel("descText")    // Construct radar description text
        .setPosition(1560, 432)             // Position description below title text
        .setText(description)               // Set text to string variable "description"
        .setColorValue(greenSolid)          // Set color of text
        .setVisible(false)                  // Hide slider for intro screen and link it to the
    ;                                       // ....visibility of the main page screen
    radarClassTangoScaleKnob = radarClassCP.addKnob("tangoScale") // Knob for tango point scale control
        .setPosition(1560, knobRowYPos)     // Position knob below CtrlP5 color picker
        .setRange(0,5)                      // Set min/max range of values for knob
        .setValue(2)                        // Set initial value on knob for runtime
        .setRadius(30)                      // Set size of knob arc geometry
        .setNumberOfTickMarks(5)            // Set number of tick marks visible around knob arc
        .setTickMarkLength(2)               // Set tick mark length projected from knob arc
        .snapToTickMarks(true)              // Force knob movement to snap to defined tick marks
        .setColorForeground(whiteSolid)     // Set colors for different elements used by knob
        .setColorBackground(blackSolid)
        .setColorActive(redSolid)
        .setColorLabel(greenSolid)
        .setDragDirection(Knob.HORIZONTAL)  // Knob operation set to dragging mouse horizontally
        .setLabel("Tango Scale")            // Set the visible label below the knob
        .setVisible(false)                  // Hide slider for intro screen and link it to the
    ;                                       // ....visibility of the main page screen
    radarClassTangoDensityKnob = radarClassCP.addKnob("tangoDensity")  // Knob for number of tango points
       .setPosition(1640, knobRowYPos)      // Position knob below CtrlP5 color picker
       .setRange(0, maxTango)               // Max range value changes maxTango class variable
       .setValue(10)                        // Set initial value on knob for runtime
       .setRadius(30)                       // Set size of knob arc geometry
       .setNumberOfTickMarks(5)             // Set number of tick marks visible around knob arc
       .setTickMarkLength(2)                // Set tick mark length projected from knob arc
       .snapToTickMarks(false)              // Force knob movement to snap to defined tick marks
       .setColorForeground(whiteSolid)      // Set colors for different elements used by knob
       .setColorBackground(blackSolid)
       .setColorActive(redSolid)
       .setColorLabel(greenSolid)
       .setDragDirection(Knob.HORIZONTAL)   // Knob operation set to dragging mouse horizontally
       .setLabel("Tango Density")           // Set the visible label below the knob
       .setVisible(false)                   // Hide slider for intro screen and link it to the
    ;                                       // ....visibility of the main page screen
    // Color picker for tango points in radar
    radarClassTangoColorPicker = radarClassCP.addColorPicker("tangoPicker")  // Color picker for tangos
        .setPosition(1560, 470)             // Position color picker below description text
        .setSize(260, 60)                   // Set size of bar denoting the dropdown color picker
        .setColorLabel(greenSolid)          // Set color for text label
        .setColorValue(color(255, 0, 0, 255))      // Defines the starting color of the tango points
        .showBar()                          // Display the bar that activates dropdown color picker
        .setBarHeight(10)                   // Set the height of the bar
        .enableCollapse()                   // Allow for the color picker to be collapsed into a 
        .close()                            // dropdown menu and have it closed initially
        .setLabel("Tango Point Color Selector")  // Set the visible text label within dropdown bar
        .setVisible(false)                  // Hide slider for intro screen and link it to the
    ;                                       // ....visibility of the main page screen
    
    for(int i=0; i < ptPos.length; i++){    // Initiate the x- & y-values for a set of points within the
      float ptPX = random(-radarRadius/2, radarRadius/2);    // ....radar system that serve as the
      float ptPY = random(-radarRadius/2, radarRadius/2);    // ....tango points
      ptPos[i] = new PVector(ptPX, ptPY);   // Add the point values into an array of vectors
    }                                       // These are defined in the constructor so that the random
  }                                         // preserves the points that are created, unlike in draw()
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  // *******************************************************
  // Render UI elements for radar control panel
  void viewport(){
     radarClassTextTitle.setVisible(true);          // Activate visibility of title text,
     radarClassTextDesc.setVisible(true);           // ....description text,
     radarClassTangoColorPicker.setVisible(true);   // ....color picker,
     radarClassTangoScaleKnob.setVisible(true);     // ....scale knob, 
     radarClassTangoDensityKnob.setVisible(true);   // ....density knob.
     pushMatrix();
     translate(1540, 400);                  // Position rectangle frame around control panel elements
     fill(blackSolid);
     stroke(greenSolid);
     strokeWeight(1);
     rect(0, 0, 340, 220);                  // Create background and border for control panel
     popMatrix();
  }
  
  // *******************************************************
  // Render all elements to display the radar system geometry 
  void renderRadar(){
    pushMatrix();
    translate(1650, 830, 50);               // Position radar system at bottom right corner of canvas
    tangoPtRadius = radarClassTangoScaleKnob.getValue();        // Get value from CtrlP5 scale knob to 
                                                                // ....define the radius of tango points
    tangoDensity = int(radarClassTangoDensityKnob.getValue());  // Get value from CtrlP5 density knob to
                                                                // ....define the number of tango points
    tangoColor = radarClassTangoColorPicker.getColorValue();    // Get value from CtrlP5 color picker to
                                                                // ....define color of tango points
    int spacing = 13;                      // Spacing between each iteration of drawn ellipses
    ellipseMode(RADIUS);
    fill(blackSolid);
    ellipse(0, 0, radarRadius, radarRadius);    // Solid ellipse to serve as background for radar
    noFill();
    stroke(whiteSolid, 20);
    strokeWeight(2);
    for(int i=5; i < radarRadius; i+=spacing){
       ellipse(0, 0, i, i);                // Series of increasing size ellipses with a faint stroke
    }                                      // ....and no fill
    radarScanArc();                        // Create an instance of the gradient arc
    // Create a series of green rings with varying tick marks along circumference
    radarRing.radialGrid(radarDiameter/4, -3, 10, 1, 1, greenSolid, 150 ,true);
    radarRing.radialGrid(radarDiameter/2, 5, 20, 1, 1, greenSolid, 100, true);
    radarRing.radialGrid(int(radarDiameter * 0.75), 10, 10, 1, 1, greenSolid, 150, true);
    radarRing.radialGrid(radarDiameter, 5, 2, 1, 1, greenSolid, 150, true);
    radarRing.radialGrid(radarDiameter, 0, 45, 1, 1, greenSolid, 100, false);
    radarRing.radialGrid(radarDiameter, 0, 90, 1, 1, greenSolid, 100, false);    
    tangoPts();                            // Create the tango points to appear within radar
    popMatrix();
  }

  // *******************************************************
  // Create an arc shape drawn by lines to depict a gradient
  void radarScanArc(){
    float rotateSpeed = 6;                 // Rotation speed multipler for moving arc
    color scanColorLight = color(greenSolid, 10);  // Lower end of transparent color gradient
    color scanColorDark = color(greenSolid, 100);  // Higher end of transparent color gradient
    int angle = 45;                        // Arc size defined by max angle
    pushMatrix();
    rotateAngle++;                         // Increase class variable per draw call to rotate arc
    rotate(radians(rotateAngle * rotateSpeed));      // Dynamic rotation initiated
    for(float i = 0; i < angle; i+=0.25){  // Iteration value is fraction to smooth line gradient
      float gradRange = map(i, 0, angle, 0.0, 1.0);  // Map arc angle between 0 and 1 gradient range
      color gradient = lerpColor(scanColorLight, scanColorDark, gradRange);  // Vary the color 
      stroke(gradient);                    // ....applied to stroke for each iteration in this loop       
      rotate(radians(i));                  // Rotate next iteration by the iteration value
      line(0, 0, radarRadius, 0);          // Create a line from center of radar to outer boundary
      rotate(radians(-i));                 // Reset rotation angle to 0 to allow for next iteration
    }
    popMatrix();
  }
  
  // *******************************************************
  // Change x- and y-values for each tango point to depict movement
  void tangoPts(){                         // X- and y-values for each point were initialized in 
    for(int i=0; i < tangoDensity; i++){   // constructor, but this method creates and moves them
       tangoPt(ptPos[i].x, ptPos[i].y);    // Create tango point with x- and y-values in vector array
       int growth = 2;                     // Defines max range for iterative tango point movement
       int addX = int(random(-growth, growth));  // X-value changes iteratively between growth
       ptPos[i].x += addX;                       // ....value range
       int addY = int(random(-growth, growth));  // Y-value changes iteratively between growth
       ptPos[i].y += addY;                       // ....value range
    }
  }

  // *******************************************************
  // Create a single instance of a tango point using an ellipse shape that appears to blink
  void tangoPt(float x, float y){         // As long as changing alphaOne value does not equal 
      if(alphaOne != alphaLast){          // ....predefined alphaLast value,  
         alphaOne++;                      // ....alphaOne value for fill increases to full opaque
      }                                   // When alphaOne value reaches alphaLast value,
      else{                               // ....the alphaOne value is reset to 0 so it can continue
         alphaOne = 0;                    // ....increasing each iteration back to full opaque
      }                                    
      fill(tangoColor, alphaOne);         // Current alpha value used for fill each iteration
      noStroke();
      ellipse(x, y, tangoPtRadius, tangoPtRadius);    // Create tango point using ellipse shape
  }
}  
