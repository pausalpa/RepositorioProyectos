# Repositorio Proyectos Paulo Salvatore
Bienvenido!
Espero tengas un buen paseo por los principales proyectos multidisciplinarios que he desarrollado a lo largo de los años.
A continuación un pequeño índice de lo que se encuentra en cada una de las carpetas de éste repositorio:

## Electrónica

### Microcontroladores PIC

<!-- #### 1. Convertidor ascendente y descente hexadecimal](/Electrónica/Microcontroladores/Convertidor_Ascendente_Descendente_Hexadecimal)
El microcontrolador muestra en un display de 7 segmnentos los valores de 0-F que se incrementan o decrementan (esto definido por un deep switch en el primer puerto) únicamente con cada click realizado a un push button en el último puerto. -->

#### [1. Contador ascendente-descendente automático/manual hexadecimal](/Electrónica/Microcontroladores/Contador_Ascendente_Descendente_AutoMan)
El microcontrolador itera entre los valores 0-F mostrandolos en un display de 7 segmentos, ya sea en orden ascendente o descendente de un modo automático o manual según las entradas del mismo.

#### [2. Calculadora de 3 bits](/Electrónica/Microcontroladores/Calculadora_3Bits)
El microcontrolador recibe 2 numeros de 3 bits y realiza las operaciones básicas segun un selector de 2 bits. Estos datos se muestran junto con el resultado en un display LCD.

#### [3. Multiplexor de 4 canales analógicos](/Electrónica/Microcontroladores/Multiplexor_ADC)
El microcontrolador recibe 4 señales analógicas en sus puertos ADC y según una entrada digital en otro puerto toma ese valor y lo muestra en analógico y digital en un display LCD.


## Software

### CAD

#### [1. Tristeza](./Software/CAD/Tristeza)
Diseño de un llavero del personaje de Intensamente: *Tristeza*, el proyecto incluye las diferentes versiones del llavero en SolidWorks y sus archivos para imprimirlo en 3D.

#### [2. Gatito de la suerte](Software/CAD/Gatito_de_la_Suerte)
Diseño de un llavero de un gatito de la suerte, el proyecto incluye el diseño en SolidWorks.

### Control de Procesos: Matlab y Simulink

#### [1. Control de Lazo Abierto de un motor con Arduino](./Software/Control_de_procesos/Control_de_Lazo_Abierto_con_Arduino)
El sistema toma una señal analógica del Arduino (proveniente de un potenciometro), la mapea y la manda como PWM al motor.

#### [2. Control de Lazo Cerrado de un motor con Arduino](./Software/Control_de_procesos/Control_de_Lazo_Cerrado_con_Arduino)
El sistema recibe un pulso que se establece como setpoint, éste, mediante un lazo cerrado de control PI, busca establecer la señal del tacogenerador conectado al motor en la misma forma.

#### [3. Control de Lazo Abierto de un motor con Inversión de giro con Arduino](./Software/Control_de_procesos/Control_de_Lazo_Abierto_con_Inversion_de_Giro)
El sistema recibe una señal senoidal y busca establecer el sentido de giro del motor en el inverso de la zona de la señal recibida.

#### [4. Control de posición de un motor con Arduino](./Software/Control_de_procesos/Control_de_Posicion_con_Arduino)
El potenciometro funciona en el sistema como un medio para establecer un setpoint, al entrar al sistema un control PI busca que la posición angular del motor sea equivalente a la del potenciometro, actuando como un Servomotor.
