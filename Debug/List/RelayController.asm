
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _SegDot=R4
	.DEF _Segment1=R3
	.DEF _Segment2=R6
	.DEF _Segment3=R5
	.DEF _RawAdc=R7
	.DEF _RawAdc_msb=R8
	.DEF _Count=R10
	.DEF _TempInit=R9
	.DEF _TempAvg=R11
	.DEF _TempAvg_msb=R12
	.DEF _TempTarget=R14
	.DEF _TempSetTarget=R13

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0xEF,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0

_0x3:
	.DB  0x30,0xF9,0x52,0xD0,0x99,0x94,0x14,0xF1
	.DB  0x10,0x90
_0x4:
	.DB  0x2

__GLOBAL_INI_TBL:
	.DW  0x0B
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0A
	.DW  _SegNum
	.DW  _0x3*2

	.DW  0x01
	.DW  _DiffTempSet
	.DW  _0x4*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 3/8/2023
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega328P
;Program type            : Application
;AVR Core Clock frequency: 1.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;#include <stdint.h>
;#include <stdio.h>
;//----------------------------------------------------------------------
;typedef enum RelayNumber
;{
;	Fan = 0x01,
;	One = 0x02,
;	Two = 0x03,
;	Three = 0x04,
;	All = 0x05
;}Relay;
;
;unsigned char SegNum[10] = {0x30, 0xF9, 0x52, 0xD0, 0x99, 0x94, 0x14, 0xF1, 0x10, 0x90};

	.DSEG
;unsigned char SegDot = 0xEF;
;uint8_t Segment1, Segment2, Segment3;
;
;int16_t RawAdc = 0;
;uint8_t Count = 0;
;uint8_t TempInit = 0;
;uint16_t TempAvg = 0;
;uint8_t TempTarget = 0;
;uint8_t TempSetTarget = 0;
;uint8_t TempCheckSecond = 0;
;uint8_t FanFlag = 0;
;uint8_t TurnOFF_FanSecond = 0;
;
;eeprom unsigned char EEPROM_Value;
;
;uint8_t ToggleWarning = 0;
;
;uint8_t SettingCount = 0;
;uint8_t SettingFlag = 0;
;uint8_t DiffTempTarget = 0;
;uint8_t DiffTempSet = 2;
;//----------------------------------------------------------------------
;void Routine(void);
;void Relay_TurnOn(uint8_t Number);
;void Relay_TurnOff(uint8_t Number);
;void Warning_On(void);
;void Warning_Off(void);
;void Display(uint16_t Number);
;void Display_Configuration(uint8_t Number, uint8_t Place);
;void Keys_Update(void);
;void WindSensor_Update(void);
;void LimitSensor_Update(void);
;uint8_t TempSensor_Update(void);
;void Initial(void);
;void EEPROM_Write(uint8_t w);
;uint8_t EEPROM_Read(void);
;void SettingUpdate(void);
;//----------------------------------------------------------------------
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0052 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 0053 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	STS  124,R30
; 0000 0054 // Delay needed for the stabilization of the ADC input voltage
; 0000 0055 delay_us(10);
	__DELAY_USB 3
; 0000 0056 // Start the AD conversion
; 0000 0057 ADCSRA|=(1<<ADSC);
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
; 0000 0058 // Wait for the AD conversion to complete
; 0000 0059 while ((ADCSRA & (1<<ADIF))==0);
_0x5:
	LDS  R30,122
	ANDI R30,LOW(0x10)
	BREQ _0x5
; 0000 005A ADCSRA|=(1<<ADIF);
	LDS  R30,122
	ORI  R30,0x10
	STS  122,R30
; 0000 005B return ADCW;
	LDS  R30,120
	LDS  R31,120+1
	JMP  _0x2080001
; 0000 005C }
; .FEND
;
;// SPI functions
;#include <spi.h>
;
;// Timer0 Initial function
;void timer0_init()
; 0000 0063 {
_timer0_init:
; .FSTART _timer0_init
; 0000 0064     // set up timer with prescaler = 1024
; 0000 0065     TCCR0B |= (1 << CS02)|(1 << CS00);
	IN   R30,0x25
	ORI  R30,LOW(0x5)
	OUT  0x25,R30
; 0000 0066     // initialize counter
; 0000 0067     TCNT0 = 0;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0068 }
	RET
; .FEND
;
;void main(void)
; 0000 006B {
_main:
; .FSTART _main
; 0000 006C // Declare your local variables here
; 0000 006D 
; 0000 006E // Crystal Oscillator division factor: 1
; 0000 006F #pragma optsize-
; 0000 0070 CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0071 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0072 #ifdef _OPTIMIZE_SIZE_
; 0000 0073 #pragma optsize+
; 0000 0074 #endif
; 0000 0075 
; 0000 0076 // Input/Output Ports initialization
; 0000 0077 // Port B initialization
; 0000 0078 // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0079 DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(47)
	OUT  0x4,R30
; 0000 007A // State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 007B PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 007C 
; 0000 007D // Port C initialization
; 0000 007E // Function: Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 007F DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(56)
	OUT  0x7,R30
; 0000 0080 // State: Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 0081 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 0082 
; 0000 0083 // Port D initialization
; 0000 0084 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0085 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(224)
	OUT  0xA,R30
; 0000 0086 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0087 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0088 
; 0000 0089 // Timer/Counter 0 initialization
; 0000 008A // Clock source: System Clock
; 0000 008B // Clock value: 0.488 kHz
; 0000 008C // Mode: Normal top=0xFF
; 0000 008D // OC0A output: Disconnected
; 0000 008E // OC0B output: Disconnected
; 0000 008F // Timer Period: 0.52429 s
; 0000 0090 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x24,R30
; 0000 0091 TCCR0B=(0<<WGM02) | (1<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(4)
	OUT  0x25,R30
; 0000 0092 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0093 OCR0A=0x00;
	OUT  0x27,R30
; 0000 0094 OCR0B=0x00;
	OUT  0x28,R30
; 0000 0095 
; 0000 0096 // Timer/Counter 1 initialization
; 0000 0097 // Clock source: System Clock
; 0000 0098 // Clock value: Timer1 Stopped
; 0000 0099 // Mode: Normal top=0xFFFF
; 0000 009A // OC1A output: Disconnected
; 0000 009B // OC1B output: Disconnected
; 0000 009C // Noise Canceler: Off
; 0000 009D // Input Capture on Falling Edge
; 0000 009E // Timer1 Overflow Interrupt: Off
; 0000 009F // Input Capture Interrupt: Off
; 0000 00A0 // Compare A Match Interrupt: Off
; 0000 00A1 // Compare B Match Interrupt: Off
; 0000 00A2 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 00A3 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	STS  129,R30
; 0000 00A4 TCNT1H=0x00;
	STS  133,R30
; 0000 00A5 TCNT1L=0x00;
	STS  132,R30
; 0000 00A6 ICR1H=0x00;
	STS  135,R30
; 0000 00A7 ICR1L=0x00;
	STS  134,R30
; 0000 00A8 OCR1AH=0x00;
	STS  137,R30
; 0000 00A9 OCR1AL=0x00;
	STS  136,R30
; 0000 00AA OCR1BH=0x00;
	STS  139,R30
; 0000 00AB OCR1BL=0x00;
	STS  138,R30
; 0000 00AC 
; 0000 00AD // Timer/Counter 2 initialization
; 0000 00AE // Clock source: System Clock
; 0000 00AF // Clock value: Timer2 Stopped
; 0000 00B0 // Mode: Normal top=0xFF
; 0000 00B1 // OC2A output: Disconnected
; 0000 00B2 // OC2B output: Disconnected
; 0000 00B3 ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 00B4 TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0000 00B5 TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	STS  177,R30
; 0000 00B6 TCNT2=0x00;
	STS  178,R30
; 0000 00B7 OCR2A=0x00;
	STS  179,R30
; 0000 00B8 OCR2B=0x00;
	STS  180,R30
; 0000 00B9 
; 0000 00BA // Timer/Counter 0 Interrupt(s) initialization
; 0000 00BB TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	STS  110,R30
; 0000 00BC 
; 0000 00BD // Timer/Counter 1 Interrupt(s) initialization
; 0000 00BE TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	STS  111,R30
; 0000 00BF 
; 0000 00C0 // Timer/Counter 2 Interrupt(s) initialization
; 0000 00C1 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	STS  112,R30
; 0000 00C2 
; 0000 00C3 // External Interrupt(s) initialization
; 0000 00C4 // INT0: Off
; 0000 00C5 // INT1: Off
; 0000 00C6 // Interrupt on any change on pins PCINT0-7: Off
; 0000 00C7 // Interrupt on any change on pins PCINT8-14: Off
; 0000 00C8 // Interrupt on any change on pins PCINT16-23: Off
; 0000 00C9 EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 00CA EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 00CB PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 00CC 
; 0000 00CD // USART initialization
; 0000 00CE // USART disabled
; 0000 00CF UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 00D0 
; 0000 00D1 // Analog Comparator initialization
; 0000 00D2 // Analog Comparator: Off
; 0000 00D3 // The Analog Comparator's positive input is
; 0000 00D4 // connected to the AIN0 pin
; 0000 00D5 // The Analog Comparator's negative input is
; 0000 00D6 // connected to the AIN1 pin
; 0000 00D7 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 00D8 // Digital input buffer on AIN0: On
; 0000 00D9 // Digital input buffer on AIN1: On
; 0000 00DA DIDR1=(0<<AIN0D) | (0<<AIN1D);
	LDI  R30,LOW(0)
	STS  127,R30
; 0000 00DB 
; 0000 00DC // ADC initialization
; 0000 00DD // ADC Clock frequency: 15.625 kHz
; 0000 00DE // ADC Voltage Reference: AREF pin
; 0000 00DF // ADC Auto Trigger Source: ADC Stopped
; 0000 00E0 // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 00E1 // ADC4: On, ADC5: On
; 0000 00E2 DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
	STS  126,R30
; 0000 00E3 ADMUX=ADC_VREF_TYPE;
	STS  124,R30
; 0000 00E4 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(134)
	STS  122,R30
; 0000 00E5 ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 00E6 
; 0000 00E7 // SPI initialization
; 0000 00E8 // SPI Type: Master
; 0000 00E9 // SPI Clock Rate: 2*31.250 kHz
; 0000 00EA // SPI Clock Phase: Cycle Start
; 0000 00EB // SPI Clock Polarity: High
; 0000 00EC // SPI Data Order: MSB First
; 0000 00ED SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (1<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	LDI  R30,LOW(88)
	OUT  0x2C,R30
; 0000 00EE SPSR=(1<<SPI2X);
	LDI  R30,LOW(1)
	OUT  0x2D,R30
; 0000 00EF 
; 0000 00F0 // TWI initialization
; 0000 00F1 // TWI disabled
; 0000 00F2 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	LDI  R30,LOW(0)
	STS  188,R30
; 0000 00F3 //----------------------------------------------------------------------
; 0000 00F4 Initial();
	RCALL _Initial
; 0000 00F5 PORTC.5 = 1;
	SBI  0x8,5
; 0000 00F6 TempInit = EEPROM_Read();
	RCALL _EEPROM_Read
	MOV  R9,R30
; 0000 00F7 TempTarget = TempInit;
	MOV  R14,R9
; 0000 00F8 TempSetTarget = TempInit;
	MOV  R13,R9
; 0000 00F9 timer0_init();
	RCALL _timer0_init
; 0000 00FA //----------------------------------------------------------------------
; 0000 00FB while (1)
_0xA:
; 0000 00FC       {
; 0000 00FD         WindSensor_Update();
	RCALL _WindSensor_Update
; 0000 00FE         LimitSensor_Update();
	RCALL _LimitSensor_Update
; 0000 00FF         Keys_Update();
	RCALL _Keys_Update
; 0000 0100         Display(TempTarget);
	MOV  R26,R14
	CLR  R27
	RCALL _Display
; 0000 0101         Routine();
	RCALL _Routine
; 0000 0102         SettingUpdate();
	RCALL _SettingUpdate
; 0000 0103       }
	RJMP _0xA
; 0000 0104 }
_0xD:
	RJMP _0xD
; .FEND
;//----------------------------------------------------------------------
;void Routine(void)
; 0000 0107 {
_Routine:
; .FSTART _Routine
; 0000 0108     if (TCNT0 >= 250)
	IN   R30,0x26
	CPI  R30,LOW(0xFA)
	BRSH PC+2
	RJMP _0xE
; 0000 0109     {
; 0000 010A         TCNT0 = 0;            // reset counter
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 010B         TempCheckSecond++;
	LDS  R30,_TempCheckSecond
	SUBI R30,-LOW(1)
	STS  _TempCheckSecond,R30
; 0000 010C         if(TempCheckSecond > 150)
	LDS  R26,_TempCheckSecond
	CPI  R26,LOW(0x97)
	BRLO _0xF
; 0000 010D         {
; 0000 010E             TempCheckSecond = 0;
	LDI  R30,LOW(0)
	STS  _TempCheckSecond,R30
; 0000 010F             TempInit = TempSensor_Update();
	RCALL _TempSensor_Update
	MOV  R9,R30
; 0000 0110             TempTarget = TempInit;
	MOV  R14,R9
; 0000 0111 
; 0000 0112             if((TempSetTarget - TempInit) <= 0)
	CALL SUBOPT_0x0
	BRLT _0x10
; 0000 0113             {
; 0000 0114                 Relay_TurnOff(Three);
	LDI  R26,LOW(4)
	RCALL _Relay_TurnOff
; 0000 0115                 Relay_TurnOff(Two);
	CALL SUBOPT_0x1
; 0000 0116                 Relay_TurnOff(One);
; 0000 0117                 FanFlag = 1;
	LDI  R30,LOW(1)
	STS  _FanFlag,R30
; 0000 0118                 TurnOFF_FanSecond++;
	LDS  R30,_TurnOFF_FanSecond
	SUBI R30,-LOW(1)
	STS  _TurnOFF_FanSecond,R30
; 0000 0119             }
; 0000 011A             else if((TempSetTarget - TempInit) > 0 && (TempSetTarget - TempInit) < (DiffTempSet + 1))
	RJMP _0x11
_0x10:
	CALL SUBOPT_0x0
	BRGE _0x13
	CALL SUBOPT_0x2
	BRLT _0x14
_0x13:
	RJMP _0x12
_0x14:
; 0000 011B             {
; 0000 011C                 Relay_TurnOn(Fan);
	CALL SUBOPT_0x3
; 0000 011D                 Relay_TurnOn(Three);
; 0000 011E                 Relay_TurnOff(Two);
	CALL SUBOPT_0x1
; 0000 011F                 Relay_TurnOff(One);
; 0000 0120             }
; 0000 0121             else if((TempSetTarget - TempInit) >= (DiffTempSet + 1) && (TempSetTarget - TempInit) < (DiffTempSet + 2))
	RJMP _0x15
_0x12:
	CALL SUBOPT_0x2
	BRLT _0x17
	CALL SUBOPT_0x4
	BRLT _0x18
_0x17:
	RJMP _0x16
_0x18:
; 0000 0122             {
; 0000 0123                 Relay_TurnOn(Fan);
	CALL SUBOPT_0x3
; 0000 0124                 Relay_TurnOn(Three);
; 0000 0125                 Relay_TurnOn(Two);
	LDI  R26,LOW(3)
	RCALL _Relay_TurnOn
; 0000 0126                 Relay_TurnOff(One);
	LDI  R26,LOW(2)
	RCALL _Relay_TurnOff
; 0000 0127             }
; 0000 0128             else if((TempSetTarget - TempInit) >= (DiffTempSet + 2))
	RJMP _0x19
_0x16:
	CALL SUBOPT_0x4
	BRLT _0x1A
; 0000 0129             {
; 0000 012A                 Relay_TurnOn(Fan);
	CALL SUBOPT_0x3
; 0000 012B                 Relay_TurnOn(Three);
; 0000 012C                 Relay_TurnOn(Two);
	LDI  R26,LOW(3)
	RCALL _Relay_TurnOn
; 0000 012D                 Relay_TurnOn(One);
	LDI  R26,LOW(2)
	RCALL _Relay_TurnOn
; 0000 012E             }
; 0000 012F 
; 0000 0130         }
_0x1A:
_0x19:
_0x15:
_0x11:
; 0000 0131     }
_0xF:
; 0000 0132     if(FanFlag == 1 && TurnOFF_FanSecond > 2)
_0xE:
	LDS  R26,_FanFlag
	CPI  R26,LOW(0x1)
	BRNE _0x1C
	LDS  R26,_TurnOFF_FanSecond
	CPI  R26,LOW(0x3)
	BRSH _0x1D
_0x1C:
	RJMP _0x1B
_0x1D:
; 0000 0133     {
; 0000 0134         Relay_TurnOff(Fan);
	LDI  R26,LOW(1)
	RCALL _Relay_TurnOff
; 0000 0135         FanFlag = 0;
	LDI  R30,LOW(0)
	STS  _FanFlag,R30
; 0000 0136         TurnOFF_FanSecond = 0;
	STS  _TurnOFF_FanSecond,R30
; 0000 0137     }
; 0000 0138 }
_0x1B:
	RET
; .FEND
;//----------------------------------------------------------------------
;void Relay_TurnOn(uint8_t Number)
; 0000 013B {
_Relay_TurnOn:
; .FSTART _Relay_TurnOn
; 0000 013C     switch(Number)
	CALL SUBOPT_0x5
;	Number -> Y+0
; 0000 013D     {
; 0000 013E         case Fan:
	BRNE _0x21
; 0000 013F             PORTC.5 = 1;
	SBI  0x8,5
; 0000 0140         break;
	RJMP _0x20
; 0000 0141         case One:
_0x21:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x24
; 0000 0142             PORTD.5 = 1;
	SBI  0xB,5
; 0000 0143         break;
	RJMP _0x20
; 0000 0144         case Two:
_0x24:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x27
; 0000 0145             PORTD.6 = 1;
	SBI  0xB,6
; 0000 0146         break;
	RJMP _0x20
; 0000 0147         case Three:
_0x27:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ _0xBC
; 0000 0148             PORTD.7 = 1;
; 0000 0149         break;
; 0000 014A         case All:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x20
; 0000 014B             PORTC.5 = 1;
	SBI  0x8,5
; 0000 014C             PORTD.5 = 1;
	SBI  0xB,5
; 0000 014D             PORTD.6 = 1;
	SBI  0xB,6
; 0000 014E             PORTD.7 = 1;
_0xBC:
	SBI  0xB,7
; 0000 014F         break;
; 0000 0150     }
_0x20:
; 0000 0151 }
	JMP  _0x2080001
; .FEND
;//----------------------------------------------------------------------
;void Relay_TurnOff(uint8_t Number)
; 0000 0154 {
_Relay_TurnOff:
; .FSTART _Relay_TurnOff
; 0000 0155     switch(Number)
	CALL SUBOPT_0x5
;	Number -> Y+0
; 0000 0156     {
; 0000 0157         case Fan:
	BRNE _0x39
; 0000 0158             PORTC.5 = 0;
	CBI  0x8,5
; 0000 0159         break;
	RJMP _0x38
; 0000 015A         case One:
_0x39:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3C
; 0000 015B             PORTD.5 = 0;
	CBI  0xB,5
; 0000 015C         break;
	RJMP _0x38
; 0000 015D         case Two:
_0x3C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x3F
; 0000 015E             PORTD.6 = 0;
	CBI  0xB,6
; 0000 015F         break;
	RJMP _0x38
; 0000 0160         case Three:
_0x3F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ _0xBD
; 0000 0161             PORTD.7 = 0;
; 0000 0162         break;
; 0000 0163         case All:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x38
; 0000 0164             PORTC.5 = 0;
	CBI  0x8,5
; 0000 0165             PORTD.5 = 0;
	CBI  0xB,5
; 0000 0166             PORTD.6 = 0;
	CBI  0xB,6
; 0000 0167             PORTD.7 = 0;
_0xBD:
	CBI  0xB,7
; 0000 0168         break;
; 0000 0169     }
_0x38:
; 0000 016A }
	JMP  _0x2080001
; .FEND
;//----------------------------------------------------------------------
;void Warning_On(void)
; 0000 016D {
_Warning_On:
; .FSTART _Warning_On
; 0000 016E     PORTC.4 = 1;
	SBI  0x8,4
; 0000 016F }
	RET
; .FEND
;//----------------------------------------------------------------------
;void Warning_Off(void)
; 0000 0172 {
_Warning_Off:
; .FSTART _Warning_Off
; 0000 0173     PORTC.4 = 0;
	CBI  0x8,4
; 0000 0174 }
	RET
; .FEND
;//----------------------------------------------------------------------
;void Display(uint16_t Number)
; 0000 0177 {
_Display:
; .FSTART _Display
; 0000 0178     Segment1 = (Number / 100) % 10;
	ST   -Y,R27
	ST   -Y,R26
;	Number -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x6
	MOV  R3,R30
; 0000 0179     Segment2 = (Number / 10) % 10;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x6
	MOV  R6,R30
; 0000 017A     Segment3 = (Number / 1) % 10;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	MOV  R5,R30
; 0000 017B     if(Number == 100)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRNE _0x52
; 0000 017C     {
; 0000 017D         Display_Configuration(Segment1, 1);
	CALL SUBOPT_0x7
; 0000 017E         delay_ms(1);
; 0000 017F         Display_Configuration(Segment2, 2);
; 0000 0180         delay_ms(1);
; 0000 0181         Display_Configuration(Segment3, 3);
	RJMP _0xBE
; 0000 0182         delay_ms(1);
; 0000 0183     }
; 0000 0184     else if(Number > 100 && Number < 999)
_0x52:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRLO _0x55
	CPI  R26,LOW(0x3E7)
	LDI  R30,HIGH(0x3E7)
	CPC  R27,R30
	BRLO _0x56
_0x55:
	RJMP _0x54
_0x56:
; 0000 0185     {
; 0000 0186         Display_Configuration(Segment1, 1);
	CALL SUBOPT_0x7
; 0000 0187         delay_ms(1);
; 0000 0188         Display_Configuration(Segment2, 2);
; 0000 0189         delay_ms(1);
; 0000 018A         Display_Configuration(Segment3, 3);
	RJMP _0xBE
; 0000 018B         delay_ms(1);
; 0000 018C     }
; 0000 018D     else if(Number >= 10 && Number < 100)
_0x54:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,10
	BRLO _0x59
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLO _0x5A
_0x59:
	RJMP _0x58
_0x5A:
; 0000 018E     {
; 0000 018F         Display_Configuration(Segment2, 2);
	ST   -Y,R6
	LDI  R26,LOW(2)
	CALL SUBOPT_0x8
; 0000 0190         delay_ms(1);
; 0000 0191         Display_Configuration(Segment3, 3);
	RJMP _0xBE
; 0000 0192         delay_ms(1);
; 0000 0193     }
; 0000 0194     else if(Number < 10)
_0x58:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,10
	BRSH _0x5C
; 0000 0195     {
; 0000 0196         Display_Configuration(Segment3, 3);
_0xBE:
	ST   -Y,R5
	LDI  R26,LOW(3)
	CALL SUBOPT_0x8
; 0000 0197         delay_ms(1);
; 0000 0198     }
; 0000 0199 }
_0x5C:
	RJMP _0x2080002
; .FEND
;//----------------------------------------------------------------------
;void Display_Configuration(uint8_t Number, uint8_t Place)
; 0000 019C {
_Display_Configuration:
; .FSTART _Display_Configuration
; 0000 019D     switch(Place)
	CALL SUBOPT_0x5
;	Number -> Y+1
;	Place -> Y+0
; 0000 019E     {
; 0000 019F         case 1:
	BRNE _0x60
; 0000 01A0             PORTB.0 = 0;
	CBI  0x5,0
; 0000 01A1             PORTB.1 = 1;
	SBI  0x5,1
; 0000 01A2             PORTB.2 = 1;
	SBI  0x5,2
; 0000 01A3             spi(SegNum[Number]);
	RJMP _0xBF
; 0000 01A4             PORTC.3 = 1;
; 0000 01A5             PORTC.3 = 0;
; 0000 01A6         break;
; 0000 01A7         case 2:
_0x60:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6B
; 0000 01A8             PORTB.0 = 1;
	SBI  0x5,0
; 0000 01A9             PORTB.1 = 0;
	CBI  0x5,1
; 0000 01AA             PORTB.2 = 1;
	SBI  0x5,2
; 0000 01AB             spi(SegNum[Number]);
	RJMP _0xBF
; 0000 01AC             PORTC.3 = 1;
; 0000 01AD             PORTC.3 = 0;
; 0000 01AE         break;
; 0000 01AF         case 3:
_0x6B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x5F
; 0000 01B0             PORTB.0 = 1;
	SBI  0x5,0
; 0000 01B1             PORTB.1 = 1;
	SBI  0x5,1
; 0000 01B2             PORTB.2 = 0;
	CBI  0x5,2
; 0000 01B3             spi(SegNum[Number]);
_0xBF:
	LDD  R30,Y+1
	LDI  R31,0
	SUBI R30,LOW(-_SegNum)
	SBCI R31,HIGH(-_SegNum)
	LD   R26,Z
	CALL _spi
; 0000 01B4             PORTC.3 = 1;
	SBI  0x8,3
; 0000 01B5             PORTC.3 = 0;
	CBI  0x8,3
; 0000 01B6         break;
; 0000 01B7     }
_0x5F:
; 0000 01B8 }
_0x2080002:
	ADIW R28,2
	RET
; .FEND
;//----------------------------------------------------------------------
;void Keys_Update(void)
; 0000 01BB {
_Keys_Update:
; .FSTART _Keys_Update
; 0000 01BC     if(PIND.4 == 0)    //Off_Btn
	SBIC 0x9,4
	RJMP _0x81
; 0000 01BD     {
; 0000 01BE         Initial();
	RCALL _Initial
; 0000 01BF     }
; 0000 01C0     else if(PIND.0 == 0)    //Up_Btn
	RJMP _0x82
_0x81:
	SBIC 0x9,0
	RJMP _0x83
; 0000 01C1     {
; 0000 01C2         TempTarget += 1;
	INC  R14
; 0000 01C3         delay_ms(2500);
	CALL SUBOPT_0x9
; 0000 01C4         TempCheckSecond = 0;
; 0000 01C5         SettingCount = 0;
; 0000 01C6     }
; 0000 01C7     else if(PIND.1 == 0)    //Down_Btn
	RJMP _0x84
_0x83:
	SBIC 0x9,1
	RJMP _0x85
; 0000 01C8     {
; 0000 01C9         TempTarget -= 1;
	DEC  R14
; 0000 01CA         delay_ms(2500);
	CALL SUBOPT_0x9
; 0000 01CB         TempCheckSecond = 0;
; 0000 01CC         SettingCount = 0;
; 0000 01CD     }
; 0000 01CE     else if(PIND.2 == 0)    //Set_Btn
	RJMP _0x86
_0x85:
	SBIC 0x9,2
	RJMP _0x87
; 0000 01CF     {
; 0000 01D0         delay_ms(2500);
	CALL SUBOPT_0x9
; 0000 01D1         TempCheckSecond = 0;
; 0000 01D2         SettingCount = 0;
; 0000 01D3         TempSetTarget = TempTarget;
	MOV  R13,R14
; 0000 01D4         EEPROM_Write(TempSetTarget);
	MOV  R26,R13
	RCALL _EEPROM_Write
; 0000 01D5     }
; 0000 01D6     else if(PIND.3 == 0)    //On_Btn
	RJMP _0x88
_0x87:
	SBIC 0x9,3
	RJMP _0x89
; 0000 01D7     {
; 0000 01D8         PORTB.0 = 1;
	SBI  0x5,0
; 0000 01D9         PORTB.1 = 1;
	SBI  0x5,1
; 0000 01DA         PORTB.2 = 1;
	SBI  0x5,2
; 0000 01DB         SettingCount++;
	LDS  R30,_SettingCount
	SUBI R30,-LOW(1)
	STS  _SettingCount,R30
; 0000 01DC         delay_ms(2500);
	CALL SUBOPT_0xA
; 0000 01DD 
; 0000 01DE         if(SettingCount > 15)
	LDS  R26,_SettingCount
	CPI  R26,LOW(0x10)
	BRLO _0x90
; 0000 01DF         {
; 0000 01E0             for(ToggleWarning = 0; ToggleWarning < 10; ToggleWarning++)
	LDI  R30,LOW(0)
	STS  _ToggleWarning,R30
_0x92:
	LDS  R26,_ToggleWarning
	CPI  R26,LOW(0xA)
	BRSH _0x93
; 0000 01E1             {
; 0000 01E2                 Warning_On();
	RCALL _Warning_On
; 0000 01E3                 delay_ms(2500);
	CALL SUBOPT_0xA
; 0000 01E4                 Warning_Off();
	RCALL _Warning_Off
; 0000 01E5                 delay_ms(2500);
	CALL SUBOPT_0xA
; 0000 01E6             }
	LDS  R30,_ToggleWarning
	SUBI R30,-LOW(1)
	STS  _ToggleWarning,R30
	RJMP _0x92
_0x93:
; 0000 01E7             SettingFlag = 1;
	LDI  R30,LOW(1)
	STS  _SettingFlag,R30
; 0000 01E8         }
; 0000 01E9     }
_0x90:
; 0000 01EA }
_0x89:
_0x88:
_0x86:
_0x84:
_0x82:
	RET
; .FEND
;//----------------------------------------------------------------------
;void WindSensor_Update(void)
; 0000 01ED {
_WindSensor_Update:
; .FSTART _WindSensor_Update
; 0000 01EE     if(PINC.1 == 0)    //Wind_Off
	SBIC 0x6,1
	RJMP _0x94
; 0000 01EF     {
; 0000 01F0         Warning_On();
	RCALL _Warning_On
; 0000 01F1         Relay_TurnOn(All);
	LDI  R26,LOW(5)
	RCALL _Relay_TurnOn
; 0000 01F2     }
; 0000 01F3     else
	RJMP _0x95
_0x94:
; 0000 01F4     {
; 0000 01F5         Warning_Off();
	RCALL _Warning_Off
; 0000 01F6     }
_0x95:
; 0000 01F7 }
	RET
; .FEND
;//----------------------------------------------------------------------
;void LimitSensor_Update(void)
; 0000 01FA {
_LimitSensor_Update:
; .FSTART _LimitSensor_Update
; 0000 01FB     if(PINC.2 == 0)    //Limit_Off
	SBIC 0x6,2
	RJMP _0x96
; 0000 01FC     {
; 0000 01FD         Warning_On();
	RCALL _Warning_On
; 0000 01FE         Relay_TurnOff(One);
	LDI  R26,LOW(2)
	RCALL _Relay_TurnOff
; 0000 01FF         Relay_TurnOff(Two);
	LDI  R26,LOW(3)
	RCALL _Relay_TurnOff
; 0000 0200         Relay_TurnOff(Three);
	LDI  R26,LOW(4)
	RCALL _Relay_TurnOff
; 0000 0201         delay_ms(5000);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	CALL _delay_ms
; 0000 0202         Relay_TurnOff(Fan);
	LDI  R26,LOW(1)
	RCALL _Relay_TurnOff
; 0000 0203     }
; 0000 0204     else
	RJMP _0x97
_0x96:
; 0000 0205     {
; 0000 0206         Warning_Off();
	RCALL _Warning_Off
; 0000 0207     }
_0x97:
; 0000 0208 }
	RET
; .FEND
;//----------------------------------------------------------------------
;uint8_t TempSensor_Update(void)
; 0000 020B {
_TempSensor_Update:
; .FSTART _TempSensor_Update
; 0000 020C     RawAdc = read_adc(0);
	CALL SUBOPT_0xB
; 0000 020D     if(RawAdc == 470)
	CP   R30,R7
	CPC  R31,R8
	BRNE _0x98
; 0000 020E         return 25;
	LDI  R30,LOW(25)
	RET
; 0000 020F     else
_0x98:
; 0000 0210     {
; 0000 0211         for(Count = 0; Count < 10; Count++)
	CLR  R10
_0x9B:
	LDI  R30,LOW(10)
	CP   R10,R30
	BRSH _0x9C
; 0000 0212         {
; 0000 0213             RawAdc = read_adc(0);
	CALL SUBOPT_0xB
; 0000 0214             RawAdc -= 470;
	__SUBWRR 7,8,30,31
; 0000 0215             RawAdc = (RawAdc * -1) + 25;
	__GETW1R 7,8
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	ADIW R30,25
	__PUTW1R 7,8
; 0000 0216             TempAvg += RawAdc;
	__ADDWRR 11,12,7,8
; 0000 0217         }
	INC  R10
	RJMP _0x9B
_0x9C:
; 0000 0218         TempAvg = TempAvg / 10;
	__GETW2R 11,12
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	__PUTW1R 11,12
; 0000 0219         return TempAvg;
	RET
; 0000 021A     }
; 0000 021B }
	RET
; .FEND
;//----------------------------------------------------------------------
;void Initial(void)
; 0000 021E {
_Initial:
; .FSTART _Initial
; 0000 021F     PORTB.0 = 1;
	SBI  0x5,0
; 0000 0220     PORTB.1 = 0;
	CBI  0x5,1
; 0000 0221     PORTB.2 = 1;
	SBI  0x5,2
; 0000 0222     spi(SegDot);
	MOV  R26,R4
	CALL _spi
; 0000 0223     PORTC.3 = 1;
	SBI  0x8,3
; 0000 0224     PORTC.3 = 0;
	CBI  0x8,3
; 0000 0225     delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 0226     PORTD.5 = 0;
	CBI  0xB,5
; 0000 0227     PORTD.6 = 0;
	CBI  0xB,6
; 0000 0228     PORTD.7 = 0;
	CBI  0xB,7
; 0000 0229     delay_ms(10000);
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	CALL _delay_ms
; 0000 022A     PORTC.5 = 0;
	CBI  0x8,5
; 0000 022B     SettingFlag = 0;
	LDI  R30,LOW(0)
	STS  _SettingFlag,R30
; 0000 022C     while(PIND.3 == 1);
_0xAF:
	SBIC 0x9,3
	RJMP _0xAF
; 0000 022D }
	RET
; .FEND
;//----------------------------------------------------------------------
;void EEPROM_Write(uint8_t w)
; 0000 0230 {
_EEPROM_Write:
; .FSTART _EEPROM_Write
; 0000 0231     EEPROM_Value = (char)w;
	ST   -Y,R26
;	w -> Y+0
	LD   R30,Y
	LDI  R26,LOW(_EEPROM_Value)
	LDI  R27,HIGH(_EEPROM_Value)
	CALL __EEPROMWRB
; 0000 0232     delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 0233 }
	JMP  _0x2080001
; .FEND
;//----------------------------------------------------------------------
;uint8_t EEPROM_Read(void)
; 0000 0236 {
_EEPROM_Read:
; .FSTART _EEPROM_Read
; 0000 0237     char r = 0;
; 0000 0238     r = EEPROM_Value;
	ST   -Y,R17
;	r -> R17
	LDI  R17,0
	LDI  R26,LOW(_EEPROM_Value)
	LDI  R27,HIGH(_EEPROM_Value)
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 0239     delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 023A     return (uint8_t)r;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 023B }
; .FEND
;//----------------------------------------------------------------------
;void SettingUpdate(void)
; 0000 023E {
_SettingUpdate:
; .FSTART _SettingUpdate
; 0000 023F     while(SettingFlag == 1)
_0xB2:
	LDS  R26,_SettingFlag
	CPI  R26,LOW(0x1)
	BRNE _0xB4
; 0000 0240     {
; 0000 0241         Display(DiffTempTarget);
	LDS  R26,_DiffTempTarget
	CLR  R27
	RCALL _Display
; 0000 0242         if(PIND.4 == 0)    //Off_Btn
	SBIC 0x9,4
	RJMP _0xB5
; 0000 0243         {
; 0000 0244             Initial();
	RCALL _Initial
; 0000 0245         }
; 0000 0246         else if(PIND.0 == 0)    //Up_Btn
	RJMP _0xB6
_0xB5:
	SBIC 0x9,0
	RJMP _0xB7
; 0000 0247         {
; 0000 0248             DiffTempTarget += 1;
	LDS  R30,_DiffTempTarget
	SUBI R30,-LOW(1)
	STS  _DiffTempTarget,R30
; 0000 0249             delay_ms(2500);
	CALL SUBOPT_0xA
; 0000 024A         }
; 0000 024B         else if(PIND.1 == 0)    //Down_Btn
	RJMP _0xB8
_0xB7:
	SBIC 0x9,1
	RJMP _0xB9
; 0000 024C         {
; 0000 024D             DiffTempTarget -= 1;
	LDS  R30,_DiffTempTarget
	SUBI R30,LOW(1)
	STS  _DiffTempTarget,R30
; 0000 024E             delay_ms(2500);
	CALL SUBOPT_0xA
; 0000 024F         }
; 0000 0250         else if(PIND.2 == 0)    //Set_Btn
	RJMP _0xBA
_0xB9:
	SBIC 0x9,2
	RJMP _0xBB
; 0000 0251         {
; 0000 0252             DiffTempSet = DiffTempTarget;
	LDS  R30,_DiffTempTarget
	STS  _DiffTempSet,R30
; 0000 0253             SettingFlag = 0;
	LDI  R30,LOW(0)
	STS  _SettingFlag,R30
; 0000 0254         }
; 0000 0255     }
_0xBB:
_0xBA:
_0xB8:
_0xB6:
	RJMP _0xB2
_0xB4:
; 0000 0256 }
	RET
; .FEND
;//----------------------------------------------------------------------
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_spi:
; .FSTART _spi
	ST   -Y,R26
	LD   R30,Y
	OUT  0x2E,R30
_0x2020003:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x2020003
	IN   R30,0x2E
_0x2080001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_SegNum:
	.BYTE 0xA
_TempCheckSecond:
	.BYTE 0x1
_FanFlag:
	.BYTE 0x1
_TurnOFF_FanSecond:
	.BYTE 0x1

	.ESEG
_EEPROM_Value:
	.BYTE 0x1

	.DSEG
_ToggleWarning:
	.BYTE 0x1
_SettingCount:
	.BYTE 0x1
_SettingFlag:
	.BYTE 0x1
_DiffTempTarget:
	.BYTE 0x1
_DiffTempSet:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	MOV  R26,R13
	CLR  R27
	MOV  R30,R9
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(3)
	CALL _Relay_TurnOff
	LDI  R26,LOW(2)
	JMP  _Relay_TurnOff

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	MOV  R26,R13
	CLR  R27
	MOV  R30,R9
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	LDS  R30,_DiffTempSet
	LDI  R31,0
	ADIW R30,1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(1)
	CALL _Relay_TurnOn
	LDI  R26,LOW(4)
	JMP  _Relay_TurnOn

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	MOV  R26,R13
	CLR  R27
	MOV  R30,R9
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	LDS  R30,_DiffTempSet
	LDI  R31,0
	ADIW R30,2
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7:
	ST   -Y,R3
	LDI  R26,LOW(1)
	CALL _Display_Configuration
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	ST   -Y,R6
	LDI  R26,LOW(2)
	CALL _Display_Configuration
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	CALL _Display_Configuration
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(2500)
	LDI  R27,HIGH(2500)
	CALL _delay_ms
	LDI  R30,LOW(0)
	STS  _TempCheckSecond,R30
	STS  _SettingCount,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(2500)
	LDI  R27,HIGH(2500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(0)
	CALL _read_adc
	__PUTW1R 7,8
	LDI  R30,LOW(470)
	LDI  R31,HIGH(470)
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

;END OF CODE MARKER
__END_OF_CODE:
