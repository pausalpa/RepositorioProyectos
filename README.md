# Repositorio Proyectos Paulo Salvatore
Bienvenido!
Espero tengas un buen paseo por los principales proyectos multidisciplinarios que he desarrollado a lo largo de los años.
A continuación se mostrará un índice de lo que se encuentra en cada una de las carpetas anexas, la descripción de cada uno de los proyectos se encuentra adentro de su correspondiente carpeta madre, permitiendo así una mejor visualización de todos los contenidos de este repositorio.

## Software

### LabVIEW

#### [1. Elevadores](/Software/LabVIEW/Elevadores)
Esta sección más que un proyecto o archivo individual, es una serie de programas que representan la intención de programar un elevador de 2 pisos (y una PB) con botones adentro y en cada uno de éstos. Implementando indicadores de la posición del elevador y del status de sus puertas. Sin embargo, tras multiples versiones, el sistema se define como _aún con fallas_ ya que hay escenarios sin respuesta definida. Sin embargo, he aquí mi progreso.

#### [2. Proyectos físicos con tarjetas de adquisición de datos](/Software/LabVIEW/Proyectos_Físicos)
Esta sección es una serie de proyectos orientados a solucionar problemas que parten de una situación real, en los cuales, se busca interactuar con el ambiente mediante tarjetas de adquisicón de datos que también tienen terminales de salida. Entre las soluciones encontramos: Depósitos de agua interconectados, sistemas de toldo y riego automáticos, entre otros. 

### Control de Procesos: Matlab y Simulink

#### [1. Control de Lazo Abierto de un motor con Arduino](./Software/Matlab_&_Simulink/Control_de_Lazo_Abierto_con_Arduino)
El sistema toma una señal analógica del Arduino (proveniente de un potenciometro), la mapea y la manda como PWM al motor.

#### [2. Control de Lazo Cerrado de un motor con Arduino](./Software/Matlab_&_Simulink/Control_de_Lazo_Cerrado_con_Arduino)
El sistema recibe un pulso que se establece como setpoint, éste, mediante un lazo cerrado de control PI, busca establecer la señal del tacogenerador conectado al motor en la misma forma.

#### [3. Control de Lazo Abierto de un motor con Inversión de giro con Arduino](./Software/Matlab_&_Simulink/Control_de_Lazo_Abierto_con_Inversion_de_Giro)
El sistema recibe una señal senoidal y busca establecer el sentido de giro del motor en el inverso de la zona de la señal recibida.

#### [4. Control de posición de un motor con Arduino](./Software/Matlab_&_Simulink/Control_de_Posicion_con_Arduino)
El potenciometro funciona en el sistema como un medio para establecer un setpoint, al entrar al sistema un control PI busca que la posición angular del motor sea equivalente a la del potenciometro, actuando como un Servomotor.

#### [5. Diagrama de bloques de procesos de transmisión de calor](/Software/Matlab_&_Simulink/Prcoesos_Transmisión_Calor)
Esta sección muestra una serie de diagramas de bloques de diferentes modelos de procesos de transmisión de calor: Calderas, Hornos e Intercambiadores de Calor. Iterando en multiples modelos de los procesos.

#### [6. Diagrama de bloques de un proceso de reactor químico](/Software/Matlab_&_Simulink/Reactor_Químico)
Aquí se encuentra el archivo de Simulink que alberga un par de modelos de el proceso de un reactor químico, a su vez, cuenta con una especie de log de versiones pasadas a modo de imágenes, donde se puede ver que los modelos de esta y la sección de los procesos de transmisión de calor, vienen de la misma bibliografía.

### PLC: RSLogix

#### [1. Soluciones de pistones paso a paso](/Software/RSLogix/Pistones_Paso_a_Paso)
Esta sección engloba una serie de programas que dan solución -mediante la metodología paso a paso- a diferentes secuencias con pistones. Desafortunadamente, no se cuenta con la descripción de las problemáticas originales, por lo que únicamente se anexan las soluciones.

### [Neumática: FluidSIM](/Software/FluidSIM/)

#### [➤ Secuencia con Arranque y Paro](/Software/FluidSIM#-secuencia-con-arranque-y-paro)


#### [➤ Puente Articulado](/Software/FluidSIM#-puente-articulado)

#### [➤ Dispositivo para curvar monturas de gafas](/Software/FluidSIM#-dispositivo-para-curvar-monturas-de-gafas)

## Electrónica

### Microcontroladores PIC

#### [1. Contador ascendente-descendente automático/manual hexadecimal](/Electrónica/Microcontroladores/Contador_Ascendente_Descendente_AutoMan)
El microcontrolador itera entre los valores 0-F mostrandolos en un display de 7 segmentos, ya sea en orden ascendente o descendente de un modo automático o manual según las entradas del mismo.

#### [2. Calculadora de 3 bits](/Electrónica/Microcontroladores/Calculadora_3Bits)
El microcontrolador recibe 2 numeros de 3 bits y realiza las operaciones básicas segun un selector de 2 bits. Estos datos se muestran junto con el resultado en un display LCD.

#### [3. Multiplexor de 4 canales analógicos](/Electrónica/Microcontroladores/Multiplexor_ADC)
El microcontrolador recibe 4 señales analógicas en sus puertos ADC y según una entrada digital en otro puerto toma ese valor y lo muestra en analógico y digital en un display LCD.

## Diseño

### SolidWorks

#### [1. Tristeza](./Diseño/SolidWorks/Tristeza)
Diseño de un llavero del personaje de Intensamente: *Tristeza*, el proyecto incluye las diferentes versiones del llavero en SolidWorks y sus archivos para imprimirlo en 3D.

#### [2. Gatito de la suerte](Diseño/SolidWorks/Gatito_de_la_Suerte)
Diseño de un llavero de un gatito de la suerte, el proyecto incluye el diseño en SolidWorks.

### AutoCAD

#### [1. Proceso de Flujo](Diseño/AutoCAD/Proceso_de_Flujo)
Este diseño CAD muestra el diagrama de Instrumentación de la variable de Flujo de un proceso de llenado de un tanque.

#### [2. Proceso de Nivel](Diseño/AutoCAD/Proceso_de_Nivel)
Este diseño CAD muestra el diagrama de Instrumentación de la variable de Nivel del mismo proceso de llenado del tanque.