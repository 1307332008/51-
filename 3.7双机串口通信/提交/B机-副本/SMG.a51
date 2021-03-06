
NEWFLAG 	EQU 	26H
LATCH1 		BIT 	P2.2;段锁存
LATCH2 		BIT 	P2.3;位锁存

ORG 	0000H		;主程序入口地址
LJMP 	START
ORG  	000BH		;T0中断入口地址
LJMP 	T0SUB
ORG	0023H		;串口中断入口地址
LJMP	COM_INT
ORG		0100H
START:
MOV 		SP,		#60H;堆栈指针值赋为60H
MOV 		23H,		#00H
MOV 		22H,		#00H
MOV		21H,		#00H
MOV		20H,		#00H
MOV		NEWFLAG,	#01H
MOV 		TMOD,#21H
MOV 		TH0,#0FCH
MOV 		TL0,#18H
MOV 		TH1,#0FAH		;设置T1定时器初值，波特率为9600
MOV 		TL1,#0FAH
MOV		PCON,#00H
MOV		IE,#82H
MOV		SCON,#50H
MOV		IP,#10H
SETB		TR0
SETB 		TR1
SETB 		EA		;总中断打开

WAIT: JNB	RI,	WAIT
	CLR	RI
	SETB	ES


MOV 		R0,		#30H		;R0为显示缓冲区首地址30H
MOV		R1,		#23H
MOV 		R2,		#0FEH		;R2赋值11111110
MOV 		DPTR,		#TABLE	;数据指针首地址
LCALL 	STORE				;将二进制转换成BCD码七段码存入37H到30H

;将二进制转换成BCD码七段码，实现将20H到23H转换成七段码存入37H到30H
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
MOV 		A,		NEWFLAG		;NEWFLAG值存入A	   
CJNE		A,		#00H,		LOOP3;检测A的内容与0比较，不是0则跳到STORE，是0则跳到LOOP	   
JMP  		LOOP         
LOOP3:
MOV		NEWFLAG,	#00H
LJMP		STORE


T0SUB:	
CLR 		EA
PUSH 		PSW	 
PUSH 		Acc	 
SETB		EA
MOV 		TH0,		#0FCH	;T0定时1ms
MOV 		TL0,		#18H
MOV 		P0,		@R0	;段码P0口输出，段锁存
SETB 		LATCH1
CLR 		LATCH1	
INC 		R0	 
MOV 		P0,		R2
SETB 		LATCH2
CLR 		LATCH2 

MOV 		A,		R2
RL 		A
MOV 		R2,		A			;R2左移	
CJNE 		R0,		#38H,		RE	;（R0）与38H作比较，不相等则跳到RE中断返回
MOV 		R0,		#30H			;R0变为显示缓冲区首地址30H
MOV 		R2,		#0FEH			;R2赋值11111110
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
MOV		NEWFLAG,	#01H			;4个数传完才给newflag
MOV		R1,		#23H
SHOU:
POP 		Acc	 
POP		DPH
POP		DPL 
RETI

TABLE:DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH ;共阴字码表
END
