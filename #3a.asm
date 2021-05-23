;Sobolev L2
;3) К порту D подключены 8 светодиодов. Организовать заполнение линейки горящих светодиодов и, затем, их последовательное погасание.
;А именно, при нажатии кнопки должен загораться крайний светодиод ряда.
;При следующем нажатии – дополнительно соседний светодиод и т. д. пока не загорятся все 8 светодиодов.
;При дальнейших нажатиях должны погасать сначала первый, потом второй и т. д. Далее процесс повторяется.
;3.а При долговременном нажатии на кнопку (более 3х секунд) процесс переходит в автоматический режим (пока не будет отпущена кнопка).

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
	BSF 	PORTB, 7	
;====================================
main:
    BSF 	PORTB, 7	
	BTFSC 	PORTB,7		;ожидание нажатия кнопки
	GOTO 	main		;бесконечный переход
	
	MOVLW 	0X1F		
	MOVWF 	COUNT_4		
mainLoop:				
	BTFSC 	PORTB,7		;если кнопку отпустили, тогда переходим в обычный режим
	CALL 	CHOOSE		;вызов процедуры выбора операции
	CALL 	DELAY1		;задержка в 1 секунду
	DECFSZ  COUNT_4		;выход из цикла по истечению счетчика
	GOTO 	mainLoop

	CALL	AUTO		;вызов работы в автоматическом режиме
	GOTO 	main		;возврат на главный поинт
;=====================================
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
	RLF		PORTD,F
	INCF	PORTD,F
	GOTO	main
RETURN
;====================================
TURNOFF					; процедура побитового выключения светодиодов
	BCF 	STATUS, C	;обнуление бита переноса
	RLF		PORTD,F
	GOTO	main
RETURN
;====================================
CHOOSE					;выбор процедуры включения или выключения
	BTFSS	PORTD,7		;выбор определяется состоянием 7 бита порта D
	CALL 	TURNON
	BTFSC 	PORTD,7
	CALL 	TURNOFF
RETURN
;====================================
AUTO
auto_point:
	CALL	CHOOSE_AUTO
	CALL 	DELAY_1	SEC
	BTFSC 	PORTB,7	
	GOTO 	main
	GOTO 	auto_point
RETURN
;====================================
TURNON_AUTO					;процедура побитового включения св. для авто режима
	BCF 	STATUS, C	;обнуление бита переноса
	RLF		PORTD,F
	INCF	PORTD,F

RETURN
;====================================
TURNOFF_AUTO					; процедура побитового выключения светодиодов для авто режима
	BCF 	STATUS, C	;обнуление бита переноса
	RLF		PORTD,F

RETURN
;====================================
CHOOSE_AUTO					;выбор процедуры включения или выключения для авто режима
	BTFSS	PORTD,7		;выбор определяется состоянием 7 бита порта D
	CALL 	TURNON_AUTO
	BTFSC 	PORTD,7
	CALL 	TURNOFF_AUTO
RETURN
;====================================
DELAY_1SEC
	MOVLW 	0X09
	MOVWF 	COUNT_4	
loop4:
	CALL 	DELAY1
	DECFSZ 	COUNT_4
	GOTO loop4
RETURN
END
