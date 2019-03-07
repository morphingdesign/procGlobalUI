// Class for radar system construction and animation
class Radar {
  
  // Class Variables
  Grid radarRing;
  
  ControlP5 radarClassCP;
  Textlabel radarClassTextTitle;            // Title text
  Textlabel radarClassTextDesc;             // Description text
  ColorPicker radarClassTangoColorPicker;   // UI for tango point color
  Knob radarClassTangoScaleKnob;            // UI for tango point scale
  Knob radarClassTangoDensityKnob;           // UI for tango point density
  String title = ("RADAR SYSTEM CONTROL PANEL");
  String description = ("Visualize global network of airports and flight paths using \n the following control panel and settings.");
  float knobYPos = 530;
  
  int rotateSpeed = 1;
  
  int radarRadius = 200;
  int radarDiameter = radarRadius * 2;
  //int radius = 200;
  int spacing = 13;
  //int radarHeight = 400;
  
  int maxTango = 20;
  PVector ptPos[] = new PVector[maxTango];
    

  float tangoPtRadius = 1;
  int alphaOne = 0;
  int alphaLast = 600;
  int growth = 2;
  
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Used to construct the radar system
  Radar(ControlP5 ctrlP5){  
    radarRing = new Grid();
    radarClassCP = ctrlP5;
    

    
    
    // Radar system control panel
    
    radarClassTextTitle = radarClassCP.addTextlabel("titleText")
        .setPosition(1560, 420)
        .setText(title)
        .setColorValue(greenSolid)
        .setVisible(false)
    ;
    
    radarClassTextDesc = radarClassCP.addTextlabel("descText")
        .setPosition(1560, 432)
        .setText(description)
        .setColorValue(greenSolid)
        .setVisible(false)
    ;
    
    //
    radarClassTangoScaleKnob = radarClassCP.addKnob("tangoScale")
        .setPosition(1560, knobYPos)
        .setRange(0,5)
        .setValue(2)
        .setRadius(30)
        .setNumberOfTickMarks(5)
        .setTickMarkLength(2)
        .snapToTickMarks(true)
        .setColorForeground(whiteSolid)
        .setColorBackground(blackSolid)
        .setColorActive(redSolid)
        .setColorLabel(greenSolid)
        .setDragDirection(Knob.HORIZONTAL)
        .setLabel("Tango Scale")
        .setVisible(false)
    ; 
    
    // Controls the amount of paths visible in the Earth module
    // The data set "routes" includes a very large number of paths,
    // so this allows user to show only a few or a lot in the UI
    radarClassTangoDensityKnob = radarClassCP.addKnob("tangoDensity")
       .setPosition(1640, knobYPos)
       .setRange(0, maxTango)
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
       .setLabel("Tango Density")
       .setVisible(false)
    ;  

    // Color picker for paths on Earth, part of main Earth control panel
    radarClassTangoColorPicker = radarClassCP.addColorPicker("tangoPicker")
        .setPosition(1560, 470)
        .setSize(260, 60)
        .setColorLabel(greenSolid)
        .setColorValue(color(255, 0, 0, 255))      // Defines the starting color of the data paths
        .showBar()
        .setBarHeight(10)
        .enableCollapse()
        .close()
        .setLabel("Tango Point Color Selector")
        .setVisible(false)
    ;    
    
    for(int i=0; i < ptPos.length; i++){
      float ptPX = random(-radarRadius/2, radarRadius/2);
      float ptPY = random(-radarRadius/2, radarRadius/2);
      ptPos[i] = new PVector(ptPX, ptPY);
    }
    
  }
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  // *******************************************************
  // 
  void renderRadar(){
    pushMatrix();
    translate(1650, 830, 50);
    
    tangoPtRadius = radarClassTangoScaleKnob.getValue();
    tangoDensity = int(radarClassTangoDensityKnob.getValue());
    tangoColor = radarClassTangoColorPicker.getColorValue();
    
    drawRadar();
    popMatrix();
  }
  
  // *******************************************************
  // 
  void viewport(){
     radarClassTextTitle.setVisible(true);
     radarClassTextDesc.setVisible(true);
     radarClassTangoColorPicker.setVisible(true);
     radarClassTangoScaleKnob.setVisible(true);
     radarClassTangoDensityKnob.setVisible(true);
    
     pushMatrix();
     translate(1540, 400);
     fill(blackSolid);
     stroke(greenSolid);
     strokeWeight(1);
     rect(0, 0, 340, 220);
     popMatrix();
  }
  
  // *******************************************************
  // 
  void drawRadar(){
    
    pushMatrix();
    ellipseMode(RADIUS);
    noFill();
    stroke(255, 5);
    strokeWeight(2);
    for(int i=10; i < radarRadius; i+=spacing){
       ellipse(0, 0, i, i);
    }
    stroke(255, 50);
    strokeWeight(1);
    for(int i=5; i < radarRadius; i+=spacing){
       ellipse(0, 0, i, i);
    }
    popMatrix();
    
    pushMatrix();
    translate(0,0,0);
    fill(1);
    //noFill();
    stroke(100, 255);
    strokeWeight(2);
    ellipse(0, 0, radarRadius, radarRadius);
    popMatrix();
    
    
  
    pushMatrix();
    translate(0, 0, 0);
    radarScanArc(radarDiameter);
    
    radarRing.radialGrid(radarDiameter/4, -3, 10, 1, 1, greenSolid, 150 ,true);
    radarRing.radialGrid(radarDiameter/2, 5, 20, 1, 1, greenSolid, 100, true);
    radarRing.radialGrid(int(radarDiameter * 0.75), 10, 10, 1, 1, greenSolid, 150, true);
    radarRing.radialGrid(radarDiameter, 5, 2, 1, 1, greenSolid, 150, true);
    radarRing.radialGrid(radarDiameter, 0, 45, 1, 1, greenSolid, 100, false);
    radarRing.radialGrid(radarDiameter, 0, 90, 1, 1, greenSolid, 100, false);    
    
    //tangoPts(radarHeight/2 - radarHeight/4);
    tangoPts();
    popMatrix();
    
    
    
  }

  // *******************************************************
  // 
  void radarScanArc(int diameter){
    float rSpeed = 6;
    color scanColorLight = color(0, 255, 0, 10);
    color scanColorDark = color(0, 255, 0, 100);
    int angle = 45;
    pushMatrix();
    rotateSpeed++;
    rotate(radians(rotateSpeed * rSpeed));      // Dynamic rotation initiated
    for(float i = 0; i < angle; i+=0.25){
      float gradRange = map(i, 0, angle, 0.0, 1.0);
      color gradient = lerpColor(scanColorLight, scanColorDark, gradRange);
      stroke(gradient);
      rotate(radians(i));
      line(0, 0, diameter/2, 0);
      rotate(radians(-i));
    }
    popMatrix();
  }
  
  // *******************************************************
  // 

  
  void tangoPts(){
    //PVector ptPos[] = new PVector[numOfTango];
    

    
    
    for(int i=0; i < tangoDensity; i++){
       pushMatrix();
       tangoPt(ptPos[i].x, ptPos[i].y);
       popMatrix();
       //println("start: " + tXPos + " , " + tYPos);
       if(ptPos[i].x == radarRadius/2 || ptPos[i].x == -radarRadius/2){
           ptPos[i].x = 0;
       }
       else{
           int addX = int(random(-growth, growth));
           ptPos[i].x += addX;
       }
       if(ptPos[i].y == radarRadius/2 || ptPos[i].y == -radarRadius/2){
           ptPos[i].y = 0;
       }
       else{
           int addY = int(random(-growth, growth));
           ptPos[i].y += addY;
       }
    }
  }
 
  
  
  void tangoPt(float x, float y){
      pushMatrix();
      //translate(ptRad/2, ptRad/2);
      if(alphaOne != alphaLast){
         alphaOne++;
      }
      else{
         alphaOne = 0;
      }
      fill(tangoColor, alphaOne);
      noStroke();
      ellipse(x, y, tangoPtRadius, tangoPtRadius);
      popMatrix();
  }
}  
