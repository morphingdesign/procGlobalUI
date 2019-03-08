// Class for arsenal viewer and UI construction
class Arsenal {  
  
  // Class Variables
    ControlP5 arsenalClassCP;     // Used to pass through Control P5 into this class
    Textarea dataTextBox;         // Control P5 text field for arsenal data
    ScrollableList arsenalSelect; // Control P5 list that serves as a collapsable dropdown menu
    Slider viewSlider;            // Control P5 slider for interactive image viewport
    String guideText;             // String of text used to create framework
    int viewportSizeX = 416;      // Sizes image viewport width to align with 16:9 aspect ratio
    int viewportSizeY = 234;      // Sizes image viewport height to align with 16:9 aspect ratio
    int dataTextBoxSizeX = 360;   // Width of main text field
    int dataTextBoxSizeY = 540;   // Height of main text field
    int iteration;                // Defines selection within image array used in the image viewport
    int dataSelection;            // Defines selection within arsenal array used in the dropdown menu
  
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
       .setVisible(false)                     // Hide slider for intro screen and link it to the
       ;                                      // ....visibility of the main page screen
     dataTextBox = arsenalClassCP.addTextarea("txt")  // Construct arsenal text box
       .setPosition(25,245)                   // Position text box below dropdown list menu
       .setSize(dataTextBoxSizeX - 10, dataTextBoxSizeY - 10)  // Subtract margins from width & height
       .setFont(monoFont)                     // Use imported font type & size for text in text box
       .setLineHeight(16)                     // Set text line leading
       .setColor(greenSolid)                  // Set color of text in text box
       .setScrollBackground(blackSolid)       // Set color of scroll bar background
       .setScrollActive(redSolid)             // Set color of scroll handle to red when active
       .setScrollForeground(whiteSolid)       // Set color of scroll handle to white when inactive
       .setColorBackground(color(blackSolid,100))    // Transparency added to allow text stream
       .setColorForeground(color(whiteSolid,100))    // ....in background to show through       
       .setVisible(false)                     // Initially hide slider for intro screen and link 
       ;                                      // ....to main page view visibility  
     arsenalSelect = arsenalClassCP.addScrollableList("arsenal")  // Construct arsenal dropdown menu
       .setPosition(20, 140)                  // Position menu above text box
       .setSize(360, 100)                     // Align width of dropdown with text box boundary
       .setBarHeight(20)                      // Height for initial list item in dropdown menu
       .setItemHeight(20)                     // Height for all other list items in menu
       .addItems(arsenalList)                 // Add items from arsenal list array
       .setLabel("Arsenal Dropdown Menu")     // Set the visible label for the dropdown menu
       .plugTo(this, "setArsenalValue")       // Connect list item value to arsenal data source
       .setType(ControlP5.DROPDOWN)           // Set the list to act as a dropdown vs. a list
       .setOpen(false)                        // Initiate the dropdown menu to be closed
       .setColorActive(whiteSolid)            // Set colors for different elements in dropdown menu
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
  // Text box with bounding frame and data stream
  void dataTextBox(){
    dataTextBox.setVisible(true);             // Activate visibility of text box and dropdown menu
    arsenalSelect.setVisible(true);           // ....when this method is called in draw()
    pushMatrix();
    translate(20, 140);                       // Define position for frame behind menu & text box
    fill(0, 180);                             // Add transparency to fill of background rectangles
    stroke(greenSolid);                       // Stroke color for background rectangle frames
    strokeWeight(1);                          // Stroke weight for background rectangle frames
    rect(0, 0, dataTextBoxSizeX, 20);         // Rectangle frame for dropdown menu
    rect(0, 100, dataTextBoxSizeX, dataTextBoxSizeY);    // Rectangle frame for textbox
    dataStream();                             // Display data stream from arsenal JSON file
    dataTextBox.setText(guideText.toUpperCase());        // Sets the text from JSON data stream into
    popMatrix();                                         // .... text box. It is called within draw()
  }                                                      // .... to allow data set to switch based on
                                                         // .... selection from dropdown menu.  Cannot
                                                         // .... be located in constructor or text will
                                                         // .... be static and unchangeable in draw().
  
  // *******************************************************
  // 
  void viewport(){
     viewSlider.setVisible(true);              // Activate visibility of text box and dropdown menu 
     pushMatrix();                             // ....when this method is called in draw()
     translate(20, 800);                       // Define position for frame behind image viewport 
     fill(blackSolid);                         // Background fill set to black to compensate for
     noStroke();                               // ....any transparency in PNGs within image array
     rect(0, 0, viewportSizeX, viewportSizeY); // Background rectangle behind image viewport
     image(photo[iteration], 0, 0);            // Display corresponding image from image array
     noFill();                                 // No fill in rectangle frame on top of image viewport
     stroke(greenSolid);
     strokeWeight(1);
     rect(0, 0, viewportSizeX, viewportSizeY); // Green frame to serve as border around image viewport
     popMatrix();
  }
  
  // *******************************************************
  // Defines value for the slider to change the iteration number in the image array
  void setValue(int value){                    // Method name coordinated with "plugTo" method in
    iteration = value;                         // .... ControlP5 viewSlider in constructor
  }
  
  // *******************************************************
  // Defines the value for the dropdown menu to change the JSON object within the linked data stream
  void setArsenalValue(int i){                 // Method name coordinated with "plugTo" method in
    arsenalClassCP.get(ScrollableList.class, "arsenal").getItem(i);  // ....ControlP5 arsenalSelect
    dataSelection = i;                         // This local class variable identifies JSON object
  }                                            // ....selection within dataStream() 
  
  // *******************************************************
  // Method to parse data within each object in JSON array and combine with text labels
  void dataStream(){                                             // Parse top level JSONObject based on
      JSONObject drone = arsenal.getJSONObject(dataSelection);   // dataSelection variable.     
      String codeName = drone.getString("codename");             // Parsed data within the top level
      String name = drone.getString("name");                     // ...."drone" JSONObject
      JSONObject genChar = drone.getJSONObject("General Characteristics");  // Parse 2nd level JSONObject
      String crew = genChar.getString("Crew");                   // The rest are parsed data within the
      String dLength = genChar.getString("Length");              // ...."genChar" JSONObject
      String wingspan = genChar.getString("Wingspan");
      String dHeight = genChar.getString("Height");
      String emptyWeight = genChar.getString("Empty weight");
      String maxWeight = genChar.getString("Max takeoff weight");
      String fuelCap = genChar.getString("Fuel capacity");
      String payload = genChar.getString("Payload");
      String internal = genChar.getString("Internal");
      String external = genChar.getString("External");
      String power = genChar.getString("Powerplant");
      JSONObject perform = drone.getJSONObject("Performance");  // Parse 2nd level JSONObject
      String maxSpeed = perform.getString("Maximum speed");     // The rest are parsed data within the
      String cruiseSpeed = perform.getString("Cruise speed");   // ...."perform" JSONObject
      String range = perform.getString("Range");
      String endurance = perform.getString("Endurance");
      String serviceClg = perform.getString("Service ceiling");
      String opAlt = perform.getString("Operational altitude");
      JSONObject armament = drone.getJSONObject("Armament");    // Parse 2nd level JSONObject
      String arm1 = armament.getString("1");                    // The rest are parsed data within the
      String arm2 = armament.getString("2");                    // ...."armament" JSONObject
      String arm3 = armament.getString("3");
      String arm4 = armament.getString("4");
      String arm5 = armament.getString("5");
      String arm6 = armament.getString("6");
      String arm7 = armament.getString("7");
      String arm8 = armament.getString("8");
      JSONObject avionics = drone.getJSONObject("Avionics");   // Parse 2nd level JSONObject
      String av1 = avionics.getString("1");                    // The rest are parsed data within the
      String av2 = avionics.getString("2");                    // ...."avionics" JSONObject
      String av3 = avionics.getString("3");
          
      // This guideText variable coordinates string variables from JSONArray above with text labels, 
      // separators, and new line breaks. It is basically one continuous line of text using new line
      // breaks ("\n") to separate each line item.  Code formatted to show each line item on a separate
      // line for clarity.
      guideText = codeName  + " " + name + "\n"                // Title for selected arsenal item
        + "***************************************" + "\n"     // Visible separator using asterisks
        + "General Characteristics" + "\n"                     // Section title
        + "***************************************" + "\n"     
        + "Crew: " + crew + "\n"                               // This is a typical format showing a 
        + "Length: " + dLength + "\n"                          // ....text label followed by a reference
        + "Wingspan: " + wingspan + "\n"                       // ....to a certain string parsed from
        + "Height: " + dHeight + "\n"                          // ....JSONArray, and ending with a new
        + "Empty Weight: " + emptyWeight + "\n"                // ....line break
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
