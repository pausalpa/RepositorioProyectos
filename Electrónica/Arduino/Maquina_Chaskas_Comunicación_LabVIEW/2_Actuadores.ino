//Motores a Pasos
  void CondicionesInicialesMotores()
    {
        digitalWrite (Enable1, HIGH);
        digitalWrite (Enable2, HIGH);
        digitalWrite (Enable3, HIGH);
        digitalWrite (Enable4, HIGH);
        digitalWrite (Enable5, HIGH);
        digitalWrite (Enable6, HIGH);
        digitalWrite (Enable7, HIGH);
    }
  void Motor1()                                               //Platano
    {
    digitalWrite (Enable1, LOW);
    digitalWrite (DirMot1,HIGH);
    Serial.println ("Vertiendo platano.");
    for (int i =0; i<NumeroDePasos; i++)
      {
      digitalWrite(StepMot1, HIGH);
      delayMicroseconds(stepDelay);
      digitalWrite(StepMot1, LOW);
      delayMicroseconds(stepDelay);
      }
    digitalWrite (Enable1, HIGH);
    }
  void Motor2()                                              //Yogurth
    {
    digitalWrite (Enable2, LOW);  
    digitalWrite (DirMot2,HIGH);
    Serial.println ("Vertiendo yogurth.");
    for (int i =0; i<NumeroDePasos; i++)
      {
      digitalWrite(StepMot2, HIGH);
      delayMicroseconds(stepDelay);
      digitalWrite(StepMot2, LOW);
      delayMicroseconds(stepDelay);
      }
    digitalWrite (Enable2, HIGH);  
    }
  void Motor3()                                              //Fresa
    {
    digitalWrite (Enable3, LOW);
    digitalWrite (DirMot3,HIGH);
    Serial.println ("Vertiendo fresa.");
    for (int i =0; i<NumeroDePasos; i++)
      {
      digitalWrite(StepMot3, HIGH);
      delayMicroseconds(stepDelay);
      digitalWrite(StepMot3, LOW);
      delayMicroseconds(stepDelay);
      }
    digitalWrite (Enable3, HIGH);
    }
  void Motor4()                                             //Chocolate 
    {
    digitalWrite (Enable4, LOW);
    digitalWrite (DirMot4,HIGH);
    Serial.println ("Vertiendo chocolate.");
    for (int i =0; i<NumeroDePasosC; i++)
      {
      digitalWrite(StepMot4, HIGH);
      delayMicroseconds(stepDelay);
      digitalWrite(StepMot4, LOW);
      delayMicroseconds(stepDelay);
      }
    digitalWrite (Enable4,HIGH);
    }
  void Motor5()                                             //FrootLoops
    {
    digitalWrite (Enable5, LOW);
    digitalWrite (DirMot5,HIGH);
    Serial.println ("Vertiendo FrootLoops.");
    for (int i =0; i<(NumeroDePasosC+15); i++)
      {
      digitalWrite(StepMot5, HIGH);
      delayMicroseconds(stepDelay);
      digitalWrite(StepMot5, LOW);
      delayMicroseconds(stepDelay);
      }
    digitalWrite (Enable5, HIGH);
    }
  void Motor6()                                             //Cereal 2
    {
    digitalWrite (Enable6, LOW);
    digitalWrite (DirMot6,HIGH);
    Serial.println ("Vertiendo TrigoInf.");
    for (int i =0; i<NumeroDePasosC; i++)
      {
      digitalWrite(StepMot6, HIGH);
      delayMicroseconds(stepDelay);
      digitalWrite(StepMot6, LOW);
      delayMicroseconds(stepDelay);
      }
    delay(100);
    digitalWrite (Enable6, HIGH);
    }
    void MotorLengueta()                                           //Lengüeta tolva
    {
    digitalWrite (Enable7, LOW);
    digitalWrite (DirMot7,LOW);
    Serial.println ("CayendoNieve.");
    for (int i =0; i<Pasoslengueta; i++)
      {
      digitalWrite(StepMot7, HIGH);
      delayMicroseconds(stepDelayL);
      digitalWrite(StepMot7, LOW);
      delayMicroseconds(stepDelayL);
      }
    delay(4000);
    digitalWrite (DirMot7,HIGH);
    Serial.println ("CerrandoLengueta.");
    for (int i =0; i<Pasoslengueta; i++)
      {
      digitalWrite(StepMot7, HIGH);
      delayMicroseconds(stepDelayL);
      digitalWrite(StepMot7, LOW);
      delayMicroseconds(stepDelayL);
      }
    delay(100);
    digitalWrite (Enable7, HIGH);
    }
