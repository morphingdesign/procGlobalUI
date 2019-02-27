// Class for text stream construction and animation
class TextStream {  
  
  // Class Variables
  //color textColor = color(39, 255, 8);   // original color
  color textColor = color(255, 0, 0); 
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Used to construct the text stream
 
  TextStream(){
  }
 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  // *******************************************************
  // Render dynamic text stream
  void renderStream(int multiplier){
    pushMatrix();
    translate(20, 0, -1);

    multiplier = 40;
    int numOfCurves = height / multiplier;
    int curveOffset = height / numOfCurves;
    
    drawCurveArray(numOfCurves, curveOffset, 125);
    drawCurveArray(numOfCurves, curveOffset, 100);
    drawCurveArray(numOfCurves, curveOffset, 75);
    drawCurveArray(numOfCurves, curveOffset, 50);     
    popMatrix(); 
  }
  
  // *******************************************************
  // 
  void drawCurveArray(int numOfCurves, int offset, int alpha){
    for(int i=0; i < numOfCurves; i++){
      pushMatrix();
      translate(0, (i * offset));
      drawCurve(alpha);
      popMatrix();
    }
  }
  
  // *******************************************************
  // 
  void drawCurve(int alpha){
    int scalar = 10;
    int arrayLength = (width)/scalar + scalar;
    int shift;
    
    noFill();
    noStroke();
    strokeWeight(1);
    
    float xList[] = new float[arrayLength];
    float yList[] = new float[arrayLength];
    
    for(int i=0; i < arrayLength; i++){
       shift = int(random(0, 2));
       xList[i] = scalar * i;
       yList[i] = scalar * (sin(i) + shift);
    }
    beginShape();
    curveVertex(xList[0], yList[0]);
    curveVertex(xList[0], yList[0]);
    
    for(int i=1; i < arrayLength; i++){
       curveVertex(xList[i], yList[i]);
    }
    curveVertex(xList[xList.length-1], yList[yList.length-1]);
    endShape();
    
    char[] alphabet = new char[26];
    for(int i = 0; i < 26; i++){
      alphabet[i] = (char)(65 + i);
    }
    
    char[] glyph = new char[95];
    for(int i = 0; i < 95; i++){
      glyph[i] = (char)(33 + i);
    }
    
    for(int i=0; i < arrayLength; i++){
       if(yList[i] > yList[0]){
         noStroke();
         noFill();
         ellipse(xList[i], yList[i], 3, 3);
         
         textSize(10);
         textAlign(CENTER, CENTER);
         
         fill(textColor, alpha);          // Defines color for all text in background
         text(glyph[int(random(0, 95))], xList[i], yList[i]);
       }
    }
  }
}  
