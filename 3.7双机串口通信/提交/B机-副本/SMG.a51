
NEWFLAG 	EQU 	26H
LATCH1 		BIT 	P2.2;������
LATCH2 		BIT 	P2.3;λ����

ORG 	0000H		;��������ڵ�ַ
LJMP 	START
ORG  	000BH		;T0�ж���ڵ�ַ
LJMP 	T0SUB
ORG	0023H		;�����ж���ڵ�ַ
LJMP	COM_INT
ORG		0100H
START:
MOV 		SP,		#60H;��ջָ��ֵ��Ϊ60H
MOV 		23H,		#00H
MOV 		22H,		#00H
MOV		21H,		#00H
MOV		20H,		#00H
MOV		NEWFLAG,	#01H
MOV 		TMOD,#21H
MOV 		TH0,#0FCH
MOV 		TL0,#18H
MOV 		TH1,#0FAH		;����T1��ʱ����ֵ��������Ϊ9600
MOV 		TL1,#0FAH
MOV		PCON,#00H
MOV		IE,#82H
MOV		SCON,#50H
MOV		IP,#10H
SETB		TR0
SETB 		TR1
SETB 		EA		;���жϴ�

WAIT: JNB	RI,	WAIT
	CLR	RI
	SETB	ES


MOV 		R0,		#30H		;R0Ϊ��ʾ�������׵�ַ30H
MOV		R1,		#23H
MOV 		R2,		#0FEH		;R2��ֵ11111110
MOV 		DPTR,		#TABLE	;����ָ���׵�ַ
LCALL 	STORE				;��������ת����BCD���߶������37H��30H

;��������ת����BCD���߶��룬ʵ�ֽ�20H��23Hת�����߶������37H��30H
STORE:
MOV 		A,		23H
MOV 		B,		#10
DIV 		AB
MOVC 		A,		@A+DPTR
MOV 		36H,		A
MOV 		A,		B
MOVC 		A,		@A+DPTR
MOV 		37H,		A

MOV 		A,		22H
MOV 		B,		#10
DIV 		AB
MOVC 		A,		@A+DPTR
MOV 		34H,		A
MOV 		A,		B
MOVC		A,		@A+DPTR
ADD 		A,		#80H
MOV 		35H,		A
	  
MOV		A,		21H
MOV 		B,		#10
DIV 		AB
MOVC 		A,		@A+DPTR
MOV 		32H,		A
MOV 		A,		B
MOVC 		A,		@A+DPTR
ADD 		A,		#80H
MOV 		33H,		A

MOV 		A,		20H
MOV 		B,		#10
DIV 		AB  
MOVC		A,		@A+DPTR  
MOV 		30H,		A	  
MOV 		A,		B	  
MOVC		A,		@A+DPTR	  
ADD 		A,		#80H
MOV 		31H,		A	  


LOOP:
MOV 		A,		NEWFLAG		;NEWFLAGֵ����A	   
CJNE		A,		#00H,		LOOP3;���A��������0�Ƚϣ�����0������STORE����0������LOOP	   
JMP  		LOOP         
LOOP3:
MOV		NEWFLAG,	#00H
LJMP		STORE


T0SUB:	
CLR 		EA
PUSH 		PSW	 
PUSH 		Acc	 
SETB		EA
MOV 		TH0,		#0FCH	;T0��ʱ1ms
MOV 		TL0,		#18H
MOV 		P0,		@R0	;����P0�������������
SETB 		LATCH1
CLR 		LATCH1	
INC 		R0	 
MOV 		P0,		R2
SETB 		LATCH2
CLR 		LATCH2 

MOV 		A,		R2
RL 		A
MOV 		R2,		A			;R2����	
CJNE 		R0,		#38H,		RE	;��R0����38H���Ƚϣ������������RE�жϷ���
MOV 		R0,		#30H			;R0��Ϊ��ʾ�������׵�ַ30H
MOV 		R2,		#0FEH			;R2��ֵ11111110
RE: 
CLR 		EA 
POP 		Acc	 
POP	 	PSW	 
SETB 		EA	
RETI


COM_INT:
PUSH		DPL
PUSH		DPH	 
PUSH 		Acc	 	
CLR		RI
MOV		@R1,		SBUF
DEC		R1
CJNE		R1,		#1FH,		SHOU
MOV		NEWFLAG,	#01H			;4��������Ÿ�newflag
MOV		R1,		#23H
SHOU:
POP 		Acc	 
POP		DPH
POP		DPL 
RETI

TABLE:DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH ;���������
END
