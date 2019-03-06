// Class for radar system construction and animation
class Radar {
  
  // Class Variables
  Grid radarRing;
  int rotateSpeed = 1;
  
  int radarRadius = 200;
  int radarDiameter = radarRadius * 2;
  //int radius = 200;
  int spacing = 13;
  //int radarHeight = 400;
  
  int numOfTango = 10;
  int ptXPos[] = new int[numOfTango];
  int ptYPos[] = new int[numOfTango];
  float ptRad = 2;
  int tango[] = new int[numOfTango];
  int alphaOne = 0;
  int alphaLast = 600;
  int growth = 2;
  
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Used to construct the radar system
  Radar(){  
    radarRing = new Grid();
    
    for(int i=0; i < tango.length; i++){
      tango[i] = i;
      ptXPos[i] = int(random(-radarDiameter/3, radarDiameter/3));
      ptYPos[i] = int(random(-radarDiameter/3, radarDiameter/3));
    }
  }
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  // *******************************************************
  // 
  void renderRadar(){
    pushMatrix();
    translate(1650, 830, 50);
    //drawScanGeo();
    drawRadar();
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
  /**
  void tangoPts(int diameter){
    pushMatrix();
    float ptXPos, ptYPos, ptRad;
    int numOfTangoes = 10;
    ptRad = 2;
    int alpha = int(map(second(), 0, 5, 0, 255));    
    for(int i=0; i < numOfTangoes; i++){
       ptXPos = random(-diameter, diameter);
       ptYPos = random(-diameter, diameter);
       color tangoColor = color(255, 0, 0, alpha);
       stroke(tangoColor);
       strokeWeight(2);
       ellipse(ptXPos, ptYPos, ptRad, ptRad);
    }
    popMatrix();
  }
  **/
  
  void tangoPts(){
    for(int i=0; i < tango.length; i++){
       pushMatrix();
       //translate(width/2, height/2);
       //int tXPos = ptXPos[i];
       //int tYPos = ptYPos[i];
       tangoPt(ptXPos[i], ptYPos[i]);
       popMatrix();
       //println("start: " + tXPos + " , " + tYPos);
       //int addX = int(random(-growth, growth));
       //ptXPos[i] += addX;
       //int addY = int(random(-growth, growth));
       //ptYPos[i] += addY;
       //println("add: " + addX + " , " + addY);
       //println("next: " + ptXPos[i] + " , " + ptYPos[i]);
    }
  }
  
  void tangoPt(int x, int y){
      pushMatrix();
      //translate(ptRad/2, ptRad/2);
      if(alphaOne != alphaLast){
         alphaOne++;
      }
      else{
         alphaOne = 0;
      }
      fill(redSolid, alphaOne);
      noStroke();
      ellipse(x, y, ptRad, ptRad);
      popMatrix();
  }
  
}  
