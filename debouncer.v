`timescale 1ns / 1ps
module debouncer(
    input dbfreq,
    input btn_in,
    output btn_out
    );

reg[7:0] counter;

always @ (posedge dbfreq)
begin
	if (btn_in == 0)
	begin
		counter <= 0;
		btn_out <= 0;
	end
	else
	begin
		counter <= counter + 1;
		if (counter == 8'b11111111)
		begin
			btn_out <= 1;
			counter <= 0;
		end
	end
end

endmodule

