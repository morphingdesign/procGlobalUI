// Class for screen HUD graphics construction
class Screen {  
  
  // Class Variables
  ControlP5 programCP;
  Grid centralGrid;
  int edgeOffset = 10;    // Offset from sketch border
  int ctrTopPos = 490;
  int ctrSidePos = 360;
  color highlightEdge;     // Color changes 
  color highlightStroke;   // Stroke changes 
  String powerInfo = "activate \nprogram";
  float animSpeed = 0.03;  // Speed for screen saver animation
  
  Arc[] arcShape = new Arc[10];
  
  int dia1Out = 1080 - 20;
  int dia1In = dia1Out - 20;

  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // 
  Screen(ControlP5 ctrlP5){
    programCP = ctrlP5;
    programCP.addToggle("power")
       .setPosition(200,height/2)
       .setSize(36,20)
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
       
    centralGrid = new Grid();   
    
     arcShape[0] = new Arc(dia1Out, dia1In, 0, 90, 0, whiteGrad50); 
     arcShape[1] = new Arc(dia1Out, dia1In, 94, 98, 0, whiteGrad50);
     arcShape[2] = new Arc(dia1Out, dia1In, 100, 104, 0, whiteGrad50); 
     arcShape[3] = new Arc(dia1Out, dia1In, 140, 200, 0, whiteGrad50); 
     arcShape[4] = new Arc(dia1Out, dia1In, 220, 250, 0, whiteGrad50); 
     arcShape[5] = new Arc(dia1Out, dia1In, 254, 258, 0, whiteGrad50);
     arcShape[6] = new Arc(dia1Out, dia1In, 260, 262, 0, whiteGrad50);
     arcShape[7] = new Arc(dia1Out, dia1In, 290, 330, 0, whiteGrad50); 
     arcShape[8] = new Arc(dia1Out, dia1In, 334, 336, 0, whiteGrad50);
     arcShape[9] = new Arc(dia1Out, dia1In, 338, 340, 0, whiteGrad50);
     
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
    if(inGlobalHotSpot){
       highlightEdge = redSolid;
    }
    else{
      highlightEdge = whiteSolid;
    };
  }
  
  // *******************************************************
  //
  void renderRunGraphics(){   
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
    
    pushMatrix();
    translate(0, 0, -800);
    rotateArc();
    popMatrix();
  }
  
  // *******************************************************
  //
  void renderPreGraphics(){
    pushMatrix();
    translate(width/2, height/2, -100);
    // Stroke color, alpha, and weight are in the radialGrid() method
    rotateZ(frameCount * animSpeed);
    centralGrid.radialGrid(height, -10, 2, 0, 1, whiteSolid, 100, true);
    rotateZ(frameCount * animSpeed +.1);
    centralGrid.radialGrid(height + 20, -5, 4, 0, 1, whiteSolid, 150, true);
    popMatrix();

    pushMatrix();
    translate(0, 0, -1000);
    rotateArc();
    popMatrix();

    int plusAlpha = 100;
    plusIcon(width - 250, height/2, 40, whiteSolid, plusAlpha);
    plusIcon(width/2 + 400, height/2 + 400, 20, whiteSolid, plusAlpha);
    plusIcon(width/2 + 400, height/2 - 400, 20, whiteSolid, plusAlpha);
    plusIcon(width/2 - 400, height/2 + 400, 20, whiteSolid, plusAlpha);
    plusIcon(width/2 - 400, height/2 - 400, 20, whiteSolid, plusAlpha);
    
    int rectAlpha = 100;
    rectIcon(50, 50, 20, whiteSolid, rectAlpha);
    rectIcon(50, height - 50, 20, whiteSolid, rectAlpha);
    rectIcon(width - 50, 50, 20, whiteSolid, rectAlpha);
    rectIcon(width - 50, height - 50, 20, whiteSolid, rectAlpha);
  
    int angleAlpha = 100;
    color highlightColor = whiteSolid;
    int s = second();
    
    angleIcon(400, 180, -45, 15, 1, whiteSolid, angleAlpha);
    angleIcon(width - 400, 180, 135, 15, 1, whiteSolid, angleAlpha);
    angleIcon(400, height - 180, -45, 15, 1, whiteSolid, angleAlpha);
    angleIcon(width - 400, height - 180, 135, 15, 1, whiteSolid, angleAlpha);
    
    if(millis() > 5000){
      if(s % 2 == 1){
         highlightColor = redSolid;
         highlightStroke = 3;
         angleAlpha = 255;
      }
      else{
         highlightColor = whiteSolid;
         highlightStroke = 1;
         angleAlpha = 100;
      }
    }
    
    angleIcon(180, height/2 + 10, -45, 20, highlightStroke, highlightColor, angleAlpha);
    angleIcon(260, height/2 + 10, 135, 20, highlightStroke, highlightColor, angleAlpha);
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
  // Creates a single iteration of a line with end lines at each point
  void plusIcon(int x, int y, int length, color lineColor, int alpha){
    length = length/2;
    pushMatrix();
    translate(x, y);
    strokeWeight(1);
    stroke(lineColor, alpha);
    line(-length, 0, length, 0);
    line(0, -length, 0, length);
    popMatrix();
  }  
  
  // *******************************************************
  // Creates a single iteration of a square at each point
  void rectIcon(int x, int y, int length, color lineColor, int alpha){
    pushMatrix();
    translate(x, y);
    strokeWeight(1);
    stroke(lineColor, alpha);
    rectMode(CENTER);
    rect(0, 0, length, length);
    rectMode(CORNER);
    popMatrix();
  }  
  
  // *******************************************************
  // Creates a single iteration of an arrowhead at each point
  void angleIcon(int x, int y, int angle, int length, int sWeight, color lineColor, int alpha){
    pushMatrix();
    translate(x, y);
    rotate(radians(angle));
    strokeWeight(sWeight);
    stroke(lineColor, alpha);
    line(-length, 0, 0, 0);
    line(0, -length, 0, 0);
    popMatrix();
  }     
  
  // *******************************************************
  // 
  void rotateArc(){
  
     pushMatrix();
     translate(width/2, height/2, 0);  
     arcShape[0].rotateArc(1, 0); 
     arcShape[1].rotateArc(1, 0);
     arcShape[2].rotateArc(1, 0);
     
     arcShape[3].rotateArc(1, 0);
     
     arcShape[4].rotateArc(1, 0);   
     arcShape[5].rotateArc(1, 0);
     arcShape[6].rotateArc(1, 0);
     
     arcShape[7].rotateArc(1, 0);   
     arcShape[8].rotateArc(1, 0);
     arcShape[9].rotateArc(1, 0);
     
     popMatrix();
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
}  
