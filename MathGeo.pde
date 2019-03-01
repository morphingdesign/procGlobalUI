// Class for grid construction
class MathGeo {  
  
  // Class Variables
  float animSpeed = 0.03;  // Speed for screen saver animation
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // 
  MathGeo(){ 
  }
 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
    
  // *******************************************************
  // Creates a Tranguloid Trefoil shape as an abstract form
  // to serve as a screen saver when program is not running
  void geoTrefoil(){
    float x, y, z, u, v;
    float scalar = 45;
    float iteration = .05;
    pushMatrix();
    translate(width/2, height/2, 400);
    rotateX(frameCount * animSpeed);
    rotateY(frameCount * animSpeed);
    rotateZ(frameCount * animSpeed);
    stroke(255);
    strokeWeight(1);
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Formula for Tranguloid Trefoil source citation below:
    // http://www.3d-meier.de/tut3/Seite57.html
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
    for(u=-PI; u < PI; u+=iteration){
      for(v=-PI; v < PI; v+=iteration){
        x = (2 * sin(3 * u) / (2 + cos(v))) * scalar;
        y = (2 * (sin(u) + 2 * sin(2 * u)) / (2 + cos(v + 2 * PI / 3))) * scalar;
        z = ((cos(u) - 2 * cos(2 * u)) * (2 + cos(v)) * (2 + cos(v + 2 * PI / 3)) / 4) * scalar;
        point(x, y, z);        
      }
    }
    popMatrix();  
  }
  
  // *******************************************************
  // Creates a blend shape between a Hyperbolic Helicoid and 
  // a Stilleto Surface geometry shape as an abstract form
  // to serve as an interactive screen saver when program is 
  // not running  
  void geoHelicoid(){    
    float depth = -10;
    depth = map(mouseY, 0, height, 0, 2);
    
    pushMatrix();
    translate(width/2, height/2, depth);
    rotateX(frameCount * animSpeed);
    rotateY(frameCount * animSpeed);
    rotateZ(frameCount * animSpeed);
    stroke(0);
    strokeWeight(4);
  
    float x, y, z, u, v;
    float iteration = .4;
    float scalar = 800;
    float easing = 0.1;
    for(u=0; u < TWO_PI; u+=iteration){
      for(v=0; v < PI; v+=iteration){
        stroke(random(100, 120));
        strokeWeight(2);
        // +++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // Formula for Stiletto Surface source citation below:
        // http://www.3d-meier.de/tut3/Seite53.html
        // +++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
        x = (2 + cos(u)) * cos(v) * cos(v) * cos(v) * sin(v) * scalar;
        y = (2 + cos(u + 2 * PI / 3)) * cos(v + 2 * PI / 3) * cos(v + 2 * PI / 3) * sin(v + 2 * PI / 3) * sin(v + 2 * PI / 3) * scalar; 
        z = -(2 + cos(u - 2 * PI / 3)) * cos(v + 2 * PI / 3) * cos(v + 2 * PI / 3) * sin(v + 2 * PI / 3) * sin(v + 2 * PI / 3) * scalar;
        
        float x2, y2, z2, u2, v2;
        float iteration2 = .4;
        float scalar2 = 1200;
        float a = 1;            // Changes variation of Hyperbolic Helicoid
        for(u2=0; u2 < TWO_PI; u2+=iteration2){
          for(v2=0; v2 < PI; v2+=iteration2){
            stroke(random(100, 120));
            strokeWeight(2);
            // +++++++++++++++++++++++++++++++++++++++++++++++++++++++
            // Formula for Hyperbolic Helicoid source citation below:
            // http://www.3d-meier.de/tut3/Seite26.html
            // +++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
            x2 = (float)(Math.sinh(v2) * cos(a * u2) / (1 + Math.cosh(u2) * Math.cosh(v2))) * scalar2;
            y2 = (float)(Math.sinh(v2) * sin(a * u2) / (1 + Math.cosh(u2) * Math.cosh(v2))) * scalar2;
            z2 = (float)(Math.cosh(v2) * Math.sinh(u2) / (1 + Math.cosh(u2) * Math.cosh(v2))) * scalar2;
            
            point(x, y, z);
  
            float mouseXPos = map(mouseX, 0, width, -1, 1);  
            float dX = mouseXPos * x2 - x;
            x += dX * easing;
            
            float mouseYPos = map(mouseY, 0, width, -1, 1);  
            float dY = mouseYPos * y2 - y;
            y += dY * easing;
            
            float mouseZPos = depth;
            float dZ = mouseZPos * z2 - z;
            z += dZ * easing;
            
            point(x, y, z);
          }
        }
      }
    }    
    popMatrix();
  }
}  
