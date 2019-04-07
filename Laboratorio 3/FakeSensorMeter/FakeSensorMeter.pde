FakeMeter[] meters = new FakeMeter[4];
  Meter m;
public void setup() 
{
	size(900, 546);

  for (int i = 0; i < 4; i++) {
    int x = 440 * (i % 2) + 20 * (i % 2);
    int y = (i <= 1) ? 0 : 263 + 20;
    
    meters[i] = new FakeMeter(this, x, y, i);
  }
}

void draw() {
  for (int i = 0; i < 4; i++) {
    meters[i].updateSensorData();
  }
}
