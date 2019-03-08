// Class for arsenal viewer and UI construction
class Arsenal {  
  
  // Class Variables
    ControlP5 arsenalClassCP;     // Used to pass through Control P5 into this class
    Textarea dataStreamText;      // Control P5 text field for arsenal data
    ScrollableList arsenalSelect; // Control P5 list that serves as a collapsable dropdown menu
    Slider viewSlider;            // Control P5 slider for interactive image viewport
    String guideText;             // String of text used to create framework
    int viewportSizeX = 416;      // Sizes image viewport width to align with 16:9 aspect ratio
    int viewportSizeY = 234;      // Sizes image viewport height to align with 16:9 aspect ratio
    int dataStreamSizeX = 360;    // Width of main text field
    int dataStreamSizeY = 540;    // Height of main text field
    int iteration;                // 
    int dataSelection;            // 
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Used to construct the assets within the arsenal module 
  Arsenal(ControlP5 ctrlP5){                  // Construct the Arsenal controller object 
     arsenalClassCP = ctrlP5;                 // Pass through ControlP5 into this class
     viewSlider = arsenalClassCP.addSlider("slider")  // Add slider UI element
       .setPosition(20, 1040)                 // Position slider below image portal
       .plugTo(this, "setValue")              // Connect the slider value to viewport method
       .setSize(viewportSizeX-60,10)          // Coordinate slider size with image viewport
       .setRange(0,numOfFrames - 1)           // Max value defined by number of image frames
       .setSliderMode(Slider.FLEXIBLE)        // Show slider control as a triangle vs. a bar
       .setNumberOfTickMarks(numOfFrames - 1) // Align tick marks with number of image frames
       .setLabel("Rotate View")               // Set the visible label adjacent to slider
       .setValue(4)                           // Set initial value on slider for runtime
       .setColorTickMark(greenSolid)          // Set colors for different elements in slider
       .setColorForeground(whiteSolid)
       .setColorBackground(blackSolid)
       .setColorActive(redSolid)
       .setColorLabel(greenSolid)
       .setColorValue(blackSolid)
       .setVisible(false)                     // Initially hide slider for intro screen and link  
       ;                                      // ....to main page view visibility
     dataStreamText = arsenalClassCP.addTextarea("txt")  // 
       .setPosition(25,245)
       .setSize(dataStreamSizeX - 10, dataStreamSizeY - 10)
       .setFont(monoFont)
       .setLineHeight(16)
       .setColor(greenSolid)                  // Set color of text in text box
       .setScrollBackground(blackSolid)       // Set color of scroll bar background
       .setScrollActive(redSolid)             // Set color of scroll handle to red when active
       .setScrollForeground(whiteSolid)       // Set color of scroll handle to white when inactive
       .setColorBackground(color(blackSolid,100))    // Transparency added to allow text stream
       .setColorForeground(color(whiteSolid,100))    // ....in background to show through       
       .setVisible(false)                     // Initially hide slider for intro screen and link 
       ;                                      // ....to main page view visibility  
     arsenalSelect = arsenalClassCP.addScrollableList("arsenal")  // 
       .setPosition(20, 140)
       .setSize(360, 100)
       .setBarHeight(20)
       .setItemHeight(20)
       .addItems(arsenalList)
       .setLabel("Arsenal Dropdown Menu")
       .plugTo(this, "setArsenalValue")
       .setType(ControlP5.DROPDOWN)  
       .setOpen(false)
       .setColorActive(whiteSolid)
       .setColorLabel(greenSolid)
       .setColorValue(greenSolid)
       .setColorForeground(redSolid)
       .setColorBackground(blackSolid)
       .setVisible(false)                     // Initially hide slider for intro screen and link
       ;                                      // ....to main page view visibility
  }
 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  // *******************************************************
  // Create shape
  void dataStreamBox(){
    viewSlider.setVisible(true); 
    dataStreamText.setVisible(true); 
    
    pushMatrix();
    translate(20, 140);
    fill(0, 180);
    stroke(0, 255, 0);
    strokeWeight(1);
    rect(0, 0, dataStreamSizeX, 20);
    rect(0, 100, dataStreamSizeX, dataStreamSizeY);
    dataStream();
    dataStreamText.setText(guideText.toUpperCase());
    popMatrix();
  }
  
  // *******************************************************
  // 
  void viewport(){
     arsenalSelect.setVisible(true);     // Activate visibility when this method is called in draw()
     pushMatrix();
     translate(20, 800);
     fill(0);
     noStroke();
     rect(0, 0, viewportSizeX, viewportSizeY);      // Solid black background behind images
     image(photo[iteration], 0, 0);                 // Since some images have transparency
     noFill();
     stroke(color(0, 255, 0));
     strokeWeight(1);
     rect(0, 0, viewportSizeX, viewportSizeY);      // Border around viewport
     popMatrix();
  }
  
  // *******************************************************
  // Allows the slider to change the iteration number of the image array
  void setValue(int value){
    iteration = value;
  }
  
  // *******************************************************
  // 
  void setArsenalValue(int i){
    arsenalClassCP.get(ScrollableList.class, "arsenal").getItem(i);
    dataSelection = i;
  }
  
  // *******************************************************
  // 
  void dataStream(){
      JSONObject drone = arsenal.getJSONObject(dataSelection);
      //String id = drone.getString("id");
      String codeName = drone.getString("codename");
      String name = drone.getString("name");
      JSONObject genChar = drone.getJSONObject("General Characteristics");
      String crew = genChar.getString("Crew");
      String dLength = genChar.getString("Length");
      String wingspan = genChar.getString("Wingspan");
      String dHeight = genChar.getString("Height");
      String emptyWeight = genChar.getString("Empty weight");
      String maxWeight = genChar.getString("Max takeoff weight");
      String fuelCap = genChar.getString("Fuel capacity");
      String payload = genChar.getString("Payload");
      String internal = genChar.getString("Internal");
      String external = genChar.getString("External");
      String power = genChar.getString("Powerplant");
      JSONObject perform = drone.getJSONObject("Performance");
      String maxSpeed = perform.getString("Maximum speed");
      String cruiseSpeed = perform.getString("Cruise speed");
      String range = perform.getString("Range");
      String endurance = perform.getString("Endurance");
      String serviceClg = perform.getString("Service ceiling");
      String opAlt = perform.getString("Operational altitude");
      JSONObject armament = drone.getJSONObject("Armament");
      String arm1 = armament.getString("1");
      String arm2 = armament.getString("2");
      String arm3 = armament.getString("3");
      String arm4 = armament.getString("4");
      String arm5 = armament.getString("5");
      String arm6 = armament.getString("6");
      String arm7 = armament.getString("7");
      String arm8 = armament.getString("8");
      JSONObject avionics = drone.getJSONObject("Avionics");
      String av1 = avionics.getString("1");
      String av2 = avionics.getString("2");
      String av3 = avionics.getString("3");
          
      guideText = codeName  + " " + name + "\n"      // 
        + "***************************************" + "\n"
        + "General Characteristics" + "\n"
        + "***************************************" + "\n"
        + "Crew: " + crew + "\n"
        + "Length: " + dLength + "\n"
        + "Wingspan: " + wingspan + "\n"
        + "Height: " + dHeight + "\n"
        + "Empty Weight: " + emptyWeight + "\n"
        + "Max Weight: " + maxWeight + "\n"
        + "Fuel Capacity: " + fuelCap + "\n"
        + "Payload: " + payload + "\n"
        + "Internal: " + internal + "\n"
        + "External: " + external + "\n"
        + "Powerplant: " + power + "\n"
        + "***************************************" + "\n"
        + "Performance" + "\n"
        + "***************************************" + "\n"
        + "Maximum Speed: " + maxSpeed + "\n"
        + "Cruise Speed: " + cruiseSpeed + "\n"
        + "Range: " + range + "\n"
        + "Endurance: " + endurance + "\n"
        + "Service Ceiling: " + serviceClg + "\n"
        + "Operational Altitude: " + opAlt + "\n"
        + "***************************************" + "\n"
        + "Armament" + "\n"
        + "***************************************" + "\n"
        + "*** " + arm1 + " "
        + "*** " + arm2 + " "
        + "*** " + arm3 + " "
        + "*** " + arm4 + " "
        + "*** " + arm5 + " "
        + "*** " + arm6 + " "
        + "*** " + arm7 + " "
        + "*** " + arm8 + "\n"
        + "***************************************" + "\n"
        + "Avionics" + "\n"
        + "***************************************" + "\n"
        + "*** " + av1 + " "
        + "*** " + av2 + " "
        + "*** " + av3 + "\n"
        + "***************************************";
  }
  
}  
