import http.requests.*;
import meter.*;

Meter m;
int sensorValue;
int minIn, maxIn;

public void setup() 
{
	size(600,400);
	smooth();

  m = new Meter(this, 50, 25);
  // Use the default values for testing, 0 - 255.
  minIn = m.getMinInputSignal();
  maxIn = m.getMaxInputSignal();
	
	GetRequest get = new GetRequest("http://localhost:8090/fakesensor/fakesensor");
	get.send();
	println("Reponse Content: " + get.getContent());
	println("Reponse Content-Length Header: " + get.getHeader("Content-Length"));
}

void draw() {
  // Input for testing.
  sensorValue = (int)random(minIn, maxIn);
  // Update the sensor value to the meter.
  m.updateMeter(sensorValue);
  // Use a delay to see the changes.
  delay(700);
}
