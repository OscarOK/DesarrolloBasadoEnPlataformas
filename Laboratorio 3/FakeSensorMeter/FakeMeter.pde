import http.requests.*;
import meter.*;

class FakeMeter extends Meter {
  String port = "8090";
  String url = "http://localhost:" + port + "/fakesensor/fakesensor";
  String[] scaleLabels = {"0","0.25","0.5","0.75", "1"};
  
  XML data;
  
  int index;
  
  public FakeMeter(PApplet parent, int x, int y, int index) {
    super(parent, x, y);
    this.index = index;
    setUp(0, 51, 0, 1, 180, 360);
    setScaleLabels(scaleLabels);
    
    updateData();
    setTitle(getDataTitle());
  }
  
  private void updateData() {
    GetRequest get = new GetRequest(url + "?param=" + index);
    get.send();
    data = parseXML(get.getContent());
  }
  
  public void updateSensorData() {
    updateData();
    updateMeter(getSensorValue());
  }
  
  private String getDataTitle() {
    return data.getChild("Sensor").getChild("Sensor_Name").getContent();
  }
  
  private int getSensorValue() {
    float d = data.getChild("Sensor").getChild("Sensor_Value").getFloatContent() * 51;
    return (int) d;
  }
}
