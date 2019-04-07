int cx, cy;

float alarma;

int aramadoAlarma = 0, flagSirena = 0;
int contSirena = 0, estadoSirena = 0;

void setup(){
  size(640, 360);
  stroke(255);
  
  int radius = min(width, height)/2;
  
  cx = width / 2;
  cy = height / 2;
}
  void draw() {
    fill(80);
    noStroke();
   
   if (estadoSirena == 1) {
     flagSirena = 2; 
     contSirena = 0;

  
   }
  }
  
