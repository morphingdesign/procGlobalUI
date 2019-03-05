class Arc {

  int firstAngle;
  int secondAngle;
  int angle;
  int outDiameter;
  int inDiameter;
  color arcColor;

  Arc(int oDia, int iDia, int fAngle, int sAngle, int ang, color aColor) {
    outDiameter = oDia;
    inDiameter = iDia;
    firstAngle = fAngle;
    secondAngle = sAngle;
    angle = ang;
    arcColor = aColor;
  }

  void rotateArc(float direction, int fillOpt){
    pushMatrix();
    //if(second() > 30 && second() < 59){
    //   direction*=-1;   
    //}    
    rotate(radians((angle++) * direction));
    if(fillOpt == 1){
       createOutline();
    }
    else{
       createSolid();
    }
    popMatrix();
  }

  void createSolid(){
      noStroke();
      fill(arcColor);
      arc(0, 0, outDiameter, outDiameter, radians(firstAngle), radians(secondAngle), PIE); 
      fill(blackSolid);
      arc(0, 0, inDiameter, inDiameter, radians(firstAngle), radians(secondAngle), OPEN);
      noStroke();
      ellipse(0, 0, inDiameter, inDiameter); 
  }
  
  void createOutline(){
      noStroke();
      // Outer line
      fill(arcColor);
      arc(0, 0, outDiameter, outDiameter, radians(firstAngle), radians(secondAngle), PIE);
      fill(blackSolid);
      arc(0, 0, outDiameter - 4, outDiameter - 4, radians(firstAngle), radians(secondAngle), PIE);
      //ellipse(0, 0, outDiameter - 4, outDiameter - 4);
      // Left line
      fill(arcColor);
      arc(0, 0, outDiameter, outDiameter, radians(firstAngle), radians(firstAngle + 1), PIE);
      // Right line
      arc(0, 0, outDiameter, outDiameter, radians(secondAngle), radians(secondAngle + 1), PIE);
      fill(blackSolid);
      arc(0, 0, inDiameter, inDiameter, radians(firstAngle), radians(secondAngle + 1), PIE);
      //ellipse(0, 0, inDiameter, inDiameter);
      // Bottom line
      fill(arcColor);
      arc(0, 0, inDiameter + 4, inDiameter + 4, radians(firstAngle), radians(secondAngle), PIE);
      fill(blackSolid);
      arc(0, 0, inDiameter, inDiameter, radians(firstAngle), radians(secondAngle), PIE);
      //ellipse(0, 0, inDiameter, inDiameter);
  }

}
