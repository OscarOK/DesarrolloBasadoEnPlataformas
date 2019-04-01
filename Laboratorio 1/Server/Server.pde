import processing.net.*;
import static javax.swing.JOptionPane.*;
import javax.swing.*;
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddressList myNetAddressList = new NetAddressList();
/* listeningPort is the port the server is listening for incoming messages */
int myListeningPort = 32000;
/* the broadcast port is the port the clients should listen for incoming messages from the server*/
int myBroadcastPort = 12000;

private Paddle leftPlayer;
private Paddle rightPlayer;
private Ball ball;

private color gameColor = #fff016;
private color backgroundColor = #424242;

private float paddleHeight = 60;
private float paddleWidth = 10;

private int leftPlayerScore = 0;
private int rightPlayerScore = 0;

private float leftPlayerTargetY;
private float rightPlayerTargetY;

void setup() {
  background(backgroundColor);
  oscP5 = new OscP5(this, myListeningPort, OscP5.UDP);
  
  size(1000, 600);
  
  leftPlayer = new Paddle(paddleWidth, height / 2f, paddleWidth, paddleHeight);
  rightPlayer = new Paddle(width - paddleWidth, height / 2f, paddleWidth, paddleHeight);
  
  ball = new Ball(width/2f, height/2f, 15f);
  
  String developed = "Developed by \n Karyny Narayany Rodio - 335661 \n Oscar Eduardo Ordoñez Medina - 310898 \n Erick Jassiel Blanco Sausameda - 311008";
  
  showMessageDialog(null, developed, "Credits", INFORMATION_MESSAGE);
}

void draw() {
  background(backgroundColor);
  rectMode(CENTER);
  fill(gameColor);
  
  if(myNetAddressList.size() < 2) {
    textAlign(CENTER);
    textSize(60);
    fill(gameColor);
    text("Esperando " + (2-myNetAddressList.size()) + " jugador(es)", width/2f, height/2f);
    return;
  }
  rect(width/2f, height/2f, 5, height);
  
  ball.checkPaddleCollision(leftPlayer);
  ball.checkPaddleCollision(rightPlayer);
  ball.applyForce();
  ball.display();
  
  rightPlayer.setToTargetY(rightPlayerTargetY);
  rightPlayer.display();
  
  leftPlayer.setToTargetY(leftPlayerTargetY);
  leftPlayer.display();
  
  updateScore();
  displayScore();
  checkWinner();
}

void resetSketch() {
  leftPlayerScore = 0;
  rightPlayerScore = 0;
  leftPlayerTargetY = 0;
  rightPlayerTargetY = 0;
  background(backgroundColor);
  setup();
}

void checkWinner() {
  int scoreDiff = 5;
  
  if (leftPlayerScore - rightPlayerScore >= scoreDiff) {
    showMessageDialog(null, "Left player won!", "End of the game", INFORMATION_MESSAGE);
    resetSketch();
  } else if (rightPlayerScore - leftPlayerScore >= scoreDiff) {
    showMessageDialog(null, "Right player won!", "End of the game", INFORMATION_MESSAGE);
    resetSketch();
  }
}

void displayScore() {
  float middleMargin = 100;
  float topMargin = 50;
  
  textAlign(RIGHT);
  textSize(30);
  fill(gameColor);
  text(String.valueOf(leftPlayerScore), width/2f - middleMargin, topMargin);
  textAlign(LEFT);
  textSize(30);
  fill(gameColor);
  text(String.valueOf(rightPlayerScore), width/2f + middleMargin, topMargin);
}

void updateScore() {
  if (ball.x > width) {
    leftPlayerScore++;
    ball.randomService(width/2f, height/2f, 1);
    leftPlayer.updateHeight(1);
    rightPlayer.updateHeight(-1);
  }
  
  if (ball.x < 0) {
    rightPlayerScore++;
    ball.randomService(width/2f, height/2f, 0);
    leftPlayer.updateHeight(-1);
    rightPlayer.updateHeight(1);
  }
  
  OscMessage score = new OscMessage("score");
  score.add(leftPlayerScore);
  score.add(rightPlayerScore);
  oscP5.send(score, myNetAddressList.get(0));
  oscP5.send(score, myNetAddressList.get(1));
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.addrPattern().equals("/server/connect")) {
    println("Connection");
    connect(theOscMessage.netAddress().address());
    return;
  }
  
  float accelerometerY = theOscMessage.get(0).floatValue();
  float target = map(accelerometerY, -5, 5, 0, height);
  println(myNetAddressList.get(0).address() + " " + theOscMessage.netAddress().address());
  if (theOscMessage.netAddress().address().equals(myNetAddressList.get(0).address())){
    leftPlayerTargetY = target;
  } else if (theOscMessage.netAddress().address().equals(myNetAddressList.get(1).address())) {
    rightPlayerTargetY = target;
  }
}

private void connect(String theIPaddress) {
  if (!myNetAddressList.contains(theIPaddress, myBroadcastPort)) {
    myNetAddressList.add(new NetAddress(theIPaddress, myBroadcastPort));
    println("### adding "+theIPaddress+" to the list.");
  } else {
    println("### "+theIPaddress+" is already connected.");
  }
  println("### currently there are "+myNetAddressList.list().size()+" remote locations connected.");
 }
