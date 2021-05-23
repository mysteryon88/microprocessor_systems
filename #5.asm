;Sobolev L2
;5) К порту D подключена линейка светодиодов (8 шт.)
;К порту B подключена кнопка. При нажатой кнопке по светодиодам порта Д 
;циклически бежит один огонек, при нажатой другой кнопке – два рядом стоящих огонька


#include "P16F877.INC"
__CONFIG(_CP_OFF&_PWRTE_ON&_WDT_OFF&_HS_OSC);
			d1 equ 0x24
			count equ 0x25
			d2 equ 0x26
			
ORG 0 			 
START:
		CLRF d1
		CLRF d2
		CLRF PORTB
		CLRF PORTD

		BSF STATUS, RP0 ;Переход на 1 страницу
		CLRF TRISD ;Выходы порта на вывод
		
		BCF TRISB, 6; обозначили кнопки 
		BCF TRISB, 7;
		
		BCF STATUS,RP0 ;Возвращаемся на страницу 0
;====================================
RUN:
	    BSF PORTB, 6   
		BTFSC PORTB, 6 ; проверяем нажатость кнопки
		CALL MIG1
		
        BSF PORTB, 7    
		BTFSC PORTB, 7
		CALL MIG

		GOTO RUN
;====================================
; процедура - включение светодиодов
MIG:	 
		INCF PORTD,F ; 00000001
		CALL DELAY
		MOVLW	8 ; для того, чтобы прошло всю ленту
		MOVWF   count
		LOOP:
		BCF  STATUS, C	 ;обнуление бита переноса
		RLF  PORTD,F     ;сдвигаем бит влево
		CALL DELAY
		DECFSZ count,F 
		GOTO LOOP
RETURN
;====================================
;мигание двух
MIG1:
    MOVLW	8
	MOVWF   count
	MOVLW	3 ; 00000011 в порт D
	MOVWF   PORTD 
	
	CALL DELAY
	
	LOOP1:

 	BCF  STATUS, C	;обнуление бита переноса
	RLF  PORTD, F     ;сдвигаем биты влево
	
    CALL DELAY
	
	DECFSZ count,F 
	GOTO LOOP1
	
RETURN
;====================================
; Процедура организации задержки
DELAY:
           MOVLW 0xFF
           MOVWF d1
	LOOP:
	       MOVLW 0xFF
		   MOVWF d2
	LOOP_1:
		   DECFSZ d2, F
	GOTO LOOP_1	
		   MOVLW 0xFF
		   MOVWF d2
	LOOP_2:
		   DECFSZ d2, F
	GOTO LOOP_2
		   MOVLW 0xFF
		   MOVWF d2
	LOOP_3:
		   DECFSZ d2, F
	GOTO LOOP_3
		   MOVLW 0xFF
		   MOVWF d2
	LOOP_4:
		   DECFSZ d2, F
	GOTO LOOP_4
		   DECFSZ d1, F
	GOTO LOOP
RETURN 

END