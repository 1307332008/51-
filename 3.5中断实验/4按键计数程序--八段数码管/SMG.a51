;�����жϳ���
;��д�ˣ��ߺ�ΰ
;��д����2019-4-6
;�޸�����2019-4-10
;30HΪ���������洢��Ԫ
;

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
      MOV 		30H,#00H			;���������洢��Ԫ
	CALL 		STORE				;�ȴ洢һ�ζ���

SCAN:	 
     MOV 		A,		22H
     MOV 		P0,		A
     SETB 		LATCH1
     CLR 		LATCH1
     MOV 		P0,		#11111110B 
     SETB 		LATCH2	
     CLR 		LATCH2
     CALL 		DELAY

     MOV 		A,		21H
     MOV 		P0,		A
     SETB 		LATCH1
     CLR 		LATCH1
     MOV 		P0,		#11111101B 
     SETB 		LATCH2
     CLR 		LATCH2
     CALL 		DELAY
	 
     MOV 		A,		20H
     MOV 		P0,		A
     SETB 		LATCH1
     CLR 		LATCH1
     MOV 		P0,		#11111011B
     SETB 		LATCH2
     CLR 		LATCH2
     CALL 		DELAY
     LJMP 		SCAN

DELAY: MOV 		R6,		#4    ;ɨ����ʱ
D3:    MOV 		R7,		#248
       DJNZ 	R7,		$
       DJNZ 	R6,		D3
       RET
INT_0:
	 CLR 		EA
	 PUSH 	PSW
	 PUSH 	Acc
	 SETB 	EA
       INC 		30H		;��������
	 CALL 	STORE 	;ת��Ϊ����
	 CLR 		EA
	 POP 		Acc
	 POP 		PSW
	 SETB 	EA
	 RETI

;����ת������
STORE:
	  MOV 	A,	30H
	  MOV 	B,	#100
	  DIV 	AB
	  MOVC 	A,	@A+DPTR
	  MOV 	22H,	A
	  MOV 	A,	B
	  MOV 	B,	#10
	  DIV 	AB
	  MOVC 	A,	@A+DPTR
	  MOV 	21H,	A
	  MOV 	A,	B
	  MOVC 	A,	@A+DPTR
	  MOV 	20H,A
	  RET
	  
TABLE:DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH    ;���������
END