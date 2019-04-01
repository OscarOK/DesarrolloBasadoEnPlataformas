class Ball {
  public float x;
  public float y;
  public float size;
  public float speed = 3;
  public float xDirection = 1;
  public float yDirection = 1;
  public color ballColor = gameColor;
  
  public Ball(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  public void applyForce() {
    windowHeightConstraint();
    x += xDirection * speed;
    y += yDirection * speed;
  }
  
  private void windowHeightConstraint() {
    float radius = size / 2f;
    
    if (y + radius >= height || y - radius <= 0) {
      yDirection *= -1;
    }
  }
  
  public void randomService(float x, float y, int side) {
    this.x = x;
    this.y = y;
    
    yDirection = random(-2, 2);
    
    switch(side) {
      // Throwing to the left side
      case 0:
        xDirection = -1;
      break;
      
      // Throwing to the right side
      case 1:
        xDirection = 1;
      break;
      
      default:
        throw new IllegalArgumentException("Invalid side value");
    }
  }
  
  public void checkPaddleCollision(Paddle p) {
    float left = p.x - (p.paddleWidth / 2);
    float right = p.x + (p.paddleWidth / 2);
    float top = p.y - (p.paddleHeight / 2);
    float bottom = p.y + (p.paddleHeight / 2);
    float radius = size / 2f;
    
    if (x + radius >= left && x - radius <= right && y + radius <= bottom && y - radius >= top) {
        xDirection *= -1;
        
        if (random(-1, 1) > 0) {
          yDirection *= -1; 
        }
    }
  }
  
  public void display() {
    fill(ballColor);
    noStroke();
    ellipseMode(CENTER);
    smooth();
    ellipse(x, y, size, size);
  }
}
