import android.os.Bundle;
import android.content.Intent;

import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;
import oscP5.*;

KetaiBluetooth bt;

KetaiList connectionList;
String info = "";
PVector remoteCursor = new PVector();
boolean isConfiguring = true;
String UIText;

void setup() {
  orientation(PORTRAIT);
  background(78, 93, 75);
  stroke(255);
  textSize(48);

  bt.start();

  UIText =  "[b] - make this device discoverable\n" +
    "[d] - discover devices\n" +
    "[c] - pick device to connect to\n" +
    "[p] - list paired devices\n" +
    "[i] - show Bluetooth info";
}

void draw() {
  if (isConfiguring) {
    ArrayList<String> devices;
    background(78, 93, 75);

    if (key == 'i')
      info = getBluetoothInformation();
    else {
      if (key == 'p') {
        info = "Paired Devices:\n";
        devices = bt.getPairedDeviceNames();
      }
      else {
        info = "Discovered Devices:\n";
        devices = bt.getDiscoveredDeviceNames();
      }

      for (int i=0; i < devices.size(); i++) {
        info += "["+i+"] "+devices.get(i).toString() + "\n";
      }
    }
    text(UIText + "\n\n" + info, 5, 200);
  }
  else {
    background(78, 93, 75);
    pushStyle();
    fill(255);
    ellipse(mouseX, mouseY, 50, 50);
    fill(0, 255, 0);
    stroke(0, 255, 0);
    ellipse(remoteCursor.x, remoteCursor.y, 50, 50);
    popStyle();
  }

  drawUI();
}

void mouseDragged() {
  if (isConfiguring)
    return;

  OscMessage m = new OscMessage("/remoteMouse/");
  m.add(mouseX);
  m.add(mouseY);

  bt.broadcast(m.getBytes());
  // use writeToDevice(String _devName, byte[] data) to target a specific device
  ellipse(mouseX, mouseY, 20, 20);
}

void onBluetoothDataEvent(String who, byte[] data) {
  if (isConfiguring)
    return;

  KetaiOSCMessage m = new KetaiOSCMessage(data);
  if (m.isValid())
  {
    if (m.checkAddrPattern("/remoteMouse/"))
    {
      if (m.checkTypetag("ii"))
      {
        remoteCursor.x = m.get(0).intValue();
        remoteCursor.y = m.get(1).intValue();
      }
    }
  }
}

String getBluetoothInformation() {
  String btInfo = "Server Running: ";
  btInfo += bt.isStarted() + "\n";
  btInfo += "Discovering: " + bt.isDiscovering() + "\n";
  btInfo += "Device Discoverable: "+bt.isDiscoverable() + "\n";
  btInfo += "\nConnected Devices: \n";

  ArrayList<String> devices = bt.getConnectedDeviceNames();
  for (String device: devices)
  {
    btInfo+= device+"\n";
  }

  return btInfo;
}
