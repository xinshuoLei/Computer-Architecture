
module arraySortCheck_control(sorted, done, load_input, load_index, select_index, go, inversion_found, end_of_array, zero_length_array, clock, reset);
	output sorted, done, load_input, load_index, select_index;
	input go, inversion_found, end_of_array, zero_length_array;
	input clock, reset;
	
	wire sGarbage, sStart, sCheck, sSorted, sNotsorted;

	wire sGarbage_next = (sGarbage & ~go) | reset;
	wire sStart_next = ((sGarbage & go )| (sStart & go) | (sSorted & go) | (sNotsorted & go)) & ~reset;

	wire sCheck_next = ((sStart & ~go & ~zero_length_array) | (sCheck & ~end_of_array & ~inversion_found)) & ~reset;
	wire sSorted_next = ((sCheck & end_of_array) | (sStart & ~go & zero_length_array) | (sSorted & ~go)) & ~reset;
	wire sNotsorted_next = ((sCheck & inversion_found) | (sNotsorted & ~go)) & ~reset;

	dffe fsGarbage(sGarbage, sGarbage_next, clock, 1'b1, 1'b0);
	dffe fsStart(sStart, sStart_next, clock, 1'b1, 1'b0);
	dffe fsCheck(sCheck, sCheck_next, clock, 1'b1, 1'b0);
	dffe fsSorted(sSorted, sSorted_next, clock, 1'b1, 1'b0);
	dffe fsNotsorted(sNotsorted, sNotsorted_next, clock, 1'b1, 1'b0);

	assign done = sSorted | sNotsorted;
	assign sorted = sSorted;
	assign load_input = sStart;
	assign load_index = sStart | sCheck;
	assign select_index = sCheck;
endmodule
