// Class for grid construction
class Grid {  
  
  // Class Variables 
  // No local class variables defined
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Used to construct either a rectangular or radial grid
  Grid(){  
  }
 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  // *******************************************************
  // Create rectangular grid system of horizontal and vertical lines
  void rectGrid(int x, int bkgdGridColor, int gridSpace){
    pushMatrix();
    strokeWeight(1);
    stroke(bkgdGridColor);
    translate(x, 0, -1);           // X-value used to vary start position
    for(int i=0; i < height; i+=gridSpace){
       line(0, i, width, i);       // Horizontal Lines
    }                              // Line spacing varies by passed through parameter
    for(int i=0; i < width; i+=gridSpace){
       line(i, 0, i, height);       // Vertical Lines
    }
    popMatrix();
  }
  
  // *******************************************************
  // Create a single radial ring instance with or without tick marks
  void radialGrid(int diameter, int projection, int interval, int ringWeight, 
              int tickWeight, color gridColor, int colorAlpha, boolean ticks){
    int tickLineLength;
    pushMatrix();
    noFill();
    strokeWeight(ringWeight);
    stroke(gridColor, colorAlpha);   // Color & alpha separated to allow varying alphas
    ellipseMode(RADIUS);
    ellipse(0, 0, diameter/2, diameter/2);
    if(ticks){                       // Conditionatal to check if ticks are used or not
       tickLineLength = diameter/2 - projection;
    }                                // Projection variable defines length of tick from
    else{                            // ....ring towards its center point
       tickLineLength = 0;           // When ticks are not active, they are not shown
    }
    for(int i = 0; i < 360; i+=interval){  // Interval defines spacing of tick lines
      strokeWeight(tickWeight);
      stroke(gridColor, colorAlpha); // Color & alpha separated to allow varying alphas
      rotate(radians(i));            // Coordinate system rotated for each tick
      line(tickLineLength, 0, diameter/2, 0);
      rotate(radians(-i));           // Coordinate system rotation reset before next
    }                                // ....iteration
    popMatrix();
  }  
}  
