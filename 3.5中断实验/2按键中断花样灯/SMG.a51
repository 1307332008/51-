;�����ж� ������ 6��ģʽ
;��д�ˣ��ߺ�ΰ
;��д����2019-4-6
;�޸�����2019-4-10
;30HΪ���������洢��Ԫ
LATCH1 BIT P2.2
LATCH2 BIT P2.3

ORG 0000H
LJMP START
ORG 0003H
LJMP INT_0
START:
	SETB 	 	EA
	SETB		EX0
	SETB 		PX0
	SETB 		IT0				;INT0�жϳ�ʼ��
      MOV 		DPTR,		#TABLE
      MOV 		SP,		#60H		;�����ջ
      MOV 		R1,		#00H		;���������洢��Ԫ

SCAN:	      
     SJMP 		SCAN

INT_0:
	 CLR 		EA
	 PUSH 	PSW
	 PUSH 	Acc
	 SETB 	EA   
	 
	 MOV		A,		R1
	 MOVC		A,		@A+DPTR
	 MOV		P1,		A
	 INC		R1
	 CJNE		R1,		#06H,		EXIT
	 MOV		R1,		#00H
 EXIT: CLR 		EA
	 POP 		Acc
	 POP 		PSW
	 SETB 	EA
	 RETI
	  
TABLE:DB 0AAH,055H,0F0H,0FH,99H,66H   ;LED��
END