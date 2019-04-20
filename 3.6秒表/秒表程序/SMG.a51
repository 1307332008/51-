;������
;��д�ˣ��ߺ�ΰ
;��д����2019-4-6
;�޸�����2019-4-9
;T0�ж�ʱ��R1ָ��26H--29H���ֱ�洢���룬�룬�֣�ʱ
;R0ָ��1EH--25H���ֱ�洢���룬�룬�֣�ʱ�Ķ���
;T1�ж�ʱR1ָ��25H--1EH���Ĵ������Ѱַ�����P0��
;R3�洢����ֵ��T1�ж�ʱ�����P0�ڣ�Ȼ������


LATCH1 BIT P2.2
LATCH2 BIT P2.3

ORG 0000H
LJMP START ;������
ORG 0003H
LJMP INT_0 ;�����ж�
ORG 000BH
LJMP T0_INT ;��ʱ��0��10ms
ORG 001BH
LJMP T1_INT ;��ʱ��1��1ms
START:
	  MOV  TCON,	#51H
	  MOV  IP,		#02H
	  MOV  IE,		#8BH
	  MOV  TMOD,	#11H	 ;�������ڷ�ʽ1
	  MOV  TL0,		#0F0H
	  MOV  TH0,		#0D8H  ;10ms�ж�
	  MOV  TL1,		#18H
	  MOV  TH1,		#0FCH  ;1ms�ж�
        MOV  DPTR,	#TABLE
        MOV  SP,		#60H      	 
	  MOV  32H,		#00H ;��������
	  MOV  R1,		#25H ;ָ�룬����BCD��	  
	  MOV  R3,		#11111110B;λ���ֵ
	 
	 HERE: SJMP HERE  ;ԭ�صȴ��ж�
		
T1_INT:
	 MOV   TL1,		#18H
	 MOV   TH1,		#0FCH
       MOV   P0,		@R1   ;��ʾ����@R1Ϊ���������P0
       SETB  LATCH1
       CLR   LATCH1
       MOV   P0,		R3	;���λ��
       SETB  LATCH2
       CLR   LATCH2
	 DEC   R1
	 MOV   A,		R3
	 RL    A
	 MOV   R3,		A
	 CJNE  R1,		#1DH,EXIT_T1_INT
	 MOV   R1,		#25H	
	EXIT_T1_INT:RETI
	 
T0_INT:
	 CLR 		EA
	 PUSH 	PSW
	 PUSH 	Acc
	 MOV  	31H,		R1	;��װR1��ջ	 
	 SETB 	EA
	 MOV 		R1,		#26H ;ָ�룬����BCD��
	 MOV 		R0,		#1EH ;ָ�룬�����
	 MOV  	TL0,		#0F0H
	 MOV  	TH0,		#0D8H
	 MOV		A,		32H          ;��������ֵ��ѡ����
	 CJNE 	A,		#01H ,EQU2	 ;����ֵΪ1����������תΪ������
	 SETB 	TR0
       CALL 	TIME
	 CALL 	STORE
	 SJMP 	EXIT_T0_INT
EQU2:  CJNE 	A,	#02H,	EQU3		 ;����ֵΪ2�������������̣�ʵ����ͣ
	 SJMP 	EXIT_T0_INT
EQU3:
	 MOV 		26H,		#00H		 ;����ֵΪ3������
	 MOV 		27H,		#00H
	 MOV 		28H,		#00H
	 MOV 		29H,		#00H
	 CALL STORE
EXIT_T0_INT: CLR EA
	 MOV 		R1,		31H
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
	 CJNE		A,		#04H,	NEXT
	 MOV 		32H,		#01H	     
NEXT:  CLR 		EA
	 POP 		Acc
	 POP 		PSW
	 SETB 	EA
	 EXIT_INT_0: RETI
 
TABLE:DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH    ;���������
END