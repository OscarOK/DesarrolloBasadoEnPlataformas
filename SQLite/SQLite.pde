import ketai.data.*;
import ketai.sensors.*;

final int ACCELEROMETER = 0,
  GYROSCOPE = 1,
  MAGNETOMETER = 2;
KetaiSensor sensor;
KetaiSQLite db;
boolean isCapturing = false;
float G = 9.80665;
String CREATE_DB_SQL =
  "CREATE TABLE IF NOT EXISTS sensor_data ( time INTEGER PRIMARY KEY, sensor INTEGER, x REAL, y REAL, z REAL);";

void setup() {
  db = new KetaiSQLite(this);
  sensor = new KetaiSensor(this);
  orientation(LANDSCAPE);
  textAlign(LEFT);
  textSize(72);
  rectMode(CENTER);
  frameRate(5);
  if ( db.connect() ) {
      db.execute(CREATE_DB_SQL);
  }
  sensor.start();
}

void draw() {
  background(78, 93, 75);
  if (isCapturing) {
    text("Recolectando datos...\n(toque para detener)" +"\n\n" +
      "Current Data count: " + db.getDataCount(), width/2, height/2);
  }
  else {
    //text("Recoleccion pausada...\n(toque para renaudar)", width/2, height/2);
    plotData();
  }
}

void mousePressed() {
    isCapturing = !isCapturing;
}

void onAccelerometerEvent(float x, float y, float z, long time, int accuracy) {
  String sql = String.format(
    "INSERT into sensor_data (time, sensor, x, y, z) VALUES (%d, %d, %f, %f, %f)",
    System.currentTimeMillis(), ACCELEROMETER, x, y, z); 
  if (db.connect() && isCapturing) {
    if (!db.execute(sql))
      println("Failed to record data!" );
  }
}

void plotData() {
  if (db.connect()) {
    pushStyle();
    line(0, height/2, width, height/2);
    line(mouseX, 0, mouseX, height);
    noStroke();
    
    db.query("SELECT * FROM sensor_data WHERE sensor= 0 ORDER BY time DESC");
    int  i = 0;
    while (db.next ()) {
      float x = db.getFloat("x");
      float y = db.getFloat("y");
      float z = db.getFloat("z");
      PVector vec = new PVector(x,y,z);
      float plotX, plotY = 0;

      fill(255, 0, 0);
      plotX = map(i, 0, db.getDataCount(), 0, width);
      plotY = map(vec.mag(), -2*G, 2*G, 0, height);
      ellipse(plotX, plotY, 3, 3);
      if (abs(mouseX-plotX) < 1)
        text(nfp(x, 2, 2), plotX, plotY);

      i++;
    }
    popStyle();
  }
}
