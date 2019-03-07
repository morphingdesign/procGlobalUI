class Arc {

  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Variables
  // Local class variables connect the different local methods and their operations
  int outDiameter;   // Outer diameter of arc shape
  int inDiameter;    // Inner diameter of arc shape
  int angle;         // Start position of the arc
  int firstAngle;    // Start of the arc creation, relative to angle
  int secondAngle;   // End of the arc creation
  color arcColor;    // Sets color arc fill or stroke

  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Used to construct an instance of an arc shape with option to rotate
  // Can be either as a solid or an outline
  Arc(int oDia, int iDia, int fAngle, int sAngle, int ang, color aColor) {
    outDiameter = oDia;
    inDiameter = iDia;
    firstAngle = fAngle;
    secondAngle = sAngle;
    angle = ang;
    arcColor = aColor;
  }

  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  // *******************************************************
  // Create complete arc shape with rotation
  void rotateArc(float direction, int fillOpt){
    pushMatrix();   
    rotate(radians((angle++) * direction));    // Rotate direction either CW or CCW
    if(fillOpt == 1){
       createArcOutline();    // Create arc with only an outline and no fill
    }
    else{
       createArcSolid();      // Create arc with only fill and no outline
    }
    popMatrix();
  }

  // *******************************************************
  // Create arc with only fill and no outline; its position is defined in this method
  void createArcSolid(){
      noStroke();
      fill(arcColor);    // Main arc solid shape
      arc(0, 0, outDiameter, outDiameter, radians(firstAngle), radians(secondAngle), PIE); 
      fill(blackSolid);  // Solid ellipse superimposed to cover inner part of the arc
      ellipse(0, 0, inDiameter, inDiameter);   
  }
  
  // *******************************************************
  // Create arc with only outline and no fill; its position is defined in this method
  void createArcOutline(){
      noStroke();
      // Outer top line made by superimposing inner arc over outer arc, leaving a line
      fill(arcColor);
      arc(0, 0, outDiameter, outDiameter, radians(firstAngle), radians(secondAngle), PIE);
      fill(blackSolid);  // Superimposing inner arc
      arc(0, 0, outDiameter - 4, outDiameter - 4, radians(firstAngle), radians(secondAngle), PIE);
      
      // Left & right side lines mady by superimposing inner arc over outer arc, leaving a line
      // Left side line
      fill(arcColor);
      arc(0, 0, outDiameter, outDiameter, radians(firstAngle), radians(firstAngle + 1), PIE);
      // Right side line
      arc(0, 0, outDiameter, outDiameter, radians(secondAngle), radians(secondAngle + 1), PIE);
      fill(blackSolid);  // Superimposing inner arc
      arc(0, 0, inDiameter, inDiameter, radians(firstAngle), radians(secondAngle + 1), PIE);
      
      // Inner bottom line made by superimposing inner arc over outer arc, leaving a line
      fill(arcColor);
      arc(0, 0, inDiameter + 4, inDiameter + 4, radians(firstAngle), radians(secondAngle), PIE);
      fill(blackSolid);  // Superimposing inner arc
      arc(0, 0, inDiameter, inDiameter, radians(firstAngle), radians(secondAngle), PIE);
  }
}
