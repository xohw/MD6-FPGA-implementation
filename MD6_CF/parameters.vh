// file name: parameters.vh	

//constants
`define wi  1   // amount of blocks of words
`define w	64
`define b	8
`define L	0
`define r	168 // max default value of r (40+d/4 = 40+512/4)
`define n 	89
`define c 	16
`define clk_freq 100_000_000// System clock frequency
`define baud_rate 9600      // Baud rate
////////////////////////////
//IV  (For SEQ mode of operation)

`define V0          64'h0000000000000000
`define V1          64'h0000000000000000
`define V2          64'h0000000000000000
`define V3          64'h0000000000000000
`define V4          64'h0000000000000000
`define V5          64'h0000000000000000
`define V6          64'h0000000000000000
`define V7          64'h0000000000000000
`define V8          64'h0000000000000000
`define V9          64'h0000000000000000
`define V10         64'h0000000000000000
`define V11         64'h0000000000000000
`define V12         64'h0000000000000000
`define V13         64'h0000000000000000
`define V14         64'h0000000000000000
`define V15         64'h0000000000000000

`define IV			{`V15	,`V14	,`V13	,`V12	,`V11	,`V10	,`V9	,`V8	,`V7	,`V6	,`V5	,`V4	,`V3	,`V2	,`V1	,`V0}

////////////////////////////
//Q vector
`define	Q0 			64'h7311c2812425cfa0
`define	Q1 			64'h6432286434aac8e7
`define	Q2 			64'hb60450e9ef68b7c1
`define	Q3 			64'he8fb23908d9f06f1
`define	Q4 			64'hdd2e76cba691e5bf
`define	Q5 			64'h0cd0d63b2c30bc41
`define	Q6 			64'h1f8ccf6823058f8a
`define	Q7 			64'h54e5ed5b88e3775d
`define	Q8 			64'h4ad12aae0a6d6031
`define	Q9 			64'h3e7f16bb88222e0d
`define	Q10 		64'h8af8671d3fb50c2c
`define	Q11			64'h995ad1178bd25c31
`define	Q12			64'hc878c1dd04c4b633
`define	Q13 		64'h3b72066c7a1552ac
`define	Q14 		64'h0d6f3522631effcb
 
 //Q_array[15*w-1:0]
`define Q_array     {`Q14,`Q13,`Q12,`Q11,`Q10,`Q9,`Q8,`Q7,`Q6,`Q5,`Q4,`Q3,`Q2,`Q1,`Q0}

////////////////////////////
//t - indexs for the algo.
`define t0	8'd17
`define t1	8'd18
`define t2	8'd21
`define t3	8'd31
`define t4	8'd67
//t_array[5*byte-1:0]
`define t_array     {`t0,`t1,`t2,`t3,`t4}
////////////////////////////


////////////////For TB simulations////////////////// 
//// Massage example 2 
//`define M1		64'h1122334455667711
//`define M2		64'h2233445566771122
//`define M3		64'h3344556677112233
//`define M4		64'h4455667711223344
//`define M5		64'h5566771122334455
//`define M6		64'h6677112233445566
//`define M7		64'h7711223344556677
//
//`define M_array_2  {`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1}
//
//// Massage example 3 
//
//`define M_array_3  {`M2,	 `M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1,	`M7,	`M6,	`M5,	`M4,	`M3,	`M2,	`M1}
