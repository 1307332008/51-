;����Ki��ʾ��Ӧ����i
;��д�ˣ��ߺ�ΰ
;��д����2019-4-9
;�޸�����2019-4-10
;R1�ṩ�����ƫ�Ƶ�ַ
;R3���λ��

LATCH1 BIT P2.2	
LATCH2 BIT P2.3	


START:
      MOV 	  DPTR,	#TABLE
      MOV 	  SP,		#60H
	MOV  	  P1,		#0FFH ;��д1�ٶ�����
	
	JNB	P1.0,		KEY1 
	JNB  	P1.1,		KEY2
	JNB  	P1.2,		KEY3
	JNB  	P1.3,		KEY4 
	JNB  	P1.4,		KEY5
	JNB  	P1.5		KEY6	  
	JNB  	P1.6,		KEY7 
	JNB  	P1.7,		KEY8 ;target out of range,����2K������ת���ɼ�һ����תָ��	  
	LJMP  START

;�������ʾ
SCAN:	
     MOV 	A,		R1
     MOVC 	A, 		@A+DPTR
     MOV 	P0,		A
     SETB 	LATCH1
     CLR 	LATCH1
     MOV 	P0,		R3
     SETB 	LATCH2
     CLR 	LATCH2
     CALL 	DELAY
     LJMP 	START

KEY1:	
	MOV 	R1,	#01H 	    ;���ʶ���	  
	MOV 	R3,	#11111110B;λ���ֵ
	LJMP 	SCAN
KEY2:
	MOV 	R1,	#02H      ;���ʶ���	  
	MOV 	R3,	#11111101B;λ���ֵ
	LJMP 	SCAN
KEY3:
	MOV 	R1,	#03H      ;���ʶ���	  
	MOV 	R3,	#11111011B;λ���ֵ
	LJMP 	SCAN
KEY4:
	MOV 	R1,	#04H      ;���ʶ���	  
	MOV 	R3,	#11110111B;λ���ֵ
	LJMP 	SCAN
KEY5:
	MOV 	R1,	#05H      ;���ʶ���	  
	MOV 	R3,	#11101111B;λ���ֵ
	LJMP 	SCAN
	 
KEY6:
	MOV 	R1,	#06H      ;���ʶ���	  
	MOV 	R3,	#11011111B;λ���ֵ
	LJMP 	SCAN
     	 
KEY7:
	MOV 	R1,	#07H      ;���ʶ���	  
	MOV 	R3,	#10111111B;λ���ֵ
	LJMP 	SCAN 
KEY8:
	MOV 	R1,	#08H      ;���ʶ���	  
	MOV 	R3,	#01111111B;λ���ֵ
	LJMP 	SCAN
  
DELAY: MOV 	R6,	#4    ;ɨ����ʱ
D3:    MOV 	R7,	#248
       DJNZ R7,	$
       DJNZ R6,	D3
       RET  
	 
TABLE:DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH    ;���������

END