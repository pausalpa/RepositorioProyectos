//NOTA:
//Específicar que de aquí en adelante, Cereal1 es FrootLoops y Cereal2 es Trigo Inflado, pudiendo variar éstos dependiendo de su disponibilidad
//Y además, Durazno=Platano

//Pines quemados: 36&37 (Dir,Step1.) 40&41 (Dir,Step3) 42,43 (Dir,Step4) 44,45 (Dir,Step5)
//Reemplazo de pines 36&37=3&4. 40&41= 9&10. 42&43=11&12. 44&45=54&55

//Incluimos librerías sensores temperatura
#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>

//Sensores Temperatura
#define DHTPIN 34                                       //DHT 1 está en pin 34
#define DHTPIN_2 35                                     //DHT 2 está en pin 35
#define DHTPIN_3 2                                      //DHT 3 está en pin 02
#define DHTTYPE DHT11
#define DHTTYPE_2 DHT11
#define DHTTYPE_3 DHT11
DHT dht (DHTPIN, DHTTYPE);
DHT dht_2 (DHTPIN_2, DHTTYPE_2);
DHT dht_3 (DHTPIN_3, DHTTYPE_3);

//Ultrasónicos
const int Trigger1 = 22;
const int Echo1 = 23;                                   //Ultrasónico 1
const int Trigger2 = 24;
const int Echo2 = 25;                                   //Ultrasónico 2
const int Trigger3 = 26;
const int Echo3 = 27;                                   //Ultrasónico 3
const int Trigger4 = 28;
const int Echo4 = 29;                                   //Ultrasónico 4
const int Trigger5 = 30;
const int Echo5 = 31;                                   //Ultrasónico 5
const int Trigger6 = 32;
const int Echo6 = 33;                                   //Ultrasónico 6

//Motores a Pasos. De arriba hacia abajo, enable, dirección, step.
const int Enable1 = 48;
const int DirMot1 = 3;
const int StepMot1 = 4;                                //Motor 1
const int Enable2 = 49;
const int DirMot2 = 38;
const int StepMot2 = 39;                                //Motor 2
const int Enable3 = 50;
const int DirMot3 = 9;
const int StepMot3 = 10;                                //Motor 3
const int Enable4 = 51;
const int DirMot4 = 11;
const int StepMot4 = 12;                                //Motor 4
const int Enable5 = 52;
const int DirMot5 = 54;
const int StepMot5 = 55;                                //Motor 5
const int Enable6 = 53;
const int DirMot6 = 46;
const int StepMot6 = 47;                                //Motor 6
const int Enable7 = 6;
const int DirMot7 = 56;
const int StepMot7 = 57;                                 //Motor 7

int NumeroDeRevoluciones,NumeroDePasos, RevolucionesLengueta = 15;  //RevolucionesC=1;   //Cada revolución son 200 pasos
int Pasoslengueta= RevolucionesLengueta * 200;         //Cada revolución son 200 pasos
int NumeroDePasosC=50;                                 // RevolucionesC * 200;
int stepDelay = 3000, stepDelayL= 800;                                    //Retraso (en uS) entre paso de los motores, determina la velocidad

//Motor AC
const int MotorAC = 5;
int CorrienteMaxima=15;                                                   //Corriente Máxima del Motor en Amperes

//Variables de Control
int HacerNieve = 0, ControlPorcion=0, ControlSabor=0, ErrorSobrePico=0;

//Variables para comunicación con Labview
String Tamano, Fresa, Durazno, Chocolate, Cereal1, Cereal2, Resultado, Envio, Porcion, Sabor, Chocochoco, Cereales;

void setup()
{
  Serial.begin(9600);

  //Ultrasónicos
  pinMode (Trigger1, OUTPUT);
  pinMode (Echo1, INPUT);
  pinMode (Trigger2, OUTPUT);
  pinMode (Echo2, INPUT);
  pinMode (Trigger3, OUTPUT);
  pinMode (Echo3, INPUT);
  pinMode (Trigger4, OUTPUT);
  pinMode (Echo4, INPUT);
  pinMode (Trigger5, OUTPUT);
  pinMode (Echo5, INPUT);
  pinMode (Trigger6, OUTPUT);
  pinMode (Echo6, INPUT);
  digitalWrite (Trigger1, LOW);
  digitalWrite (Trigger2, LOW);
  digitalWrite (Trigger3, LOW);
  digitalWrite (Trigger4, LOW);
  digitalWrite (Trigger5, LOW);
  digitalWrite (Trigger6, LOW);

  //Sensores Temperatura
  dht.begin();
  dht_2.begin();
  dht_3.begin();

  //Motores a pasos
  pinMode (DirMot1, OUTPUT);
  pinMode (StepMot1, OUTPUT);
  pinMode (Enable1, OUTPUT);
  pinMode (DirMot2, OUTPUT);
  pinMode (StepMot2, OUTPUT);
  pinMode (Enable2, OUTPUT);
  pinMode (DirMot3, OUTPUT);
  pinMode (StepMot3, OUTPUT);
  pinMode (Enable3, OUTPUT);
  pinMode (DirMot4, OUTPUT);
  pinMode (StepMot4, OUTPUT);
  pinMode (Enable4, OUTPUT);
  pinMode (DirMot5, OUTPUT);
  pinMode (StepMot5, OUTPUT);
  pinMode (Enable5, OUTPUT);
  pinMode (DirMot6, OUTPUT);
  pinMode (StepMot6, OUTPUT);
  pinMode (Enable6, OUTPUT);
  CondicionesInicialesMotores();
  
  //Motor AC
  pinMode (MotorAC, OUTPUT);
}

void loop()
{
 //De Arduino a Labview, para mandar los valores de los sensores
 Tomar_Lecturas();
 Enviar_Lecturas();
 Serial.print(" \n ");

  //De Labview a Arduino, para mandar a hacer la nieve.
  
  PedidoNieve();  
  //Serial.println(HacerNieve);
  if (HacerNieve == 1)
  {
    //Hacer nieve:
    
    //Tamaño
      if (Porcion == "G.")
      {
        NumeroDeRevoluciones = 5;
        ControlPorcion=1;
      }
      else if (Porcion == "Ch.")
      {
        NumeroDeRevoluciones = 7;
        ControlPorcion=1;
      }
      else NumeroDeRevoluciones = 0;                      //No se introdujo tamaño de porción
    
    if(ControlPorcion==1)
    {
      //Dispensar ingredientes
      
        delay(2000);                                      //Tiempo muerto para seguridad
        NumeroDePasos= NumeroDeRevoluciones * 200;
        if (Sabor == "FyD.")
        {
          Motor1();                                       //Se vierte el durazno
          delay(200);
          Motor2();                                       //Se vierte el yogurth
          delay(200);
          Motor3();                                       //Se vierte la fresa
         ControlSabor=1;
        }
        else if (Sabor == "F.")
        {
          Motor2();                                       //Se vierte el yogurth
          delay(200);
          Motor3();                                       //Se vierte la fresa
          ControlSabor=1;
        }
        else if (Sabor == "D.")                            //Durazno-Fresa-Yogurth-Chocolate-Cereal1-Cereal2-Lengüeta
        {
          Motor1();                                       //Se vierte el durazno
          delay(200);
          Motor2();                                       //Se vierte el yogurth
          ControlSabor=1;
        }
      if(ControlSabor==1)
      {
        
      //Triturar nieve
      
        delay (5000);
        digitalWrite (MotorAC, HIGH);                     //Se hace la nieve
        Serial.println("Triturando.");
        delay(10000);
        Mostrar_corriente();                              //Corriente RMS del motor de CA
        if (ErrorSobrePico==0)
        {
          delay(20000);
          //delay(500);
          digitalWrite (MotorAC, LOW);
          Serial.println("FinalizoTr.");
          MotorLengueta();                                       //Se libera la nieve triturada
      
         //Estación chocolate
         
          if (Chocochoco == "ConC.")
          {
            Motor4();                                           //Se vierte chocolate
            delay(200);
          }
          
          //Estación cereales
          
            if (Cereales == "Cer1y2.")
            {
              Motor5();                                          //Vierte Cereal1
              delay(200);
              Motor6();                                          //Vierte Cereal2
            }
            else if (Cereales == "Cer1.")Motor5();               //Vierte Cereal1
            else if (Cereales == "Cer2.")Motor6();               //Vierte Cereal2
  
          Serial.println ("Chaska terminada^-^");
          delay(500);
        }
      }
    }
    if (ErrorSobrePico==1)
    {
      Serial.print ("ErrorSobrePico.");  
    }
    HacerNieve = 0;
    ControlPorcion=0;
    ControlSabor=0;
    ErrorSobrePico=0;
  }
}
