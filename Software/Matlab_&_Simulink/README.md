# Control de Procesos: Matlab y Simulink

## [» Control de Lazo Abierto de un motor con Arduino](./Software/Matlab_&_Simulink/Control_de_Lazo_Abierto_con_Arduino)
El sistema toma una señal analógica del Arduino (proveniente de un potenciometro), la mapea y la manda como PWM al motor.

## [» Control de Lazo Cerrado de un motor con Arduino](./Software/Matlab_&_Simulink/Control_de_Lazo_Cerrado_con_Arduino)
El sistema recibe un pulso que se establece como setpoint, éste, mediante un lazo cerrado de control PI, busca establecer la señal del tacogenerador conectado al motor en la misma forma.

## [» Control de Lazo Abierto de un motor con Inversión de giro con Arduino](./Software/Matlab_&_Simulink/Control_de_Lazo_Abierto_con_Inversion_de_Giro)
El sistema recibe una señal senoidal y busca establecer el sentido de giro del motor en el inverso de la zona de la señal recibida.

## [» Control de posición de un motor con Arduino](./Software/Matlab_&_Simulink/Control_de_Posicion_con_Arduino)
El potenciometro funciona en el sistema como un medio para establecer un setpoint, al entrar al sistema un control PI busca que la posición angular del motor sea equivalente a la del potenciometro, actuando como un Servomotor.

## [» Diagrama de bloques de procesos de transmisión de calor](/Software/Matlab_&_Simulink/Prcoesos_Transmisión_Calor)
Esta sección muestra una serie de diagramas de bloques de diferentes modelos de procesos de transmisión de calor: Calderas, Hornos e Intercambiadores de Calor. Iterando en multiples modelos de los procesos.

## [» Diagrama de bloques de un proceso de reactor químico](/Software/Matlab_&_Simulink/Reactor_Químico)
Aquí se encuentra el archivo de Simulink que alberga un par de modelos de el proceso de un reactor químico, a su vez, cuenta con una especie de log de versiones pasadas a modo de imágenes, donde se puede ver que los modelos de esta y la sección de los procesos de transmisión de calor, vienen de la misma bibliografía.