# Arduino BT con Android

Esta práctica aborda el uso de una placa de desarrollo de hardware, Arduino UNO y un módulo bluetooth HC-06; la intención es poder mandar mensajes de forma bidireccional entre la tablilla Arduino y el dispositivo Android.

## Requisitos

- Modulo bluetooth HC-06.
    - El código de Arduino se encarga de la configuración del dispositivo bluetooth.
    - Bautizado como ***DemoBT*** y con un código de seguridad ***1234***.
    - El pin ***RX*** del modulo bluetooth va conectada al pin ***TX*** del Arduino.
    - El pin ***TX*** del modulo bluetooth va conectada al pin ***RX*** del Arduino.
    - El pin ***GND*** del modulo bluetooth va conectada al pin ***GND*** del Arduino.
    - El pin ***VCC*** del modulo bluetooth va conectada al pin ***5V*** del Arduino.
- Tablilla Arduino.
    - Los pines del ***2*** al ***7*** van conectados cada uno a un led.
    - Los pines del ***8*** al ***13*** estan en modo _input_.
    - _NOTA: Al cargar el código al Arduino será necesario que el pin RX de la tablilla se encuentre libre._

## Ejecución

La aplicación consiste en tener relacionado los 12 pines digitales, con seis objetos virtuales que se encuentran dentro de la aplicación Android.

### Android

Al tener cargada la aplicación, nos mostrará una flor. Al presionar sobre un pétalo, mandará un mensaje por bluetooth al Arduino indicando que led deberá de encender. Cada pétalo está asignado solamente a un led.

!["Estado normal de la flor"](imgs/flor-normal.jpg)
![Flor despues de recibir datos del Arduino](imgs/flor-aleterada.jpg)

### Arduino

Al conectar tierra a un pin (pin 8 - pin 13), mandará un mensaje por bluetooth al dispositivo Android indicando cual pétalo deberá cambiar de color. Cada pin está asignado solamente a un pétalo.

![imgs/arduino.jpg]("Configuración del Arduino")
