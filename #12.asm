;Sobolev L2
;12) К порту D подключены 8 светодиодов. Организовать «бегущий огонь».
;Кнопка должна менять шаг, с которым бежит огонек.
;То есть при однократном нажатии огонек прыгает через один светодиод,
;при повторном нажатии – через два светодиода и т. д.
;Припрыжке через 7 светодиодов огонек будет стоять на месте, а через 8
;светодиодов – бежать с шагом 1 и т. д.

#INCLUDE <P16F877A.INC>

__CONFIG(_CP_OFF&_PWRTE_ON&_WDT_OFF&_HS_OSC)

COUNT   	EQU 20h
COUNT1  	EQU 21h
COUNT2  	EQU 22h
COUNT3  	EQU 22h
VALUE		EQU 23h
STEP		EQU 24h
SPEED 		EQU 25h
reg_speed equ 0x26
d1 equ 0x27
d2 equ 0x28
d3 equ 0x29

ORG 0
START:
		CLRF PORTB
		CLRF PORTD
		CLRF VALUE 
		BSF STATUS, RP0 ;Переход на 1 страницу
		
		CLRF TRISD ;Выходы порта на вывод
		BCF TRISB, 7;
		
		BCF STATUS,RP0 ;Возвращаемся на страницу 0
		MOVLW 0x8 ;midle winking by default
		MOVWF reg_speed
;====================================
RUN:
		;шаг 1
		
		CALL MIG
		
		BSF PORTB, 7; если нажали на кнопку то шаг 2
		BTFSS PORTB, 7;
		GOTO STEP2
		
		GOTO RUN
;====================================
STEP2:
		
		MOVLW	b'00000001' ;заносим что вывести
		MOVWF  PORTD
		CALL DELAY
		
		BSF PORTB, 7; если нажали на кнопку то шаг 3
		BTFSS PORTB, 7;
		GOTO STEP3
		
		MOVLW	b'00000100' ;заносим что вывести
		MOVWF  PORTD
		CALL DELAY
		
		BSF PORTB, 7; если нажали на кнопку то шаг 3
		BTFSS PORTB, 7;
		GOTO STEP3
		
		MOVLW	b'00010000' ;заносим что вывести
		MOVWF  PORTD
		CALL DELAY
		
		BSF PORTB, 7; если нажали на кнопку то шаг 3
		BTFSS PORTB, 7;
		GOTO STEP3
		
		MOVLW	b'01000000' ;заносим что вывести
		MOVWF  PORTD
		CALL DELAY
		
		GOTO STEP2
;====================================
STEP3:
		
		MOVLW	b'00000001' ;заносим что вывести
		MOVWF  PORTD
		CALL DELAY
		
		BSF PORTB, 7; если нажали на кнопку то шаг 4
		BTFSS PORTB, 7;
		GOTO STEP4
		
		BSF PORTB, 7; если нажали на кнопку то шаг 4
		BTFSS PORTB, 7;
		GOTO STEP4
		
		MOVLW	b'00001000' ;заносим что вывести
		MOVWF  PORTD
		CALL DELAY
		
		BSF PORTB, 7; если нажали на кнопку то шаг 4
		BTFSS PORTB, 7;
		GOTO STEP4
		
		MOVLW	b'01000000' ;заносим что вывести
		MOVWF  PORTD
		CALL DELAY
		
		GOTO STEP3
;====================================
STEP4:
	
		
		MOVLW	b'00000001' ;заносим что вывести
		MOVWF  PORTD
		CALL DELAY
		
		BSF PORTB, 7; если нажали на кнопку то шаг 5
		BTFSS PORTB, 7;
		GOTO STEP5
		
		MOVLW	b'00010000' ;заносим что вывести
		MOVWF  PORTD
		CALL DELAY
		
		GOTO STEP4
;====================================
STEP5:
		
		MOVLW	b'00000001' ;заносим что вывести
		MOVWF  PORTD
		CALL DELAY
		
		BSF PORTB, 7; если нажали на кнопку то шаг 6
		BTFSS PORTB, 7;
		GOTO STEP6
		
		MOVLW	b'00100000' ;заносим что вывести
		MOVWF  PORTD
		CALL DELAY
		
		GOTO STEP5
;====================================
STEP6:
		
		MOVLW	b'00000001' ;заносим что вывести
		MOVWF  PORTD
		CALL DELAY
		
		BSF PORTB, 7; если нажали на кнопку то шаг 7
		BTFSS PORTB, 7;
		GOTO STEP7
		
		MOVLW	b'01000000' ;заносим что вывести
		MOVWF  PORTD
		CALL DELAY
		
		GOTO STEP6
;====================================
STEP7:
		
		MOVLW	b'00000001' ;заносим что вывести
		MOVWF  PORTD
		CALL DELAY
		
		BSF PORTB, 7; если нажали на кнопку то шаг 8
		BTFSS PORTB, 7;
		GOTO STEP8
		
		MOVLW	b'10000000' ;заносим что вывести
		MOVWF  PORTD
		CALL DELAY
		
		GOTO STEP7
;====================================
STEP8:
		CALL DELAY
		
		BSF PORTB, 7; если нажали на кнопку то шаг 9
		BTFSS PORTB, 7;
		GOTO RUN
		
		MOVLW	b'00000001' ;заносим что вывести
		MOVWF  PORTD
		
		GOTO STEP8
;====================================
MIG:
BCF STATUS, C ; clear the carry bit
RLF PORTD,F ; bit on the left
CLRW
ADDWF PORTD,F
BTFSC STATUS,Z
INCF PORTD, F
CALL DELAY
RETURN
;====================================
; Процедура организации задержки
DELAY:
MOVFW reg_speed
MOVWF d1
LOOP:
CALL DELAY1
DECFSZ d1,F
GOTO LOOP
RETURN
DELAY1:
CLRF d2
LOOP1:
CALL DELAY2
DECFSZ d2,F
GOTO LOOP1
RETURN
DELAY2:
CLRF d3
LOOP2:
DECFSZ d3,F
GOTO LOOP2
RETURN
END