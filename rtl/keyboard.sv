//
// HT1080Z for MiSTer Keyboard module
//
// Copyright (c) 2009-2011 Mike Stirling
// Copyright (c) 2015-2017 Sorgelig
//
// All rights reserved
//
// Redistribution and use in source and synthezised forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// * Redistributions in synthesized form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//
// * Neither the name of the author nor the names of other contributors may
//   be used to endorse or promote products derived from this software without
//   specific prior written agreement from the author.
//
// * License is granted for non-commercial use only.  A fee may not be charged
//   for redistributions as source code or in synthesized/hardware form without
//   specific prior written agreement from the author.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
//
// PS/2 scancode to TRS-80 matrix conversion
//

module keyboard
(
	input             reset,		// reset when driven high
	input             clk_sys,		// should be same clock as clk_sys from HPS_IO
	input             dragon,
	input             key_strobe,
	input       [7:0] key_code,   // PS2 keycode
	input             key_pressed,
	input             key_extended,

	input       [7:0] addr,       // bottom 7 address lines from CPU for memory-mapped access
	output  reg [7:0] kb_rows,    // data lines returned from scanning

	input             kblayout,   // 0 = TRS-80 keyboard arrangement; 1 = PS/2 key assignment

	input             joystick_1_button,
	input             joystick_2_button,
	input             joystick_hilo,
	
	output reg [11:1] Fn = 0,
	output reg  [2:0] modif = 0
);

reg  [7:0] keys[7:0];
reg		  shiftstate = 0;

// Output addressed row to ULA
always @(*) begin
	kb_rows<=8'hff;
	
	
	if (joystick_1_button) kb_rows[1]<=0;
	if (joystick_2_button) kb_rows[0]<=0;
	kb_rows[7]<=joystick_hilo;
	
	if (dragon) begin
		if (keys[4][0]==1'b0) if (addr[0] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[4][1]==1'b0) if (addr[1] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[4][2]==1'b0) if (addr[2] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[4][3]==1'b0) if (addr[3] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[4][4]==1'b0) if (addr[4] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[4][5]==1'b0) if (addr[5] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[4][6]==1'b0) if (addr[6] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[4][7]==1'b0) if (addr[7] == 1'b0) kb_rows[0] <= 1'b0;

	if (keys[5][0]==1'b0) if (addr[0] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[5][1]==1'b0) if (addr[1] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[5][2]==1'b0) if (addr[2] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[5][3]==1'b0) if (addr[3] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[5][4]==1'b0) if (addr[4] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[5][5]==1'b0) if (addr[5] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[5][6]==1'b0) if (addr[6] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[5][7]==1'b0) if (addr[7] == 1'b0) kb_rows[1] <= 1'b0;

	if (keys[0][0]==1'b0) if (addr[0] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[0][1]==1'b0) if (addr[1] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[0][2]==1'b0) if (addr[2] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[0][3]==1'b0) if (addr[3] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[0][4]==1'b0) if (addr[4] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[0][5]==1'b0) if (addr[5] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[0][6]==1'b0) if (addr[6] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[0][7]==1'b0) if (addr[7] == 1'b0) kb_rows[2] <= 1'b0;

	if (keys[1][0]==1'b0) if (addr[0] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[1][1]==1'b0) if (addr[1] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[1][2]==1'b0) if (addr[2] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[1][3]==1'b0) if (addr[3] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[1][4]==1'b0) if (addr[4] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[1][5]==1'b0) if (addr[5] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[1][6]==1'b0) if (addr[6] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[1][7]==1'b0) if (addr[7] == 1'b0) kb_rows[3] <= 1'b0;

	if (keys[2][0]==1'b0) if (addr[0] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[2][1]==1'b0) if (addr[1] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[2][2]==1'b0) if (addr[2] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[2][3]==1'b0) if (addr[3] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[2][4]==1'b0) if (addr[4] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[2][5]==1'b0) if (addr[5] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[2][6]==1'b0) if (addr[6] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[2][7]==1'b0) if (addr[7] == 1'b0) kb_rows[4] <= 1'b0;

	if (keys[3][0]==1'b0) if (addr[0] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[3][1]==1'b0) if (addr[1] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[3][2]==1'b0) if (addr[2] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[3][3]==1'b0) if (addr[3] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[3][4]==1'b0) if (addr[4] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[3][5]==1'b0) if (addr[5] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[3][6]==1'b0) if (addr[6] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[3][7]==1'b0) if (addr[7] == 1'b0) kb_rows[5] <= 1'b0;

	if (keys[6][0]==1'b0) if (addr[0] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][1]==1'b0) if (addr[1] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][2]==1'b0) if (addr[2] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][3]==1'b0) if (addr[3] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][4]==1'b0) if (addr[4] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][5]==1'b0) if (addr[5] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][6]==1'b0) if (addr[6] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][7]==1'b0) if (addr[7] == 1'b0) kb_rows[6] <= 1'b0;
	end
	else begin
	
	if (keys[0][0]==1'b0) if (addr[0] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[0][1]==1'b0) if (addr[1] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[0][2]==1'b0) if (addr[2] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[0][3]==1'b0) if (addr[3] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[0][4]==1'b0) if (addr[4] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[0][5]==1'b0) if (addr[5] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[0][6]==1'b0) if (addr[6] == 1'b0) kb_rows[0] <= 1'b0;
	if (keys[0][7]==1'b0) if (addr[7] == 1'b0) kb_rows[0] <= 1'b0;

	if (keys[1][0]==1'b0) if (addr[0] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[1][1]==1'b0) if (addr[1] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[1][2]==1'b0) if (addr[2] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[1][3]==1'b0) if (addr[3] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[1][4]==1'b0) if (addr[4] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[1][5]==1'b0) if (addr[5] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[1][6]==1'b0) if (addr[6] == 1'b0) kb_rows[1] <= 1'b0;
	if (keys[1][7]==1'b0) if (addr[7] == 1'b0) kb_rows[1] <= 1'b0;

	if (keys[2][0]==1'b0) if (addr[0] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[2][1]==1'b0) if (addr[1] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[2][2]==1'b0) if (addr[2] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[2][3]==1'b0) if (addr[3] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[2][4]==1'b0) if (addr[4] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[2][5]==1'b0) if (addr[5] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[2][6]==1'b0) if (addr[6] == 1'b0) kb_rows[2] <= 1'b0;
	if (keys[2][7]==1'b0) if (addr[7] == 1'b0) kb_rows[2] <= 1'b0;

	if (keys[3][0]==1'b0) if (addr[0] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[3][1]==1'b0) if (addr[1] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[3][2]==1'b0) if (addr[2] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[3][3]==1'b0) if (addr[3] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[3][4]==1'b0) if (addr[4] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[3][5]==1'b0) if (addr[5] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[3][6]==1'b0) if (addr[6] == 1'b0) kb_rows[3] <= 1'b0;
	if (keys[3][7]==1'b0) if (addr[7] == 1'b0) kb_rows[3] <= 1'b0;

	if (keys[4][0]==1'b0) if (addr[0] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[4][1]==1'b0) if (addr[1] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[4][2]==1'b0) if (addr[2] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[4][3]==1'b0) if (addr[3] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[4][4]==1'b0) if (addr[4] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[4][5]==1'b0) if (addr[5] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[4][6]==1'b0) if (addr[6] == 1'b0) kb_rows[4] <= 1'b0;
	if (keys[4][7]==1'b0) if (addr[7] == 1'b0) kb_rows[4] <= 1'b0;

	if (keys[5][0]==1'b0) if (addr[0] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[5][1]==1'b0) if (addr[1] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[5][2]==1'b0) if (addr[2] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[5][3]==1'b0) if (addr[3] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[5][4]==1'b0) if (addr[4] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[5][5]==1'b0) if (addr[5] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[5][6]==1'b0) if (addr[6] == 1'b0) kb_rows[5] <= 1'b0;
	if (keys[5][7]==1'b0) if (addr[7] == 1'b0) kb_rows[5] <= 1'b0;

	if (keys[6][0]==1'b0) if (addr[0] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][1]==1'b0) if (addr[1] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][2]==1'b0) if (addr[2] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][3]==1'b0) if (addr[3] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][4]==1'b0) if (addr[4] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][5]==1'b0) if (addr[5] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][6]==1'b0) if (addr[6] == 1'b0) kb_rows[6] <= 1'b0;
	if (keys[6][7]==1'b0) if (addr[7] == 1'b0) kb_rows[6] <= 1'b0;
	
	end
/*
	if (keys[7][0]==1'b0) if (addr[0] == 1'b0) kb_rows[7] <= 1'b0;
	if (keys[7][1]==1'b0) if (addr[1] == 1'b0) kb_rows[7] <= 1'b0;
	if (keys[7][2]==1'b0) if (addr[2] == 1'b0) kb_rows[7] <= 1'b0;
	if (keys[7][3]==1'b0) if (addr[3] == 1'b0) kb_rows[7] <= 1'b0;
	if (keys[7][4]==1'b0) if (addr[4] == 1'b0) kb_rows[7] <= 1'b0;
	if (keys[7][5]==1'b0) if (addr[5] == 1'b0) kb_rows[7] <= 1'b0;
	if (keys[7][6]==1'b0) if (addr[6] == 1'b0) kb_rows[7] <= 1'b0;
	if (keys[7][7]==1'b0) if (addr[7] == 1'b0) kb_rows[7] <= 1'b0;
*/

end
/*
  reg [7:0] key_data;
assign key_data =  (addr[0] ? keys[0] : 8'b11111111)
                 & (addr[1] ? keys[1] : 8'b11111111)
                 & (addr[2] ? keys[2] : 8'b11111111)
                 & (addr[3] ? keys[3] : 8'b11111111)
                 & (addr[4] ? keys[4] : 8'b11111111)
                 & (addr[5] ? keys[5] : 8'b11111111)
                 & (addr[6] ? keys[6] : 8'b11111111)
                 & (addr[7] ? keys[7] : 8'b11111111);
*/

always @(posedge clk_sys) begin
	reg old_reset;
	old_reset <= reset;

	if(~old_reset & reset) begin
		keys[0] <= 8'b11111111;
		keys[1] <= 8'b11111111;
		keys[2] <= 8'b11111111;
		keys[3] <= 8'b11111111;
		keys[4] <= 8'b11111111;
		keys[5] <= 8'b11111111;
		keys[6] <= 8'b11111111;
		keys[7] <= 8'b11111111;
	end

	if(key_strobe) begin
		case(key_code)
			8'h59: modif[0]<= key_pressed; // right shift
			8'h11: modif[1]<= key_pressed; // alt
			8'h14: modif[2]<= key_pressed; // ctrl
			8'h05: Fn[1] <= key_pressed; // F1
			8'h06: Fn[2] <= key_pressed; // F2
			8'h04: Fn[3] <= key_pressed; // F3
			8'h0C: Fn[4] <= key_pressed; // F4
			8'h03: Fn[5] <= key_pressed; // F5
			8'h0B: Fn[6] <= key_pressed; // F6
			8'h83: Fn[7] <= key_pressed; // F7
			8'h0A: Fn[8] <= key_pressed; // F8
			8'h01: Fn[9] <= key_pressed; // F9
			8'h09: Fn[10]<= key_pressed; // F10
			8'h78: Fn[11]<= key_pressed; // F11
		endcase

		case(key_code)

			//////////////////////////////
			// For the first group of keys, the keyboard mode (TRS or PC) doesn't matter
			// The results are the same either way
			//////////////////////////////

			8'h1c : keys[0][1] <= ~key_pressed; // A
			8'h32 : keys[0][2] <= ~key_pressed; // B
			8'h21 : keys[0][3] <= ~key_pressed; // C
			8'h23 : keys[0][4] <= ~key_pressed; // D
			8'h24 : keys[0][5] <= ~key_pressed; // E
			8'h2b : keys[0][6] <= ~key_pressed; // F
			8'h34 : keys[0][7] <= ~key_pressed; // G

			8'h33 : keys[1][0] <= ~key_pressed; // H
			8'h43 : keys[1][1] <= ~key_pressed; // I
			8'h3b : keys[1][2] <= ~key_pressed; // J
			8'h42 : keys[1][3] <= ~key_pressed; // K
			8'h4b : keys[1][4] <= ~key_pressed; // L
			8'h3a : keys[1][5] <= ~key_pressed; // M
			8'h31 : keys[1][6] <= ~key_pressed; // N
			8'h44 : keys[1][7] <= ~key_pressed; // O

			8'h4d : keys[2][0] <= ~key_pressed; // P
			8'h15 : keys[2][1] <= ~key_pressed; // Q
			8'h2d : keys[2][2] <= ~key_pressed; // R
			8'h1b : keys[2][3] <= ~key_pressed; // S
			8'h2c : keys[2][4] <= ~key_pressed; // T
			8'h3c : keys[2][5] <= ~key_pressed; // U
			8'h2a : keys[2][6] <= ~key_pressed; // V
			8'h1d : keys[2][7] <= ~key_pressed; // W

			8'h22 : keys[3][0] <= ~key_pressed; // X
			8'h35 : keys[3][1] <= ~key_pressed; // Y
			8'h1a : keys[3][2] <= ~key_pressed; // Z

			8'h16 : keys[4][1] <= ~key_pressed;	// 1
			8'h26 : keys[4][3] <= ~key_pressed; // 3
			8'h25 : keys[4][4] <= ~key_pressed; // 4
			8'h2e : keys[4][5] <= ~key_pressed; // 5


			8'h41 : keys[5][4] <= ~key_pressed; // ,<
			8'h49 : keys[5][6] <= ~key_pressed; // .>
			8'h4a : keys[5][7] <= ~key_pressed; // /?

			8'h5a : keys[6][0] <= ~key_pressed; // ENTER

			8'h0d : keys[6][1] <= ~key_pressed; // TAB (PC)    -> CLEAR (TRS)
			8'h76 : keys[6][2] <= ~key_pressed; // ESCAPE (PC) -> BREAK (TRS)

			8'h75 : keys[3][3] <= ~key_pressed; // UP ARROW
			8'h72 : keys[3][4] <= ~key_pressed; // DN ARROW
			8'h6B : keys[3][5] <= ~key_pressed; // LF ARROW (PC)  -> LF ARROW (TRS)
			8'h66 : keys[3][5] <= ~key_pressed; // BACKSPACE (PC) -> LF ARROW (TRS)
			8'h74 : keys[3][6] <= ~key_pressed; // RT ARROW
			8'h29 : keys[3][7] <= ~key_pressed; // SPACE


			8'h12 : begin
						keys[6][7] <= ~key_pressed; // Left shift
						shiftstate <= key_pressed;
					end

			8'h59 : begin
						keys[6][7] <= ~key_pressed; // Right shift
						shiftstate <= key_pressed;
					end

			8'h58 : begin
						keys[4][0] <= ~key_pressed; // Caps lock (= shift-0 on CoCo)
						keys[6][7] <= ~key_pressed;
					end

//			8'h14 : keys[7][1] <= key_pressed; // CTRL (Symbol Shift)


			// Numpad new keys:

			8'h7b : keys[5][5] <= ~key_pressed; // keypad -
			8'h6c : keys[6][1] <= ~key_pressed; // KYPD-7 (PC) -> CLEAR (TRS)

			8'h7c : begin
						keys[5][2] <= ~key_pressed; // * (shifted)
						keys[6][7] <= ~key_pressed;
					end

			8'h79 : begin
						keys[5][3] <= ~key_pressed; // + (shifted)
						keys[6][7] <= ~key_pressed;
					end


			//////////////////////////////
			// For the next group of keys, results depend on the keyboard mode (TRS or PC)
			//////////////////////////////

			8'h54 : 															// [ (PC backslash)
					if (kblayout == 0) begin
						keys[0][0] <= ~key_pressed;						// -> @ TRS			(TRS layout)
					end														// -> no mapping	(PC layout)

			8'h45 :															// 0
					if ((kblayout == 1) && (shiftstate == 1)) begin
						keys[5][1] <= ~key_pressed;						// PC ')' -> 9 + shift (TRS)
						keys[6][7] <= ~key_pressed;
					end
					else begin
						keys[4][0] <= ~key_pressed;						// 0
					end

			8'h1e :															// 2
					if ((kblayout == 1) && (shiftstate == 1)) begin
						keys[0][0] <= ~key_pressed;						// PC '@" -> @ (TRS)
						keys[6][7] <= key_pressed;
					end
					else begin
						keys[4][2] <= ~key_pressed;						// 2
					end


			8'h36 :															// 6
					if ((kblayout == 0) || (shiftstate == 0)) begin
						keys[4][6] <= ~key_pressed;						// 6 (no mapping for '^' from PC)
					end

			8'h3d :															// 7
					if ((kblayout == 1) && (shiftstate == 1)) begin
						keys[4][6] <= ~key_pressed;						// PC '&' -> '6' + shift (TRS)
						keys[6][7] <= ~key_pressed;
					end
					else begin
						keys[4][7] <= ~key_pressed;						// 7
					end

			8'h3e :															// 8
					if ((kblayout == 1) && (shiftstate == 1)) begin
						keys[5][2] <= ~key_pressed;						// PC '*' -> ':' + shift (TRS)
						keys[6][7] <= ~key_pressed;
					end
					else begin
						keys[5][0] <= ~key_pressed;						// 8
					end

			8'h46 :															// 9
					if ((kblayout == 1) && (shiftstate == 1)) begin
						keys[5][0] <= ~key_pressed;						// PC '(' -> '8' + shift (TRS)
						keys[6][7] <= ~key_pressed;
					end
					else begin
						keys[5][1] <= ~key_pressed;						// 9
					end


			8'h4e :															// - (minus)
					if (kblayout == 0) begin
						keys[5][2] <= ~key_pressed;						// :* (TRS)
					end
					else if (shiftstate == 0) begin
						keys[5][5] <= ~key_pressed;						// - (minus)
					end

			8'h4c :															// ;:
					if ((kblayout == 1) && (shiftstate == 1)) begin
						keys[5][2] <= ~key_pressed;						// ':' (not shifted)  (TRS)
						keys[6][7] <= key_pressed;
					end
					else begin
						keys[5][3] <= ~key_pressed;						// - (minus)
					end

			8'h55 :															// = +
					if (kblayout == 1) begin
						if (shiftstate == 0) begin						// if '=' on PC keyboard
							keys[5][5] <= ~key_pressed;					// '-' + shift (TRS)
							keys[6][7] <= ~key_pressed;
						end
						else begin											// if '+' on PC keyboard
							keys[5][3] <= ~key_pressed;					// ';' + shift (TRS)
							keys[6][7] <= ~key_pressed;
						end
					end
					else begin
						keys[5][5] <= ~key_pressed;						// =
					end

			8'h52 :															// ' "
					if (kblayout == 1) begin
						if (shiftstate == 1) begin						// if (double-quote) on PC keyboard
							keys[4][2] <= ~key_pressed;					// '2' + shift (TRS)
							keys[6][7] <= ~key_pressed;
						end
						else begin											// if (apostrophe) on PC keyboard
							keys[4][7] <= ~key_pressed;					// '7' + shift (TRS)
							keys[6][7] <= ~key_pressed;
						end
					end														// otherwise no mapping (TRS)

			default: ;
		endcase
	end
end

endmodule
