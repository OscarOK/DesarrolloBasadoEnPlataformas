import android.content.Intent;
import android.os.Bundle;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

KetaiBluetooth bt;
KetaiList klist;
Flower flower;

ArrayList devicesDiscovered = new ArrayList();
color petalArduinoPressed = #aa23e0;
boolean isConfiguring = true;

byte[] index;

void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);//create the BtSerial object that will handle the connection
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
    bt.onActivityResult(requestCode, resultCode, data);
}//to show the discovered device

void setup()
{
  size(displayWidth, displayHeight); 
  smooth();
  frameRate(10);
  orientation(PORTRAIT);
  bt.start();
  isConfiguring = true;           
  flower = new Flower(width/2f, height/2f);
}

void mousePressed() {
  byte[] index = {(byte) flower.petalPressed()};
  
  bt.broadcast(index);
}

void mouseReleased() {
  byte[] zero = {(byte) -1};
  
  bt.broadcast(zero);
}

void draw() {
  if (isConfiguring) {
    klist = new KetaiList(this, bt.getPairedDeviceNames());
    isConfiguring = false;
  } else {
    flower.update();
  }
}

void onKetaiListSelection(KetaiList klist)
{
  String selection = klist.getSelection();
  bt.connectToDeviceByName(selection);
  klist = null;
}

void onBluetoothDataEvent(String who, byte[] data)
{
  if (isConfiguring) {
    return;
  }
  
  if (data != null) {
    int index = Integer.parseInt(new String(data));
    println(index);
    flower.changeColor(index);
  }
}
