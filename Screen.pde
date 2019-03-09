// Class for screen HUD graphics construction
class Screen {  
  
  // Class Variables
  ControlP5 programCP;                      // Used to pass through Control P5 into this class
  Grid centralGrid;                         // Used to create ring geometry at center of canvas
  color highlightEdge;                      // Color used to highlight element when mouseover
  int highlightStroke;                      // Stroke weight of highlighted arrowhead on intro screen
  Arc[] arcShape = new Arc[10];             // Arc shapes for use around center of intro screen
   
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Used to construct screen graphics on intro and main page screens
  Screen(ControlP5 ctrlP5){
    centralGrid = new Grid();               // Construct new Grid() for creating ring geometry
    programCP = ctrlP5;                     // Pass through ControlP5 into this class
    programCP.addToggle("power")            // Construct toggle button on intro screen
       .setPosition(200,height/2)           // Position toggle on left side of canvas
       .setSize(36,20)
       .setValue(false)                     // Set initial value of toggle to be deactivated
       .setMode(ControlP5.DEFAULT)          // Default mode used vs. switch mode
       .plugTo(this, "power")               // Connect toggle value to power boolean method
       .setValueLabel("Power Switch")       // Set the label value for toggle, but not visible
       .setCaptionLabel("activate \nprogram")    // Set the visible text below toggle
       .setColorBackground(whiteSolid)      // Set colors for different elements used by knob
       .setColorForeground(redSolid)
       .setColorCaptionLabel(greenSolid)
       .setColorActive(greenSolid) 
       ;
    int diaOut = height - 20;               // Offset outer diameter inward from canvas height
    int diaIn = diaOut - 20;                // Offset inner diameter inward from outer diameter
    arcShape[0] = new Arc(diaOut, diaIn, 0, 90, 0, whiteAlpha50);     // Create series of arc shapes
    arcShape[1] = new Arc(diaOut, diaIn, 94, 98, 0, whiteAlpha50);    // ....and assign each to array
    arcShape[2] = new Arc(diaOut, diaIn, 100, 104, 0, whiteAlpha50);  // ....items, which will then be
    arcShape[3] = new Arc(diaOut, diaIn, 140, 200, 0, whiteAlpha50);  // ....rotated in draw()
    arcShape[4] = new Arc(diaOut, diaIn, 220, 250, 0, whiteAlpha50); 
    arcShape[5] = new Arc(diaOut, diaIn, 254, 258, 0, whiteAlpha50);
    arcShape[6] = new Arc(diaOut, diaIn, 260, 262, 0, whiteAlpha50);
    arcShape[7] = new Arc(diaOut, diaIn, 290, 330, 0, whiteAlpha50); 
    arcShape[8] = new Arc(diaOut, diaIn, 334, 336, 0, whiteAlpha50);
    arcShape[9] = new Arc(diaOut, diaIn, 338, 340, 0, whiteAlpha50);
  }
 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  // *******************************************************
  // Render graphics that are consistent between both intro and main program screens
  void renderStaticGraphics(){
    int ctrTopPos = 490;                   // Offset distance for top border line width
    int ctrSidePos = 360;                  // Offset distance for side border line height
    
    pushMatrix();                          // Reuse cornerEdge method and positioning them on canvas sides
    translate(0, 0);                       
    cornerEdge();                          // Outer frame on left-most side of canvas
    popMatrix();
    pushMatrix();
    translate(width, height);
    rotate(PI);
    cornerEdge();                          // Outer frame on right-most side of canvas
    popMatrix();  
    pushMatrix();                          // Reuse sideEdge method and positioning them around center
    translate(width/2 - ctrTopPos, height/2 + ctrSidePos);
    rotate(PI/-2);
    sideEdge(ctrSidePos * 2, highlightEdge);  // Left line for globe and math geo viewport
    popMatrix();
    pushMatrix();
    translate(width/2 + ctrTopPos, height/2 - ctrSidePos);
    rotate(PI/2);
    sideEdge(ctrSidePos * 2, highlightEdge);  // Right line for globe and math geo viewport
    popMatrix();
    pushMatrix();
    translate(width/2 - ctrTopPos, 90);
    sideEdge(ctrTopPos * 2, greenSolid);      // Top line for globe and math geo viewport
    popMatrix();
    pushMatrix();
    translate(width/2 + ctrTopPos, height - 90);
    rotate(PI);
    sideEdge(ctrTopPos * 2, greenSolid);      // Bottom line for globe and math geo viewport
    popMatrix();
    
    if(inGlobalHotSpot){                // Boolean to identify globe viewport hotspot
       highlightEdge = redSolid;        // Changes variable color for globe viewport with true boolean
    }                                 
    else{
       highlightEdge = whiteSolid;
    };
  }
  
  // *******************************************************
  // Render only graphics used in main program screen
  void renderRunGraphics(){   
    stroke(greenSolid);
    rect(20, 20, 290, 60);             // Frame for title box positioned at top left corner of canvas
    noStroke();
    fill(greenSolid);
    textFont(playFont, 12);            // Apply new font "Play"
    textAlign(LEFT, TOP);
    text("PROJECT", 40, 26);           // Smaller title text
    textFont(playFont, 32);            // Apply new font "Play"
    text("STRATOSPHERE", 40, 36);      // Larger title text
    pushMatrix();                  
    translate(0, 0, -800);             // Position rotating arc geometry at center of canvas with far 
    rotateArc();                       // ....depth to sit behind dynamic 3D math geometry
    popMatrix();
  }
  
  // *******************************************************
  // Render only graphics used in intro screen
  void renderPreGraphics(){
    float animSpeed = 0.03;                // Speed multiplier for ring rotation
    pushMatrix();
    translate(width/2, height/2, -100);    // Position at center of canvas and with depth behind math geo
    rotateZ(frameCount * animSpeed);       // Rotate coordinate system CCW using frameCount as angle
    centralGrid.radialGrid(height, -10, 2, 0, 1, whiteSolid, 100, true);      // Inner ring
    rotateZ(frameCount * animSpeed +.1);   // Readjust rotation to be slightly faster than inner ring
    centralGrid.radialGrid(height + 20, -5, 4, 0, 1, whiteSolid, 150, true);  // Outer ring
    popMatrix();                           // Stroke color, alpha, and weight for rings are in the
    pushMatrix();                          // ....radialGrid() method
    translate(0, 0, -1000);                // Position rotating arc shapes at center and behind math geo
    rotateArc();                           // Create rotating arc shapes
    popMatrix();
    int plusAlpha = 100;                   // Consistent alpha value for plus icon stroke color
    plusIcon(width - 250, height/2, 40, whiteSolid, plusAlpha);          // Create a series of plus icons
    plusIcon(width/2 + 400, height/2 + 400, 20, whiteSolid, plusAlpha);  // ....around canvas in unique
    plusIcon(width/2 + 400, height/2 - 400, 20, whiteSolid, plusAlpha);  // ....locations
    plusIcon(width/2 - 400, height/2 + 400, 20, whiteSolid, plusAlpha);
    plusIcon(width/2 - 400, height/2 - 400, 20, whiteSolid, plusAlpha);
    int rectAlpha = 100;                   // Consistent alpha value for rectangle icon stroke color
    rectIcon(50, 50, 20, whiteSolid, rectAlpha);             // Create a series of rectangle icons around
    rectIcon(50, height - 50, 20, whiteSolid, rectAlpha);    // ....canvas in unique locations
    rectIcon(width - 50, 50, 20, whiteSolid, rectAlpha);     
    rectIcon(width - 50, height - 50, 20, whiteSolid, rectAlpha);
    int angleAlpha = 100;                  // Consistent alpha value for angle icon stroke color
    angleIcon(400, 180, -45, 15, 1, whiteSolid, angleAlpha);             // Create a series of angle icons
    angleIcon(width - 400, 180, 135, 15, 1, whiteSolid, angleAlpha);     // ....around canvas in unique
    angleIcon(400, height - 180, -45, 15, 1, whiteSolid, angleAlpha);    // ....locations
    angleIcon(width - 400, height - 180, 135, 15, 1, whiteSolid, angleAlpha);
    color highlightColor = whiteSolid;     // Initiate highlight color to white
    int s = second();                      // Capture second() value in int variable for use in a if/else
    if(millis() > 5000){                   // Condition is active 5 seconds after program runs
      if(s % 2 == 1){                      // Change higlight color, weight, and alpha for angle icons
         highlightColor = redSolid;        // ....every other second to appear blinking
         highlightStroke = 3;
         angleAlpha = 255;
      }
      else{
         highlightColor = whiteSolid;
         highlightStroke = 1;
         angleAlpha = 100;
      }
    }
    // Create angle icons on left and right side of power toggle on left side of canvas
    // Stroke color, weight, and alpha changes with output from if/else statement above
    angleIcon(180, height/2 + 10, -45, 20, highlightStroke, highlightColor, angleAlpha);  
    angleIcon(260, height/2 + 10, 135, 20, highlightStroke, highlightColor, angleAlpha);
  } 
  
  // *******************************************************
  // Creates a single iteration of 3 connected lines to depict a border and corner
  void cornerEdge(){
    int length1 = 20;                         // Length of short perpendicular line at end
    int length2 = 80;                         // Length of main longer line
    int edgeOffset = 10;                      // Offset from canvas border
    strokeWeight(1);
    stroke(greenSolid);
    line(edgeOffset, edgeOffset, edgeOffset, length2);    // Long line of top corner
    line(edgeOffset, edgeOffset, length1, edgeOffset);    // Short line of top corner
    line(edgeOffset, height/2 - length2, edgeOffset, height/2 + length2);   // Vertical line at center
    line(edgeOffset, height - edgeOffset, edgeOffset, height - length2);    // Long line of bottom corner
    line(edgeOffset, height - edgeOffset, length1, height - edgeOffset);    // Short line of bottom corner
  }
  
  // *******************************************************
  // Creates a single iteration of a line with short perpendicular lines at both ends
  void sideEdge(int length, color lineColor){  // Length of long line defined by parameter
    int length1 = 20;                          // Length of short perpendicular line at ends
    strokeWeight(1);
    stroke(lineColor);
    line(0, 0, length, 0);                     // Long horizontal line
    line(0, 0, 0, length1);                    // Short line on left
    line(length, 0, length, length1);          // Short line on right
  }

  // *******************************************************
  // Creates a single iteration of a plus sign icon at defined x- and y-coordinates
  void plusIcon(int x, int y, int length, color lineColor, int alpha){
    length = length/2;                         // Offsets length to align center with origin
    pushMatrix();
    translate(x, y);                           // Origin defined by coordinates passed through parameters
    strokeWeight(1);
    stroke(lineColor, alpha);
    line(-length, 0, length, 0);               // Horizontal line
    line(0, -length, 0, length);               // Vertical line
    popMatrix();
  }  
  
  // *******************************************************
  // Creates a single iteration of a square at defined x- and y-coordinates
  void rectIcon(int x, int y, int length, color lineColor, int alpha){
    pushMatrix();
    translate(x, y);                          // Origin defined by coordinates passed through parameters
    strokeWeight(1);
    stroke(lineColor, alpha);
    rectMode(CENTER);                         // Sets origin of rectangle to origin
    rect(0, 0, length, length);               // Create square shape
    rectMode(CORNER);                         // Reverts rectMode to default mode
    popMatrix();
  }  
  
  // *******************************************************
  // Creates a single iteration of an arrowhead at each defined point
  void angleIcon(int x, int y, int angle, int length, int sWeight, color lineColor, int alpha){
    pushMatrix();                             // Stroke weight, color, and alpha varied by parameter
    translate(x, y);                          // Origin defined by coordinates passed through parameters
    rotate(radians(angle));                   // Rotate coordinate system to define angle of arrowhead
    strokeWeight(sWeight);                    
    stroke(lineColor, alpha);
    line(-length, 0, 0, 0);                   // Horizontal line
    line(0, -length, 0, 0);                   // Vertical line
    popMatrix();
  }     
  
  // *******************************************************
  // Creates arc shapes and applies rotation around canvas center
  void rotateArc(){                           
     pushMatrix();
     translate(width/2, height/2, 0);  
     for(int i=0; i < arcShape.length; i++){
        arcShape[i].rotateArc(1, 0);          // Applies consistent CW rotation parameter and creates
     }                                        // ....solid arcs for each array item
     popMatrix();
  }
  
  // *******************************************************
  // Creates power toggle boolean for closing intro screen and opening main program screen
  void power(boolean powerSwitch){            // Coordinated with ControlP5 toggle
    if(powerSwitch == true) {
        programOn = true;                     // Activates the main program screen
        programCP.remove("power");            // Removes the power ControlP5 toggle from screen
      } else {
        programOn = false;                    // Closes the intro screen
      }
  }
}  
