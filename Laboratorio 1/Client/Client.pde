import oscP5.*;
import netP5.*;
import ketai.sensors.*;
  
private OscP5 oscP5;
private NetAddress myRemoteLocation;
private KetaiSensor sensor;

private color gameColor = #fff016;
private color backgroundColor = #424242;

private int leftPlayerScore = 0;
private int rightPlayerScore = 0;

private float accelerometerY;

void setup() {
  oscP5 = new OscP5(this, 12000, OscP5.UDP);
  println(NetInfo.lan());
  // send to computer address
  myRemoteLocation = new NetAddress("192.168.100.56", 32000);
  
  OscMessage m = new OscMessage("/server/connect",new Object[0]);
  oscP5.send(m, myRemoteLocation);
  
  sensor = new KetaiSensor(this);
  sensor.start();
  
  orientation(PORTRAIT);
}


void draw() {
  background(backgroundColor);
  displayScore();
}

void displayScore() {
  String text = "Left player score \n" + leftPlayerScore + "\n" + "Right player score \n" + rightPlayerScore;
  
  textAlign(CENTER);
  textSize(100);
  fill(gameColor);
  text(text, width/2f, height/2f);
}

void onAccelerometerEvent(float x, float y, float z)
{
  if (abs(accelerometerY - y)  < 0.2) {
    return;
  }
  
  accelerometerY = y;
  
  OscMessage accelerometerY = new OscMessage("accelerometerY");
  accelerometerY.add(y);
  oscP5.send(accelerometerY, myRemoteLocation);
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("score")) {
    leftPlayerScore = theOscMessage.get(0).intValue();
    rightPlayerScore = theOscMessage.get(1).intValue();
  }
}
