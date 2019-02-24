// Class for globe and global data construction and animation
class Globe {  
  
  // Class Variables


  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Used to construct an instance of the Cog object.  The parameters passed through define the type of cog and its behavior
 
  Globe(){
  }
   
 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  // *******************************************************
  // Create globe
  
  void drawGlobeGeo(int radius, int offset){
    for(int i=0; i < cities.getRowCount(); i++){
       float latitude = cities.getFloat(i, "lat");
       float longitude = cities.getFloat(i, "lng");
       PVector aPt = sphereToCart(radians(latitude), radians(longitude));
       aPt.mult(radius);
       stroke(255);
       strokeWeight(1);
       point(aPt.x, aPt.y, aPt.z);
    }  
    for(int i=0; i < airports.getRowCount(); i++){
       float latitude = airports.getFloat(i, 6);
       float longitude = airports.getFloat(i, 7);
       PVector aPt = sphereToCart(radians(latitude), radians(longitude));
       aPt.mult(radius + offset);
       stroke(255, 0, 0);
       strokeWeight(1);
       point(aPt.x, aPt.y, aPt.z);
    }    
    
  }
  
  void globePaths(){
    float lift = 1;
    PVector rise = new PVector(0, 0, 0);
    float projection = 30;
    //for(int i=0; i < routes.getRowCount(); i++){
    //for(int i=0; i < 3000; i++){
    for(int i=0; i < routes.getRowCount(); i+=pathDensity){  
       String source = routes.getString(i, 0);
       String destination = routes.getString(i, 1);
       TableRow srcIteration = airports.findRow(source, 4);
       TableRow destIteration = airports.findRow(destination, 4);
       if(srcIteration != null && destIteration != null){
           String aptCodeSrc = srcIteration.getString(4);
           String aptCodeDest = destIteration.getString(4);
           if(source.equals(aptCodeSrc) && destination.equals(aptCodeDest)){
               noFill();
               float srcLatitude = srcIteration.getFloat(6);
               float srcLongitude = srcIteration.getFloat(7);
               aptSource = sphereToCart(radians(srcLatitude), radians(srcLongitude));
               aptSource = aptSource.mult(410);
               PVector aptSourceAnchor = aptSource.cross(rise);
               float destLatitude = destIteration.getFloat(6);
               float destLongitude = destIteration.getFloat(7);
               aptDestination = sphereToCart(radians(destLatitude), radians(destLongitude));
               aptDestination = aptDestination.mult(410);
               PVector aptDestinationAnchor = aptDestination.cross(rise);
               float midLatitude = srcLatitude + ((destLatitude - srcLatitude) / 2);
               float midLongitude = srcLongitude + ((destLongitude - srcLongitude) / 2);
               PVector aptMidpoint = sphereToCart(radians(midLatitude), radians(midLongitude));
               aptMidpoint = aptMidpoint.mult(410 + projection);
               stroke(pathColor);
               strokeWeight(1);
               beginShape();
                 curveVertex(aptSourceAnchor.x, aptSourceAnchor.y, aptSourceAnchor.z);
                 curveVertex(aptSource.x, aptSource.y, aptSource.z);
                 curveVertex(aptMidpoint.x, aptMidpoint.y, aptMidpoint.z);
                 curveVertex(aptDestination.x, aptDestination.y, aptDestination.z);
                 curveVertex(aptDestinationAnchor.x, aptDestinationAnchor.y, aptDestinationAnchor.z);
               endShape();
               float dist = PVector.dist(aptSource, aptDestination);
           }        
       }
    }
  }

  PVector sphereToCart(float lat, float lon){
    // Algorithms for mapping spherical coordinates to three-dimensional Cartesian
    // coordinates derived from the following resource link:
    // https://www.mathworks.com/help/matlab/ref/sph2cart.html
    // Formulas from this reference were then converted to align elevation to latitude
    // and azimuth to longitude
    PVector vNew = new PVector(-cos(lat) * cos(lon), -sin(lat), cos(lat) * sin(lon));
    return vNew;
  }
  
  void drawSphereMask(){
    pushMatrix();
    translate(width/2, height/2);
    fill(10);
    strokeWeight(1);
    stroke(255);
    ellipseMode(RADIUS);
    ellipse(0, 0, height/2, height/2);
    popMatrix();
  }
}  
