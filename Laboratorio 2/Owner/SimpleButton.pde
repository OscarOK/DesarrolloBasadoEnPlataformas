private class SimpleButton {
  String text;
  
  color buttonColor = #ff5252;
  color buttonPressed = #ff3939;
  color disableColor = #bdbdbd;
  color textColor = #000000;
  
  float x;
  float y;
  float buttonWidth;
  float buttonHeight;
  float cornerRadius = 12f;
  float textSize = 48f;
  boolean isAvailable;
  boolean isPressed;
  
  
  public SimpleButton(float x, float y, float buttonWidth, float buttonHeight, String text) {
    this.x = x;
    this.y = y;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    this.text = text;
    this.isAvailable = true;
    this.isPressed = false;
  }
  
  public void update() {
    drawRect();
    drawText();
  }
  
  private void drawRect() {
    rectMode(CENTER);
    
    if (!isPressed) {
      fill(buttonColor);
    } else {
      fill(buttonPressed);
    }
    rect(x, y, buttonWidth, buttonHeight, cornerRadius);
  }
  
  private void drawText() {
    fill(textColor);
    textSize(textSize);
    textAlign(CENTER, CENTER);
    text(text, x, y);
  }
}
