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
final static double ACCEL_THRESHOLD = 3.0f;
final static double PROX_THRESHOLD = 2.0f;
final static double GPS_THRESHOLD = 0.01f;

KetaiSensor sensor;
KetaiLocation location;
PVector accelerometer;
float light = 0, proximity;
double lat = 0, lng = 0;

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
  
  // Start listening for BT connections
  bt.start();
}

void onAccelerometerEvent(float x, float y, float z) {
  PVector tmp = new PVector(x, y, z);
  if (abs(accelerometer.mag() - tmp.mag()) > ACCEL_THRESHOLD) {
    notifyUser("Someone crash your car");
  }
  accelerometer = tmp;
}

void onLightEvent(float v) {
  if (light == 0)
    light = v;
  if(light - v > LIGHT_THRESHOLD) {
    notifyUser("Someone is in your car");
  }
}

void onProximityEvent(float v) {
  if (v - proximity > PROX_THRESHOLD) {
    notifyUser("Someone in your car's window");
  }
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
    if(lat == 0 && lng == 0) {
      lat = _latitude;
      lng = _longitude;
    }
    if(abs(_latitude - lat) > GPS_THRESHOLD || abs(_longitude - lng) > GPS_THRESHOLD) {
      notifyUser("Your car is beign stolen");
    }
}

void notifyUser(String msg) {
  //TODO enviar información por bluetooth
  System.out.println(msg);
  
  byte[] data = msg.getBytes();
  System.out.println(data);
  bt.broadcast(data);
}

double abs(double a) {
  return (a>0)? a : -a;
}
