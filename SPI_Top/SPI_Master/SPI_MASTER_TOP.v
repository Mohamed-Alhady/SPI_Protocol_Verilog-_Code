module SPI_MASTER_TOP #(parameter WIDTH =8)(

input wire					i_clk    ,
input wire 					i_rst    ,
input wire 					MISO     ,
input wire 	[WIDTH-1 : 0]	i_PDATA  ,
input wire  [1:0]           i_mode   ,
input wire                  i_valid  ,       

//Output Ports 

output wire                 o_clk    ,              
output wire					o_ready  ,
output wire					S_DATA   ,
output wire  [WIDTH-1 : 0]  P_DATA    

);

wire ic_phase ;


wire o_leading_edge      ;
wire o_trailing_edge     ;

assign ic_phase = ((i_mode == 2'b01 ) || (i_mode == 2'b11))? 1'b1 : 1'b0 ;


CLK_GEN D0(

.i_clk            (i_clk           )     ,   
.i_rst            (i_rst           )     , 
.i_mode           (i_mode          )     , 
.i_valid          (i_valid         )     , 
.o_clk            (o_clk           )     , 
.o_ready          (o_ready         )     , 
.o_leading_edge   (o_leading_edge  )     , 
.o_trailing_edge  (o_trailing_edge )      



);

Serializer D1(

.i_clk            (i_clk          )    ,
.i_rst            (i_rst          )    ,
.i_PDATA          (i_PDATA        )    ,
.i_valid          (i_valid        )    ,
.ser_en           (o_leading_edge )    ,
.deser_en         (o_trailing_edge)    ,
.ic_phase         (ic_phase       )    ,
.S_DATA           (S_DATA         )        


);

DeSerializer D2(

.i_clk            (i_clk          )   ,
.i_rst            (i_rst          )   ,
.MISO             (MISO           )   ,
.deser_en         (o_trailing_edge)   ,
.ser_en           (o_leading_edge )   ,
.ic_phase         (ic_phase       )   ,
.P_DATA           (P_DATA         )   

);




endmodule