// Class for grid construction
class Grid {  
  
  // Class Variables
  int bkgdGridXOrigin = width/2;
  int bkgdGridYOrigin = 0;
  int spacing;
  //color gridColor;
  
  color bkgdGridColor = (50);
  int bkgdGridSpace = 20;

  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // 
 
  Grid(){  
  }
 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  
  
  // *******************************************************
  // Create rectangular grid
  void rectGrid(int bkgdGridColor, int gridSpace){
    pushMatrix();
    strokeWeight(1);
    stroke(bkgdGridColor);
    translate(bkgdGridXOrigin, bkgdGridYOrigin, -1);
    
    /**
    // Horizontal Lines
    for(int i=0; i < height; i+=gridSpace){
       line(0, i, width, i);
    }
    // Vertical Lines
    for(int i=0; i < width; i+=gridSpace){
       line(i, 0, i, height);
    }
    **/
    
    // Horizontal Lines
    for(int i=0; i < height; i+=gridSpace){
       line(0, i, width/2, i);
    }
    // Vertical Lines
    for(int i=0; i < width/2; i+=gridSpace){
       line(i, 0, i, height);
    }
    
    popMatrix();
  }
  
  // *******************************************************
  // 
  void radialGrid(int diameter, int projection, int interval, int ringWeight, int tickWeight, color gridColor, int colorAlpha, boolean ticks){
    int lineLength;
    color radarColor = color(gridColor, colorAlpha);
    pushMatrix();
    noFill();
    strokeWeight(ringWeight);
    stroke(radarColor);
    ellipseMode(RADIUS);
    ellipse(0, 0, diameter/2, diameter/2);
    if(ticks){
       lineLength = diameter/2 - projection;
    }
    else{
       lineLength = 0;
    }
    for(int i = 0; i < 360; i+=interval){
      stroke(radarColor);
      strokeWeight(tickWeight);
      rotate(radians(i));
      line(lineLength, 0, diameter/2, 0);
      rotate(radians(-i));
    }
    popMatrix();
  }  
}  
