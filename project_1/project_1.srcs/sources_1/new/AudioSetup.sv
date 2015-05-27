`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2015 08:13:55 PM
// Design Name: 
// Module Name: AudioSetup
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


module AudioSetup(
             input clk,
             input [6:0]regAddress,
             input [6:0]data,
             input transmit,
             output sdin,
             output sclk
    );
    
    localparam STATE_IDLE = 0;
    localparam STATE_START = 1;
    localparam STATE_ADDR = 2;
    localparam STATE_RW = 3;
    localparam STATE_WACK = 4;
    localparam STATE_SEC_ADDR = 5;
    localparam STATE_DATA = 6;
    localparam STATE_WACK2 = 7;
    localparam STATE_WACK3 = 8;
    localparam STATE_STOP = 10;
    
    logic [11:0]clkAccum;
    integer count = 7;
    
    logic clkOn;
    logic writeDone;
    logic [4:0]state;
    logic [6:0]mainAddr;
    logic reset;
       
    assign mainAddr = 'b0011010;
    assign reset = transmit;
    assign clkOn = 'd1; 
    
    //100 kHZ clk from 100 MHz source
    always @ (posedge clk) begin
       if (clkAccum >= 'd1000) begin
          sclk = ~sclk;
          clkAccum = 0;
       end
       else begin
          clkAccum = clkAccum + 'b1;
       end
    end
            
    always @ (posedge sclk) begin
       if (reset != 'd0) begin
          state = 'd0;
          sdin  = 'd1;
       end
       else begin
          case(state)
             STATE_IDLE: begin //idle
                sdin = 1;
                state = STATE_START;
             end
             
             STATE_START: begin //start
                sdin = 0; //think this is write, no?
                state = STATE_ADDR;
             end
             
             STATE_ADDR: begin //send MSB of addr
                if (count > 0) begin
                   sdin = mainAddr[count];
                   count = count - 'd1;
                end
                else begin
                   state = STATE_RW;
                end
             end
             
             STATE_RW: begin
                sdin = 0; //write
                state = STATE_WACK; 
             end
             
             STATE_WACK: begin //need to fix this
                state = STATE_DATA;
                count = 7;
             end
             
             STATE_SEC_ADDR: begin
                if (count > 0) begin
                   sdin = regAddress[count];
                   count = count - 1;
                end
                else begin
                   state = STATE_WACK2;
                end
             end
             
             STATE_WACK2: begin
                state = STATE_DATA; 
                count = 7;
             end
             
             STATE_DATA: begin
                if (count > 0) begin
                   sdin = data[count];
                   count = count - 1;
                end
                else begin
                   state = STATE_WACK3;
                end
             end
             
             STATE_WACK3: begin
                state = STATE_STOP;
             end
             
             STATE_STOP: begin
                sdin = 1;
                state = STATE_IDLE;
             end         
          endcase
       end  
    end            
endmodule
