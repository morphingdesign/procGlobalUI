import controlP5.*;

// Class for grid construction
class Arsenal {  
  
  // Class Variables
    ControlP5 arsenalClassCP;
    Textarea dataStreamText;
    ScrollableList arsenalSelect;
    Slider viewSlider;
    
    String text;
    int viewportSizeX = 416;      // Used for 16:9 aspect ratio
    int viewportSizeY = 234;      // Used for 16:9 aspect ratio
    int dataStreamSizeX = 360;
    int dataStreamSizeY = 540;
    int viewport_ctrl = 47;
    int iteration;
    int dataSelection;
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Constructor
  // Used to construct an instance of the Arsenal controller object.   
  Arsenal(ControlP5 ctrlP5){
     arsenalClassCP = ctrlP5;
       viewSlider = arsenalClassCP.addSlider("slider")
       .setPosition(20, 1040)
       .plugTo(this, "setValue")
       .setValue(10)
       .setSize(viewportSizeX-60,10)
       .setRange(0,viewport_ctrl)
       .setSliderMode(Slider.FLEXIBLE)
       .setNumberOfTickMarks(47)
       .setLabel("Rotate View")
       .setValue(4)
       .setColorTickMark(color(0, 255, 0))
       .setColorForeground(color(255))
       .setColorBackground(color(0))
       .setColorActive(color(255, 0, 0))
       .setColorLabel(color(0, 255, 0))
       .setColorValue(color(0, 0, 0))
       .setVisible(false)
       ; 
     dataStreamText = arsenalClassCP.addTextarea("txt")
       .setPosition(25,245)
       .setSize(dataStreamSizeX - 10, dataStreamSizeY - 10)
       .setFont(monoFont)
       .setLineHeight(16)
       .setColor(color(0, 255, 0))
       .setScrollBackground(color(0, 0))
       .setScrollActive(color(255, 0, 0))
       .setScrollForeground(color(255))
       .setColorBackground(color(0,100))
       .setColorForeground(color(255,100))
       .setVisible(false)
       ;  
     arsenalSelect = arsenalClassCP.addScrollableList("arsenal")
       .setPosition(20, 200)
       .setSize(360, 100)
       .setBarHeight(20)
       .setItemHeight(20)
       .addItems(arsenalList)
       .setLabel("Arsenal Dropdown Menu")
       .plugTo(this, "setArsenalValue")
       //.setValue(0)
       .setType(ControlP5.DROPDOWN)  
       .setOpen(false)
       .setColorActive(whiteSolid)
       .setColorLabel(color(0, 255, 0))
       .setColorValue(greenSolid)
       .setColorForeground(redSolid)
       .setColorBackground(color(0))
       .setVisible(false)
       ;
  }
 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Class Methods
  
  // *******************************************************
  // Create shape
  void dataStreamBox(){
    viewSlider.setVisible(true); 
    dataStreamText.setVisible(true); 
    
    pushMatrix();
    translate(20, 200);
    fill(0, 180);
    stroke(0, 255, 0);
    strokeWeight(1);
    rect(0, 0, dataStreamSizeX, 20);
    rect(0, 40, dataStreamSizeX, dataStreamSizeY);
    dataStream();
    dataStreamText.setText(text.toUpperCase());
    popMatrix();
  }
  
  // *******************************************************
  // 
  void viewport(){
     arsenalSelect.setVisible(true); 
    
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
  
  // *******************************************************
  // Allows the slider to change the iteration number of the image array
  void setValue(int value){
    iteration = value;
  }
  
  void setArsenalValue(int i){
    arsenalClassCP.get(ScrollableList.class, "arsenal").getItem(i);
    dataSelection = i;
  }
  
  // *******************************************************
  // 
  void dataStream(){
      JSONObject drone = armory.getJSONObject(dataSelection);
      String id = drone.getString("id");
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
          
      text = codeName  + " " + name + "\n"  
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
