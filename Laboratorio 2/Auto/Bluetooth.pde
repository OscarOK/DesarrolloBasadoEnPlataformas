import android.content.Intent;
import android.os.Bundle;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;
import java.nio.charset.Charset;

KetaiBluetooth bt;
KetaiList devices;
boolean isConfiguring = true;

void onCreate(Bundle savedInstanceState) { 
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}

void draw() {
  background(78, 93, 75);
  if (isConfiguring) {
    devices = new KetaiList(this, bt.getPairedDeviceNames());
    isConfiguring = false;
  }

}

void onKetaiListSelection(KetaiList klist) {
  String selection = klist.getSelection();
  bt.connectToDeviceByName(selection);
  
  klist = null; 
}
