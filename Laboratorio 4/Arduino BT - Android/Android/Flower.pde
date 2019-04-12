class Flower {
  Petal[] petals;
  
  float x;
  float y;
  float stemSize = 40;
  float centerSize = 240;
  int quantity = 6;
  
  float dist = 200;
  
  color stemColor = #83f441;
  color centerColor = #f4dc42;
  
  public Flower(float x, float y) {
    this.x = x;
    this.y = y;
    petals = new Petal[quantity];
    initPetals();
  }
  
  public void initPetals() {
    float angle = 360f / quantity;
    
    for (int i = 0; i < quantity; i++) {
      float x = dist * cos(radians(angle * i));
      float y = dist * sin(radians(angle * i));
      petals[i] = new Petal(this.x + x, this.y + y);
    }
  }
  
  public void update() {
    fill(stemColor);   
    noStroke();
    rect(x - (stemSize/2f), y, stemSize, height/2f);
    
    for (int i = 0; i < quantity; i++) {
      petals[i].update();
    }
    
    ellipseMode(CENTER);
    fill(centerColor);
    noStroke();
    ellipse(x, y, centerSize, centerSize);
  }
  
  public int petalPressed() {
    for (int i = 0; i < quantity; i++) {
      if (petals[i].petalPressed()) {
        return i;
      }
    }
    
    return -1;
  }
  
  public void changeColor(int index) {
    boolean state = petals[index].petalColorState;
    
    petals[index].petalColorState = !state;
  }
}
