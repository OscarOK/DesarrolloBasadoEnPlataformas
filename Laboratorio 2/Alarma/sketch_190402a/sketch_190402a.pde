/*Definiciones Entradas y Salidas */
const int sirena = 13,
          abrirBaul = 12,
          luzCortecia = 11,
          alertaIluminacion = 10,
          cerrarSeguros = 9,
          abrirSeguros = 8,
          ignicion = 7,
          velocidad = 6,
          botonValet = 5,
          pulsadorCapo = 4,
          pulsadorPuertas = 3,
          controlRadio = 2,
          subirVentanas = A4,
          bajarVentanas = A5;
RCSwitch mySwitch = RCSwitch();
/*Variables y Constantes*/
char comandos;
bool estadoIgnicion = 0,
     estadobotonValed = 0,
     estadopulsadorCapo = 0,   // 0(Abierto)/ 1(Cerrado)
    estadopulsadorPuertas = 0, // 0(Abierto)/ 1(Cerrado)
    flagSeguros = 0,
     armadoAutomatico = 0,
     armadoAlarma = 0;

long estadoControl = 0;
int estadoVelocidad = 0,
    contSirena = 0,
    flagSirena = 0,
    estadoSirena = LOW;

/* Temporizador (Millis) */

unsigned long tiempoInicial1;      // Tiempo Seguros
const long tiempoFuncional1 = 500; // Tiempo Seguros

unsigned long tiempoInicial2;       // Tiempo Alerta iluminacion
const long tiempoFuncional2 = 1200; // Tiempo Alerta iluminacion

unsigned long tiempoInicial3;      // Tiempo Sirena
const long tiempoFuncional3 = 100; // Tiempo Sirena

unsigned long tiempoInicial4;       // Armado Automatico Alarma
const long tiempoFuncional4 = 5000; // Armado Automatico alarma

void setup()
{
  Serial.begin(115200);
  pinMode(sirena, OUTPUT);
  pinMode(abrirBaul, OUTPUT);
  pinMode(luzCortecia, OUTPUT);
  pinMode(alertaIluminacion, OUTPUT);
  pinMode(cerrarSeguros, OUTPUT);
  pinMode(abrirSeguros, OUTPUT);
  pinMode(subirVentanas, OUTPUT);
  pinMode(bajarVentanas, OUTPUT);
  pinMode(ignicion, INPUT);
  pinMode(velocidad, INPUT);                      // Comprobar si es posible incluirlo
  pinMode(botonValet, INPUT);                     // Posiblemente NO
  pinMode(pulsadorCapo, INPUT);
  pinMode(pulsadorPuertas, INPUT);
  pinMode(controlRadio, INPUT);
  mySwitch.enableReceive(0);                       // pin 2 para control
}

void lecturaDatos()
{
  if (Serial.available() > 0)
  {
    comandos = Serial.read();
  }
  if (mySwitch.available())
  {
    estadoControl = mySwitch.getReceivedValue();
    if (estadoControl == 0)
    {
      Serial.println("error de codigo");
    }
    /*    else
    {
      Serial.print("codigo Recibido ");
      Serial.println(estadoControl);
    }   */
    mySwitch.resetAvailable();
  }
}
void asignacionPulsadores()
{
  estadoIgnicion = digitalRead(ignicion);
  estadoVelocidad = digitalRead(velocidad);
  estadobotonValed = digitalRead(botonValet);
  estadopulsadorCapo = digitalRead(pulsadorCapo);
  estadopulsadorPuertas = digitalRead(pulsadorPuertas);
}
void estadoSeguros(int estadoPuertas)
{
  digitalWrite(estadoPuertas, HIGH);
  digitalWrite(alertaIluminacion, HIGH); // En caso de utilizar señal negativa para encender relay como alternativa utilizar un blink
  tiempoInicial1 = millis();
  tiempoInicial2 = millis();
  flagSeguros = 1;
}
void loop()
{

  lecturaDatos();
  /*Control Automatico*/
  

  /*Control Manual */
  // Radio control y comando bluetooth

  if (((estadoControl == 11227985) || comandos == 'a') && (flagSeguros == 0)) // Comando y codigo para abir puertas
  {
    estadoSeguros(abrirSeguros);
    flagSirena = 3;
    contSirena = 0;
  }

  if (((estadoControl == 11227986) || comandos == 'c') && (flagSeguros == 0)) // Comando y codigo para cerrar puertas
  {
    estadoSeguros(cerrarSeguros);
    flagSirena = 2;
    contSirena = 0;
  }

  if (((estadoControl == 11227988) || comandos == 'b') && (flagSeguros == 0)) // Comando y codigo para abir el baul
  {
    estadoSeguros(abrirBaul);
    flagSirena = 4;
    contSirena = 0;
  }

  // Apagado de pines millis
  if (millis() - tiempoInicial1 >= tiempoFuncional1) // Desactivacion pines de seguros
  {
    digitalWrite(abrirSeguros, LOW);
    digitalWrite(cerrarSeguros, LOW);
    digitalWrite(abrirBaul, LOW);
    tiempoInicial1 = 0;
    flagSeguros = 0;
  }

  if (millis() - tiempoInicial2 >= tiempoFuncional2) // Desactivacion pines de alerta iluminacion
  {
    digitalWrite(alertaIluminacion, LOW);
    tiempoInicial2 = 0;
  }
  if (contSirena < flagSirena) // Blink Sirena (Optimizar si se puede)
  {
    if (millis() - tiempoInicial3 >= tiempoFuncional3)
    {
      tiempoInicial3 = millis();

      if (estadoSirena == LOW)
      {
        estadoSirena = HIGH;
      }
      else
      {
        estadoSirena = LOW;
        contSirena++;
      }
    }
  }

  digitalWrite(sirena, estadoSirena);

  // Limpieza de variables
  estadoControl = 0;
  comandos = ' ';
}
