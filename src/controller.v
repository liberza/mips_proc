module controller(input wire op[5:0],
						input wire func[5:0],
						input wire zero,
						input wire clock,
						input wire reset,
						output reg muxctrl[6:0],
						output reg memctrl[1:0],
						output reg aluctrl[2:0]
						);
	
	