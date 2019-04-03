import android.os.Bundle;
import android.content.Intent;

import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
KetaiBluetooth bt;
NetAddress myRemoteLocation;

KetaiList connectionList;
String info = "";
PVector remoteCursor = new PVector();
boolean isConfiguring = true;
String UIText;

SimpleButton callButton;
SimpleCard infoCard;

String buttonText = "CALL 911";
String cardTitle = "Car Messages";
String content = "There aren't new messages";
String prevContent; 

int timer;
float margin = 32f;
float buttonHeight = 120f;
float cardHeight = 1000f;

void setup() {
  oscP5 = new OscP5(this, 12000, OscP5.UDP);
  println(NetInfo.lan());
  // send to computer address
  myRemoteLocation = new NetAddress("192.168.100.56", 32000);
  
  orientation(PORTRAIT);
  background(#eeeeee);
 
  bt.start();
  
  callButton = new SimpleButton(width/2f, height - margin - (buttonHeight/2f), width - (2 * margin), buttonHeight, buttonText);
  infoCard = new SimpleCard(width/2f, margin + (cardHeight/2f), width - (2 * margin), cardHeight, cardTitle);
}

void draw() {
  if (millis() - timer >= 30000) {
    infoCard.content = content;
    timer = millis();
  }
  
  background(#eeeeee);
  drawUI();
}

void onBluetoothDataEvent(String who, byte[] data) { 
  if (data != null)
  {
    prevContent = infoCard.content;
    infoCard.content = new String(data);
    println(infoCard.content);
  }
}
