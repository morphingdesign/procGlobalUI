// Class for math geometry construction
class MathGeo {  
  
  // Class Variables
  float animSpeed = 0.03;  // Speed multiplier for intro screen animation of math geo
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Used to construct the math geo
  MathGeo(){ 
  }
 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
    
  // *******************************************************
  // Creates a Tranguloid Trefoil shape as an abstract form to serve as part of intro screen
  void geoTrefoil(){
    float x, y, z, u, v;
    float scalar = 45;        // Define scale of geometry relative to canvas
    float iteration = .05;    // Spacing of computed values within geometry formulas
    pushMatrix();
    translate(width/2, height/2, 400);  // Place geometry at canvas center and closer to 
    rotateX(frameCount * animSpeed);    // ....foreground by translating z-axis
    rotateY(frameCount * animSpeed);    // Rotate geometry around all axes and sync with
    rotateZ(frameCount * animSpeed);    // .... frame count
    stroke(whiteSolid);
    strokeWeight(1);
    for(u=-PI; u < PI; u+=iteration){    // Apply u & v values along predefined iterations
      for(v=-PI; v < PI; v+=iteration){  // ....to compute x, y, z values for each point
      
        // +++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // Formula for Tranguloid Trefoil source citation below:
        // http://www.3d-meier.de/tut3/Seite57.html
        // Formula is used to create the x, y, z points
        x = (2 * sin(3 * u) / (2 + cos(v))) * scalar;
        y = (2 * (sin(u) + 2 * sin(2 * u)) / (2 + cos(v + 2 * PI / 3))) * scalar;
        z = ((cos(u) - 2 * cos(2 * u)) * (2 + cos(v)) * (2 + cos(v + 2 * PI / 3)) / 4) * scalar;
        // +++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
        
        point(x, y, z);                  // Create points using generated x, y, z values
      }
    }
    popMatrix();  
  }
  
  // *******************************************************
  // Creates a blend shape between a Hyperbolic Helicoid and a Stilleto Surface geometry shape
  // as an abstract form to serve as part of interactive intro screen 
  void geoHelicoid(){    
    float depth = -10;                      
    depth = map(mouseY, 0, height, 0, 2);   // Map the depth variable using the mouse position as it moves vertically along the canvas
    float x, y, z, u, v;
    float scalar = 800;                     // Define scale of geometry relative to canvas; varies greatly to compensate point z-value
    float iteration = .4;                   // Spacing of computed values within geometry formulas
    pushMatrix();
    translate(width/2, height/2, depth);    // Position geometry at center and vary z-axis by mouse position
    rotateX(frameCount * animSpeed);        // Rotate geometry around all axes and sync with frame count
    rotateY(frameCount * animSpeed);
    rotateZ(frameCount * animSpeed);
    strokeWeight(2);                        // Weight set to 2 to pronounce points clearer as they are dynamic
    stroke(100);                            // Set color of points to a grayscale range since weight is set to 2
    for(u=0; u < TWO_PI; u+=iteration){     // Apply u & v values along predefined iterations to compute x, y, z values for each point
      for(v=0; v < PI; v+=iteration){    
        
        // +++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // Formula for Stiletto Surface source citation below:
        // http://www.3d-meier.de/tut3/Seite53.html
        // Formula is used to create the x, y, z points
        x = (2 + cos(u)) * cos(v) * cos(v) * cos(v) * sin(v) * scalar;
        y = (2 + cos(u + 2 * PI / 3)) * cos(v + 2 * PI / 3) * cos(v + 2 * PI / 3) * sin(v + 2 * PI / 3) * sin(v + 2 * PI / 3) * scalar; 
        z = -(2 + cos(u - 2 * PI / 3)) * cos(v + 2 * PI / 3) * cos(v + 2 * PI / 3) * sin(v + 2 * PI / 3) * sin(v + 2 * PI / 3) * scalar;
        // +++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        float x2, y2, z2, u2, v2;
        float scalar2 = 1200;              // Define scale of geometry relative to canvas; varies greatly to compensate point z-value
        float iteration2 = .4;             // Spacing of computed values within geometry formulas
        float a = 1;                       // Changes variation of Hyperbolic Helicoid
        for(u2=0; u2 < TWO_PI; u2+=iteration2){    // Apply u & v values along predefined iterations to compute x, y, z values for points
          for(v2=0; v2 < PI; v2+=iteration2){
            
            // +++++++++++++++++++++++++++++++++++++++++++++++++++++++
            // Formula for Hyperbolic Helicoid source citation below:
            // http://www.3d-meier.de/tut3/Seite26.html
            // Formula is used to create the x, y, z points
            x2 = (float)(Math.sinh(v2) * cos(a * u2) / (1 + Math.cosh(u2) * Math.cosh(v2))) * scalar2;
            y2 = (float)(Math.sinh(v2) * sin(a * u2) / (1 + Math.cosh(u2) * Math.cosh(v2))) * scalar2;
            z2 = (float)(Math.cosh(v2) * Math.sinh(u2) / (1 + Math.cosh(u2) * Math.cosh(v2))) * scalar2;
            // +++++++++++++++++++++++++++++++++++++++++++++++++++++++   
            
            float mouseXPos = map(mouseX, 0, width, -1, 1);    // Map the mouse x-position within canvas width to a small range
            float mouseYPos = map(mouseY, 0, height, -1, 1);   // Map the mouse y-position within canvas width to a small range
            float mouseZPos = depth;                           // Align the mouse z-position variable with the varying depth variable
            
            // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
            // The following code block using easing referenced from the following source: https://processing.org/examples/easing.html
            float easing = 0.1;              // Easing variable used to create a smooth transition between mouse position movement
            float dX = mouseXPos * x2 - x;   // Use the mapped mouse-x and -y variables, along with mouse-z variable to translate
            float dY = mouseYPos * y2 - y;   // .... via a gradual delta between each of the 2 geometric shapes, the Hyperbolic Helicoid
            float dZ = mouseZPos * z2 - z;   // .... and the Stiletto Surface, creating a new abstract form that blends the two into one
            x += dX * easing;                // New x-, y-, and z-values defined with the additional delta and easing for gradual change
            y += dY * easing;
            z += dZ * easing;
            // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            
            point(x, y, z);                  // Create points using generated x, y, z values
          }
        }
      }
    }    
    popMatrix();
  }
}  
