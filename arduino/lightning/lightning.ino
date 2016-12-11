// Arduino "bridge" code between streamer device and WS2801-based
// digital RGB LED. Intended for use with Arduino Uno, but may work
// with other Arduino models as well.

#include <SPI.h>

#define LED_DDR  DDRB
#define LED_PORT PORTB
#define LED_PIN  _BV(PORTB5)

static const uint8_t magic[] = {'L','i','g', 'h', 't', 'n', 'i', 'n', 'g'};
#define MAGICSIZE  sizeof(magic)
#define HEADERSIZE (MAGICSIZE + 2)

#define MODE_HEADER 0
#define MODE_HOLD   1
#define MODE_DATA   2

void setup()
{
  uint8_t
    buffer[256],
    indexIn       = 0,
    indexOut      = 0,
    mode          = MODE_HEADER,
    lo, chk, i, spiFlag;
  int16_t
    bytesBuffered = 0,
    hold          = 0,
    c;
  int32_t
    bytesRemaining;
  unsigned long
    startTime,
    lastByteTime,
    t;

  LED_DDR  |=  LED_PIN;
  LED_PORT &= ~LED_PIN;

  Serial.begin(115200);
  SPI.begin();
  SPI.setBitOrder(MSBFIRST);
  SPI.setDataMode(SPI_MODE0);
  SPI.setClockDivider(SPI_CLOCK_DIV16);

  startTime    = micros();
  lastByteTime = millis();

  for(;;) {
    t = millis();
    
    if((bytesBuffered < 256) && ((c = Serial.read()) >= 0)) {
      buffer[indexIn++] = c;
      bytesBuffered++;
      lastByteTime = t;
    } else {
      // Turn off lights, when no data recieved for more than minute
      if((t - lastByteTime) > 60000) {
        for(c=0; c<32767; c++) {
          for(SPDR=0; !(SPSR & _BV(SPIF)); );
        }
        delay(1);
        lastByteTime = t;
      }
    }

    switch(mode) {
     case MODE_HEADER:
      if(bytesBuffered >= HEADERSIZE) {        
        for(i=0; (i<MAGICSIZE) && (buffer[indexOut++] == magic[i++]););
        if(i == MAGICSIZE) {
          lo  = buffer[indexOut++];
          chk = buffer[indexOut++];
          if(chk == (lo ^ 0x13)) {
            bytesRemaining = 3L * ((long)lo + 1L);
            bytesBuffered -= 2;
            spiFlag        = 0;
            mode           = MODE_HOLD;
          } else {
            indexOut  -= 2;
          }
        }
        bytesBuffered -= i;
      }
      break;

     case MODE_HOLD:
      if((micros() - startTime) < hold) break;
      LED_PORT &= ~LED_PIN;
      mode      = MODE_DATA;

     case MODE_DATA:
      while(spiFlag && !(SPSR & _BV(SPIF)));
      if(bytesRemaining > 0) {
        if(bytesBuffered > 0) {
          SPDR = buffer[indexOut++];
          bytesBuffered--;
          bytesRemaining--;
          spiFlag = 1;
        }
        if((bytesBuffered < 32) && (bytesRemaining > bytesBuffered)) {
          startTime = micros();
          hold      = 100 + (32 - bytesBuffered) * 10;
          mode      = MODE_HOLD;
  }
      } else {
        startTime  = micros();
        hold       = 1000;
        LED_PORT  |= LED_PIN;
        mode       = MODE_HEADER;
      }
    }
  }
}

void loop()
{
  // Code won't reach here
}

