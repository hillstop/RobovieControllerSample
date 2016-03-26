import processing.serial.*;
import controlP5.*;
import java.util.*;

Serial serial;

ControlP5 cp5;
CheckBox checkBox;
Slider2D slider2D;
Slider sliderEyeLid;
Button button;

List<Slider> sliderList;
List<Integer> sliderValueList;

String sendSerial;

static final int rate = 30;

///////////////////////////////////SetUp/////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void setup() {
  frameRate(rate);
  size(400, 400);
  serial = new Serial(this,Serial.list()[0],115200);
  
  sendSerial = "w 200880 00 00 00 01\r\n";
  serial.write(sendSerial);
  println(sendSerial);
 
  cp5 = new ControlP5(this);
  
  sliderList = new ArrayList<Slider>();
  sliderValueList = new ArrayList<Integer>();

  sliderList.add(cp5.addSlider("rightArm1")
                     .setRange(12000,-32767)
                     .setPosition(200,200)
                     .setSize(125,20)
                     .setNumberOfTickMarks(1000)
                     );
  sliderList.add(cp5.addSlider("rightArm2")
                     .setRange(0,-28000)
                     .setPosition(200,250)
                     .setSize(125,20)
                     .setNumberOfTickMarks(1000)
                     );
  sliderList.add(cp5.addSlider("rightArm3")
                     .setRange(23000,-20000)
                     .setPosition(200,300)
                     .setSize(125,20)
                     .setNumberOfTickMarks(1000)
                     );
  sliderList.add(cp5.addSlider("rightArm4")
                     .setRange(0,32767)
                     .setPosition(200,350)
                     .setSize(125,20)
                     .setNumberOfTickMarks(1000)
                     );  
  sliderList.add(cp5.addSlider("leftArm1")
                     .setRange(-15000,29000)
                     .setPosition(25,200)
                     .setSize(125,20)
                     .setNumberOfTickMarks(1000)
                     );
  sliderList.add(cp5.addSlider("leftArm2")
                     .setRange(0,32767)
                     .setPosition(25,250)
                     .setSize(125,20)
                     .setNumberOfTickMarks(1000)
                     );
  sliderList.add(cp5.addSlider("leftArm3")
                     .setRange(-25000,16000)
                     .setPosition(25,300)
                     .setSize(125,20)
                     .setNumberOfTickMarks(1000)
                     );
  sliderList.add(cp5.addSlider("leftArm4")
                     .setRange(0,-32767)
                     .setPosition(25,350)
                     .setSize(125,20)
                     .setNumberOfTickMarks(1000)
                     );
  sliderList.add(cp5.addSlider("headZ")
                     .setRange(-32767,32767)
                     .setPosition(250,135)
                     .setSize(100,20)
                     .setNumberOfTickMarks(1000)
                     );
  sliderList.add(cp5.addSlider("headX")
                     .setRange(-14000,10496)
                     .setPosition(250,35)
                     .setSize(100,20)
                     .setNumberOfTickMarks(1000)
                     );
  sliderList.add(cp5.addSlider("headY")
                     .setRange(-32767,32767)
                     .setPosition(250,85)
                     .setSize(100,20)
                     .setNumberOfTickMarks(1000)
                     );


  slider2D = cp5.addSlider2D("eye")
                 .setPosition(115,55)
                 .setSize(100,100)
                 .setMaxX(12032)
                 .setMaxY(16000)
                 .setMinX(-12032)
                 .setMinY(-16000)
                 .setArrayValue(new float[]{12032, 16000})
                 ;

  sliderEyeLid = cp5.addSlider("eyeLid")
                     .setRange(6016,-32767)
                     .setPosition(115 ,25)
                     .setSize(100,20)
                     .setNumberOfTickMarks(1000)
                     ;

  checkBox = cp5.addCheckBox("motor")
                 .setPosition(25, 25)
                 .setSize(35, 35)
                 .addItem("MotorOn", 10)
                 ;
                 
  button = cp5.addButton("reset")
              .setPosition(25, 100)
              .setSize(35, 35)
              ;
                 
//  slider2D.setArrayValue(new float[]{1000, 1000});
  
  checkBox.activateAll();
}

///////////////////////////////////Draw/////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int preCheckBoxValue = 0;

void draw() {
  background(125);
  sendSerial = "w 200884";

  
  List<Integer> VList = new ArrayList<Integer>();
  //VList ni atai wo ireru
  float r = 0.8;
  
  if(sliderValueList.size() == 0){
    for(int i = 0; i < sliderList.size() + 6; i++){ 
      sliderValueList.add(0);
    }
  }    

  for(int i = 0; i < sliderList.size(); i++){
    VList.add((int)((float)sliderList.get(i).getValue() * r + (float)sliderValueList.get(i) * (1.0 - r)));
  }  
  VList.add((int)((float)slider2D.arrayValue()[0] * r + (float)sliderValueList.get(sliderList.size() + 0) * (1.0 - r)));
  VList.add(-1 * (int)((float)sliderEyeLid.getValue() * r + (float)sliderValueList.get(sliderList.size() + 1) * (1.0 - r)));
  VList.add((int)((float)slider2D.arrayValue()[1] * r + (float)sliderValueList.get(sliderList.size() + 2) * (1.0 - r)));
  VList.add((int)((float)slider2D.arrayValue()[0] * r + (float)sliderValueList.get(sliderList.size() + 3) * (1.0 - r)));
  VList.add((int)((float)sliderEyeLid.getValue() * r + (float)sliderValueList.get(sliderList.size() + 4) * (1.0 - r)));
  VList.add(-1 * (int)((float)slider2D.arrayValue()[1] * r + (float)sliderValueList.get(sliderList.size() + 5) * (1.0 - r)));
  
  sliderValueList = VList;
  
//  println("sliderValueList.size()="+sliderValueList.size());
  
  for(Integer value : sliderValueList){
    char[] hexChar = hex(value, 4).toCharArray();
    sendSerial = sendSerial + " " + hexChar[2] + hexChar[3] + " " + hexChar[0] + hexChar[1];
  }
  
  
  sendSerial = sendSerial + "\r\n";
  
//  println("(int)checkBox.getValue()="+(int)checkBox.getArrayValue()[0]);
  
  if((int)checkBox.getArrayValue()[0] != preCheckBoxValue){
    if((int)checkBox.getArrayValue()[0] == 1){
      sendSerial = "w 2009f6 01 00\r\n";
    } else {
      sendSerial = "w 2009f6 00 00\r\n";
    }
  }
  preCheckBoxValue = (int)checkBox.getArrayValue()[0];
  
  serial.write(sendSerial);
//  println(sendSerial);
  
}


///////////////////////////////////Method/////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void reset(){
  for(Slider slider: sliderList){
    slider.setValue(0.0);
  }
  sliderEyeLid.setValue(0.0);
  slider2D.setArrayValue(new float[]{12032, 16000});
}


