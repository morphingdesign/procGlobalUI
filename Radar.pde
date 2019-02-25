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
    
    pushMatrix();
    int radius = 200;
    int spacing = 13;
    ellipseMode(RADIUS);

    noFill();
    stroke(255, 10);
    strokeWeight(4);
    for(int i=10; i < radius; i+=spacing){
       ellipse(0, 0, i, i);
    }
    
    
    stroke(255, 50);
    strokeWeight(1);
    for(int i=5; i < radius; i+=spacing){
       ellipse(0, 0, i, i);
    }
    popMatrix();
    
    pushMatrix();
    translate(0,0,0);
    fill(1);
    //noFill();
    stroke(100, 255);
    strokeWeight(2);
    ellipse(0, 0, radius, radius);
    popMatrix();
    
    
    
    
    
    int radarHeight = 400;
  
    pushMatrix();
    translate(0, 0);
    radarScanArc(radarHeight);
    
    radialGrid(radarHeight/4, -3, 10, 1, 1, 150 ,true);
    radialGrid(radarHeight/2, 5, 20, 1, 1, 100, true);
    radialGrid(int(radarHeight * 0.75), 10, 10, 2, 1, 150, true);
    radialGrid(radarHeight, 5, 2, 1, 1, 200, true);
    radialGrid(radarHeight, 0, 45, 1, 1, 100, false);
    radialGrid(radarHeight, 0, 90, 1, 1, 255, false);
    
    tangoPts(radarHeight/2 - radarHeight/4);
    
    popMatrix();
    
  }
  
  
  
  void radarScanArc(int diameter){
    float rSpeed = 1;
    color scanColorLight = color(0, 255, 0, 10);
    color scanColorDark = color(0, 255, 0, 100);
    int angle = 45;
    pushMatrix();
    float rotateSpeed = map(second(), 0, 59, 0, TWO_PI) * rSpeed;
    rotate(rotateSpeed);                       // Dynamic rotation initiated
    for(float i = 0; i < angle; i+=0.25){
      float gradRange = map(i, 0, angle, 0.0, 1.0);
      color gradient = lerpColor(scanColorLight, scanColorDark, gradRange);
      stroke(gradient);
      rotate(radians(i));
      line(0, 0, diameter/2, 0);
      rotate(radians(-i));
    }
    popMatrix();
  }
  
  //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  // RELOCATE THIS FUNCTION TO THE GRID CLASS
  // THE GLOBE CLASS IS ALREADY USING THIS COPY OF THE FUNCTION THAT IS LOCATED IN THE GRID CLASS
  // BRING IN THIS FUNCTION FROM THE GRID CLASS INTO THE RADAR CLASS SO THAT THERE IS ONLY A SINGLE FUNCTION 
  // IN THE ENTIRE PROGRAM - CONSOLIDATE
  //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  void radialGrid(int diameter, int projection, int interval, int ringWeight, int tickWeight, int colorAlpha, boolean ticks){
    int lineLength;
    color radarColor = color(0, 255, 0, colorAlpha);
    pushMatrix();
    noFill();
    strokeWeight(ringWeight);
    stroke(radarColor);
    ellipseMode(RADIUS);
    ellipse(0, 0, diameter/2, diameter/2);
    if(ticks){
       lineLength = diameter/2 - projection;
    }
    else{
       lineLength = 0;
    }
    for(int i = 0; i < 360; i+=interval){
      stroke(radarColor);
      strokeWeight(tickWeight);
      rotate(radians(i));
      line(lineLength, 0, diameter/2, 0);
      rotate(radians(-i));
    }
    popMatrix();
  }
  //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  
  void tangoPts(int diameter){
    pushMatrix();
    float ptXPos, ptYPos, ptRad;
    int numOfTangoes = 10;
    //int alpha = 150;
    
    //randomSeed(0);    // Turning this on here will freeze the TextStream since it relies on a randomSeed;
                        // Consider adding a randomSeed() to the TextStream to isolate this randomSeed
                        // from that randomSeed()
    ptRad = 2;
    int alpha = int(map(second(), 0, 10, 150, 255));
    for(int i=0; i < numOfTangoes; i++){
       ptXPos = random(-diameter, diameter);
       ptYPos = random(-diameter, diameter);
       
       color tangoColor = color(255, 0, 0, alpha);
       stroke(tangoColor);
       strokeWeight(2);
       ellipse(ptXPos, ptYPos, ptRad, ptRad);
    }
    popMatrix();
  }
  
  
}  
