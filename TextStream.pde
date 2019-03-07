// Class for text stream construction and animation
class TextStream {  
  
  // Class Variables
  // No local class variables defined
  
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
    translate(22, 105, -1);                        // Position text stream in composition
    multiplier = 40;                               // Multiplier divides height to define 
    int numOfCurves = height / multiplier;         // ....the number of curves for stream
    int curveOffset = height / numOfCurves;        // Offset positions the curves 
    drawCurveSet(numOfCurves, curveOffset, 125);   // Render each of curves in system
    drawCurveSet(numOfCurves, curveOffset, 100);   // Each one is set with a unique alpha
    drawCurveSet(numOfCurves, curveOffset, 75);
    drawCurveSet(numOfCurves, curveOffset, 50);   
    translate(0, -5, 0);        // Position of pulsing lines
    pulse();                    // Top row of pulsing lines sync'ed with text stream
    popMatrix();
  }
  
  // *******************************************************
  // Create set of sine curves
  void drawCurveSet(int numOfCurves, int offset, int alpha){
    for(int i=0; i < numOfCurves; i++){
      pushMatrix();
      translate(0, (i * offset));    // Offset each of the curves within this set
      drawCurve(alpha);      // Color is defined within method, but alpha is set here
      popMatrix();
    }
  }
  
  // *******************************************************
  // Create pulsing row of lines
  void pulse(){
    stroke(whiteSolid, 200);        // Vertical lines offset in horizontal sequence
    for(int i = 0; i < 70; i++){    // ....by a multiple of 5 for 70 iterations
       line(i + (i * 5), 0, i + (i * 5), random(5, 30));  // Random creates pulse
    }                  
  }
  
  // *******************************************************
  // Create individual sine curves depicted with glyph characters
  void drawCurve(int alpha){    // Alpha parameter to allow varying transparency
    int scalar = 10;            // Amplitude (a.k.a. height) of sine curve 
    int arrayLength = (320)/scalar + scalar;   // Defines length of curve
    int shift;                  // Shift used to move curve horizontally
    noFill();                   // Sine curves are created, but not actually rendered
    noStroke();                 // Curves create paths to anchor glyphs
    float xList[] = new float[arrayLength];    // Array of x-values for curve
    float yList[] = new float[arrayLength];    // Array of y-values for curve
    
    for(int i=0; i < arrayLength; i++){
       shift = int(random(0, 5));      // Random creates a dynamic shift in curve
       xList[i] = scalar * i;          // X-values shift horizontally by scalar
       yList[i] = scalar * (sin(i) + shift);  // Y-values define curve amplitude
    }                                         // ....and depict horizontal shift
    
    beginShape();                      // Begin creation of curves using vertices
    curveVertex(xList[0], yList[0]);   // ....and predefined x- and y-values
    curveVertex(xList[0], yList[0]);   // First 2 vertices are control & first point
    for(int i=1; i < arrayLength; i++){
       curveVertex(xList[i], yList[i]);  // Subsequent vertices compose the curve
    }
    curveVertex(xList[xList.length-1], yList[yList.length-1]);  // Last control point
    endShape();                         // Finish curve creation
        
    char[] glyph = new char[95];      // Create array of glpyhs using Unicode decimal
    for(int i = 0; i < 95; i++){      // ....values to render a variety of characters
      glyph[i] = (char)(33 + i);      // ....including the alphabet
    }
    
    for(int i=0; i < arrayLength; i++){
       if(yList[i] > yList[0]){       // For each y value in vertex array, place a 
         textSize(10);                // ....random glyph from char array
         textAlign(CENTER, CENTER);   // Center glyph at each point position
         fill(whiteSolid, alpha);     // Defines color and alpha for glyph
         text(glyph[int(random(0, 95))], xList[i], yList[i]);  // Select random glyph
       }
    }
  }
}  
