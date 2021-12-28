;Sobolev L2
;8) Реализовать цикл мигания 8 лампочек порта D от середины к краям.
;По нажатию кнопки осуществить обратное мигание лампочек. Скорость процесса изменяется по нажатию кнопки:
;Кнопка 1 – быстрее, Кнопка 2 – медленнее. 
#INCLUDE <P16F877A.INC>

__CONFIG(_CP_OFF&_PWRTE_ON&_WDT_OFF&_HS_OSC)

COUNT   	EQU 20h
COUNT1  	EQU 21h
COUNT2  	EQU 22h
ChoiceSpeed EQU 23h


ORG 0

START: 
		BSF STATUS,RP0; Choice first page of memofy
		CLRF TRISD ; Register D is Data OutPut

		BCF TRISB, 6; OUTPUT 3 button - for inverse
		BCF TRISB, 5; OUTPUT 2 button - for SET FAST SPEED
		BCF TRISB, 4; OUTPUT 1 button - for SET SLOW SPEED


		BCF STATUS,RP0 ; Return at zero page
		CLRF PORTD ; Zeroing port D: 0000 0000

		MOVLW 0x5 ;5 - fast by default (15 - slow)
		MOVWF ChoiceSpeed
;====================================
RUN:
		; 6 BIT - INVERSE, 4 - SET FAST SPEED, 5 - SET SLOW SPEED
		BSF PORTB, 6; bit = 1 
		BTFSS PORTB, 6;if 6 bit = 0 then execution Mig
		GOTO MigINV
		
		BSF PORTB, 6; bit = 1 
		BTFSS PORTB, 6;if 6 bit = 1 then execution MigINV
		GOTO Mig

	GOTO RUN
		
;====================================
Mig:
	MOVLW	b'10000001' ;заносим что вывести
	MOVWF  PORTD  ;выводим на 
	CALL DELAY
	BSF PORTB, 6 
	BTFSS PORTB, 6
	GOTO MigINV
	MOVLW	b'01000010' ;заносим что вывести
	MOVWF  PORTD 
	CALL DELAY
	BSF PORTB, 6
	BTFSS PORTB, 6
	GOTO MigINV
	MOVLW	b'00100100' ;заносим что вывести
	MOVWF  PORTD 
	CALL DELAY
	BSF PORTB, 6
	BTFSS PORTB, 6
	GOTO MigINV
	MOVLW	b'00011000' ;заносим что вывести
	MOVWF  PORTD 
	CALL DELAY
	BSF PORTB, 6
	BTFSS PORTB, 6
	GOTO MigINV
GOTO Mig
;====================================
MigINV: 
	MOVLW	b'00011000' ;заносим что вывести
	MOVWF  PORTD 
	CALL DELAY
    BSF PORTB, 6 
	BTFSS PORTB, 6
	GOTO Mig
	MOVLW	b'00100100' ;заносим что вывести
	MOVWF  PORTD 
	CALL DELAY
	BSF PORTB, 6
	BTFSS PORTB, 6
	GOTO Mig
	MOVLW	b'01000010' ;заносим что вывести
	MOVWF  PORTD 
	CALL DELAY
	BSF PORTB, 6
	BTFSS PORTB, 6
	GOTO Mig
	MOVLW	b'10000001' ;заносим что вывести
	MOVWF  PORTD 
	CALL DELAY
	BSF PORTB, 6
	BTFSS PORTB, 6
	GOTO Mig
GOTO MigINV
;====================================
DELAY:  
	BSF PORTB, 4; 
	BTFSS PORTB, 4 ; change to FAST
	CALL FAST
		
    BSF PORTB, 5; 
	BTFSS PORTB, 5 ; change to SLOW
	CALL SLOW
		
	MOVFW ChoiceSpeed
	MOVWF COUNT	

	LOOP:
		CALL DELAY1
		DECFSZ COUNT, F
	GOTO LOOP
RETURN
;====================================
DELAY1: MOVLW 0xFF
		MOVWF COUNT1

	LOOP1:
		CALL DELAY2
		DECFSZ COUNT1, F
	GOTO LOOP1

RETURN
;====================================
DELAY2: MOVLW 0xFF
		MOVWF COUNT2

	LOOP2:
		NOP
		DECFSZ COUNT2, F
	GOTO LOOP2

RETURN
;====================================
FAST:	MOVLW 0x5 ;5 - fast by befault (15 - slow)
		MOVWF ChoiceSpeed
RETURN
;====================================
SLOW:	MOVLW 0xF ;5 - fast by befault (15 - slow)
		MOVWF ChoiceSpeed
RETURN
END