;���ڷ��ͳ���
;��д�ˣ��ߺ�ΰ
;��д����2019-4-19
;�޸�����2019-4-20
;T0�ж�ʱ��R1ָ��26H-29H���ֱ�洢���룬�룬�֣�ʱ
;T0��R0ɨ�����
;STORE�����У��ֱ������룬�룬�֣�ʱ�Ķ��룬�洢��1DH--24H
;T1�жϷ�ʽ�����ṩ������4800
;R3�洢λ��ֵ������


LATCH1 BIT P2.2
LATCH2 BIT P2.3

ORG 0000H
LJMP START ;������
ORG 0003H
LJMP INT_0 ;�����ж�
ORG 000BH
LJMP T0_INT ;��ʱ��0��1ms
ORG 001BH
LJMP T1_INT ;��ʱ��1�����ڲ�����4800
ORG 0023H
LJMP COM_INT 	;���ڣ�10ms
START:
	  MOV  TCON,	#51H
	  MOV	 SCON,	#40H	
	  MOV	 PCON,	#00H
	  MOV  IP,		#10H
	  ;MOV  IE,		#9BH
	  MOV  TMOD,	#21H	 ;T0�����ڷ�ʽ1��T1��ʽ��
	  MOV  TL0,		#018H
	  MOV  TH0,		#0FCH   ;1ms�ж�
	  MOV  TL1,		#0FAH
	  MOV  TH1,		#0FAH  ;10ms�ж�
        MOV  DPTR,	#TABLE
        MOV  SP,		#60H      	 
	  MOV  32H,		#00H ;��������
	  MOV  R1,		#24H ;ָ�룬����BCD��
	  MOV  R0,		#26H
	  MOV  R3,		#11111110B;λ���ֵ
	  ACALL		TRAIN
	 HERE: SJMP HERE  ;ԭ�صȴ��ж�

TRAIN:

	 MOV  	IE,		#9BH
	 MOV		A,		@R0
	 MOV		SBUF,		A
	
	 
T1_INT:
	 RETI

COM_INT:
	 CLR		TI
	 CLR 		EA
	 PUSH 	PSW
	 PUSH 	Acc
	 SETB 	EA	
	 
	 INC		R0
	 CJNE		R0,		#2AH,		SEND
	 CLR		ES
	 MOV		R0,		#26H
NEXT:  CLR 		EA
	 POP 		Acc
	 POP 		PSW
	 SETB 	EA
	 RETI
	 
SEND:	 MOV		A,		@R0
	 MOV		SBUF,		A	
	 JMP		NEXT
	 


T0_INT:
	 CLR 		EA
	 PUSH 	PSW
	 PUSH 	Acc	 	 
	 SETB 	EA
	 MOV  	TL0,		#018H
	 MOV  	TH0,		#0FCH 
	 
	 MOV   	P0,		@R1   ;��ʾ����@R1Ϊ���������P0
       SETB  	LATCH1
       CLR   	LATCH1
       MOV   	P0,		R3	;���λ��
       SETB  	LATCH2
       CLR   	LATCH2
	 DEC   	R1
	 MOV   	A,		R3
	 RL    	A
	 MOV   	R3,		A
	 CJNE  	R1,		#1CH,		EXIT_SCAN
	 MOV   	R1,		#24H		 
EXIT_SCAN: 
	 MOV		A,		32H          ;��������ֵ��ѡ����
	 CJNE 	A,		#01H ,EQU2	 ;����ֵΪ1����������תΪ������
	 SETB 	TR0
	 INC  	25H
	 MOV  	A,		25H
	 CJNE 	A,		#0AH, EXIT_T0_INT		;10ms��һ��TIME & STORE
	 MOV  	25H,		#00H
	 MOV  	30H,		R0
	 MOV  	31H,		R1		;��װ	R0,	R1��ջ
	 MOV 		R1,		#26H 		;ָ�룬����BCD��
	 MOV 		R0,		#1DH 		;ָ�룬�����
       CALL 	TIME
	 CALL 	STORE
	 MOV 		R0,		#26H
	 SETB		ES
	 MOV		SBUF,		@R0	;���ڷ���������	
	 MOV 		R1,		31H
	 MOV		R0,		30H	;��װ��ջ
	 
	 MOV		A,		@R0
	 MOV		SBUF,		A
	 SJMP 	EXIT_T0_INT
EQU2:  CJNE 	A,	#02H,	EQU3		 ;����ֵΪ2�������������̣�ʵ����ͣ
	 SJMP 	EXIT_T0_INT
EQU3:	
	 MOV  	30H,		R0
	 MOV  	31H,		R1		;��װR1��ջ
	 MOV 		R1,		#26H 		;ָ�룬����BCD��
	 MOV 		R0,		#1DH 		;ָ�룬�����
	 MOV 		25H,		#00H	
	 MOV 		26H,		#00H	 	;����ֵΪ3������
	 MOV 		27H,		#00H
	 MOV 		28H,		#00H
	 MOV 		29H,		#00H
	 CALL STORE
	 MOV 		R0,		#26H
	 MOV		SBUF,		@R0
	 MOV 		R1,		31H		;��װ��ջ
	 MOV		R0,		30H
EXIT_T0_INT:
	 CLR EA
	 POP 		Acc
	 POP 		PSW
	 SETB		EA
	 RETI

;TIMEΪ���룬�룬�֣�ʱ
TIME:   
	  INC  	26H
	  MOV  	A,		26H
	  CJNE 	A,		#64H, EXIT_TIME
	  MOV  	26H,		#00H
	  
	  INC  	27H
	  MOV  	A,		27H
	  CJNE 	A,		#3CH, EXIT_TIME	  
	  MOV  	27H,		#00H
	  
	  INC  	28H
	  MOV  	A,		28H
	  CJNE 	A,		#3CH, EXIT_TIME	  
	  MOV  	28H,		#00H
	  
	  INC  	29H
	  MOV  	A,		29H
	  CJNE 	A,		#18H, EXIT_TIME
	  MOV  	29H,		#00H
	  EXIT_TIME:  RET
	  
;STOREΪ���룬�룬�֣�ʱ	�Ķ���	 
STORE:
	  MOV 	A,		@R1
	  MOV 	B,		#10
	  DIV 	AB
	  MOVC 	A,		@A+DPTR
	  INC 	R0
	  MOV 	@R0,		A
	  MOV 	A,B
	  MOVC	A,		@A+DPTR
	  DEC 	R0
	  MOV 	@R0,		A
	  INC 	R0
	  INC 	R0
	  INC 	R1
	  CJNE 	R1,		#2AH,	STORE	  
	  RET

INT_0:
	 CLR 		EA
	 PUSH 	PSW
	 PUSH 	Acc
	 SETB 	EA	
	 INC 		32H		;�����жϼ���
	 MOV 		A,		32H
	 CJNE		A,		#04H,	NEXT0
	 MOV 		32H,		#01H	     
NEXT0: CLR 		EA
	 POP 		Acc
	 POP 		PSW
	 SETB 	EA
	 RETI
 
TABLE:DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH    ;���������
END