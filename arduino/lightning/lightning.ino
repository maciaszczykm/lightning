// Arduino "bridge" code between streamer device and WS2801-based digital RGB LED.
// Intended for use with Arduino Uno, but may work with other Arduino models as well.

#include <SPI.h>

// Lightning sends a packages with specific header. It consits of magic word, number of LEDs and checksum.
uint8_t magicWord[] = {'L','i','g', 'h', 't', 'n', 'i', 'n', 'g'}, leds, checksum;
#define MAGIC_WORD_SIZE  sizeof(magicWord)
#define HEADER_SIZE (MAGIC_WORD_SIZE + 2)

// Serial port bit rate.
#define PORT_SPEED 115200

// Port registers allow lower-level and faster manipulation of I/O pins of the microcontroller.
// Each port have three registers: DDR determining whether pin is input or output, PORT controlling if pin is in high or low state and PIN registering state of input pins set to input with pinMode().
// Lightning uses port B (digital pins from 8 to 13) for LED control.
// More information at https://www.arduino.cc/en/Reference/PortManipulation.
#define LED_DDR  DDRB
#define LED_PORT PORTB
#define LED_PIN  _BV(PORTB5)

// Lightning LEDs timeout, by default 5 seconds.
#define LED_TIMEOUT 5000

// Lightning main loop states.
#define HEADER_VALIDATION_STATE 0
#define DATA_BUFFERING_STATE   1

uint8_t state = HEADER_VALIDATION_STATE;  // Initial Lightning state.
uint8_t indexIn = 0, indexOut = 0;        // Indexes for input and output buffers.
uint8_t buffer[256];                      // Circular buffer for serial port data is 256 bytes long.
uint8_t spiFlag;                          // Allows to skip check if first byte has been already buffered when skipping from HEADER_VALIDATION_STATE to DATA_BUFFERING_STATE.
int16_t index;                            // Index for reading header from buffer and turning LEDs off.
int16_t bytesBuffered = 0;                // Number of bytes buffered to the buffer.
int16_t value;                            // Current value read from serial port.
int32_t bytesRemaining;                   // Number of bytes remaining to buffer in DATA_BUFFERING_STATE.
unsigned long lastByteTime;               // Last time when byte was buffered.

void setup() {
  LED_DDR  |=  LED_PIN; // Make LED pin an output.
  LED_PORT &= ~LED_PIN; // Turn off LEDs.

  Serial.begin(PORT_SPEED);

  SPI.begin();
  SPI.setBitOrder(MSBFIRST);
  SPI.setDataMode(SPI_MODE0);
  SPI.setClockDivider(SPI_CLOCK_DIV16); 

  lastByteTime = millis(); 
}

void loop() {
  // Buffer byte if there are any on serial port.
  if((bytesBuffered < 256) && ((value = Serial.read()) >= 0)) {
    buffer[indexIn++] = value;
    bytesBuffered++;
    lastByteTime = millis();
  } else {
    // Turn off LEDs and reset timeout counter, when no data recieved for more than LED_TIMEOUT.
    if((millis() - lastByteTime) > LED_TIMEOUT) {
      for(index=0; index<32767; index++) {
        for(SPDR=0; !(SPSR & _BV(SPIF)); );
      }
      delay(1);
      lastByteTime = millis();
    }
  }

  switch(state) {

    case HEADER_VALIDATION_STATE:
      if(bytesBuffered >= HEADER_SIZE) {
        for(index=0; (index<MAGIC_WORD_SIZE) && (buffer[indexOut++] == magicWord[index++]);); // Move indexOut through buffer if it matches magic word.
        if(index == MAGIC_WORD_SIZE) {
          leds  = buffer[indexOut++];
          checksum = buffer[indexOut++];
          if(checksum == (leds ^ 0x13)) {
            bytesRemaining = 3L * ((long)leds + 1L);
            bytesBuffered -= 2;
            spiFlag = 0;
            state = DATA_BUFFERING_STATE;
          } else {
            indexOut  -= 2;
          }
        }
        bytesBuffered -= index;
      }
      break;

    case DATA_BUFFERING_STATE:
      while(spiFlag && !(SPSR & _BV(SPIF))); // Wait for prior byte to buffer.
      if(bytesRemaining > 0) {
        if(bytesBuffered > 0) {
          SPDR = buffer[indexOut++];
          bytesBuffered--;
          bytesRemaining--;
          spiFlag = 1;
        }
      } else {
        LED_PORT |= LED_PIN;
        state = HEADER_VALIDATION_STATE;
      }
    }
}
