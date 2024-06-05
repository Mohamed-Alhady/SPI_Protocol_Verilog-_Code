module Serializer #(parameter WIDTH =8)(

input  wire                    i_clk        ,
input  wire                    i_rst        ,
input  wire    [WIDTH-1 : 0]   i_PDATA      ,
input  wire                    i_valid      ,
input  wire                    ser_en       ,
input  wire                    deser_en     ,
input  wire                    ic_phase     ,
output reg                     S_DATA      


);

reg [WIDTH-1 : 0] P_data  ;

always @(posedge i_clk , negedge i_rst)
begin
	if(!i_rst)
		begin
		
			P_data <= 'b0  ;
			S_DATA <= 1'b0 ;
		end
	
	else 
		begin
			if(i_valid)
				begin
					P_data <= i_PDATA ;
				
				end
			else if(ic_phase)
				begin
					if(ser_en)
						begin
						S_DATA <= P_data[7]    ;
						P_data <= P_data << 1  ;
					
						end
				
			
					else 
						begin
							S_DATA <= S_DATA ;
							P_data <= P_data ;
						end
				end
						
			else if (!ic_phase)
				begin
					if(deser_en)
						begin
						S_DATA <= P_data[7]    ;
						P_data <= P_data << 1  ;
					
						end
				
					else 
						begin
						S_DATA <= S_DATA ;
						P_data <= P_data ;
						end
						
				
				end
		end


end


endmodule