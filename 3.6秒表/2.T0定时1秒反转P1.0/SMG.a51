;��ʱ���ж�ʹP1.0��ת����
;��д�ˣ��ߺ�ΰ
;��д����2019-4-6
;�޸�����2019-4-10
;50ms��������20����

LATCH1 BIT P2.2
LATCH2 BIT P2.3

ORG 0000H
LJMP START
ORG 000BH
LJMP T_0
START:
	MOV		TMOD,		#01H		;T0�жϳ�ʼ��
	MOV		TCON,		#11H
	MOV		IE,		#82H
	MOV		TL0,		#0B0H		;��ʱ50ms
	MOV		TH0,		#3CH		;��һ�����һ��
      MOV 		SP,		#60H		;�����ջ
	MOV		30H,		#00H		;50ms��������20����
	
SCAN:	JMP SCAN

T_0:
	 CLR 		EA
	 PUSH 	PSW
	 PUSH 	Acc
	 SETB 	EA
	 MOV		TL0,		#0B0H
	 MOV		TH0,		#3CH		
	 INC		30H
	 MOV		A,		30H
	 CJNE		A,		#14H,		EXIT
	 MOV		30H,		#00H
       CPL		P1.0
 EXIT:	
	 CLR 		EA
	 POP 		Acc
	 POP 		PSW
	 SETB 	EA
	 RETI
END