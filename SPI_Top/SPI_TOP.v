module SPI_TOP #(parameter WIDTH=8) (

input wire 				  		i_clk      ,
input wire 				  		i_rst      ,  
input wire [WIDTH-1 : 0]  		i_PDATA    ,  
input wire [1:0]				i_mode     ,  
input wire                      i_valid    ,
input wire [WIDTH-1 : 0]  		I_DATA     ,  
input wire  			  		i_CS       ,  
input wire  			  		start      ,  
										
output wire [WIDTH-1 : 0] 		RX_DATA    ,  
output wire [WIDTH-1 : 0] 		P_DATA       

);

wire MISO , MOSI;
wire SCLK     ;
wire O_READY  ;


SPI_MASTER_TOP D2 (

.i_clk        (i_clk  )  ,
.i_rst        (i_rst  )  ,
.MISO         (MISO   )  ,
.i_PDATA      (i_PDATA)  ,
.i_mode       (i_mode )  ,
.i_valid      (i_valid)  ,

.o_clk        (SCLK   )  ,
.o_ready      (O_READY)  ,
.S_DATA       (MOSI   )  ,
.P_DATA       (P_DATA )  

);

Slave D3(

.i_SCLK    (SCLK   )  ,
.i_RST     (i_rst  )  ,
.MOSI      (MOSI   )  ,
.I_DATA    (I_DATA )  ,
.I_READY   (O_READY)  ,
.i_CS      (i_CS   )  ,
.i_mode    (i_mode )  ,
.start     (start  )  ,


.MISO      (MISO   )  ,
.RX_DATA   (RX_DATA)

);

endmodule