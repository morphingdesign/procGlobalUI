// Class for grid construction
class Grid {  
  
  // Class Variables
  int bkgdGridXOrigin = 0;
  int bkgdGridYOrigin = 0;
  int spacing;
  color gridColor;

  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Used to construct an instance of the Cog object.  The parameters passed through define the type of cog and its behavior
 
  Grid(color gColor, int gSpace){
    gridColor = gColor;
    spacing = gSpace;
  }
   
 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  // *******************************************************
  // Create shape
  
  void rectGrid(){
    pushMatrix();
    strokeWeight(1);
    stroke(bkgdGridColor);
    translate(bkgdGridXOrigin, bkgdGridYOrigin, -1);
    // Horizontal Lines
    for(int i=0; i < height; i+=spacing){
       line(0, i, width, i);
    }
    // Vertical Lines
    for(int i=0; i < width; i+=spacing){
       line(i, 0, i, height);
    }
    popMatrix();
  }
  
  void radialGrid(int diameter, int projection, int interval, int ringWeight, int tickWeight, int colorAlpha, boolean ticks){
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
      stroke(gridColor);
      strokeWeight(tickWeight);
      rotate(radians(i));
      line(lineLength, 0, diameter/2, 0);
      rotate(radians(-i));
    }
    popMatrix();
  }
}  
