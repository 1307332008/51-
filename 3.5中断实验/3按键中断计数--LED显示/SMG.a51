;�����ж� �ư�����--LED��ʾ
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
      MOV 		SP,		#60H		;�����ջ
      MOV 		30H,		#00H
	MOV		31H,		#00H

SCAN:	      
     SJMP 		SCAN

INT_0:
	 CLR 		EA
	 PUSH 	PSW
	 PUSH 	Acc
	 SETB 	EA   	 
	 INC		30H
	 MOV		A,		30H
	 CJNE		A,		#0FFH,		EXIT
	 MOV		30H,		#00H
	 INC		31H
	 MOV		A,		31H
	 CJNE		A,		#0FFH,		EXIT
	 MOV		31H,		#00H
 EXIT: MOV		A,		30H
	 XRL		A,		#0FFH
	 MOV		P1,		A
	 CLR 		EA
	 POP 		Acc
	 POP 		PSW
	 SETB 	EA
	 RETI

END