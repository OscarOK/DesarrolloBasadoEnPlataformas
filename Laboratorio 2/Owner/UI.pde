void mousePressed() {
  float left = callButton.x - (callButton.buttonWidth/2f);
  float right = callButton.x + (callButton.buttonWidth/2f);
  float top = callButton.y - (callButton.buttonHeight/2f);
  float bottom = callButton.y + (callButton.buttonHeight/2f);
  
  if (mouseX >= left && mouseX <= right && mouseY <= bottom && mouseY >= top) {
    println("CALLING...");
    callButton.isPressed = true;
    OscMessage call = new OscMessage("/call/");
    call.add(911);
    oscP5.send(call, myRemoteLocation);
  }
}

void mouseReleased() {
  if (callButton.isPressed) {
    callButton.isPressed = false;
  }
}

void keyPressed() {
  if (key =='c')
  {
    //If we have not discovered any devices, try prior paired devices
    if (bt.getDiscoveredDeviceNames().size() > 0)
      connectionList = new KetaiList(this, bt.getDiscoveredDeviceNames());  // 3
    else if (bt.getPairedDeviceNames().size() > 0)
      connectionList = new KetaiList(this, bt.getPairedDeviceNames());  // 4
  }
  else if (key == 'd')
    bt.discoverDevices();  // 5
  else if (key == 'b')
    bt.makeDiscoverable();  // 6
}


void drawUI()
{
  callButton.update();
  infoCard.update();
}


void onKetaiListSelection(KetaiList connectionList)  // 11
{
  String selection = connectionList.getSelection();  // 12
  bt.connectToDeviceByName(selection);  // 13
  connectionList = null;  // 14
}
