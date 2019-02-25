import controlP5.*;

// Class for grid construction
class Arsenal {  
  
  // Class Variables
    ControlP5 arsenalClassCP;
    PImage photo[] = new PImage[48];
    String imgFileNameBase = "images/drone (";
    String imgFileNameEnd = ").png";
    int viewportSizeX = 416;
    int viewportSizeY = 234;
    int viewport_ctrl = 47;
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Used to construct an instance of the Cog object.  The parameters passed through define the type of cog and its behavior
 
  Arsenal(ControlP5 ctrlP5){
     arsenalClassCP = ctrlP5;
     for(int i=0; i < photo.length ; i++){
        photo[i] = loadImage(imgFileNameBase + (i + 1) + imgFileNameEnd);
     }
     arsenalClassCP.addSlider("viewport_ctrl")
       .setPosition(20, 270)
       .setSize(viewportSizeX-70,10)
       .setRange(0,viewport_ctrl)
       .setSliderMode(Slider.FLEXIBLE)
       .setNumberOfTickMarks(47)
       .shuffle()        // Sets to a random value
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
  
  void viewport(){
     pushMatrix();
     translate(20, 20);
     image(photo[viewport_ctrl], 0, 0);
     noFill();
     stroke(color(0, 255, 0));
     strokeWeight(1);
     rect(0, 0, viewportSizeX, viewportSizeY);
     popMatrix();
  }
  

}  
