module SPI_TOP_TB #(parameter WIDTH =8) ();

reg  				  		i_clk   ;
reg  				  		i_rst   ;
reg  [WIDTH-1 : 0]  		i_PDATA ;
reg  [1:0]				  	i_mode  ;
reg  [WIDTH-1 : 0]  		I_DATA  ;
reg   			  		    i_CS    ;
reg   			  		    start   ;
reg  [1:0 ]                 i_valid ;
								    
wire  [WIDTH-1 : 0] 		RX_DATA ; 
wire  [WIDTH-1 : 0] 		P_DATA  ;  
 
//localparam CLK_PER = 10 ; 
 
 
 
 
 
SPI_TOP DUT(

.i_clk     (i_clk  ) ,
.i_rst     (i_rst  ) ,
.i_PDATA   (i_PDATA) ,
.i_mode    (i_mode ) ,
.i_valid   (i_valid) ,
.I_DATA    (I_DATA ) ,
.i_CS      (i_CS   ) ,
.start     (start  ) ,
.RX_DATA   (RX_DATA) ,
.P_DATA    (P_DATA )

);


initial begin

initialize ();

#3
i_rst <= 1'b1;

#7
I_DATA <= 'b11011011 ;
i_PDATA <= 'b10001101;

#5

i_valid<= 1'b0;

#50
start <= 1'b0 ;
#750
i_valid <=1'b1;
i_PDATA <= 'b11011111;
#10
i_valid <= 1'b0 ;

#1000
$stop ;

end

task initialize();
begin

i_clk <= 1'b0;
i_rst <= 1'b0;

i_PDATA <= 'b0;
i_mode  <= 2'b11 ;

I_DATA  <= 'b0 ;
i_CS    <= 1'b0;
start   <= 1'b1;
i_valid <= 1'b1;

end
endtask





always #5 i_clk = !i_clk ;

endmodule