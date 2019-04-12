const int LED = 13;
const int BTPWR = 12;

char nameBT[] = "DemoBT";
char velocityBT = '4'; // 9600bps
char pinBT[] = "1234";

void setup() {
  pinMode(LED, OUTPUT);
  pinMode(BTPWR, OUTPUT);

  digitalWrite(LED, LOW);
  digitalWrite(BTPWR, HIGH);

  Serial.begin(9600);

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

  digitalWrite(LED, HIGH);
}

void loop() {
  Serial.println("Hello World!");
  delay(1000);
}
