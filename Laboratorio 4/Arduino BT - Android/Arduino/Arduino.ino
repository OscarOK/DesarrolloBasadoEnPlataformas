#include <SoftwareSerial.h>

const int LED = 13;
const int BTPWR = 12;

const int RX = 0;
const int TX = 1;

char nameBT[] = "DemoBT";
char velocityBT = '4'; // 9600bps
char pinBT[] = "1234";

SoftwareSerial bt(RX, TX);

void setup() {
  for (int i = 2; i < 8; i++) {
    pinMode(i, OUTPUT);
    digitalWrite(i, LOW);
  }

  for (int i = 8; i < 14; i++) {
    pinMode(i, INPUT_PULLUP);
  }

  Serial.begin(9600);
  bt.begin(9600);

  Serial.print("AT");
  delay(1000);

  Serial.print("AT+NAME");
  Serial.print(nameBT);
  delay(1000);

  Serial.print("AT+BAUD");
  Serial.print(velocityBT);
  delay(1000);

  Serial.print("AT+PIN");
  Serial.print(pinBT);
  delay(1000);
}

void loop() {  
  if (bt.available() > 0) {
    byte data[] = {bt.read()};
    
    int index = data[0] + 2;

    if (index == 257) {
      turnOffLeds();  
    } else if (index > 1 && index < 8) {
      turnOnLed(index);  
    }

    //Serial.println(index);
  }

  changePetalsColor();
}

void turnOnLed(int i) {
  digitalWrite(i, HIGH);
}

void turnOffLeds() {
  for (int i = 2; i < 8; i++) {
    digitalWrite(i, LOW);  
  }
}

void changePetalsColor() {
  for (int i = 8; i < 14; i++) {
    if (digitalRead(i) == LOW) {
      Serial.println(i - 8);
      delay(1000);
    }
  }
}
