class Petal {
  float x;
  float y;
  
  float petalSize = 240;
  
  color petalColor = #f44242;
  color petalPressedColor = #bc3131;
  
  color petalColor1 = #b43dce;
  color petalPressedColor1 = #842799;
  
  boolean petalColorState = true;
  
  public Petal(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void update() {
    if (petalPressed() && petalColorState) {
      fill(petalPressedColor);
    } else if (petalColorState) {
      fill(petalColor);
    } else if (petalPressed() && !petalColorState) {
      fill(petalPressedColor1);
    } else if (!petalColorState) {
      fill(petalColor1);
    }
    
    ellipseMode(CENTER);
    noStroke();
    ellipse(x, y, petalSize, petalSize);
  }
  
  public boolean petalPressed() {
    return mousePressed && dist(x, y, mouseX, mouseY) <= (petalSize/2f);
  }
}
