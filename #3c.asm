;Sobolev L2
;3) К порту D подключены 8 светодиодов. Организовать заполнение линейки горящих светодиодов и, затем, их последовательное погасание.
;А именно, при нажатии кнопки должен загораться крайний светодиод ряда.
;При следующем нажатии – дополнительно соседний светодиод и т. д. пока не загорятся все 8 светодиодов.
;При дальнейших нажатиях должны погасать сначала первый, потом второй и т. д. Далее процесс повторяется.
;3.с При нажатии на другую кнопку процесс заполнение происходит автоматически одновременно с двух сторон регистра (от краев к центру).

#include "P16F877A.INC"

__CONFIG(_CP_OFF&_PWRTE_ON&_WDT_OFF&_HS_OSC); 

	COUNT_1 EQU		20H
	COUNT_2 EQU		21H
	COUNT_3 EQU		22H	
	COUNT_4 EQU		23H

	ORG 0

START:	
	BSF 	STATUS, RP0	; go to page 1
	ClRF 	TRISB		;prepare TRISB for output
	CLRF 	TRISD		; prepare TRISD for output

	BCF 	STATUS, RP0	;go to page 0 
	CLRF	PORTD		;clear portd
	BSF 	PORTB, 7	; btn will be on 7b of portb
	BSF 	PORTB, 6	; btn will be on 6b of portb
;====================================	
main:
	BTFSS	PORTB, 6 ;ожидание нажатия кнопки 
	GOTO	AUTO
	CALL 	DELAY1		;задержка
	CALL 	DELAY1		;задержка 
	BTFSS	PORTB,7		;ожидание нажатия кнопки 7
	CALL 	CHOOSE		;вызов процедуры выбора операции	
	GOTO 	main		;возврат на главный поинт
;====================================	
AUTO:
	MOVLW	b'10000001' ;заносим что вывести
	MOVWF  PORTD 
	CALL 	DELAY1		;задержка 
	CALL 	DELAY1		;задержка 
	CALL 	DELAY1	
	MOVLW	b'11000011' ;заносим что вывести
	MOVWF  PORTD 
	CALL 	DELAY1	
	CALL 	DELAY1		
	CALL 	DELAY1	
	MOVLW	b'11100111' ;заносим что вывести
	MOVWF  PORTD 
	CALL 	DELAY1		
	CALL 	DELAY1	
	MOVLW	b'11111111' ;заносим что вывести
	MOVWF  PORTD 
	CALL 	DELAY1		
	CALL 	DELAY1	
	CALL 	DELAY1	
	CLRF	PORTD		;отчистили порт D
	CALL 	DELAY1	
        CALL 	DELAY1		
	CALL 	DELAY1		
	BTFSC	PORTB, 6
	GOTO main
	GOTO  AUTO
;====================================		 
DELAY1
	MOVLW 	0x03
	MOVWF	COUNT_1
	
LOOP1: 
	CALL 	DELAY2
	DECFSZ 	COUNT_1
	GOTO 	LOOP1
	RETURN
;=====================================
DELAY2
	MOVLW 	0xFF
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
;====================================
TURNON					;процедура побитового включения св.
	BCF 	STATUS, C	;обнуление бита переноса
	RLF		PORTD,F ;перенос
	INCF	PORTD,F ;+1 к тому что выводит
	GOTO	main
RETURN
;====================================
TURNOFF					; процедура побитового выключения светодиодов
	BCF 	STATUS, C	;обнуление бита переноса
	RLF		PORTD,F ;перенос
	GOTO	main
RETURN
;====================================
CHOOSE					;выбор процедуры включения или выключения
	BTFSS	PORTD,7		;выбор определяется состоянием 7 бита порта D
	CALL 	TURNON
	BTFSC 	PORTD,7
	CALL 	TURNOFF
RETURN
END
