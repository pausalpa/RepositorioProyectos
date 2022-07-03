//Variables a imprimir
String Enviar,Coma=",";

void Enviar_Lecturas()
{
  Enviar= dU1 + Coma + dU2 +Coma + dU3 + Coma + dU4 + Coma + dU5 + Coma + dU6 + Coma + hDHT1 + Coma + tDHT1 + Coma +hDHT2 + Coma + tDHT2 + Coma + hDHT3 + Coma + tDHT3 + Coma;
  Serial.print(Enviar);
}

//Leer pedido
void PedidoNieve()
{
  if  (Serial.available() > 0)
  {
    Tamano = Serial.readStringUntil(',');
    Durazno = Serial.readStringUntil(',');
    Fresa = Serial.readStringUntil(',');
    Chocolate = Serial.readStringUntil(',');
    Cereal1 = Serial.readStringUntil(',');
    Cereal2 = Serial.readStringUntil('\n');
    if (Tamano == "Grande") Porcion = "G.";
    else if (Tamano == "Chica") Porcion = "Ch.";
    else Porcion = "El tamaño de la nieve se introdujo mal. ";

    if (Fresa == "1" && Durazno == "1")Sabor = "FyD.";
    else if (Fresa == "1") Sabor = "F.";
    else if (Durazno == "1") Sabor = "D.";
    else Sabor = "Por favor seleccione un sabor de nieve. ";

    if (Chocolate == "1") Chocochoco = "ConC.";
    else Chocochoco = "SinC.";

    if (Cereal1 == "1" && Cereal2 == "1") Cereales = "Cer1y2.";
    else if (Cereal1 == "1") Cereales = "Cer1.";
    else if (Cereal2 == "1") Cereales = "Cer2.";
    else Cereales = "SinCer.";

    Resultado = Porcion + Sabor + Chocochoco + Cereales + "\n";
    
    if (Porcion == "El tamaño de la nieve se introdujo mal. ") Serial.println ("NoTamaño");
    else if (Sabor == "Por favor seleccione un sabor de nieve. ") Serial.println ("NoSabor");
    else
    {
      Serial.print(Resultado);
      HacerNieve = 1;
    } 
    delay(200); 
  }
}
