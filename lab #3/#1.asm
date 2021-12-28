; Секундомер, 3 кнопки(с кликом) Старт (продолжение), стоп, сброс
#include "P16F877A.INC"
;__CONFIG(_CP_OFF&_PWRTE_ON&_WDT_OFF&_HS_OSC); set config for current programm
__CONFIG(0x3972)
;--------------------------------------------------------------------------
NumberInd1	equ 21h; {0 - 9} right indicator
NumberInd2	equ 23h; {0 - 9} left indicator
CountTimer      equ 25h
tmp			equ 26h
t2	     	equ 27h
t3	     	equ 28h
COUNT_1		equ 029h
COUNT_2		equ 030h
COUNT_3		equ 031h
COUNT		equ 032h
c_beep		equ 033h

;---------------------------------------------------------------------------
ORG 0

GOTO Main
;----------------------------------------------------------------------------| Ineraction ORG 4 |													     
	ORG 4																		 														 
		BCF	INTCON,2
		MOVWF tmp;           
		MOVFW STATUS ;
		MOVWF t2  	;												                                     
		CALL  IntSig;																 																			 
		MOVFW t2 ;		                                                         
		MOVWF STATUS ;
		MOVFW tmp;									  	                 
		RETFIE																		
;--------------------------------------------------------------------------- |ConstArray: SignalConstArray|
SignalConstArray: 	
			
	addwf   PCL,F 
	retlw B'00010000' ;0
	retlw B'01011011' ;1
	retlw B'00001100' ;2
	retlw B'00001001' ;3
	retlw B'01000011' ;4
	retlw B'00100001' ;5
	retlw B'00100000' ;6
	retlw B'00011011' ;7
	retlw B'00000000' ;8
	retlw B'00000001' ;9

;--------------------------------------------------------------------------- |
Main:
	BSF STATUS, RP0; page 1
	movlw	b'00000111'
	movwf	OPTION_REG  
	movlw	b'10100000'
   	movwf	INTCON  	
	CLRF TRISC     ;Port c -out
	clrf TRISB
	
	BCF		STATUS,RP0
	BSF		PORTB,5	;	Button START
	BSF 	PORTB,6 ;	Button STOP
	BSF     PORTB,7	;	Button RESET
	MOVLW 0x00
	MOVWF NumberInd1; initialization
	MOVLW 0x00	
	MOVWF NumberInd2; initialization
	CLRF CountTimer;

Start:	
		BSF	PORTB,5 ; button 5 - START
		BTFSC PORTB,5 
		GOTO Start
		CALL beep
		CALL IntRTM0
		goto Start
		
;--------------------------------------------------------------------------------------| 
beep
	BSF STATUS,RP0
	clrf TRISB
	BCF STATUS,RP0
	MOVLW	.40
	MOVWF	c_beep
	BEEPLOOP:
		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP
		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP

		BSF	PORTB,3
		CALL DELAY_BEEP
		BCF PORTB,3
		CALL DELAY_BEEP
		DECFSZ c_beep,F
		GOTO BEEPLOOP
		RETURN
;--------------------------------------------------------------------------------------| 

STOP_b
CALL beep
stoploop:
	BSF	PORTB,7
	btfss 	PORTB, 7 ;  кнопка "Сброс"
	call 	ResetTimer
	call 	DELAY3
	
	BSF	PORTB,5
	btfsc	PORTB,5 ;кнопка "старт"
	goto 	stoploop
	goto    Start
	RETURN
	
;--------------------------------------------------------------------------------------| 	
DELAY_BEEP   
	MOVLW 	0xCF
	MOVWF 	COUNT_3	
LOOPB: 
	DECFSZ 	COUNT_3
	GOTO 	LOOPB
	RETURN
;---------------------------------------------------------------------------------------------------
IntRTM0: 

	LOOP:
		BSF PORTB,6
		BTFSS	PORTB,6
		call	STOP_b

		CALL DELAY
		CALL TIK
		BSF PORTB,6
		BTFSS	PORTB,6
		call	STOP_b		    	
		GOTO LOOP
		CALL EXIT
	   
	 RETURN

;--------------------------------------------------------------------------------------| 
TIK:
	CLRF CountTimer
	INCF NumberInd2,F
	MOVFW NumberInd2
	SUBLW 0x0a
	BTFSS STATUS, Z
	RETURN
	CLRF NumberInd2
	INCF NumberInd1, F
	MOVFW NumberInd1
	SUBLW 0x0a
	BTFSC STATUS, Z
	CLRF NumberInd1
	RETURN

;--------------------------------------------------------------------------------------|
EXIT
	call beep
	call ResetTimer 
	goto Start
	RETURN
;---------------------------------------------------------------------------------|
ResetTimer   ; сброс таймера
	CALL beep
	 clrf NumberInd1
	 clrf NumberInd2
	 clrf PORTC
	 movlw .0
	 goto Main
	RETURN

;---------------------------------------------------------------------------------|
IntSig:
		btfss t3,0
		call TOind1
		btfsc t3,0
		call TOind2
		movlw .1
		xorwf t3,f
		RETURN
;---------------------------------------------------------------------------------| 
TOind1
	movfw	NumberInd1
	call 	SignalConstArray
	IORLW	B'10000000'
	movwf 	PORTC
	RETURN			
;---------------------------------------------------------------------------------| 
TOind2
	movfw	NumberInd2
	call 	SignalConstArray
	movwf 	PORTC
	RETURN
DELAY	
	MOVLW 	0x1A
	MOVWF	COUNT_1
	
LOOP1: 
	CALL 	DELAY2
	DECFSZ 	COUNT_1
	GOTO 	LOOP1
	RETURN
;=====================================
DELAY2
	MOVLW 	0xF9
	MOVWF 	COUNT_2
	
LOOP2: 
	CALL 	DELAY3
	DECFSZ 	COUNT_2
	GOTO 	LOOP2
	RETURN
;=====================================

DELAY3
	MOVLW 	0xFF
	MOVWF 	COUNT_3	
LOOP3: 
	DECFSZ 	COUNT_3
	GOTO 	LOOP3
	RETURN

END 
