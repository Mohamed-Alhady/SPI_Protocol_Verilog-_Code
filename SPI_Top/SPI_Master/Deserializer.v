module DeSerializer #(parameter WIDTH =8)(

input  wire                    i_clk        ,
input  wire                    i_rst        ,
input  wire                    MISO         ,
input  wire                    deser_en     ,
input  wire                    ser_en       ,
input  wire                    ic_phase     ,
output reg   [WIDTH-1 : 0]     P_DATA       

);

reg [WIDTH-1 : 0] P_DATA_R   ;
reg [3:0]         data_cnt  ;

always @(posedge i_clk , negedge i_rst)
begin
if(!i_rst)
	begin
		P_DATA_R <= 'b0    ;
		P_DATA   <= 'b0    ;
		data_cnt <= 1'b0   ;
	end

else
	begin
		if(ic_phase)
			begin
				if(deser_en && data_cnt == 4'd8)
				begin
					data_cnt <= 'b0                   ;
					P_DATA   <= P_DATA_R              ;
					P_DATA_R  <={MISO,P_DATA_R[7:1]}  ;
					
						
				end
				else if(deser_en && data_cnt != 4'd8)
					begin
					P_DATA_R  <={MISO,P_DATA_R[7:1]}  ;
					data_cnt  <= data_cnt + 1'b1      ;
					end
				
				else
					begin
				
					P_DATA_R   <= P_DATA_R      ;
					P_DATA     <= P_DATA        ;
					data_cnt    <= data_cnt     ;
					end
			end
			
		else if(!ic_phase)
			begin
			
			if(ser_en && data_cnt == 4'd8)
			begin
				data_cnt <= 'b0                   ;
				P_DATA   <= P_DATA_R              ;
				P_DATA_R  <={MISO,P_DATA_R[7:1]}  ;
				
					
			end
			else if(ser_en && data_cnt != 4'd8)
				begin
				P_DATA_R  <={MISO,P_DATA_R[7:1]}  ;
				data_cnt  <= data_cnt + 1'b1      ;
				end
			
			else
				begin
			
				P_DATA_R   <= P_DATA_R      ;
				P_DATA     <= P_DATA        ;
				data_cnt    <= data_cnt     ;
				end
		
			
			end
				
	end

end


endmodule