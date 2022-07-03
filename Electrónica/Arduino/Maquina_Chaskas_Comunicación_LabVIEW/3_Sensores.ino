//Variables 
long dU1, dU2, dU3, dU4, dU5, dU6, hDHT1, tDHT1, hDHT2, tDHT2, hDHT3=15, tDHT3=18;

//Ultrasónicos
void Ultrasonico1()                                    //Platano
{
  digitalWrite(Trigger1, HIGH);
  delayMicroseconds(10);
  digitalWrite(Trigger1, LOW);
  long tU1 = pulseIn (Echo1, HIGH);                   //Tiempo que demora en llegar el eco
  dU1 = tU1 / 59;                                     //Distancia en cm
}
void Ultrasonico2()                                     //Fresa
{
  digitalWrite(Trigger2, HIGH);
  delayMicroseconds(10);
  digitalWrite(Trigger2, LOW);
  long tU2 = pulseIn (Echo2, HIGH);                   //Tiempo que demora en llegar el eco
  dU2 = tU2 / 59;                                     //Distancia en cm
}
void Ultrasonico3()                                   //Tablillas de yogurth
{
  digitalWrite(Trigger3, HIGH);
  delayMicroseconds(10);
  digitalWrite(Trigger3, LOW);
  long tU3 = pulseIn (Echo3, HIGH);                   //Tiempo que demora en llegar el eco
  dU3 = tU3 / 59;                                     //Distancia en cm
}
void Ultrasonico4()                                   //Chocolate
{
  digitalWrite(Trigger4, HIGH);
  delayMicroseconds(10);
  digitalWrite(Trigger4, LOW);
  long tU4 = pulseIn (Echo4, HIGH);                   //Tiempo que demora en llegar el eco
  dU4 = tU4 / 59;                                     //Distancia en cm
}
void Ultrasonico5()                                   //Cereal 1
{
  digitalWrite(Trigger5, HIGH);
  delayMicroseconds(10);
  digitalWrite(Trigger5, LOW);
  long tU5 = pulseIn (Echo5, HIGH);                   //Tiempo que demora en llegar el eco
  dU5 = tU5 / 59;                                     //Distancia en cm
}
void Ultrasonico6()                                   //Cereal 2
{
  digitalWrite(Trigger6, HIGH);
  delayMicroseconds(10);
  digitalWrite(Trigger6, LOW);
  long tU6 = pulseIn (Echo6, HIGH);                     //Tiempo que demora en llegar el eco
  dU6 = tU6 / 59;                                      //Distancia en cm
}

//Sensores Temperatura

long TiempoUltimaLecturaDHT1 = 0;
void SensorTemp1()                                      //Llevan humedad,temperatura. Durazno
{
  if (millis() - TiempoUltimaLecturaDHT1 > 2000)
  {
    hDHT1 = dht.readHumidity();
    tDHT1 = dht.readTemperature();                      //Leemos la temperatura en grados Celsius
    TiempoUltimaLecturaDHT1 = millis();                 //Actualizamos el tiempo de la última lectura del DHT1
  }
}

long TiempoUltimaLecturaDHT2 = 0;
void SensorTemp2()                                      //Fresa
{
  if (millis() - TiempoUltimaLecturaDHT2 > 2000)
  {
    hDHT2 = dht_2.readHumidity();
    tDHT2 = dht_2.readTemperature();              //Temperatura en grados Celsius
    TiempoUltimaLecturaDHT2 = millis();                 //Actualizamos el tiempo de la última lectura del DHT2
  }
}

long TiempoUltimaLecturaDHT3 = 0;
void SensorTemp3()                                     //Tablillas de yogurth
{
  if (millis() - TiempoUltimaLecturaDHT3 > 2000)
  {
    hDHT3 = dht_3.readHumidity();
    tDHT3 = dht_3.readTemperature();              //Leemos la temperatura en grados Celsius
    TiempoUltimaLecturaDHT3 = millis();                 //Actualizamos el tiempo de la última lectura del DHT3
  }
}

//Sensor Corriente
void Mostrar_corriente()
{
  float Ip = Obtener_corriente();                                             //Obtenemos la corriente pico
  float Irms = Ip * 0.707;                                                    //Intensidad RMS = Ipico*2/(2^1/2)
  Serial.print(Irms, 3);
  Serial.print ("A. ");
  if (Irms>CorrienteMaxima)                                                               
  {
  digitalWrite (MotorAC, LOW);
  ErrorSobrePico=1;
  }
}

float Obtener_corriente()
{
  long TiempoSensorI = millis();
  float SensibilidadI = .0659;                                                //Sensibilidad del Sensor de corriente de 30 A
  float OffsetI = 0;                                                          //Ip cuando I=0
  float VoltajeSensorI;
  float Corriente = 0;
  float Imax = 0;
  float Imin = 0;
  while (millis() - TiempoSensorI < 500)                                      //Mediciones durante 0.5 segundos
  {
    VoltajeSensorI = analogRead(A4) * (5.0 / 1023.0);                         //Lectura del sensor y mapeo a 5V
    Corriente = 0.9 * Corriente + 0.1 * ((VoltajeSensorI - 2.501) / SensibilidadI); //Ecuación  para obtener la corriente, aplicamos un filtro pasa bajas,
    if (Corriente > Imax)Imax = Corriente;
    if (Corriente < Imin)Imin = Corriente;
  }
  return (((Imax - Imin) / 2) - OffsetI);
}

//Tomar lecturas
void Tomar_Lecturas()
{
  Ultrasonico1();
  Ultrasonico2();
  Ultrasonico3();
  Ultrasonico4();
  Ultrasonico5();
  Ultrasonico6();
  SensorTemp1();
  SensorTemp2();
  SensorTemp3();
}
