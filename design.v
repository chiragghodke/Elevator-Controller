// Code your design here
// Code your design here
module elevator_controller (request_floor, in_current_floor, clk, reset, complete, direction,over_time, over_weight, weigh_alert, door_alert, out_current_floor);

  input [3:0] request_floor; // the 4 bit input request_floor
  input [3:0]in_current_floor; // the 4 bit input   request_floor; 
  input clk; //we generate a low frequency clock 
  input reset; // the 1 bit input reset
	
  input over_time; //the 1 bit input which indicates the door keep open for 3 minutes 
  input over_weight; // the 1 bit input which indicates the weight in the elevator is larger than 600kgs

//the output pins

output direction; // the 1 bit output which indicates the direction of the elevator 
output complete; // the 1 bit output which indicates whether elevalor is running or stopped

output door_alert; // the 1 bit output which indicates the door keep open for 3 minutes 
output weigh_alert; // the 1 bit output which ndicates the weight in the elevator is larger than 600kgs 
  output [3:0] out_current_floor; // the 4 bit ourput which shows the current floor


  //register parameters

reg r_direction; // 1 bit register connected to the output direction 
reg r_complete; // 1 bit register connected to the output complete

reg r_door_alert;// 1 bit register connected to the output door_alert 
reg r_weigh_alert;// 1 bit register connected to the output weigh_alert

reg [3:0] r_out_current_floor; // 4 bit register connected to the output out_current_floor;

//clock generator register

reg [12:0] clk_count;

reg clk_200;

reg clk_trigger;

//match pins and registers

assign direction=r_direction;
assign complete=r_complete;
assign door_alert=r_door_alert; 
assign weigh_alert=r_weigh_alert;
assign out_current_floor= r_out_current_floor;

//initialization

always @(negedge reset) begin

  clk_200=1'b0;

  clk_count=0;

  clk_trigger=1'b0;

  //reset the clock registers

  r_complete=1'b0; // set the default value to 0
  r_door_alert=1'b0; //set the default value to 0
  r_weigh_alert=1'b0; //set the default value to 0

end
  
// clock generator block

always @ (posedge clk) begin 
	if (clk_trigger) begin 
		clk_count=clk_count+1; 
    end
  

	if (clk_count==5000) begin

		clk_200=~clk_200;

		clk_count=0;

	end

end
  
// in the case if there is a request floor

always @(request_floor) begin

    clk_trigger=1; 
    clk_200=~clk_200;

//trigger the clock generator

	r_out_current_floor <= in_current_floor;

// put the value of the input in_current_floor to the register r_out_current_floor

end

  

//the normal running cases of the elevator 
always @ (posedge clk) begin

	if (!reset && !over_time && !over_weight) begin 
    // case 1: the normal running case of the elevator

      if (request_floor > r_out_current_floor) begin

			r_direction=1'b1;

			r_out_current_floor <=r_out_current_floor << 1;
				
      	end
      
		else if (request_floor < r_out_current_floor) begin
		r_direction= 1'b0;

		r_out_current_floor <=r_out_current_floor >> 1;
    	end
	
		else if (request_floor == r_out_current_floor) begin

		r_complete=1; 
        r_direction=0;

		end
	end
  
	//case 2: the door keep open for more than 3 minutes
	else if (!reset && over_time) begin

		r_door_alert= 1 ;

		r_complete = 1 ;

		r_weigh_alert = 0 ;

		r_direction = 0;

		r_out_current_floor <= r_out_current_floor;

	end

//case 3: the total weigt in the elevator is more than 600kgs

	else if ( reset && over_weight) begin

		r_door_alert=0;

		r_weigh_alert=1;

		r_complete = 1 ;

		r_direction = 0;

		r_out_current_floor <= r_out_current_floor;
	end
end
endmodule

  
  
  
