import controlP5.*;

// Class for grid construction
class Arsenal {  
  
  // Class Variables
    ControlP5 arsenalClassCP;
    int viewportSizeX = 416;      // Used for 16:9 aspect ratio
    int viewportSizeY = 234;      // Used for 16:9 aspect ratio
    int dataStreamSizeX = 360;
    int dataStreamSizeY = 560;
    int viewport_ctrl = 47;
    int iteration;
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Used to construct an instance of the Arsenal controller object.  
 
  Arsenal(ControlP5 ctrlP5, String iterAdd){
     arsenalClassCP = ctrlP5;
     arsenalClassCP.addSlider("iteration-" + iterAdd)
       .setPosition(20, 1040)
       .plugTo(this, "setValue")
       .setValue(10)
       .setSize(viewportSizeX-60,10)
       .setRange(0,viewport_ctrl)
       .setSliderMode(Slider.FLEXIBLE)
       .setNumberOfTickMarks(47)
       .setLabel("Rotate View")
       //.shuffle()        // Sets to a random value
       .setValue(4)
       .setColorTickMark(color(0, 255, 0))
       .setColorForeground(color(0, 255, 0))
       .setColorBackground(color(0))
       .setColorActive(color(255, 0, 0))
       .setColorLabel(color(0, 255, 0))
       .setColorValue(color(0, 0, 0))
       ; 
  }
   
 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  // *******************************************************
  // Create shape
  
  void dataStream(){
    pushMatrix();
    translate(20, 200);
    fill(0, 180);
    stroke(0, 255, 0);
    rect(0, 0, dataStreamSizeX, dataStreamSizeY);
    
    popMatrix();
  }
  
  void viewport(){
     pushMatrix();
     translate(20, 800);
     fill(0);
     noStroke();
     rect(0, 0, viewportSizeX, viewportSizeY);
     image(photo[iteration], 0, 0);
     noFill();
     stroke(color(0, 255, 0));
     strokeWeight(1);
     rect(0, 0, viewportSizeX, viewportSizeY);
     popMatrix();
  }
  
  void setValue(int value){
    iteration = value;
  }

}  
