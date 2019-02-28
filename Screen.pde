import controlP5.*;

// Class for grid construction
class Screen {  
  
  // Class Variables
  ControlP5 programCP;
  Grid centralGrid;
  int edgeOffset = 10;    // Offset from sketch border
  int ctrTopPos = 490;
  int ctrSidePos = 360;
  color highlightEdge;     // Color changes when mouse is in radar hotspot
  String powerInfo = "Toggle switch to activate / deactivate global view & data.";
  float animSpeed = 0.03;  // Speed for screen saver animation
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // 
  Screen(ControlP5 ctrlP5){
    programCP = ctrlP5;
    programCP.addToggle("power")
       .setPosition(20,140)
       .setSize(40,20)
       .setValue(false)
       .setMode(ControlP5.DEFAULT)
       //.setMode(ControlP5.SWITCH)    // Visualizes a switch
       .plugTo(this, "power")
       .setValueLabel("Power Switch")
       .setCaptionLabel(powerInfo)
       .setColorBackground(whiteSolid)
       .setColorForeground(redSolid)
       .setColorCaptionLabel(greenSolid)
       .setColorActive(greenSolid)
       ;
       
    centralGrid = new Grid(whiteSolid);   
  }
 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  // *******************************************************
  //
  void renderStaticGraphics(){
    // Outer frame on left side
    pushMatrix();
    translate(0, 0);
    cornerEdge();
    popMatrix();
    
    // Outer frame on right side
    pushMatrix();
    translate(width, height);
    rotate(PI);
    cornerEdge();
    popMatrix();
    
    // Frame for title box
    stroke(greenSolid);
    fill(0, 180);
    rect(20, 20, 290, 60);
    
    // Title text
    noStroke();
    fill(greenSolid);
    textFont(playFont, 12);        // Reference new font "Play"
    textAlign(LEFT, TOP);
    text("PROJECT", 40, 26);
    textFont(playFont, 32);        // Reference new font "Play"
    text("STRATOSPHERE", 40, 36);    
    
    // Left line for radar
    pushMatrix();
    translate(width/2 - ctrTopPos, height/2 + ctrSidePos);
    rotate(PI/-2);
    sideEdge(ctrSidePos * 2, highlightEdge);
    popMatrix();
    
    // Right line for radar
    pushMatrix();
    translate(width/2 + ctrTopPos, height/2 - ctrSidePos);
    rotate(PI/2);
    sideEdge(ctrSidePos * 2, highlightEdge);
    popMatrix();
    
    // Top line for radar
    pushMatrix();
    translate(width/2 - ctrTopPos, 90);
    sideEdge(ctrTopPos * 2, greenSolid);    
    popMatrix();
    
    // Bottom line for radar
    pushMatrix();
    translate(width/2 + ctrTopPos, height - 90);
    rotate(PI);
    sideEdge(ctrTopPos * 2, greenSolid);
    popMatrix();
    
    // Variable to identify radar hotspot
    if(inRadarHotSpot){
       highlightEdge = redSolid;
    }
    else{
      highlightEdge = whiteSolid;
    };
  }
  
  // *******************************************************
  //
  void renderPreGraphics(){
    //     
    pushMatrix();
    translate(width/2, height/2, -100);
    // Stroke color, alpha, and weight are in the radialGrid() method
    // (int diameter, int projection, int interval, int ringWeight, int tickWeight, int colorAlpha, boolean ticks)
    rotateZ(frameCount * animSpeed);
    centralGrid.radialGrid(height, -10, 2, 0, 1, 100, true);
    rotateZ(frameCount * animSpeed +.1);
    centralGrid.radialGrid(height + 20, -5, 4, 0, 1, 150, true);
    popMatrix();
    
    
  }
  
  // *******************************************************
  // 
  void renderRunGraphics(){
    // Pulsing line graphic below title
    pushMatrix();
    translate(20, 90);
    pulse();                       
    popMatrix();
  }  
  
  // *******************************************************
  // Creates a single iteration of a line with an end line at one point
  void cornerEdge(){
    int length1 = 20;
    int length2 = 80;
    strokeWeight(1);
    stroke(greenSolid);
    line(edgeOffset, edgeOffset, edgeOffset, length2);
    line(edgeOffset, edgeOffset, length1, edgeOffset);
    line(edgeOffset, height/2 - length2, edgeOffset, height/2 + length2); 
    line(edgeOffset, height - edgeOffset, edgeOffset, height - length2);
    line(edgeOffset, height - edgeOffset, length1, height - edgeOffset);
  }
  
  // *******************************************************
  // Creates a single iteration of a line with end lines at each point
  void sideEdge(int length, color lineColor){
    int length1 = 20;
    strokeWeight(1);
    stroke(lineColor);
    line(0, 0, length, 0);
    line(0, 0, 0, length1);
    line(length, 0, length, length1);
  }
  
  // *******************************************************
  // Creates pulsing row of lines
  void pulse(){
    stroke(greenSolid);  
    for(int i = 0; i < 70; i++){
       line(i + (i * 5), 0, i + (i * 5), random(5, 30));
    }
  }
  
  // *******************************************************
  // Creates power switch for main program
  void power(boolean powerSwitch){
    if(powerSwitch == true) {
        programOn = true;               // Activates the main program
        programCP.remove("power");      // Removes the power toggle CP from screen
      } else {
        programOn = false;              // Displays intro screen
      }
  }
  
  // *******************************************************
  // Creates a Tranguloid Trefoil shape as an abstract form
  // to serve as a screen saver when program is not running
  void screenSaver(){
    float x, y, z, u, v;
    float scalar = 45;
    float iteration = .05;
    pushMatrix();
    translate(width/2, height/2, 400);
    rotateX(frameCount * animSpeed);
    rotateY(frameCount * animSpeed);
    rotateZ(frameCount * animSpeed);
    stroke(255);
    strokeWeight(1);
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Formula for Tranguloid Trefoil source citation below:
    // http://www.3d-meier.de/tut3/Seite57.html
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
    for(u=-PI; u < PI; u+=iteration){
      for(v=-PI; v < PI; v+=iteration){
        x = (2 * sin(3 * u) / (2 + cos(v))) * scalar;
        y = (2 * (sin(u) + 2 * sin(2 * u)) / (2 + cos(v + 2 * PI / 3))) * scalar;
        z = ((cos(u) - 2 * cos(2 * u)) * (2 + cos(v)) * (2 + cos(v + 2 * PI / 3)) / 4) * scalar;
        point(x, y, z);
      }
    }
    popMatrix();  
  }
}  
