
module index(
	input clk,
	input in,
	input RST,
	input [63:0] ins,
	output [15:0] check_out,
	output [63:0] ins_out,
	output out);
	
parameter 	IDLE	= 2'b00,
			s_0 	= 2'b01;
			fault   = 2'b10;
			nodata  = 64d'0;
			
reg [1:0] state;

reg [1:0] check;
wire [1:0] ifneed;
reg [63:0] temp;
wire [63:0] store;
reg [1:0] che_i;
wire[15:0] check_sre;
wire[63:0] store_ins;
wire [63:0] load_ins;
reg [15:0] mid;
wire[1:0] if_trk;
reg[1:0] yes_command;
reg[11:0] refnum;
 

assign ins_out = temp;
assign check_out = mid;
assign che_i = ifneed;
assign yes_command =if_trk;
	
	BIDcheck(.clk_in(clk),
				.input_ins(ins),
				.enable_in(in),
				.check_out(check_sre),
				.output_ins(store),
				.logic_out(if_trk)
				);
	BIDpass(.clk_in(clk),
				.input_ins(store_ins),
				.enable_in(in),
				.output_ins(load_ins),
				.logic_out(idneed)
				);
	
always @ (posedge clk or posedge RST) begin
    
	
	
	if (RST) begin
	tate <=IDLE;
	mid<= #1 16'd0;
	temp <= #1 64'd0;
	out <=#1 1'b0;
	end
	else begin
	
	case (state)
	IDLE:	begin
			
				if (in == 1 & yes_command == 1) begin
				state <= s_1;
				mid <= #1 check_sre;
				store_ins <= #1 store;
				refnum <= #1 refnum+1;
				end
				else if(in == 0)
				state <=IDLE;
				else
				state <= s_0;
			end
	s_0: 	begin
	
				if (in == 1 & yes_command == 0 & che_i == 1 & refnum >= 5000) begin
				state <= s_1;
				temp <= #1 load_ins;
				out <= #1 1'b1;
				else
				state <= fault;
				end
			end
	fault:	begin
			mid<= #1 16'd0
			temp <= #1 64'd0;
			out <=#1 1'b0;
			state <= IDLE;
			end
	default:	state <= IDLE;
	endcase
	end
end

endmodule

