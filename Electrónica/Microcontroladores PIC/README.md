# Microcontroladores PIC

## [⇸ Contador ascendente-descendente automático/manual hexadecimal](/Electrónica/Microcontroladores%20PIC/Contador_Ascendente_Descendente_AutoMan/)
El microcontrolador itera entre los valores 0-F mostrandolos en un display de 7 segmentos, ya sea en orden ascendente o descendente de un modo automático o manual según las entradas del mismo.

<!-- ## [⇸ Calculadora de 3 bits (Maybe se va)](/ Electrónica/Microcontroladores/Calculadora_3Bits)
El microcontrolador recibe 2 numeros de 3 bits y realiza las operaciones básicas segun un selector de 2 bits. Estos datos se muestran junto con el resultado en un display LCD. -->

## [⇸ Multiplexor de 4 canales analógicos](/Electrónica/Microcontroladores%20PIC/Multiplexor_ADC/)
El microcontrolador recibe 4 señales analógicas en sus puertos ADC y según una entrada digital en otro puerto toma ese valor y lo muestra en analógico y digital en un display LCD.

## [⇸ Control de Temperatura](/Electr%C3%B3nica/Microcontroladores%20PIC/Control_Temperatura/)
El microcontrolador recibe una señal analógica de un LM35, a su vez, mediante un par de botones, define el setpoint deseada de la temperatura, subiendo o bajando tanto decenas como unidades. Para finalmente, comparar el valor sensado con el Setpoint y mostrar el status del proceso en un display LCD.

## [⇸ Comunicación Serial entre 2 PIC](/Electr%C3%B3nica/Microcontroladores%20PIC/Comunicaci%C3%B3n_Serial/)
El proceso se compone de 2 PIC 16F886 interconectados por comunicación serial RS232. Uno está conectado a un teclado matricial 4x4 y el otro a un display LCD. Al presionar una tecla, el otro PIC debe mostrar en el display cuál fue la tecla presionada.
