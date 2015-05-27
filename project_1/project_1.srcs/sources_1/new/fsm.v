`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2015 11:25:21 AM
// Design Name: 
// Module Name: fsm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fsm(
    input clock,
    input [31:0] ledBits,
    input tvalid,
    output tready,
    input tlast,
    output [7:0] je
    );
    
    reg [7:0] je;
    reg [28:0] clockAccumulator = 'd0;
    reg [23:0] bitCount = 'd0;
    reg [8:0] ledCount = 'd0;
    reg newclock;
    reg tready = 0;
    reg [5:0]state = 0;
    reg [5:0]nextstate = 0;
    
    always @(posedge clock) begin
        state = nextstate;
        
        if (state == 'd0) begin
            tready = 'd1;
            nextstate = 'd1;
        end    
        else if (state == 'd1) begin
            if (tready == 'd1 && tvalid == 'd1) begin
                nextstate = 'd2;
                //validReady = 'd0;
                clockAccumulator = 'd0;
                //bitCount = 'd0;
                //newclock = 'd1;
                tready = 'd0;
            end
        end
        else if (state == 'd2) begin
            clockAccumulator = clockAccumulator + 'd1;
            
            if (clockAccumulator > 'd150) begin
                nextstate = 'd3;
                clockAccumulator = 'd0;
                //tready = 'd0;
                newclock = 'd1;
                bitCount = 'd0;
            end
        end
        else if (state == 'd3) begin
            clockAccumulator = clockAccumulator + 'd1;

            //if (bitCount > 'd23) begin
              //  newclock = 'd0;
              //  nextstate = 'd0;
            //end
            
            if (ledBits[bitCount] == 'd1) begin
                if (clockAccumulator >= 'd125) begin
                    //newclock = 'd1;
                    if (bitCount == 'd23) begin
                        newclock = 'd0;
                        nextstate = 'd0;
                    end
                    else begin
                        newclock = 'd1;
                        clockAccumulator = 'd0;
                        bitCount = bitCount + 'd1;
                    end
                end
                else if (clockAccumulator >= 'd80) begin
                    newclock = 'd0;
                end
            end
            else begin
                if (clockAccumulator >= 'd125) begin
                    /*newclock = 'd1;
                    clockAccumulator = 'd0;
                    bitCount = bitCount + 'd1;*/
                    if (bitCount == 'd23) begin
                        newclock = 'd0;
                        nextstate = 'd0;
                    end
                    else begin
                        newclock = 'd1;
                        clockAccumulator = 'd0;
                        bitCount = bitCount + 'd1;
                    end
                end
                else if (clockAccumulator >= 'd40) begin
                    newclock = 'd0;
                end
            end
            

        end
    end

    always @(*) begin
        je[4] = tlast;
        je[5] = tready;
        je[6] = tvalid;
        je[7] = newclock;
    end

endmodule





