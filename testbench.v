`timescale 1ns/1ns 

module elevator_controller_tb;
  reg [3:0] request_floor;
  reg [3:0] in_current_floor;
  reg clk;
  reg reset;
  reg over_time;
  reg over_weight;

  wire direction;
  wire complete;
  wire door_alert;
  wire weigh_alert;

  wire [3:0] out_current_floor;

  elevator_controller elevator_controller_test (
    .request_floor(request_floor),
    .in_current_floor(in_current_floor),
    .clk(clk),
    .reset(reset),
    .direction(direction),
    .out_current_floor(out_current_floor),
    .complete(complete),
    .over_time(over_time),
    .over_weight(over_weight),
    .door_alert(door_alert),
    .weigh_alert(weigh_alert)
  );

  initial begin
    clk = 0;
    reset = 1;
    over_time = 0;
    over_weight = 0;
    
    #50 reset = 0;
    #50 reset = 1;
    #50 request_floor = 4'b0001;
    in_current_floor = 4'b1000;
    #50 reset = 1;
    #50 reset = 0;
    #50 request_floor = 4'b0001;
    in_current_floor = 4'b1000;
    #50 reset = 1;
    #50 reset = 0;
    #50 over_time = 1;
    #50 reset = 1;
    #50 reset = 0;
    #50 over_weight = 1;
    #50 reset = 1;
    #100 $finish;
  end
  
  initial begin
    		    $monitor("reset=%b,request_floor=%b,in_current_floor=%b,over_time=%b,over_weight=%b",reset,request_floor,in_current_floor,over_time,over_weight);
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,reset,request_floor,in_current_floor,over_time,over_weight);
  end

  always #50 clk = ~clk;
endmodule
