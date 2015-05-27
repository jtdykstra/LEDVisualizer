`timescale 1us / 1ps
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
             input wire clk,
             input wire [6:0]regAddress,
             input wire [8:0]data,
             input wire reset,
             output reg sdin = 0,
             output wire sclk,
             output reg ready = 1
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
    localparam STATE_PAD1 = 11;
    localparam STATE_PAD2 = 12;
    
    reg [11:0]clkAccum = 0;
    reg [7:0]count = 7; 
    reg [4:0]state = 0;
    reg innerClk = 0;
    reg [15:0] saved_regaddr;
    wire [7:0]mainAddr;
    reg enable = 0;
        
    assign mainAddr = 'b00011010;
    assign sclk = (enable == 0 || reset == 1) ? 1 : ~innerClk;
    
    always @ (posedge clk) begin
       if (reset == 1) begin
          innerClk = 1;
          clkAccum = 0;
       end
       else begin
          if (clkAccum == 501) begin
             innerClk = ~innerClk;
             clkAccum = 0;
          end
          else begin
             clkAccum = clkAccum + 1;
          end      
       end       
    end
    
    always @ (negedge innerClk) begin
       if (reset == 1) begin
          enable = 0;
       end 
       else begin
          if (state == STATE_IDLE || state == STATE_START || state == STATE_STOP) begin
             enable = 0;
          end
          else begin
             enable = 1;
          end
       end
    end
                
    always @ (posedge innerClk) begin
       if (reset == 1) begin
          state = 'd0;
          sdin  = 'd1;   
          count = 'd7;
          ready = 'd0;
       end
       else begin
          case(state)
             STATE_IDLE: begin //idle
                sdin = 'd1;
                state = STATE_START;
                saved_regaddr = {regAddress, data};
             end
             
             STATE_START: begin //start
                sdin = 'd0;
                state = STATE_ADDR;
                count = 'd7;
             end
             
             STATE_ADDR: begin //send MSB of addr
                if (count > 'd0) begin
                   sdin = mainAddr[count - 1];
                   count = count - 'd1;
                end
                else begin
                   state = STATE_RW;
                end
             end
             
             STATE_RW: begin
                sdin = 'hZ; //write
                state = STATE_WACK; 
             end
             
             STATE_WACK: begin //need to fix this
                state = STATE_SEC_ADDR;
                sdin = saved_regaddr[15];
                count = 'd15;
             end           
             
             STATE_SEC_ADDR: begin
                if (count > 'd8) begin
                   sdin = saved_regaddr[count - 1];
                   count = count - 'd1;
                end
                else begin
                   sdin = 'hZ;
                   state = STATE_WACK2;
                end
             end
             
             STATE_WACK2: begin
                sdin = saved_regaddr[7];
                count = 'd7;
                state = STATE_DATA;
             end
             
             STATE_DATA: begin
                if (count > 'd0) begin
                   sdin = saved_regaddr[count - 1];
                   count = count - 'd1;
                end
                else begin
                   sdin = 'hZ;
                   state = STATE_WACK3;
                end
             end
             
             STATE_WACK3: begin
                sdin = 'h0;
                state = STATE_STOP;
             end
             
             STATE_STOP: begin
                state = STATE_STOP;
                sdin = 'h1;
                ready = 'd1;
             end         
          endcase
       end  
    end            
endmodule
