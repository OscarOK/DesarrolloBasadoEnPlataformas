/**
a) Actividad en el sensor de aceleración nos indica que el auto puede haber sido alcanzado por otro carro estando estacionado, o que podrían estarse robando las copas del auto
b) Actividad en el sensor de aceleración y en el GPS indica que se están robando el auto
c) Actividad en el sensor de proximidad indica que alguien está asomandose por las ventanas del auto
d) Actividad en el sensor touch indica que alguien esta intentando abrir/romper los cristales del auto
e) Actividad en el sensor touch y en el sensor de luz indica que alguien entro al auto

*/

import ketai.sensors.*;

// Time between multiple touch events (in milliseconds)
final static int TOUCH_THRESHOLD = 2000;
final static int STRIKES = 3;
final static double LIGHT_THRESHOLD = 12.0f;

KetaiSensor sensor;
KetaiLocation location;
PVector accelerometer;
double longitude, latitude, altitude;
float light = 0, proximity, accuracy;

int touchCount = 0;
int touchInitTime;

void setup() {
  // UI setup
  orientation(LANDSCAPE);
  textAlign(CENTER, CENTER);
  textSize(72);
  
  // Sensor setup
  location = new KetaiLocation(this);
  sensor = new KetaiSensor(this);
  sensor.start();
  sensor.list();
  accelerometer = new PVector();
}

void draw() {
  background(78, 93, 75);
}

void onAccelerometerEvent(float x, float y, float z, long time, int accuracy) {
  accelerometer.set(x, y, z);
}

void onLightEvent(float v) {
  if (light == 0)
    light = v;
  if(abs(light - v) > LIGHT_THRESHOLD) {
    notifyUser("Someone is in your car");
  }
}

void onProximityEvent(float v) {
    proximity = v;
}

public void mousePressed() {
  int time = millis();

  if (touchCount == 0) {
    touchInitTime = time;
  } else if (touchCount == STRIKES) {
    notifyUser("Someone is hiting your car");
  } else if ((time - touchInitTime) > TOUCH_THRESHOLD) {
      touchCount = -1;
  }
  touchCount ++;
}

void onLocationEvent(double _latitude, double _longitude,
  double _altitude, float _accuracy) {
    
  longitude = _longitude;
  latitude = _latitude;
  altitude = _altitude;
  accuracy = _accuracy;
}

void notifyUser(String msg) {
  //TODO enviar información por bluetooth
  System.out.println(msg);
}
