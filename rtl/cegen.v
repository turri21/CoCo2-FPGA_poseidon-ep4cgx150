module CEGen(
	input reset,
	input clk,
	output reg clk_en
);

parameter SYSTEM_CLOCK = 32'd12_000_000;
parameter OUT_CLOCK    = 32'd12_000;

reg [31:0] cnt;
always @(posedge clk) begin
	if(reset) begin
		cnt <= 32'd0;
		clk_en <= 1'b0;
	end else begin
		clk_en <= 1'b0;

		if(cnt < SYSTEM_CLOCK)
			cnt <= cnt + OUT_CLOCK;
		else begin
			cnt <= cnt - SYSTEM_CLOCK + OUT_CLOCK;
			clk_en <= 1'b1;
		end
	end
end

endmodule
