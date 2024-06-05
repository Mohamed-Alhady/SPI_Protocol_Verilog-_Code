module Slave #(parameter WIDTH = 8) (

  //// input Signals 
input wire                 i_SCLK      ,
input wire                 i_RST       ,
input wire                 MOSI        ,
input wire [WIDTH-1 : 0]   I_DATA      ,
input wire                 I_READY     ,
input wire                 i_CS        ,
input wire [1:0]           i_mode      ,
input wire                 start       ,
							   
  //// Output Signals 
output reg                MISO     ,
output reg  [WIDTH-1:0]   RX_DATA


);
wire ic_phase , ic_pol ;
reg start_en ;

assign ic_pol   = ((i_mode == 2'b10 ) || (i_mode == 2'b11))? 1'b1 : 1'b0 ;
assign ic_phase = ((i_mode == 2'b01 ) || (i_mode == 2'b11))? 1'b1 : 1'b0 ;

reg [7:0] rx_reg , tx_reg ;

reg [3:0] tx_count ;
reg [3:0] rx_count ;
reg       tx_done ;

//assign  start_en = start_en | start ;

always @(*)
begin

	if(!i_RST )
		start_en <= 1'b0 ;
	
	else if (tx_done)
		start_en <= 1'b0;
	
	else if(start | start_en) 
		start_en <= 1'b1 ;
	
	else 
		start_en <=1'b0 ;

end


always @(posedge i_SCLK, negedge i_RST)
begin
	if (!i_RST)
		begin
			tx_count <= 'b0 ;
			tx_done  <= 'b0 ;
		end
	else 
		begin
			if(tx_count == 4'd9)
				begin
					tx_count <= 'b0 ;
					tx_done  <= 1'b1;
				end
			else if (start_en && tx_count != 4'd9)
				begin
					tx_count <= tx_count +1'b1 ;
					tx_done  <= 1'b0           ;
				end
			
			else 
				begin
					tx_count <= tx_count ;
					tx_done  <= tx_done  ;
				end
		end
end

always @(posedge i_SCLK, negedge i_RST)
begin
if(!i_RST)
	rx_count <= 1'b0 ;
	
else 
	begin
		if(rx_count == 4'd9 )
			begin
			rx_count <= 1'b0;
			
			end
		else if(rx_count != 4'd9 && !I_READY )
			begin
				rx_count <= rx_count +1'b1 ;
			
			end
	
		else 
			rx_count = 'b0 ;
	end


end

always @(*)
begin
tx_reg <= (start) ? I_DATA : tx_reg ;

end







always @(posedge i_SCLK , negedge i_RST)
begin
	if(!i_RST)
		begin
			rx_reg <= 'b0;
			tx_reg <= 'b0;
			MISO   <= 1'b0;
			RX_DATA<= 'b0 ;
		end
	
	//else if (start)
	//	begin
	//		tx_reg   <= I_DATA ;	
	//		start_en <= 1'b1   ;
	//	
	//	end
	
	
	else
		begin
			case({i_CS,ic_pol,ic_phase})
			3'b000 , 3'b011 :
				begin
					
					//rx_reg <=rx_reg ;
					
					//if (start)
					//	begin
					//		tx_reg   <= I_DATA ;
					//		//start_en <= 1'b1   ;
					//	
					//	end
					
					if(!tx_done && start_en && !start)
						begin
							MISO   <= tx_reg[7];
							tx_reg <= tx_reg << 1'b1 ;
						end
					
					
					else 
						begin
							MISO <= 1'b0 ;
						
						end
				end
					
			3'b001 , 3'b010 :
				begin
				
					//if(I_READY )
					//	begin
					//		RX_DATA <= rx_reg ;
					//		
					//	end
						
					if (!I_READY && rx_count != 4'd9)
						begin
						rx_reg <= {MOSI, rx_reg[7:1]} ;
						
						end
					else 
						begin
							RX_DATA <= RX_DATA ;
							rx_reg  <= rx_reg  ;
						end
	
				end
			default :
				begin
					rx_reg <= 'b0   ;
					tx_reg <= 'b0   ;
				
				end
		endcase
		end


end

always @(*)
begin

RX_DATA <= (I_READY) ? rx_reg : RX_DATA ;

end


always @(negedge i_SCLK , negedge i_RST)
begin
	if(!i_RST)
		begin
			rx_reg <= 'b0;
			tx_reg <= 'b0;
			MISO   <= 'b0;
			RX_DATA<= 'b0;
		end
	
	//else if (start)
	//	begin
	//		tx_reg   <= I_DATA ;	
	//		start_en <= 1'b1   ;
	//	
	//	end
	
	
	else
		begin
			case({i_CS,ic_pol,ic_phase})
			3'b000 , 3'b011 :
				begin
					
					//if(I_READY)
					//	begin
					//		RX_DATA <= rx_reg ;
					//		
					//	end
						
					if (!I_READY && rx_count != 4'd9)
                    	begin
                    	rx_reg <= {MOSI, rx_reg[7:1]} ;
				    	
						end
					else 
						begin
							RX_DATA <= RX_DATA ;
							rx_reg  <= rx_reg  ;
						end
				end
					
			3'b001 , 3'b010 :
				begin
					//rx_reg <=rx_reg ;
					
				//if (start)
				//	begin
				//		tx_reg   <= I_DATA ;
				//		//start_en <= 1'b1   ;
				//	
				//	end
					
					
					
					if(!tx_done && start_en && !start)
						begin
							MISO   <= tx_reg[7];
							tx_reg <= tx_reg << 1'b1 ;
						end
						
						
						else 
							begin
								MISO <= 1'b0 ;
								tx_reg <= tx_reg;
							
							end	
				end
			default :
				begin
					rx_reg <= 'b0   ;
					tx_reg <= 'b0   ;
				
				end
			endcase
		
		end
		
	

end


endmodule 