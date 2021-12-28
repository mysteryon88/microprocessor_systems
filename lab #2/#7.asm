;Sobolev L2
;7) Запрограммировать работу светофора, как он работает в реальной жизни. 
;Должна быть кнопка, которая контролирует дневной или ночной режим работы светофора.
;В качестве лампочек светофора используйте три младших раряда порта D.

#include "P16F877A.INC"

__CONFIG(_CP_OFF&_PWRTE_ON&_WDT_OFF&_HS_OSC); 


COUNT   EQU 20h
COUNT1  EQU 21h
COUNT2  EQU 22h

		ORG 0

START:    
		BSF STATUS,RP0; Choice first page of memofy
		CLRF TRISD ; Register D is Data OutPut

		BCF TRISB, 7; для кнопки

		BCF STATUS,RP0 
		CLRF PORTD 
;====================================		
RUN:
		CLRF PORTD 
		
		BSF PORTD, 0 ; зеленый
		CALL DELAY
		CALL DELAY
		
		BSF PORTB, 7; если нажали на кнопку то ночной
		BTFSS PORTB, 7;
		GOTO NIGHT
		
		CALL DELAY
		CALL DELAY
		BCF PORTD, 0 ; погалисили зеленый
		
		BSF PORTB, 7; если нажали на кнопку то ночной
		BTFSS PORTB, 7;
		GOTO NIGHT
		
		BSF PORTD, 1 ; желтый
		CALL DELAY
		CALL DELAY
		BCF PORTD, 1 ; погалисили желтый
		
		BSF PORTB, 7; если нажали на кнопку то ночной
		BTFSS PORTB, 7;
		GOTO NIGHT
		
		BSF PORTD, 2 ; красный
		CALL DELAY
		CALL DELAY
		
		BSF PORTB, 7; если нажали на кнопку то ночной
		BTFSS PORTB, 7;
		GOTO NIGHT
		
		CALL DELAY
		CALL DELAY
		BCF PORTD, 2 ; погалисили крвсный
		
		BSF PORTB, 7; если нажали на кнопку то ночной
		BTFSS PORTB, 7;
		GOTO NIGHT
		
		BSF PORTD, 1 ; желтый
		CALL DELAY
		CALL DELAY
		BCF PORTD, 1 ; погалисили желтый
		
		BSF PORTB, 7; если нажали на кнопку то ночной
		BTFSS PORTB, 7;
		GOTO NIGHT
		
		GOTO RUN
;====================================
NIGHT:
	    CLRF PORTD 
		BSF PORTD, 1 ; желтый
		CALL DELAY
		BSF PORTB, 7
		BTFSS PORTB, 7;
		GOTO RUN
		BCF PORTD, 1 ; погалисили желтый
		CALL DELAY
		BSF PORTB, 7
		BTFSS PORTB, 7;
		GOTO RUN
	  
GOTO NIGHT	
;====================================
DELAY:
	MOVLW 0x5     
	MOVWF COUNT

	LOOP:	
		CALL DELAY1
		DECFSZ COUNT, F
	GOTO LOOP

RETURN
;====================================
DELAY1:
	MOVLW 0xFF
	MOVWF COUNT1

	LOOP1:
		CALL DELAY2
		DECFSZ COUNT1, F
	GOTO LOOP1

RETURN
;====================================
DELAY2:
	MOVLW 0xFF
	MOVWF COUNT2

	LOOP2:
		NOP
		DECFSZ COUNT2, F
	GOTO LOOP2
RETURN
END