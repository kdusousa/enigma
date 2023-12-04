; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------


RT_TAM		.equ	26
GIRO1		.equ	-1


VISTO1:		MOV		#MSG,R5
 			MOV 	#GSM,R6
 			MOV		#0, R14			; Contador giro rotor esquerda
 			MOV		#0, R15			; Contador giro rotor centro

 			;Capturar valores de rotores, configurações e refletores
			MOV		#CHAVE, R4		; Seleciona o rotor da esquerda
 			CALL	#DEF_RTR_ESQ	;Define e configura o rotor da esquerda
 			CALL	#DEF_RTR_CNT	;Define e configura o rotor central
 			CALL	#DEF_RTR_DIR	;Define e configura o rotor da direita
 			CALL	#DEF_RF


			CALL	#ENIGMA5

			CALL	#RESETE

			MOV 	#GSM,R5
			MOV		#DCF,R6
 			CALL	#ENIGMA5 ;Decifrar
 			JMP 	$
 			NOP

RESETE:		MOV		#CHAVE, R4
RESETE1:	CALL	#DEF_RTR_ESQ
 			CALL	#DEF_RTR_CNT
 			CALL	#DEF_RTR_DIR
 			CLR.B	R14
 			CLR.B	R15

			RET

;**********************************************************************
;***  DEFNIÇÃO E CONFIGURAÇÃO DO REFLETOR ****************************

DEF_RF:		CMP.B	#1, 0(R4)
			JEQ		SET_RF1
			CMP.B	#2, 0(R4)
			JEQ		SET_RF2
			CMP.B	#3, 0(R4)
			JEQ		SET_RF3


SET_RF1:	MOV		#RFCF, R10
			CLR.B	R11
LOOP1:		MOV.B	RF1(R11), 0(R10)
			INC		R10
			INC		R11
			CMP		#RT_TAM, R11
			JNZ		LOOP1
			RET

SET_RF2:	MOV		#RFCF, R10
			CLR.B	R11
LOOP2:		MOV.B	RF2(R11), 0(R10)
			INC		R10
			INC		R11
			CMP		#RT_TAM, R11
			JNZ		LOOP2
			RET

SET_RF3:	MOV		#RFCF, R10
			CLR.B	R11
LOOP3:		MOV.B	RF3(R11), 0(R10)
			INC		R10
			INC		R11
			CMP		#RT_TAM, R11
			JNZ		LOOP3
			RET

;****************************************************************
;************** DEFINIÇÃO E CONFIGURAÇÃO DOS ROTORES ************

DEF_RTR_ESQ:
			CMP.B	#1, 0(R4)
			JEQ		SET_ROT1_ESQ
			CMP.B	#2, 0(R4)
			JEQ		SET_ROT2_ESQ
			CMP.B	#3, R4
			JEQ		SET_ROT3_ESQ
			CMP.B	#4, R4
			JEQ		SET_ROT4_ESQ
			CMP.B	#5, R4
			JEQ		SET_ROT5_ESQ
DEF_RTR_CNT:
			CMP.B	#1, 0(R4)
			JEQ		SET_ROT1_CNT
			CMP.B	#2, 0(R4)
			JEQ		SET_ROT2_CNT
			CMP.B	#3, 0(R4)
			JEQ		SET_ROT3_CNT
			CMP.B	#4, 0(R4)
			JEQ		SET_ROT4_CNT
			CMP.B	#5, 0(R4)
			JEQ		SET_ROT5_CNT

DEF_RTR_DIR:
			CMP.B	#1, 0(R4)
			JEQ		SET_ROT1_DIR
			CMP.B	#2, 0(R4)
			JEQ		SET_ROT2_DIR
			CMP.B	#3, 0(R4)
			JEQ		SET_ROT3_DIR
			CMP.B	#4, 0(R4)
			JEQ		SET_ROT4_DIR
			CMP.B	#5, 0(R4)
			JEQ		SET_ROT5_DIR

SET_ROT1_ESQ:
			INCD	R4
			MOV		#RT1CF,	R10
 			CALL	#CONF_RTR1
			RET
SET_ROT2_ESQ:
			INCD	R4
			MOV		#RT1CF,	R10
 			CALL	#CONF_RTR2
			RET
SET_ROT3_ESQ:
			INCD	R4
			MOV		#RT1CF,	R10
 			CALL	#CONF_RTR3
			RET
SET_ROT4_ESQ:
			INCD	R4
			MOV		#RT1CF,	R10
 			CALL	#CONF_RTR4
			RET
SET_ROT5_ESQ:
			INCD	R4
			MOV		#RT1CF,	R10
 			CALL	#CONF_RTR5
			RET

SET_ROT1_CNT:
			INCD	R4
			MOV		#RT2CF,	R10
 			CALL	#CONF_RTR1
			RET
SET_ROT2_CNT:
			INCD	R4
			MOV		#RT2CF,	R10
 			CALL	#CONF_RTR2
			RET
SET_ROT3_CNT:
			INCD	R4
			MOV		#RT2CF,	R10
 			CALL	#CONF_RTR3
			RET
SET_ROT4_CNT:
			INCD	R4
			MOV		#RT2CF,	R10
 			CALL	#CONF_RTR4
			RET
SET_ROT5_CNT:
			INCD	R4
			MOV		#RT2CF,	R10
 			CALL	#CONF_RTR5
			RET

SET_ROT1_DIR:
			INCD	R4
			MOV		#RT3CF,	R10
 			CALL	#CONF_RTR1
			RET
SET_ROT2_DIR:
			INCD	R4
			MOV		#RT3CF,	R10
 			CALL	#CONF_RTR2
			RET
SET_ROT3_DIR:
			INCD	R4
			MOV		#RT3CF,	R10
 			CALL	#CONF_RTR3
			RET
SET_ROT4_DIR:
			INCD	R4
			MOV		#RT3CF,	R10
 			CALL	#CONF_RTR4
			RET
SET_ROT5_DIR:
			INCD	R4
			MOV		#RT3CF,	R10
 			CALL	#CONF_RTR5
			RET
;**************************************************
CONF_RTR1:	MOV		#0, R11			;CONTADOR
			MOV.B	-1(R4), R13

CFR1:		MOV.B	RT1(R13), 0(R10)
			INC		R10
			INC		R11
			INC		R13
			CMP		#RT_TAM, R13
			JHS		DIMINUI1
ATRIBUI1:
			CMP 	#RT_TAM, R11
			JZ		FIMCONF_ROT1
			JMP		CFR1
DIMINUI1:
			SUB.B	#RT_TAM, R13
DIMINUI12:	MOV.B	RT1(R13), 0(R10)
			INC		R10
			INC		R13
			CMP 	#RT_TAM, R11
			JZ		FIMCONF_ROT1
			INC		R11
			JMP		DIMINUI12

FIMCONF_ROT1:
			RET
;***************************************************

CONF_RTR2:	MOV		#0, R11			;CONTADOR
			MOV.B	-1(R4), R13
CFR2:		MOV.B	RT2(R13), 0(R10)
			INC		R10
			INC		R11
			INC		R13
			CMP		#RT_TAM, R13
			JHS		DIMINUI2
ATRIBUI2:
			CMP 	#RT_TAM, R11
			JZ		FIMCONF_ROT2
			JMP		CFR2
DIMINUI2:
			SUB.B	#RT_TAM, R13
DIMINUI22:	MOV.B	RT2(R13), 0(R10)
			INC		R10
			INC		R13
			CMP 	#RT_TAM, R11
			JZ		FIMCONF_ROT2
			INC		R11

			JMP		DIMINUI22
FIMCONF_ROT2:
			RET
;*******************************************************
CONF_RTR3:	MOV		#0, R11			;CONTADOR
			MOV.B	-1(R4), R13
CFR3:		MOV.B	RT3(R13), 0(R10)
			INC		R10
			INC		R11
			INC		R13
			CMP		#RT_TAM, R13
			JHS		DIMINUI3
ATRIBUI3:
			CMP 	#RT_TAM, R11
			JZ		FIMCONF_ROT1
			JMP		CFR3
DIMINUI3:
			SUB.B	#RT_TAM, R13
DIMINUI32:	MOV.B	RT3(R13), 0(R10)
			INC		R10
			INC		R13
			CMP 	#RT_TAM, R11
			JZ		FIMCONF_ROT3
			INC		R11

			JMP		DIMINUI32
FIMCONF_ROT3:
			RET
;*****************************************************
CONF_RTR4:	MOV		#0, R11			;CONTADOR
			MOV.B	-1(R4), R13
CFR4:		MOV.B	RT4(R13), 0(R10)
			INC		R10
			INC		R11
			INC		R13
			CMP		#RT_TAM, R13
			JHS		DIMINUI4
ATRIBUI4:
			CMP 	#RT_TAM, R11
			JZ		FIMCONF_ROT4
			JMP		CFR4
DIMINUI4:
			SUB.B	#RT_TAM, R13
DIMINUI42:	MOV.B	RT4(R13), 0(R10)
			INC		R10
			INC		R13
			CMP 	#RT_TAM, R11
			JZ		FIMCONF_ROT4
			INC		R11

			JMP		DIMINUI42
FIMCONF_ROT4:
			RET
;*****************************************************
CONF_RTR5:	MOV		#0, R11			;CONTADOR
			MOV.B	-1(R4), R13
CFR5:		MOV.B	RT5(R13), 0(R10)
			INC		R10
			INC		R11
			INC		R13
			CMP		#RT_TAM, R13
			JHS		DIMINUI5
ATRIBUI5:
			CMP 	#RT_TAM, R11
			JZ		FIMCONF_ROT5
			JMP		CFR5
DIMINUI5:
			SUB.B	#RT_TAM, R13
DIMINUI52:	MOV.B	RT5(R13), 0(R10)
			INC		R10
			INC		R13
			CMP 	#RT_TAM, R11
			JZ		FIMCONF_ROT5
			INC		R11

			JMP		DIMINUI52
FIMCONF_ROT5:
			RET








; Sua rotina ENIGMA (Exp 1)


ENIGMA5:	TST.B	0(R5)
			JZ		FIM5
			MOV.B	@R5+, R7
			CMP.B	#'A', R7
			JLO		PASS
			CMP.B	#'Z' +1, R7
			JHS		PASS
			SUB.B	#'A', R7
			MOV.B	RT1CF(R7), R7
			MOV.B	RT2CF(R7), R7
			MOV.B	RT3CF(R7), R7
			MOV.B	RFCF(R7), R7
			MOV.B	R7, R8
			CLR.B	R7


IDX50:		CMP.B	R8, RT3CF(R7)
			JEQ		IDX51
CONT50:		INC.B	R7
			JMP		IDX50

IDX51:		MOV.B	R7, R8
			CLR.B	R7
CONT51:		CMP.B	R8, RT2CF(R7)
			JEQ		IDX52
			INC.B	R7
			JMP		CONT51

IDX52:		MOV.B	R7, R8
			CLR.B	R7
CONT52:		CMP.B	R8, RT1CF(R7)
			JEQ		CONT53
			INC.B	R7
			JMP		CONT52
CONT53:
			ADD.B	#'A', R7
			MOV.B	R7, 0(R6)

			INC		R6
			MOV		#RT1CF, R10
 			CALL	#GIRO

			JMP		ENIGMA5

PASS:		MOV.B	R7, 0(R6)
			INC		R6
			;CALL	#GIRO
			JMP		ENIGMA5
FIM5:		RET

GIRO:
			MOV		#0, R11			;CONTADOR
			MOV.B	(RT_TAM + GIRO1)(R10), R12
			MOV.B	#(RT_TAM + GIRO1), R13
GIR1:		DEC		R13
			DEC		R10
			MOV.B	(RT_TAM + GIRO1)(R10), (RT_TAM)(R10)
			TST.B	R13
			JNZ		GIR1

FIM_GIRO:	MOV.B		R12, (RT_TAM + GIRO1)(R10)
			INC.B		R14
			CMP.B		#RT_TAM, R14
			JEQ			GIRO2
			RET

GIRO2:		CLR.B	R14
			MOV		#RT2CF, R10
			MOV		#0, R11			;CONTADOR
			MOV.B	(RT_TAM + GIRO1)(R10), R12
			MOV.B	#(RT_TAM + GIRO1), R13
GIR21:		DEC		R13
			DEC		R10
			MOV.B	(RT_TAM + GIRO1)(R10), (RT_TAM)(R10)
			TST.B	R13
			JNZ		GIR21

FIM_GIRO2:	MOV.B		R12, (RT_TAM + GIRO1)(R10)
			INC.B		R15
			CMP.B		#RT_TAM, R15
			JEQ			GIRO3
			RET

GIRO3:
			CLR.B	R15
			MOV		#RT3CF, R10
			MOV		#0, R11			;CONTADOR
			MOV.B	(RT_TAM + GIRO1)(R10), R12
			MOV.B	#(RT_TAM + GIRO1), R13
GIR31:		DEC		R13
			DEC		R10
			MOV.B	(RT_TAM + GIRO1)(R10), (RT_TAM)(R10)
			TST.B	R13
			JNZ		GIR31

FIM_GIRO3:	MOV.B		R12, (RT_TAM + GIRO1)(R10)
			RET


;
; Dados para o enigma
 			.data
;Definição da chave do Enigma
CHAVE:	 .byte 2, 6, 3, 8, 5, 12, 2

MSG:	 .byte "UMA NOITE DESTAS, VINDO DA CIDADE PARA O ENGENHO NOVO,"
		 .byte " ENCONTREI NO TREM DA CENTRAL UM RAPAZ AQUI DO BAIRRO,"
		 .byte " QUE EU CONHECO DE VISTA E DE CHAPEU.",0 ;Don Casmurro

GSM: 	 .byte "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
		 .byte "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
		 .byte "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",0

DCF:	 .byte "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
		 .byte "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
		 .byte "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",0
;Rotores

RT1: 	 .byte 10, 18, 0, 7, 3, 2, 4, 8, 14, 17, 5, 22, 20
		 .byte 25, 23, 1, 24, 13, 21, 19, 11, 6, 12, 15, 9, 16
RT2:	 .byte 19, 9, 7, 23, 11, 25, 17, 16, 2, 24, 15, 10, 6
		 .byte 14, 0, 8, 13, 4, 3, 18, 1, 22, 21, 20, 5, 12
RT3:	 .byte 16, 21, 4, 0, 1, 12, 15, 14, 8, 25, 9, 19, 17
		 .byte 6, 5, 20, 13, 24, 23, 10, 3, 22, 11, 7, 18, 2
RT4:	 .byte 25, 4, 21, 22, 17, 14, 12, 8, 5, 15, 23, 6, 2
		 .byte 18, 10, 16, 13, 3, 19, 20, 0, 24, 11, 7, 9, 1
RT5:	 .byte 13, 5, 20, 7, 0, 15, 21, 9, 19, 14, 24, 18, 12
		 .byte 6, 2, 11, 16, 8, 3, 1, 10, 23, 4, 25, 22, 17
;Rotores configuráveis
RT1CF:	 .byte 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
RT2CF:	 .byte 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
RT3CF:	 .byte 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
;Refletores

RF1:	 .byte 7, 17, 5, 19, 15, 2, 9, 0, 14, 6, 18, 16, 25
		 .byte 23, 8, 4, 11, 1, 10, 3, 22, 24, 20, 13, 21, 12
RF2:	 .byte 2, 13, 0, 8, 10, 19, 23, 14, 3, 22, 4, 20, 25
		 .byte 1, 7, 17, 21, 15, 24, 5, 11, 16, 9, 6, 18, 12
RF3:	 .byte 22, 5, 9, 12, 14, 1, 13, 10, 23, 2, 7, 21, 3
		 .byte 6, 4, 24, 17, 16, 19, 18, 25, 11, 0, 8, 15, 20

RFCF:	.byte 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0 ,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0


;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
