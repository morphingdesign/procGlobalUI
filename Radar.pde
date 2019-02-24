import ComputationalGeometry.*;


// Class for all strange attractor construction and animation
class Radar {

  // Processing Libraries
  
  
  // Class Variables
  
  IsoSkeleton attractorGeo;
  
  float zm = 0;
  float sp = 0.01 * frameCount * 0.004;
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Used to construct an instance of the Cog object.  The parameters passed through define the type of cog and its behavior
 
  Radar(IsoSkeleton isoSkeleton){
    attractorGeo = isoSkeleton;
    float x, y, z, a, c, d, e, k, f, dt, scalar;
    PVector[] pts = new PVector[10000];
      
    dt = 0.0005;
    a = 40;
    c = 1.833;
    d = 0.16;
    e = 0.65;
    k = 55;
    f = 20;
    scalar = 1;
  
    pts[0] = new PVector(0.349, 0, -0.16);
    x = pts[0].x;
    y = pts[0].y;
    z = pts[0].z;
    
    for(int i=1; i < pts.length; i++){
      x = x + (a * (y - x) + d * x * z) * dt * scalar;
      y = y + (k * x + f * y - x * z) * dt * scalar;
      z = z + (c * z + x * y - e * x * x) * dt * scalar;
      pts[i] = new PVector(x, y, z);
      //println(pts[i]);
      x = pts[i].x;
      y = pts[i].y;
      z = pts[i].z; 
    }
  
    for (int i=0; i<pts.length - 1; i++) {
      attractorGeo.addEdge(pts[i], pts[i+1]);
      
    }
  }
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  void posRadar(){
    pushMatrix();
    translate(1650, 830, 50);
    drawGeo();
    drawRadar();
    popMatrix();
  }
  
  // *******************************************************
  // Create shape
  void drawGeo(){
    pushMatrix();
    lights();
    //translate(1600, 800, 50);
    translate(585,245,-750);
    rotateZ(frameCount*0.1);
    rotateX(frameCount*0.2);
    rotateY(frameCount*0.1);
    stroke(attractorColor);
    strokeWeight(1);
    attractorGeo.plot(.5, 0);
    popMatrix();
  }
  
  void drawRadar(){
    noFill();
    pushMatrix();
    int radius = 200;
    int spacing = 10;
    ellipseMode(RADIUS);
    stroke(100, 100);
    strokeWeight(1);
    for(int i=10; i < radius; i+=spacing){
       ellipse(0, 0, i, i);
    }
    stroke(100, 255);
    strokeWeight(2);
    ellipse(0, 0, radius, radius);
    popMatrix();
  }
}  
