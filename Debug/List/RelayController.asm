
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 0.125000 MHz
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

__GLOBAL_INI_TBL:
	.DW  0x0B
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0A
	.DW  _SegNum
	.DW  _0x3*2

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
;Date    : 2/21/2023
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega328P
;Program type            : Application
;AVR Core Clock frequency: 0.125000 MHz
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
;
;// Declare your global variables here
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
;//----------------------------------------------------------------------
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
;//----------------------------------------------------------------------
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0044 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 0045 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	STS  124,R30
; 0000 0046 // Delay needed for the stabilization of the ADC input voltage
; 0000 0047 delay_us(10);
; 0000 0048 // Start the AD conversion
; 0000 0049 ADCSRA|=(1<<ADSC);
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
; 0000 004A // Wait for the AD conversion to complete
; 0000 004B while ((ADCSRA & (1<<ADIF))==0);
_0x4:
	LDS  R30,122
	ANDI R30,LOW(0x10)
	BREQ _0x4
; 0000 004C ADCSRA|=(1<<ADIF);
	LDS  R30,122
	ORI  R30,0x10
	STS  122,R30
; 0000 004D return ADCW;
	LDS  R30,120
	LDS  R31,120+1
	JMP  _0x2080001
; 0000 004E }
; .FEND
;
;// SPI functions
;#include <spi.h>
;
;// Timer0 Initial function
;void timer0_init()
; 0000 0055 {
_timer0_init:
; .FSTART _timer0_init
; 0000 0056     // set up timer with prescaler = 1024
; 0000 0057     TCCR0B |= (1 << CS02)|(1 << CS00);
	IN   R30,0x25
	ORI  R30,LOW(0x5)
	OUT  0x25,R30
; 0000 0058     // initialize counter
; 0000 0059     TCNT0 = 0;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 005A }
	RET
; .FEND
;
;void main(void)
; 0000 005D {
_main:
; .FSTART _main
; 0000 005E // Declare your local variables here
; 0000 005F 
; 0000 0060 // Crystal Oscillator division factor: 8
; 0000 0061 #pragma optsize-
; 0000 0062 CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0063 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (1<<CLKPS1) | (1<<CLKPS0);
	LDI  R30,LOW(3)
	STS  97,R30
; 0000 0064 #ifdef _OPTIMIZE_SIZE_
; 0000 0065 #pragma optsize+
; 0000 0066 #endif
; 0000 0067 
; 0000 0068 // Input/Output Ports initialization
; 0000 0069 // Port B initialization
; 0000 006A // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 006B DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(47)
	OUT  0x4,R30
; 0000 006C // State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 006D PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 006E 
; 0000 006F // Port C initialization
; 0000 0070 // Function: Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 0071 DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(56)
	OUT  0x7,R30
; 0000 0072 // State: Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 0073 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 0074 
; 0000 0075 // Port D initialization
; 0000 0076 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0077 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(224)
	OUT  0xA,R30
; 0000 0078 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0079 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 007A 
; 0000 007B // Timer/Counter 0 initialization
; 0000 007C // Clock source: System Clock
; 0000 007D // Clock value: 0.488 kHz
; 0000 007E // Mode: Normal top=0xFF
; 0000 007F // OC0A output: Disconnected
; 0000 0080 // OC0B output: Disconnected
; 0000 0081 // Timer Period: 0.52429 s
; 0000 0082 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x24,R30
; 0000 0083 TCCR0B=(0<<WGM02) | (1<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(4)
	OUT  0x25,R30
; 0000 0084 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0085 OCR0A=0x00;
	OUT  0x27,R30
; 0000 0086 OCR0B=0x00;
	OUT  0x28,R30
; 0000 0087 
; 0000 0088 // Timer/Counter 1 initialization
; 0000 0089 // Clock source: System Clock
; 0000 008A // Clock value: Timer1 Stopped
; 0000 008B // Mode: Normal top=0xFFFF
; 0000 008C // OC1A output: Disconnected
; 0000 008D // OC1B output: Disconnected
; 0000 008E // Noise Canceler: Off
; 0000 008F // Input Capture on Falling Edge
; 0000 0090 // Timer1 Overflow Interrupt: Off
; 0000 0091 // Input Capture Interrupt: Off
; 0000 0092 // Compare A Match Interrupt: Off
; 0000 0093 // Compare B Match Interrupt: Off
; 0000 0094 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 0095 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	STS  129,R30
; 0000 0096 TCNT1H=0x00;
	STS  133,R30
; 0000 0097 TCNT1L=0x00;
	STS  132,R30
; 0000 0098 ICR1H=0x00;
	STS  135,R30
; 0000 0099 ICR1L=0x00;
	STS  134,R30
; 0000 009A OCR1AH=0x00;
	STS  137,R30
; 0000 009B OCR1AL=0x00;
	STS  136,R30
; 0000 009C OCR1BH=0x00;
	STS  139,R30
; 0000 009D OCR1BL=0x00;
	STS  138,R30
; 0000 009E 
; 0000 009F // Timer/Counter 2 initialization
; 0000 00A0 // Clock source: System Clock
; 0000 00A1 // Clock value: Timer2 Stopped
; 0000 00A2 // Mode: Normal top=0xFF
; 0000 00A3 // OC2A output: Disconnected
; 0000 00A4 // OC2B output: Disconnected
; 0000 00A5 ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 00A6 TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0000 00A7 TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	STS  177,R30
; 0000 00A8 TCNT2=0x00;
	STS  178,R30
; 0000 00A9 OCR2A=0x00;
	STS  179,R30
; 0000 00AA OCR2B=0x00;
	STS  180,R30
; 0000 00AB 
; 0000 00AC // Timer/Counter 0 Interrupt(s) initialization
; 0000 00AD TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	STS  110,R30
; 0000 00AE 
; 0000 00AF // Timer/Counter 1 Interrupt(s) initialization
; 0000 00B0 TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	STS  111,R30
; 0000 00B1 
; 0000 00B2 // Timer/Counter 2 Interrupt(s) initialization
; 0000 00B3 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	STS  112,R30
; 0000 00B4 
; 0000 00B5 // External Interrupt(s) initialization
; 0000 00B6 // INT0: Off
; 0000 00B7 // INT1: Off
; 0000 00B8 // Interrupt on any change on pins PCINT0-7: Off
; 0000 00B9 // Interrupt on any change on pins PCINT8-14: Off
; 0000 00BA // Interrupt on any change on pins PCINT16-23: Off
; 0000 00BB EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 00BC EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 00BD PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 00BE 
; 0000 00BF // USART initialization
; 0000 00C0 // USART disabled
; 0000 00C1 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 00C2 
; 0000 00C3 // Analog Comparator initialization
; 0000 00C4 // Analog Comparator: Off
; 0000 00C5 // The Analog Comparator's positive input is
; 0000 00C6 // connected to the AIN0 pin
; 0000 00C7 // The Analog Comparator's negative input is
; 0000 00C8 // connected to the AIN1 pin
; 0000 00C9 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 00CA ADCSRB=(0<<ACME);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 00CB // Digital input buffer on AIN0: On
; 0000 00CC // Digital input buffer on AIN1: On
; 0000 00CD DIDR1=(0<<AIN0D) | (0<<AIN1D);
	STS  127,R30
; 0000 00CE 
; 0000 00CF // ADC initialization
; 0000 00D0 // ADC Clock frequency: 0.977 kHz
; 0000 00D1 // ADC Voltage Reference: AREF pin
; 0000 00D2 // ADC Auto Trigger Source: ADC Stopped
; 0000 00D3 // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 00D4 // ADC4: On, ADC5: On
; 0000 00D5 DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
	STS  126,R30
; 0000 00D6 ADMUX=ADC_VREF_TYPE;
	STS  124,R30
; 0000 00D7 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(135)
	STS  122,R30
; 0000 00D8 ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 00D9 
; 0000 00DA // SPI initialization
; 0000 00DB // SPI Type: Master
; 0000 00DC // SPI Clock Rate: 31.250 kHz
; 0000 00DD // SPI Clock Phase: Cycle Start
; 0000 00DE // SPI Clock Polarity: Low
; 0000 00DF // SPI Data Order: MSB First
; 0000 00E0 SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	LDI  R30,LOW(80)
	OUT  0x2C,R30
; 0000 00E1 SPSR=(0<<SPI2X);
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00E2 
; 0000 00E3 // TWI initialization
; 0000 00E4 // TWI disabled
; 0000 00E5 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  188,R30
; 0000 00E6 
; 0000 00E7 //----------------------------------------------------------------------
; 0000 00E8 Initial();
	RCALL _Initial
; 0000 00E9 TempInit = TempSensor_Update();
	RCALL _TempSensor_Update
	MOV  R9,R30
; 0000 00EA TempTarget = TempInit;
	MOV  R14,R9
; 0000 00EB TempSetTarget = TempInit;
	MOV  R13,R9
; 0000 00EC timer0_init();
	RCALL _timer0_init
; 0000 00ED //----------------------------------------------------------------------
; 0000 00EE while (1)
_0x7:
; 0000 00EF       {
; 0000 00F0         WindSensor_Update();
	RCALL _WindSensor_Update
; 0000 00F1         LimitSensor_Update();
	RCALL _LimitSensor_Update
; 0000 00F2 
; 0000 00F3         Keys_Update();
	RCALL _Keys_Update
; 0000 00F4         Display(TempTarget);
	MOV  R26,R14
	CLR  R27
	RCALL _Display
; 0000 00F5         if (TCNT0 >= 250)
	IN   R30,0x26
	CPI  R30,LOW(0xFA)
	BRLO _0xA
; 0000 00F6         {
; 0000 00F7             TempInit = TempSensor_Update();
	RCALL _TempSensor_Update
	MOV  R9,R30
; 0000 00F8             TCNT0 = 0;            // reset counter
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00F9         }
; 0000 00FA         if((TempSetTarget - TempInit) > 0 && (TempSetTarget - TempInit) < 4)
_0xA:
	CALL SUBOPT_0x0
	CALL __CPW02
	BRGE _0xC
	CALL SUBOPT_0x0
	SBIW R26,4
	BRLT _0xD
_0xC:
	RJMP _0xB
_0xD:
; 0000 00FB         {
; 0000 00FC             PORTD.7 = 1;
	SBI  0xB,7
; 0000 00FD             PORTD.6 = 0;
	RJMP _0xB8
; 0000 00FE             PORTD.5 = 0;
; 0000 00FF         }
; 0000 0100         else if((TempSetTarget - TempInit) >= 5 && (TempSetTarget - TempInit) < 11)
_0xB:
	CALL SUBOPT_0x0
	SBIW R26,5
	BRLT _0x16
	CALL SUBOPT_0x0
	SBIW R26,11
	BRLT _0x17
_0x16:
	RJMP _0x15
_0x17:
; 0000 0101         {
; 0000 0102             PORTD.7 = 1;
	SBI  0xB,7
; 0000 0103             PORTD.6 = 1;
	SBI  0xB,6
; 0000 0104             PORTD.5 = 0;
	RJMP _0xB9
; 0000 0105         }
; 0000 0106         else if((TempSetTarget - TempInit) >= 11)
_0x15:
	CALL SUBOPT_0x0
	SBIW R26,11
	BRLT _0x1F
; 0000 0107         {
; 0000 0108             PORTD.7 = 1;
	SBI  0xB,7
; 0000 0109             PORTD.6 = 1;
	SBI  0xB,6
; 0000 010A             PORTD.5 = 1;
	SBI  0xB,5
; 0000 010B         }
; 0000 010C         else
	RJMP _0x26
_0x1F:
; 0000 010D         {
; 0000 010E             PORTD.7 = 0;
	CBI  0xB,7
; 0000 010F             PORTD.6 = 0;
_0xB8:
	CBI  0xB,6
; 0000 0110             PORTD.5 = 0;
_0xB9:
	CBI  0xB,5
; 0000 0111         }
_0x26:
; 0000 0112       }
	RJMP _0x7
; 0000 0113 }
_0x2D:
	RJMP _0x2D
; .FEND
;//----------------------------------------------------------------------
;void Relay_TurnOn(uint8_t Number)
; 0000 0116 {
_Relay_TurnOn:
; .FSTART _Relay_TurnOn
; 0000 0117     switch(Number)
	CALL SUBOPT_0x1
;	Number -> Y+0
; 0000 0118     {
; 0000 0119         case Fan:
	BRNE _0x31
; 0000 011A             PORTC.5 = 1;
	SBI  0x8,5
; 0000 011B         break;
	RJMP _0x30
; 0000 011C         case One:
_0x31:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x34
; 0000 011D             PORTD.5 = 1;
	SBI  0xB,5
; 0000 011E         break;
	RJMP _0x30
; 0000 011F         case Two:
_0x34:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x37
; 0000 0120             PORTD.6 = 1;
	SBI  0xB,6
; 0000 0121         break;
	RJMP _0x30
; 0000 0122         case Three:
_0x37:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ _0xBA
; 0000 0123             PORTD.7 = 1;
; 0000 0124         break;
; 0000 0125         case All:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x30
; 0000 0126             PORTC.5 = 1;
	SBI  0x8,5
; 0000 0127             PORTD.5 = 1;
	SBI  0xB,5
; 0000 0128             PORTD.6 = 1;
	SBI  0xB,6
; 0000 0129             PORTD.7 = 1;
_0xBA:
	SBI  0xB,7
; 0000 012A         break;
; 0000 012B     }
_0x30:
; 0000 012C }
	JMP  _0x2080001
; .FEND
;//----------------------------------------------------------------------
;void Relay_TurnOff(uint8_t Number)
; 0000 012F {
_Relay_TurnOff:
; .FSTART _Relay_TurnOff
; 0000 0130     switch(Number)
	CALL SUBOPT_0x1
;	Number -> Y+0
; 0000 0131     {
; 0000 0132         case Fan:
	BRNE _0x49
; 0000 0133             PORTC.5 = 0;
	CBI  0x8,5
; 0000 0134         break;
	RJMP _0x48
; 0000 0135         case One:
_0x49:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x4C
; 0000 0136             PORTD.5 = 0;
	CBI  0xB,5
; 0000 0137         break;
	RJMP _0x48
; 0000 0138         case Two:
_0x4C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4F
; 0000 0139             PORTD.6 = 0;
	CBI  0xB,6
; 0000 013A         break;
	RJMP _0x48
; 0000 013B         case Three:
_0x4F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ _0xBB
; 0000 013C             PORTD.7 = 0;
; 0000 013D         break;
; 0000 013E         case All:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x48
; 0000 013F             PORTC.5 = 0;
	CBI  0x8,5
; 0000 0140             PORTD.5 = 0;
	CBI  0xB,5
; 0000 0141             PORTD.6 = 0;
	CBI  0xB,6
; 0000 0142             PORTD.7 = 0;
_0xBB:
	CBI  0xB,7
; 0000 0143         break;
; 0000 0144     }
_0x48:
; 0000 0145 }
	JMP  _0x2080001
; .FEND
;//----------------------------------------------------------------------
;void Warning_On(void)
; 0000 0148 {
_Warning_On:
; .FSTART _Warning_On
; 0000 0149     PORTC.4 = 1;
	SBI  0x8,4
; 0000 014A }
	RET
; .FEND
;//----------------------------------------------------------------------
;void Warning_Off(void)
; 0000 014D {
_Warning_Off:
; .FSTART _Warning_Off
; 0000 014E     PORTC.4 = 0;
	CBI  0x8,4
; 0000 014F }
	RET
; .FEND
;//----------------------------------------------------------------------
;void Display(uint16_t Number)
; 0000 0152 {
_Display:
; .FSTART _Display
; 0000 0153     Segment1 = (Number / 100) % 10;
	ST   -Y,R27
	ST   -Y,R26
;	Number -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x2
	MOV  R3,R30
; 0000 0154     Segment2 = (Number / 10) % 10;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x2
	MOV  R6,R30
; 0000 0155     Segment3 = (Number / 1) % 10;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	MOV  R5,R30
; 0000 0156     if(Number == 100)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRNE _0x62
; 0000 0157     {
; 0000 0158         Display_Configuration(Segment1, 1);
	CALL SUBOPT_0x3
; 0000 0159         delay_ms(5);
; 0000 015A         Display_Configuration(Segment2, 2);
; 0000 015B         delay_ms(5);
; 0000 015C         Display_Configuration(Segment3, 3);
	RJMP _0xBC
; 0000 015D         delay_ms(5);
; 0000 015E     }
; 0000 015F     else if(Number > 100 && Number < 999)
_0x62:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRLO _0x65
	CPI  R26,LOW(0x3E7)
	LDI  R30,HIGH(0x3E7)
	CPC  R27,R30
	BRLO _0x66
_0x65:
	RJMP _0x64
_0x66:
; 0000 0160     {
; 0000 0161         Display_Configuration(Segment1, 1);
	CALL SUBOPT_0x3
; 0000 0162         delay_ms(5);
; 0000 0163         Display_Configuration(Segment2, 2);
; 0000 0164         delay_ms(5);
; 0000 0165         Display_Configuration(Segment3, 3);
	RJMP _0xBC
; 0000 0166         delay_ms(5);
; 0000 0167     }
; 0000 0168     else if(Number >= 10 && Number < 100)
_0x64:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,10
	BRLO _0x69
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLO _0x6A
_0x69:
	RJMP _0x68
_0x6A:
; 0000 0169     {
; 0000 016A         Display_Configuration(Segment2, 2);
	ST   -Y,R6
	LDI  R26,LOW(2)
	CALL SUBOPT_0x4
; 0000 016B         delay_ms(5);
; 0000 016C         Display_Configuration(Segment3, 3);
	RJMP _0xBC
; 0000 016D         delay_ms(5);
; 0000 016E     }
; 0000 016F     else if(Number < 10)
_0x68:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,10
	BRSH _0x6C
; 0000 0170     {
; 0000 0171         Display_Configuration(Segment3, 3);
_0xBC:
	ST   -Y,R5
	LDI  R26,LOW(3)
	CALL SUBOPT_0x4
; 0000 0172         delay_ms(5);
; 0000 0173     }
; 0000 0174 }
_0x6C:
	RJMP _0x2080002
; .FEND
;//----------------------------------------------------------------------
;void Display_Configuration(uint8_t Number, uint8_t Place)
; 0000 0177 {
_Display_Configuration:
; .FSTART _Display_Configuration
; 0000 0178     switch(Place)
	CALL SUBOPT_0x1
;	Number -> Y+1
;	Place -> Y+0
; 0000 0179     {
; 0000 017A         case 1:
	BRNE _0x70
; 0000 017B             PORTB.0 = 0;
	CBI  0x5,0
; 0000 017C             PORTB.1 = 1;
	SBI  0x5,1
; 0000 017D             PORTB.2 = 1;
	SBI  0x5,2
; 0000 017E             spi(SegNum[Number]);
	RJMP _0xBD
; 0000 017F             PORTC.3 = 1;
; 0000 0180             PORTC.3 = 0;
; 0000 0181         break;
; 0000 0182         case 2:
_0x70:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x7B
; 0000 0183             PORTB.0 = 1;
	SBI  0x5,0
; 0000 0184             PORTB.1 = 0;
	CBI  0x5,1
; 0000 0185             PORTB.2 = 1;
	SBI  0x5,2
; 0000 0186             spi(SegNum[Number]);
	RJMP _0xBD
; 0000 0187             PORTC.3 = 1;
; 0000 0188             PORTC.3 = 0;
; 0000 0189         break;
; 0000 018A         case 3:
_0x7B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6F
; 0000 018B             PORTB.0 = 1;
	SBI  0x5,0
; 0000 018C             PORTB.1 = 1;
	SBI  0x5,1
; 0000 018D             PORTB.2 = 0;
	CBI  0x5,2
; 0000 018E             spi(SegNum[Number]);
_0xBD:
	LDD  R30,Y+1
	LDI  R31,0
	SUBI R30,LOW(-_SegNum)
	SBCI R31,HIGH(-_SegNum)
	LD   R26,Z
	CALL _spi
; 0000 018F             PORTC.3 = 1;
	SBI  0x8,3
; 0000 0190             PORTC.3 = 0;
	CBI  0x8,3
; 0000 0191         break;
; 0000 0192     }
_0x6F:
; 0000 0193 }
_0x2080002:
	ADIW R28,2
	RET
; .FEND
;//----------------------------------------------------------------------
;void Keys_Update(void)
; 0000 0196 {
_Keys_Update:
; .FSTART _Keys_Update
; 0000 0197     if(PIND.4 == 0)    //Off_Btn
	SBIC 0x9,4
	RJMP _0x91
; 0000 0198         Initial();
	RCALL _Initial
; 0000 0199     else if(PIND.0 == 0)    //Up_Btn
	RJMP _0x92
_0x91:
	SBIC 0x9,0
	RJMP _0x93
; 0000 019A     {
; 0000 019B         TempTarget += 2;
	INC  R14
	INC  R14
; 0000 019C         delay_ms(1500);
	CALL SUBOPT_0x5
; 0000 019D     }
; 0000 019E     else if(PIND.1 == 0)    //Down_Btn
	RJMP _0x94
_0x93:
	SBIC 0x9,1
	RJMP _0x95
; 0000 019F     {
; 0000 01A0         TempTarget -= 2;
	DEC  R14
	DEC  R14
; 0000 01A1         delay_ms(1500);
	CALL SUBOPT_0x5
; 0000 01A2     }
; 0000 01A3     else if(PIND.2 == 0)    //Set_Btn
	RJMP _0x96
_0x95:
	SBIC 0x9,2
	RJMP _0x97
; 0000 01A4     {
; 0000 01A5         delay_ms(1500);
	CALL SUBOPT_0x5
; 0000 01A6         TempSetTarget = TempTarget;
	MOV  R13,R14
; 0000 01A7     }
; 0000 01A8 }
_0x97:
_0x96:
_0x94:
_0x92:
	RET
; .FEND
;//----------------------------------------------------------------------
;void WindSensor_Update(void)
; 0000 01AB {
_WindSensor_Update:
; .FSTART _WindSensor_Update
; 0000 01AC     if(PINC.1 == 0)    //Wind_Off
	SBIC 0x6,1
	RJMP _0x98
; 0000 01AD     {
; 0000 01AE         Warning_On();
	RCALL _Warning_On
; 0000 01AF         Relay_TurnOn(All);
	LDI  R26,LOW(5)
	RCALL _Relay_TurnOn
; 0000 01B0     }
; 0000 01B1     else
	RJMP _0x99
_0x98:
; 0000 01B2     {
; 0000 01B3         Warning_Off();
	RCALL _Warning_Off
; 0000 01B4     }
_0x99:
; 0000 01B5 }
	RET
; .FEND
;//----------------------------------------------------------------------
;void LimitSensor_Update(void)
; 0000 01B8 {
_LimitSensor_Update:
; .FSTART _LimitSensor_Update
; 0000 01B9     if(PINC.2 == 0)    //Limit_Off
	SBIC 0x6,2
	RJMP _0x9A
; 0000 01BA     {
; 0000 01BB         Warning_On();
	RCALL _Warning_On
; 0000 01BC         Relay_TurnOff(One);
	LDI  R26,LOW(2)
	RCALL _Relay_TurnOff
; 0000 01BD         Relay_TurnOff(Two);
	LDI  R26,LOW(3)
	RCALL _Relay_TurnOff
; 0000 01BE         Relay_TurnOff(Three);
	LDI  R26,LOW(4)
	RCALL _Relay_TurnOff
; 0000 01BF         delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 01C0         Relay_TurnOff(Fan);
	LDI  R26,LOW(1)
	RCALL _Relay_TurnOff
; 0000 01C1     }
; 0000 01C2     else
	RJMP _0x9B
_0x9A:
; 0000 01C3     {
; 0000 01C4         Warning_Off();
	RCALL _Warning_Off
; 0000 01C5     }
_0x9B:
; 0000 01C6 }
	RET
; .FEND
;//----------------------------------------------------------------------
;uint8_t TempSensor_Update(void)
; 0000 01C9 {
_TempSensor_Update:
; .FSTART _TempSensor_Update
; 0000 01CA     RawAdc = read_adc(0);
	CALL SUBOPT_0x6
; 0000 01CB     if(RawAdc == 470)
	CP   R30,R7
	CPC  R31,R8
	BRNE _0x9C
; 0000 01CC         return 25;
	LDI  R30,LOW(25)
	RET
; 0000 01CD     else
_0x9C:
; 0000 01CE     {
; 0000 01CF         for(Count = 0; Count < 10; Count++)
	CLR  R10
_0x9F:
	LDI  R30,LOW(10)
	CP   R10,R30
	BRSH _0xA0
; 0000 01D0         {
; 0000 01D1             RawAdc = read_adc(0);
	CALL SUBOPT_0x6
; 0000 01D2             RawAdc -= 470;
	__SUBWRR 7,8,30,31
; 0000 01D3             RawAdc = (RawAdc * -1) + 25;
	__GETW1R 7,8
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	ADIW R30,25
	__PUTW1R 7,8
; 0000 01D4             TempAvg += RawAdc;
	__ADDWRR 11,12,7,8
; 0000 01D5         }
	INC  R10
	RJMP _0x9F
_0xA0:
; 0000 01D6         TempAvg = TempAvg / 10;
	__GETW2R 11,12
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	__PUTW1R 11,12
; 0000 01D7         return TempAvg;
	RET
; 0000 01D8     }
; 0000 01D9 }
	RET
; .FEND
;//----------------------------------------------------------------------
;void Initial(void)
; 0000 01DC {
_Initial:
; .FSTART _Initial
; 0000 01DD     PORTB.0 = 1;
	SBI  0x5,0
; 0000 01DE     PORTB.1 = 0;
	CBI  0x5,1
; 0000 01DF     PORTB.2 = 1;
	SBI  0x5,2
; 0000 01E0     spi(SegDot);
	MOV  R26,R4
	CALL _spi
; 0000 01E1     PORTC.3 = 1;
	SBI  0x8,3
; 0000 01E2     PORTC.3 = 0;
	CBI  0x8,3
; 0000 01E3     delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 01E4     PORTC.5 = 0;
	CBI  0x8,5
; 0000 01E5     PORTD.5 = 0;
	CBI  0xB,5
; 0000 01E6     PORTD.6 = 0;
	CBI  0xB,6
; 0000 01E7     PORTD.7 = 0;
	CBI  0xB,7
; 0000 01E8     while(PIND.3 == 1);
_0xB3:
	SBIC 0x9,3
	RJMP _0xB3
; 0000 01E9     PORTC.5 = 1;
	SBI  0x8,5
; 0000 01EA     delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 01EB }
	RET
; .FEND
;//----------------------------------------------------------------------
;
;
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

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x0:
	MOV  R26,R13
	CLR  R27
	MOV  R30,R9
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3:
	ST   -Y,R3
	LDI  R26,LOW(1)
	CALL _Display_Configuration
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
	ST   -Y,R6
	LDI  R26,LOW(2)
	CALL _Display_Configuration
	LDI  R26,LOW(5)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CALL _Display_Configuration
	LDI  R26,LOW(5)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
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
	__DELAY_USB 0x2A
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

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

;END OF CODE MARKER
__END_OF_CODE:
