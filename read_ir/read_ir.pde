#include "UsbKeyboard.h"

#include <IRremote.h>
#include <IRremoteInt.h>

int RECV_PIN = 2;

IRrecv irrecv(RECV_PIN);
decode_results results;

void setup()
{
  irrecv.enableIRIn(); // Start the receiver
  Serial.begin(9600);
}

// Compare two tick values, returning 0 if newval is shorter,
// 1 if newval is equal, and 2 if newval is longer
// Use a tolerance of 20%
int compare(unsigned int oldval, unsigned int newval) {
  if (newval < oldval * .8) {
    return 0;
  } 
  else if (oldval < newval * .8) {
    return 2;
  } 
  else {
    return 1;
  }
}

// Use FNV hash algorithm: http://isthe.com/chongo/tech/comp/fnv/#FNV-param
#define FNV_PRIME_32 16777619
#define FNV_BASIS_32 2166136261

/* Converts the raw code values into a 32-bit hash code.
 * Hopefully this code is unique for each button.
 */
unsigned long decodeHash(decode_results *results) {
  unsigned long hash = FNV_BASIS_32;
  for (int i = 1; i+2 < results->rawlen; i++) {
    int value =  compare(results->rawbuf[i], results->rawbuf[i+2]);
    // Add value into the hash
    hash = (hash * FNV_PRIME_32) ^ value;
  }
  return hash;
}

void loop() {
  UsbKeyboard.update();
  
  if (irrecv.decode(&results)) {
    /*
    Serial.print("'real' decode: ");
    Serial.print(results.value, HEX);
    Serial.print(", hash decode: ");
    */
    unsigned long _results = decodeHash(&results);
    //Serial.print("hash decode: ");
    //Serial.print(_results); // Do something interesting with this value
    //power 4105841032   
    switch (_results)
    {
      case 4105841032:
        Serial.print("POWER");
        break;
      case 3526956266:
        Serial.print("TV btn");
        break;
      
/*----------------------------------------------------------------
        NUMBER KEYS
*/      
      //one button
      case 3778927144:
        Serial.print(49);
        break;
      //2 button
      case 2908251746:
        Serial.print(50);
        break;
      //3 button        
      case 657459652:
        Serial.print(51);
        break;
      //4 button        
      case 4120482440:
        Serial.print(52);
        break; 
      //5 button      
      case 1931099650:
        Serial.print(53);
        break;
      //6 button        
      case 742730860:
        Serial.print(54);
        break;
      //7 button        
      case 1167253836:
        Serial.print(55);
        break;
      //8 button        
      case 1747313982:
        Serial.print(56);
        break;    
      //9 button
      case 2340753640:
        Serial.print(57);
        break;
      //0 button
      case 3119867746:
        Serial.print(48);
        break;
/*----------------------------------------------------------------
        CHANNEL / VOLUME
*/      
      //vol up.  there is no correlation here, making it the same as a mac
      case 1752382022:
        Serial.print("F12");
        break;
      //vol down
      case 2209452902:
        Serial.print("F11");
        break; 
      //channel up button            
      case 1595074756:
        Serial.print(0x01000004);
        break;
      //channel down
      case 412973352:
        Serial.print(0x01000005);
        break;
      //mute
      case 591444258:
        Serial.print("F10");
        break; 
        
/*----------------------------------------------------------------
        NAVIGATION
*/        
      //tools, using the guide key
      case 1825097194:
        Serial.print(0x01000014);
        break;
      //return button
      case 1003313352:
        Serial.print(13);
        break;        
      //up button  
      case 3261853764:
        Serial.print(38);
        break;
      //down button
      case 3305092678:
        Serial.print(40);
        break; 
      //left button
      case 1972149634:
        Serial.print(37);
        break;
      //right button  
      case 1400905448:
        Serial.print(39);
        break;
      //center select, using numpad_enter 
      case 2331063592:
        //Serial.print(108);
        Serial.print(13);
        break;
      //info button
      case 1908947622:
        //Serial.print(0x01000013);
        Serial.print(73);
        break;    
      //exit button  
      case 158659426:
        //Serial.print(0x01000015);
        Serial.print(88);
        break;
      //menu
      case 1723810024:
        Serial.print(77);
        break;

/*----------------------------------------------------------------
        COLORED BUTTONS
*/      
      //red button
      case 3672802284:
        Serial.print(0x01000000);
        break;
      //green button
      case 732942060:
        Serial.print(0x01000001);
        break;
      //yellow button
      case 3038842278:
        //Serial.print(0x01000002);
        Serial.print(80);
        break;    
      case 1906441864:
        Serial.print(0x01000003);
        break;
      default:
        Serial.print(_results);
        break;    

    }
    irrecv.resume(); // Resume decoding (necessary!)
    
  }
}


