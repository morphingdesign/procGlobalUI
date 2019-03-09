// Class for globe, global data, and globe control panel construction and animation
class Globe {  
  
  // Class Variables
  Grid globeRing;                          // Used to create ring border geometry around globe
  IsoWrap earthShell;                      // Used to pass through IsoWrap into this class
  ControlP5 globeClassCP;                  // Used to pass through Control P5 into this class
  Textlabel globeClassTextTitle;           // Title text for UI control panel
  Textlabel globeClassTextDesc;            // Description text for UI control panel
  ColorPicker globeClassCityColorPicker;   // UI control for global cities color
  ColorPicker globeClassAptColorPicker;    // UI control for global airports color
  ColorPicker globeClassPathColorPicker;   // UI control for global path color
  CheckBox globeClassDataCheckBox;         // UI control for global data visibility
  Knob globeClassScaleKnob;                // UI control for global scale
  Knob globeClassDataOffsetKnob;           // UI control for global data offset distance
  Knob globeClassPathOffsetKnob;           // UI control for global path offset distance
  Knob globeClassPathDetailKnob;           // UI control for global path density
  PVector[] pts = new PVector[1000];       // Declare vector array for use with globe mesh
  float radius = 400;                      // Radius of globe
  float offset = 0;                        // Perpendicular distance from globe surface for airports
  float projection = 30;                   // Perpendicular distance from globe surface for flight paths
  float dataPtScale = 1;                   // Sets the stroke weight for data points around globe
  float knobYPos = 290;                    // Y-position for consistent placement of all CtrlP5 knobs
  String title = ("GLOBAL VIEW CONTROL PANEL");                            // Title text
  String description = ("Visualize global network of airports and flight paths using"
                       + "\n the following control panel and settings.");  // Description text
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Create sphere mesh, global data points, boundary rings, and globe control panel
  Globe(IsoWrap isoWrap, ControlP5 ctrlP5){
    earthShell = isoWrap;                  // Pass through IsoWrap into this class
    globeClassCP = ctrlP5;                 // Pass through ControlP5 into this class
    globeRing = new Grid();                // Construct new Grid() for creating ring geometry
    
    // Loop to iteratively define coordinates for each vector used for creating sphere mesh
    for (int i=0; i<pts.length; i++) {
      float xOrigin = 0;                   // Sets centerpoint x-value of globe to 0  
      float yOrigin = 0;                   // Sets centerpoint y-value of globe to 0
      float zOrigin = 0;                   // Sets centerpoint z-value of globe to 0
      float xPoint, yPoint, zPoint;        // Declare x-, y-, z-values for use in conversion formula
      
      // +++++++++++++++++++++++++++++++++++++++++++++++++++++++
      // Formula for converting spherical to Cartesian coordinates source citation below:
      // https://en.wikipedia.org/wiki/Spherical_coordinate_system
      // Formula is used to create the x, y, z points using radius, theta, and phi
      float theta = random(PI * -1, PI);         // Random theta values derived from between range
      float phi = random(TWO_PI * -1, TWO_PI);   // Random phi values derived from between range
      xPoint = xOrigin + (radius * sin(theta) * cos(phi));
      yPoint = yOrigin + (radius * sin(theta) * sin(phi));
      zPoint = zOrigin + (radius * cos(theta));
      // +++++++++++++++++++++++++++++++++++++++++++++++++++++++
      
      pts[i] = new PVector(xPoint, yPoint, zPoint);  // Add vectors to array using created x, y, z values
    }  
    for (int i=0; i<pts.length; i++) {          
      for (int j=i+1; j<pts.length; j++) {     
        if (pts[i].dist( pts[j] ) < 50) {   // Loop & nested loop to add vectors from array to the addPt
          earthShell.addPt(pts[i]);         // ....method used to prepare sphere mesh
        }
      }
    }    
    
    // Globe control panel using ControlP5 elements
    globeClassTextTitle = globeClassCP.addTextlabel("titleText")  // Construct globe control title text
        .setPosition(1560, 40)              // Position title at top of control panel and left of globe
        .setText(title)                     // Set text to string variable "title"
        .setColorValue(greenSolid)          // Set color of text
        .setVisible(false)                  // Hide text for intro screen and link it to the
    ;                                       // ....visibility of the main page screen
    globeClassTextDesc = globeClassCP.addTextlabel("descText")
        .setPosition(1560, 52)              // Position description below title text
        .setText(description)               // Set text to string variable "description"
        .setColorValue(greenSolid)          // Set color of text
        .setVisible(false)                  // Hide text for intro screen and link it to the
    ;                                       // ....visibility of the main page screen
    globeClassDataCheckBox = globeClassCP.addCheckBox("checkBox")  // Toggles airport and path visibility
        .setPosition(1560, 80)              // Position row of checkboxes below CtrlP5 color pickers
        .setColorBackground(whiteSolid)     // Set colors for different elements used by checkboxes
        .setColorForeground(redSolid)
        .setColorActive(greenSolid)
        .setColorLabel(greenSolid)
        .setSize(20, 20)                    // Set size for each of the checkboxes
        .setItemsPerRow(3)                  // Set max number of checkboxes per row
        .setSpacingColumn(60)               // Set horizontal spacing between each checkbox
        .setSpacingRow(20)                  // Set vertical spacing between each row of checkboxes
        .addItem("Airports", 0)             // Define text and position for 1st checkbox; shows airports
        .addItem("Flight Paths", 1)         // Define text and position for 2nd checkbox; shows paths
        .activate(1)                        // By default, the checkboxes are turned off, but this 
                                            // ....activates the 2nd checkbox when program first runs
        .setVisible(false)                  // Hide check box for intro screen and link it to the
    ;                                       // ....visibility of the main page screen          
    globeClassScaleKnob = globeClassCP.addKnob("dataScale")  // Knob to change city point stroke weight
        .setPosition(1560, knobYPos)        // Position this 1st knob below CtrlP5 color pickers
        .setRange(0,5)                      // Set min and max range values
        .setValue(1)                        // Set initial value on knob for runtime
        .setRadius(30)                      // Set size of knob arc geometry
        .setNumberOfTickMarks(5)            // Set number of tick marks visible around knob arc
        .setTickMarkLength(2)               // Set tick mark length projected from knob arc
        .snapToTickMarks(true)              // Force knob movement to snap to defined tick marks
        .setColorForeground(whiteSolid)     // Set colors for different elements used by knob  
        .setColorBackground(blackSolid)
        .setColorActive(redSolid)
        .setColorLabel(greenSolid)
        .setDragDirection(Knob.HORIZONTAL)  // Knob operation set to dragging mouse horizontally
        .setLabel("City Scale")             // Set the visible label below the knob
        .setVisible(false)                  // Hide knob for intro screen and link it to the
    ;                                       // ....visibility of the main page screen 
    globeClassDataOffsetKnob = globeClassCP.addKnob("dataOffset")
        .setPosition(1640, knobYPos)        // Position 2nd knob below color pickers and next to 1st knob
        .setRange(0,20)                     // Set min and max range values
        .setValue(10)                       // Set initial value on knob for runtime
        .setRadius(30)                      // Set size of knob arc geometry
        .setNumberOfTickMarks(5)            // Set number of tick marks visible around knob arc
        .setTickMarkLength(2)               // Set tick mark length projected from knob arc
        .snapToTickMarks(false)             // Do not force knob movement to snap to defined tick marks
        .setColorForeground(whiteSolid)     // Set colors for different elements used by knob
        .setColorBackground(blackSolid)
        .setColorActive(redSolid)
        .setColorLabel(greenSolid)
        .setDragDirection(Knob.HORIZONTAL)  // Knob operation set to dragging mouse horizontally
        .setLabel("Data Offset")            // Set the visible label below the knob
        .setVisible(false)                  // Hide knob for intro screen and link it to the
    ;                                       // ....visibility of the main page screen  
    globeClassPathOffsetKnob = globeClassCP.addKnob("pathOffset")
        .setPosition(1720, knobYPos)        // Position 3rd knob below color pickers and next to 2nd knob
        .setRange(10,40)                    // Set min and max range values
        .setValue(30)                       // Set initial value on knob for runtime
        .setRadius(30)                      // Set size of knob arc geometry
        .setNumberOfTickMarks(5)            // Set number of tick marks visible around knob arc
        .setTickMarkLength(2)               // Set tick mark length projected from knob arc
        .snapToTickMarks(false)             // Do not force knob movement to snap to defined tick marks
        .setColorForeground(whiteSolid)     // Set colors for different elements used by knob
        .setColorBackground(blackSolid)
        .setColorActive(redSolid)
        .setColorLabel(greenSolid)
        .setDragDirection(Knob.HORIZONTAL)  // Knob operation set to dragging mouse horizontally
        .setLabel("Path Projection")        // Set the visible label below the knob
        .setVisible(false)                  // Hide knob for intro screen and link it to the
    ;                                       // ....visibility of the main page screen 
    // Controls the amount of paths visible in the Earth module
    // The data set "routes" includes a very large number of paths,
    // so this allows user to show only a few or a lot in the UI
    globeClassPathDetailKnob = globeClassCP.addKnob("pathDensity")  // Controls number of paths visible in
                                            // ....globe.  Data set "routes" includes a very large number
                                            // ....of paths, so this allows user to show only a few or a
                                            // ....lot in the UI
       .setPosition(1800, knobYPos)         // Position 4th knob below color pickers and next to 3rd knob
       .setRange(25,pathDensity)                    // Set min and max range values
       .setValue(100)                       // Set initial value on knob for runtime
       .setRadius(30)                       // Set size of knob arc geometry
       .setNumberOfTickMarks(5)             // Set number of tick marks visible around knob arc
       .setTickMarkLength(2)                // Set tick mark length projected from knob arc
       .snapToTickMarks(false)              // Do not force knob movement to snap to defined tick marks
       .setColorForeground(whiteSolid)      // Set colors for different elements used by knob
       .setColorBackground(blackSolid)
       .setColorActive(redSolid)
       .setColorLabel(greenSolid)
       .setDragDirection(Knob.HORIZONTAL)   // Knob operation set to dragging mouse horizontally
       .setLabel("Path Detail")             // Set the visible label below the knob
       .setVisible(false)                   // Hide knob for intro screen and link it to the
    ;                                       // ....visibility of the main page screen  
    globeClassPathColorPicker = globeClassCP.addColorPicker("pathPicker")  // Color picker for global paths
        .setPosition(1560, 230)             // Position color picker below airport color picker
        .setSize(260, 60)                   // Set size of bar denoting the dropdown color picker
        .setColorLabel(greenSolid)          // Set color for text label
        .setColorValue(color(0, 255, 0, 100))      // Set the starting color of the data paths
        .showBar()                          // Display the bar that activates dropdown color picker
        .setBarHeight(10)                   // Set the height of the bar
        .enableCollapse()                   // Allow for the color picker to be collapsed into a
        .close()                            // dropdown menu and have it closed initially
        .setLabel("Flight Path Color Selector")    // Set the visible text label within dropdown bar
        .setVisible(false)                  // Hide color picker for intro screen and link it to the
    ;                                       // ....visibility of the main page screen    
    globeClassAptColorPicker = globeClassCP.addColorPicker("aptPicker") // Color picker for airport points
        .setPosition(1560, 175)             // Position color picker below city color picker
        .setSize(260, 60)                   // Set size of bar denoting the dropdown color picker
        .setColorLabel(greenSolid)          // Set color for text label
        .setColorValue(color(255, 0, 0, 255))      // Set the starting color of the airport locations
        .showBar()                          // Display the bar that activates dropdown color picker
        .setBarHeight(10)                   // Set the height of the bar
        .enableCollapse()                   // Allow for the color picker to be collapsed into a
        .close()                            // dropdown menu and have it closed initially
        .setLabel("Airport Location Color Selector") // Set the visible text label within dropdown bar
        .setVisible(false)                  // Hide color picker for intro screen and link it to the
    ;                                       // ....visibility of the main page screen      
    globeClassCityColorPicker = globeClassCP.addColorPicker("cityPicker")  // Color picker for city points
        .setPosition(1560, 120)             // Position color picker below description text
        .setSize(260, 60)                   // Set size of bar denoting the dropdown color picker
        .setColorLabel(greenSolid)          // Set color for text label
        .setColorValue(color(255, 255, 255, 255))      // Set the starting color of the cities
        .showBar()                          // Display the bar that activates dropdown color picker
        .setBarHeight(10)                   // Set the height of the bar
        .enableCollapse()                   // Allow for the color picker to be collapsed into a
        .close()                            // dropdown menu and have it closed initially
        .setLabel("City Location Color Selector") // Set the visible text label within dropdown bar
        .setVisible(false)                  // Hide color picker for intro screen and link it to the
    ;                                       // ....visibility of the main page screen
  }
 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods

  // *******************************************************
  // Render UI elements for globe control panel
  void viewport(){
     globeClassTextTitle.setVisible(true);          // Activate visibility of title text,    
     globeClassTextDesc.setVisible(true);           // ....description text,
     globeClassCityColorPicker.setVisible(true);    // ....city point stroke color picker,
     globeClassAptColorPicker.setVisible(true);     // ....airport point stroke color picker,
     globeClassPathColorPicker.setVisible(true);    // ....path stroke color picker,
     globeClassDataCheckBox.setVisible(true);       // ....airport & path checkboxes,
     globeClassScaleKnob.setVisible(true);          // ....city point scale knob, 
     globeClassDataOffsetKnob.setVisible(true);     // ....airport offset knob, 
     globeClassPathOffsetKnob.setVisible(true);     // ....path offset knob,
     globeClassPathDetailKnob.setVisible(true);     // ....path density knob,
     pushMatrix();
     translate(1540, 20);                   // Position rectangle frame around control panel elements                
     fill(blackSolid);
     stroke(greenSolid);
     strokeWeight(1);
     rect(0, 0, 340, 360);                  // Create background and border for control panel
     popMatrix();
  }
  
  // *******************************************************
  // Render all elements to display globe with all global data
  void renderGlobe(){
    pushMatrix();
    translate(width/2, height/2);          // Position globe at center of canvas
    earthModule.drawSphereMask();          // Create mask to hide background and boundary around globe
    hotSpotStartX = width/2 - ctrTopPos;   // X- and y-values to define start of hotspot around globe
    hotSpotStartY = height/2 - ctrSidePos;
    hotSpotEndX = width/2 + ctrTopPos;     // X- and y-values to define end of hotspot around globe
    hotSpotEndY = height/2 + ctrSidePos;
    if(mouseX > hotSpotStartX &&  mouseX < hotSpotEndX && mouseY > hotSpotStartY && mouseY < hotSpotEndY){  
       rotateY(frameCount * 0.003 + mouseX * 0.003);
       rotateX(mouseY * 0.003);            // Conditional statement that evaluates mouse postiion relative
       inGlobalHotSpot = true;             // ....to defined hotspot area limits. If within the hotspot
    }                                      // ....area, the globe rotates horizontally and vertically
    else{                                  // ....based on mouse position.  When mouse is not in hotspot,
      rotateY(frameCount * 0.003);         // ....globe rotates slowly horizontally to the right.
      inGlobalHotSpot = false;
    }
    earthModule.globeShell();              // Render sphere mesh for globe shape
    earthModule.cityData();                // Render globe city points
    // The following variables get the values from the ControlP5 UI elements created by the constructor
    // ....and connects them to the actual geometry and data sets in the globe module.  These need to be
    // ....included in draw(), and not in the constructor/setup(), so that the values can be dynamically
    // ....updated and change the globe geometry.
    dataPtScale = globeClassScaleKnob.getValue();           // Links knob value to point stroke weight
    offset = globeClassDataOffsetKnob.getValue();           // Links knob value to point offset distance
    projection = globeClassPathOffsetKnob.getValue();       // Links knob value to path offset distance
    pathColor = globeClassPathColorPicker.getColorValue();  // Links color picker to path color 
    cityColor = globeClassCityColorPicker.getColorValue();  // Links color picker to city point color
    aptColor = globeClassAptColorPicker.getColorValue();    // Links color picker to airport point color
    if(globeClassDataCheckBox.getArrayValue(0) == 1){       // Evaluate if 1st checkbox is activated
       earthModule.airportData();                           // Render globe airport points if activated
    }
    if(globeClassDataCheckBox.getArrayValue(1) == 1){       // Evaluate if 2nd checkbox is activated
       earthModule.globePaths();                            // Render globe paths if activated
    }
    popMatrix();
  }
  
  // *******************************************************
  // Create sphere mesh using IsoWrap and array vectors initiated in constructor
  void globeShell(){
    noStroke();            // Do not display strokes of mesh edges
    fill(blackSolid);      // Fill meshes with black to mask data points on back side of globe
    earthShell.plot();     // Create sphere mesh using the vectors in array initiated in constructor
  }
  
  // *******************************************************
  // Create points to denote cities around globe using data source
  void cityData(){
    for(int i=0; i < cities.getRowCount(); i++){    // Iterate through each row within data source
       float latitude = cities.getFloat(i, "lat");  // Extract latitude for each item in data source
       float longitude = cities.getFloat(i, "lng"); // Extract longitude for each item in data source
       PVector aPt = sphereToCart(radians(latitude), radians(longitude));  // Convert lat/lon to Cartesian
                                                    // ....coordinates and create vectors for each line item
       aPt.mult(radius);                            // Multiply each vector by globe radius
       stroke(cityColor);                           // Set point stroke color; linked to color picker value
       strokeWeight(dataPtScale);                   // Set point stroke weight; linked to knob value
       point(aPt.x, aPt.y, aPt.z);                  // Create each point through iterations
    }  
  }

  // *******************************************************
  // Create points to denote airports around globe using data source
  void airportData(){
    for(int i=0; i < airports.getRowCount(); i++){  // Iterate through each row within data source
       float latitude = airports.getFloat(i, 6);    // Extract latitude for each item in data source
       float longitude = airports.getFloat(i, 7);   // Extract longitude for each item in data source
       PVector aPt = sphereToCart(radians(latitude), radians(longitude));  // Convert lat/lon to Cartesian
                                                    // ....coordinates and create vectors for each line item       
       aPt.mult(radius + offset);                   // Multiply each airport vector by globe radius and link
                                                    // ....to offset that is set by knob value
       stroke(aptColor);                            // Set point stroke color; linked to color picker value
       strokeWeight(1);                             // Set point stroke weight
       point(aPt.x, aPt.y, aPt.z);                  // Create each point through iterations
    }   
  }
    
  // *******************************************************
  // Create lines to denote flight paths connecting airport locations around globe using data source
  void globePaths(){
    
    for(int i=0; i < routes.getRowCount(); i+=pathDensity){          // Iterate through each data item in data; interval set by control knob to moderate density
       String source = routes.getString(i, 0);                       // Extract flight path source airport for each data item/row in route data
       String destination = routes.getString(i, 1);                  // Extract flight path destination airport for each data item/row in route data
       TableRow srcIteration = airports.findRow(source, 4);          // Search for airport name in airport data & extract row number if match with source variable
       TableRow destIteration = airports.findRow(destination, 4);    // Search for airport name in airport data & extract row number match with destination variable
       if(srcIteration != null && destIteration != null){            // Check to verify data item is valid; skips data items with missing information
           String aptCodeSrc = srcIteration.getString(4);            // Extract source airport name from airport data based on which row the loop is processing
           String aptCodeDest = destIteration.getString(4);          // Extract destination airport name from airport data based on which row the loop is processing
           if(source.equals(aptCodeSrc) && destination.equals(aptCodeDest)){    // Check to see if source airport name from route data equals airport name from 
                                                                     // ....airport data and if destination airport name from route data equals airport name from
                                                                     // ....route data.  Proceed with nested code if equal.
               PVector rise = new PVector(0, 0, 0);                  // Initialize vector used to set start/end control point of path perpendicular to sphere
               float srcLatitude = srcIteration.getFloat(6);         // Extract latitude for selected source airport in data source
               float srcLongitude = srcIteration.getFloat(7);        // Extract longitude for selected source airport in data source
               aptSource = sphereToCart(radians(srcLatitude), radians(srcLongitude));  // Convert lat/lon to Cartesian coordinates & create vector for each
               aptSource = aptSource.mult(radius + offset);          // Multiply each airport vector by globe radius and link to offset that is set by knob value
               PVector aptSourceAnchor = aptSource.cross(rise);      // Use cross product of airport source vector with rise to set first control path point
                                                                     // ....perpendicular to sphere.
               float destLatitude = destIteration.getFloat(6);       // Extract latitude for selected destination airport in data source
               float destLongitude = destIteration.getFloat(7);      // Extract longitude for selected destination airport in data source
               aptDestination = sphereToCart(radians(destLatitude), radians(destLongitude)); // Convert lat/lon to Cartesian coordinates & create vector for each
               aptDestination = aptDestination.mult(410);            // Multiply each airport vector by globe radius and link to offset that is set by knob value
               PVector aptDestinationAnchor = aptDestination.cross(rise);    // Use cross product of airport source vector with rise to set first control path
                                                                     // ....point perpendicular to sphere.
               float midLatitude = srcLatitude + ((destLatitude - srcLatitude) / 2);      // Compute latitude for path midpoint by halving distance between source
                                                                     // ....and destination latitude values. 
               float midLongitude = srcLongitude + ((destLongitude - srcLongitude) / 2);  // Compute longitude for path midpoint by halving distance between source
                                                                     // ....and destination latitude values. 
               PVector aptMidpoint = sphereToCart(radians(midLatitude), radians(midLongitude)); // Convert lat/lon to Cartesian coordinates & create vector for each
               aptMidpoint = aptMidpoint.mult(radius + offset + projection);    // Midpoint vector of path multiplied by projection value set by control knob
               noFill();
               stroke(pathColor);                                    // Set path stroke color based on linked color picker
               strokeWeight(1);
               beginShape();                                         // Create path using curve and curve vertices
                 curveVertex(aptSourceAnchor.x, aptSourceAnchor.y, aptSourceAnchor.z);                // Control point for first path point; makes it perpendicular
                 curveVertex(aptSource.x, aptSource.y, aptSource.z);                                  // First path point; aligns with source airport point
                 curveVertex(aptMidpoint.x, aptMidpoint.y, aptMidpoint.z);                            // Middle path point; interpolated between source & destination
                 curveVertex(aptDestination.x, aptDestination.y, aptDestination.z);                   // Last path point; aligns with destination airport point
                 curveVertex(aptDestinationAnchor.x, aptDestinationAnchor.y, aptDestinationAnchor.z); // Control point for last path point; makes it perpendicular
               endShape();
           }        
       }
    }
  }

  // *******************************************************
  // Returns vector from latitute/longitude conversion to Cartesian coordinate system
  PVector sphereToCart(float lat, float lon){
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Algorithms for mapping latitude/longitude coordinates to three-dimensional Cartesian
    // coordinates derived from the following resource link:
    // https://www.mathworks.com/help/matlab/ref/sph2cart.html
    // Formulas from this reference were then converted to align elevation to latitude and
    // azimuth to longitude
    PVector vNew = new PVector(-cos(lat) * cos(lon), -sin(lat), cos(lat) * sin(lon));
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++
    return vNew;    // Returns vector as output for this method
  }
  
  // *******************************************************
  // Create ring boundary around globe and mask to hide square grid in background
  void drawSphereMask(){
    pushMatrix();
    fill(blackSolid);                     // Solid fill to serve as mask for background
    strokeWeight(1);
    stroke(whiteSolid, 100);
    ellipseMode(RADIUS);          
    ellipse(0, 0, height/2, height/2);    // Shape mask to fit within ring boundary
    globeRing.radialGrid(height-10, -5, 10, 1, 1, whiteSolid, 100, true);  // Series of rings with tick
    globeRing.radialGrid(height-20, -5, 5, 1, 1, whiteSolid, 100, true);   // ....marks to serve as 
    globeRing.radialGrid(height-20, 5, 1, 1, 1, whiteSolid, 100, true);    // ....boundary for globe
    popMatrix();
  }
}  
