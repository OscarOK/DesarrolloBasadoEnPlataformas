private class SimpleCard {
  String title;
  String content = "There aren't new messages";
  
  color cardBackground = #ffffff;
  color shadowColor = #e0e0e0;
  color textColor = #000000;
  
  float x;
  float y;
  float cardWidth;
  float cardHeight;
  float cornerRadius = 12f;
  float shadowX;
  float shadowY;
  float shadowMargin = 4f;
  float textMargin = 32f;
  float textSize = 48f;
  
  public SimpleCard(float x, float y, float cardWidth, float cardHeight, String title) {
    this.x = x;
    this.y = y;
    this.cardWidth = cardWidth;
    this.cardHeight = cardHeight;
    this.title = title;
    this.shadowX = this.x + this.shadowMargin;
    this.shadowY = this.y + this.shadowMargin;
  }
  
  public void update() {
    drawShadow();
    drawCard();
    drawTitle();
    drawContent();
  }
  
  private void drawContent() {
    float tX = x - (cardWidth / 2f) + textMargin;
    float tY = y - (cardHeight / 2f) + (textMargin * 4f);
    textAlign(LEFT, TOP);
    textSize(textSize);
    fill(textColor);
    text(content, tX, tY);
  }
  
  private void drawTitle() {
    float tX = x - (cardWidth / 2f) + textMargin;
    float tY = y - (cardHeight / 2f) + textMargin;
    textAlign(LEFT, TOP);
    textSize(textSize);
    fill(textColor);
    text(title, tX, tY);
  }
  
  private void drawShadow() {
    rectMode(CENTER);
    fill(shadowColor);
    noStroke();
    rect(shadowX, shadowY, cardWidth, cardHeight, cornerRadius);
  }
  
  private void drawCard() {
    rectMode(CENTER);
    fill(cardBackground);
    noStroke();
    rect(x, y, cardWidth, cardHeight, cornerRadius);
  }
}
