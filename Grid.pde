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
  
  void drawGeo(){
    pushMatrix();
    strokeWeight(1);
    stroke(bkgdGridColor);
    translate(bkgdGridXOrigin, bkgdGridYOrigin);
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
}  
