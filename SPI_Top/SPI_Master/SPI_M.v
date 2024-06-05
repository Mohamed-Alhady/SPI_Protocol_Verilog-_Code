module CLK_GEN(

/// input signals /////
input wire        i_clk              ,      
input wire        i_rst              ,
input wire [1:0]  i_mode             ,
input wire        i_valid            ,

////output signals /////
output reg  o_clk              ,
output reg  o_ready            ,
output reg  o_leading_edge     ,
output reg  o_trailing_edge

);
wire      ic_pol , ic_phase ;
//reg       o_leading_edge_d , o_trailing_edge_d   ;
reg [2:0] bit_count, byte_count ;

reg valid_en  ;

assign ic_pol   = ((i_mode == 2'b10 ) || (i_mode == 2'b11))? 1'b1 : 1'b0 ;
assign ic_phase = ((i_mode == 2'b01 ) || (i_mode == 2'b11))? 1'b1 : 1'b0 ;

always @(posedge i_clk , negedge i_rst)
begin
if(!i_rst)
	bit_count <= 3'b0 ;

else 
begin

	if(bit_count == 3'd7)
		begin
		bit_count <= 1'b0 ;
		end
	
	else if (valid_en)
	bit_count <= bit_count + 1'b1 ;

	else 
	bit_count <= 1'b0 ;
		

end	

end

always @(posedge i_clk , negedge i_rst)
begin
	if(!i_rst)
	begin
		byte_count <= 'b0 ;
		o_ready    <= 1'b0;
	end

	else 
	begin
		if(bit_count == 3'd7 && byte_count == 3'd7)
		begin
			byte_count <= 3'b0 ;
			o_ready    <= 1'b1 ;
		end
		
		else if(byte_count != 3'd7 && bit_count == 3'd7 )
			byte_count <= byte_count +1'b1 ;
			
		else 
			begin
			byte_count <= byte_count ;
			o_ready <= 1'b0 ;
			end
	end

end	

always @(posedge i_clk , negedge i_rst)
begin

	if(!i_rst )
		valid_en <= 1'b0 ;
	
	else if (o_ready)
		valid_en <= 1'b0;
	
	else if(i_valid | valid_en) 
		valid_en <= 1'b1 ;
	
	else 
		valid_en <=1'b0 ;

end

always @(posedge i_clk , negedge i_rst)
begin

o_leading_edge <= 1'b0;
o_clk <= o_clk ;
o_trailing_edge <= 1'b0;

	if(!i_rst)
	o_clk <= ic_pol ;
	
	else
	begin
		if(bit_count == 3'd2)
		begin
			o_leading_edge <= 1'b1;
			o_trailing_edge<=1'b0   ;
			o_clk          <= o_clk ;
			
		end
		
		else if(bit_count == 3'd3)
		begin
			o_clk <= ~o_clk ;
			o_leading_edge <= 1'b0  ;
			o_trailing_edge<=1'b0   ;
			
		end
		
		else if(bit_count == 3'd6)
			begin
				o_trailing_edge <= 1'b1;
				o_leading_edge <= 1'b0  ;
				o_clk          <= o_clk ;
				
			end	
			
		else if(bit_count == 3'd7)		
			begin		
				o_clk <= ~o_clk ;
				o_leading_edge <= 1'b0  ;
				o_trailing_edge<=1'b0   ;
				
			end	
		
		else 
		begin
		
			o_leading_edge <= 1'b0  ;
			o_trailing_edge<=1'b0   ;
			o_clk          <= o_clk ;
		end
	//case (bit_count)
	//
	//	3'd2: begin
	//		o_leading_edge <= 1'b1;
	//		o_trailing_edge<=1'b0   ;
	//		o_clk          <= o_clk ;
	//	
	//	end
	//	3'd3 , 3'd7 : begin
	//		o_clk <= ~o_clk ;
	//		o_trailing_edge<=1'b0   ;
	//		o_leading_edge <= 1'b0;
	//	
	//	end
	//	
	//	3'd6 : begin
	//		o_leading_edge <= 1'b0;
	//		o_trailing_edge<=1'b1   ;
	//		o_clk          <= o_clk ;
	//	
	//	end
	//	
	//	default : begin
	//	
	//		o_leading_edge <= 1'b0;
	//		o_clk <= o_clk ;
	//		o_trailing_edge <= 1'b0;
	//		
	//	end
	//	
	//endcase
	end



end


//always @(posedge i_clk , negedge i_rst)
//begin
//	if(!i_rst)
//	begin
//		o_leading_edge <= 1'b0  ;
//		o_trailing_edge<=1'b0   ;
//		
//	end
//	
//	else
//	begin
//		o_leading_edge <= o_leading_edge_d     ;
//		o_trailing_edge<= o_trailing_edge_d    ;
//				
//	end
//
//
//
//
//end






endmodule
