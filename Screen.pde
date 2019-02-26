// Class for grid construction
class Screen {  
  
  // Class Variables
  color screenLineColor = color(0, 255, 0);
  color redBright = color(255, 0, 0);
  color white = color(255);
  int edgeOffset = 10;
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Used to construct an instance of the Cog object.  The parameters passed through define the type of cog and its behavior
 
  Screen(){

  }
   
 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  // *******************************************************
  // Create shape
  
  void plate(){
    
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
    stroke(screenLineColor);
    fill(0, 180);
    rect(20, 40, 220, 40);
    
    // Title
    noStroke();
    fill(screenLineColor);
    textFont(playFont, 10);        // Reference new font "Play"
    textAlign(LEFT, TOP);
    text("PROJECT", 40, 43);
    textFont(playFont, 24);        // Reference new font "Play"
    text("STRATOSPHERE", 40, 48);

    pushMatrix();
    translate(20, 90);
    pulse(); 
    popMatrix();
    
    pushMatrix();
    int ctrTopPos = 490;
    translate(width/2 - ctrTopPos, 90);
    sideEdge(ctrTopPos * 2, screenLineColor);    
    popMatrix();
    
    pushMatrix();
    translate(width/2 + ctrTopPos, height - 90);
    rotate(PI);
    sideEdge(ctrTopPos * 2, screenLineColor);
    popMatrix();
    
    pushMatrix();
    int ctrSidePos = 360;
    translate(width/2 - ctrTopPos, height/2 + ctrSidePos);
    rotate(PI/-2);
    color highlightEdge; 
    if(inRadarHotSpot){
       highlightEdge = redBright;
    }
    else{
      highlightEdge = white;
    };
    sideEdge(ctrSidePos * 2, highlightEdge);
    popMatrix();
    
    pushMatrix();
    translate(width/2 + ctrTopPos, height/2 - ctrSidePos);
    rotate(PI/2);
    sideEdge(ctrSidePos * 2, highlightEdge);
    popMatrix();
    
  }
  
  
  void cornerEdge(){
    int length1 = 20;
    int length2 = 80;
    strokeWeight(1);
    stroke(screenLineColor);
    line(edgeOffset, edgeOffset, edgeOffset, length2);
    line(edgeOffset, edgeOffset, length1, edgeOffset);
    line(edgeOffset, height/2 - length2, edgeOffset, height/2 + length2); 
    line(edgeOffset, height - edgeOffset, edgeOffset, height - length2);
    line(edgeOffset, height - edgeOffset, length1, height - edgeOffset);
  }
  
  void sideEdge(int length, color lineColor){
    int length1 = 20;
    strokeWeight(1);
    stroke(lineColor);
    line(0, 0, length, 0);
    line(0, 0, 0, length1);
    line(length, 0, length, length1);
  }
  
  void pulse(){
    stroke(screenLineColor);  
    for(int i = 0; i < 70; i++){
       line(i + (i * 5), 0, i + (i * 5), random(5, 30));
    }
  }

}  
