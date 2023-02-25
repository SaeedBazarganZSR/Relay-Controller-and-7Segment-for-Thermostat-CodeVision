/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2/21/2023
Author  : 
Company : 
Comments: 


Chip type               : ATmega328P
Program type            : Application
AVR Core Clock frequency: 0.125000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega328p.h>

// Declare your global variables here
#include <delay.h>
#include <stdint.h>
#include <stdio.h>
//----------------------------------------------------------------------
typedef enum RelayNumber
{
	Fan = 0x01,
	One = 0x02,
	Two = 0x03,
	Three = 0x04,
	All = 0x05
}Relay;

unsigned char SegNum[10] = {0x30, 0xF9, 0x52, 0xD0, 0x99, 0x94, 0x14, 0xF1, 0x10, 0x90};
unsigned char SegDot = 0xEF;
uint8_t Segment1, Segment2, Segment3;

int16_t RawAdc = 0;
uint8_t Count = 0;
uint8_t TempInit = 0;
uint16_t TempAvg = 0;
uint8_t TempTarget = 0;
uint8_t TempSetTarget = 0;
//----------------------------------------------------------------------
void Relay_TurnOn(uint8_t Number);
void Relay_TurnOff(uint8_t Number);
void Warning_On(void);
void Warning_Off(void);
void Display(uint16_t Number);
void Display_Configuration(uint8_t Number, uint8_t Place);
void Keys_Update(void);
void WindSensor_Update(void);
void LimitSensor_Update(void);
uint8_t TempSensor_Update(void);
void Initial(void);
//----------------------------------------------------------------------
// Voltage Reference: AREF pin
#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}

// SPI functions
#include <spi.h>

// Timer0 Initial function
void timer0_init()
{
    // set up timer with prescaler = 1024
    TCCR0B |= (1 << CS02)|(1 << CS00);
    // initialize counter
    TCNT0 = 0;
}

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 8
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (1<<CLKPS1) | (1<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 0.488 kHz
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
// Timer Period: 0.52429 s
TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
TCCR0B=(0<<WGM02) | (1<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2A output: Disconnected
// OC2B output: Disconnected
ASSR=(0<<EXCLK) | (0<<AS2);
TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);

// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: Off
EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
EIMSK=(0<<INT1) | (0<<INT0);
PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);

// USART initialization
// USART disabled
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
ADCSRB=(0<<ACME);
// Digital input buffer on AIN0: On
// Digital input buffer on AIN1: On
DIDR1=(0<<AIN0D) | (0<<AIN1D);

// ADC initialization
// ADC Clock frequency: 0.977 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
// Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
// ADC4: On, ADC5: On
DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 31.250 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
SPSR=(0<<SPI2X);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

//----------------------------------------------------------------------
Initial();
TempInit = TempSensor_Update();
TempTarget = TempInit;
TempSetTarget = TempInit;
timer0_init();
//----------------------------------------------------------------------
while (1)
      { 
        WindSensor_Update();
        LimitSensor_Update();
        
        Keys_Update();
        Display(TempTarget);
        if (TCNT0 >= 250)
        {
            TempInit = TempSensor_Update();
            TCNT0 = 0;            // reset counter
        }
        if((TempSetTarget - TempInit) > 0 && (TempSetTarget - TempInit) < 4)
        {
            PORTD.7 = 1;
            PORTD.6 = 0;
            PORTD.5 = 0;
        }
        else if((TempSetTarget - TempInit) >= 5 && (TempSetTarget - TempInit) < 11)
        {
            PORTD.7 = 1;
            PORTD.6 = 1;
            PORTD.5 = 0;
        }
        else if((TempSetTarget - TempInit) >= 11)
        {
            PORTD.7 = 1;
            PORTD.6 = 1;
            PORTD.5 = 1;
        }
        else
        {
            PORTD.7 = 0;
            PORTD.6 = 0;
            PORTD.5 = 0;  
        }       
      }
}
//----------------------------------------------------------------------
void Relay_TurnOn(uint8_t Number)
{
    switch(Number)
    {
        case Fan:
            PORTC.5 = 1;            
        break;
        case One:
            PORTD.5 = 1;            
        break;
        case Two:
            PORTD.6 = 1;            
        break;
        case Three:
            PORTD.7 = 1;            
        break;
        case All:
            PORTC.5 = 1;
            PORTD.5 = 1;
            PORTD.6 = 1;
            PORTD.7 = 1;            
        break;        
    }
}
//----------------------------------------------------------------------
void Relay_TurnOff(uint8_t Number)
{
    switch(Number)
    {
        case Fan:
            PORTC.5 = 0;            
        break;
        case One:
            PORTD.5 = 0;            
        break;
        case Two:
            PORTD.6 = 0;            
        break;
        case Three:
            PORTD.7 = 0;            
        break;
        case All:
            PORTC.5 = 0;
            PORTD.5 = 0;
            PORTD.6 = 0;
            PORTD.7 = 0;            
        break;        
    }
}
//----------------------------------------------------------------------
void Warning_On(void)
{
    PORTC.4 = 1;
}
//----------------------------------------------------------------------
void Warning_Off(void)
{
    PORTC.4 = 0;    
}
//----------------------------------------------------------------------
void Display(uint16_t Number)
{
    Segment1 = (Number / 100) % 10;
    Segment2 = (Number / 10) % 10;
    Segment3 = (Number / 1) % 10;
    if(Number == 100)
    {
        Display_Configuration(Segment1, 1);
        delay_ms(5);
        Display_Configuration(Segment2, 2);
        delay_ms(5);
        Display_Configuration(Segment3, 3);
        delay_ms(5);        
    }
    else if(Number > 100 && Number < 999)
    {
        Display_Configuration(Segment1, 1);
        delay_ms(5);
        Display_Configuration(Segment2, 2);
        delay_ms(5);
        Display_Configuration(Segment3, 3);
        delay_ms(5);
    }
    else if(Number >= 10 && Number < 100)
    {
        Display_Configuration(Segment2, 2);
        delay_ms(5);
        Display_Configuration(Segment3, 3);
        delay_ms(5);
    }
    else if(Number < 10)
    {
        Display_Configuration(Segment3, 3);
        delay_ms(5);
    }
}
//----------------------------------------------------------------------
void Display_Configuration(uint8_t Number, uint8_t Place)
{
    switch(Place)
    {
        case 1:
            PORTB.0 = 0;
            PORTB.1 = 1;
            PORTB.2 = 1;
            spi(SegNum[Number]);
            PORTC.3 = 1;
            PORTC.3 = 0;
        break;
        case 2:
            PORTB.0 = 1;
            PORTB.1 = 0;
            PORTB.2 = 1;
            spi(SegNum[Number]);
            PORTC.3 = 1;
            PORTC.3 = 0;        
        break;
        case 3:
            PORTB.0 = 1;
            PORTB.1 = 1;
            PORTB.2 = 0;
            spi(SegNum[Number]);
            PORTC.3 = 1;
            PORTC.3 = 0;        
        break;        
    }
}
//----------------------------------------------------------------------
void Keys_Update(void)
{
    if(PIND.4 == 0)    //Off_Btn
        Initial();
    else if(PIND.0 == 0)    //Up_Btn
    {
        TempTarget += 2;
        delay_ms(1500);
    }
    else if(PIND.1 == 0)    //Down_Btn
    {
        TempTarget -= 2;
        delay_ms(1500);
    }
    else if(PIND.2 == 0)    //Set_Btn
    {                 
        delay_ms(1500);
        TempSetTarget = TempTarget;
    }
}
//----------------------------------------------------------------------
void WindSensor_Update(void)
{
    if(PINC.1 == 0)    //Wind_Off
    {
        Warning_On();
        Relay_TurnOn(All);
    }
    else
    {
        Warning_Off();
    }    
}
//----------------------------------------------------------------------
void LimitSensor_Update(void)
{
    if(PINC.2 == 0)    //Limit_Off
    {
        Warning_On();
        Relay_TurnOff(One);
        Relay_TurnOff(Two);
        Relay_TurnOff(Three);
        delay_ms(3000);
        Relay_TurnOff(Fan);
    }
    else
    {
        Warning_Off();
    }
}
//----------------------------------------------------------------------
uint8_t TempSensor_Update(void)
{
    RawAdc = read_adc(0);
    if(RawAdc == 470)
        return 25;
    else
    {
        for(Count = 0; Count < 10; Count++)
        {        
            RawAdc = read_adc(0);
            RawAdc -= 470;
            RawAdc = (RawAdc * -1) + 25;
            TempAvg += RawAdc;
        }
        TempAvg = TempAvg / 10;
        return TempAvg;
    }
}
//----------------------------------------------------------------------
void Initial(void)
{
    PORTB.0 = 1;
    PORTB.1 = 0;
    PORTB.2 = 1;
    spi(SegDot);
    PORTC.3 = 1;
    PORTC.3 = 0;
    delay_ms(5);
    PORTC.5 = 0;
    PORTD.5 = 0;
    PORTD.6 = 0;
    PORTD.7 = 0;
    while(PIND.3 == 1);
    PORTC.5 = 1;
    delay_ms(2000);
}
//----------------------------------------------------------------------


