`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2015 04:28:59 PM
// Design Name: 
// Module Name: AudioCodec
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


module AudioCodec(
            input wire CLK, //12.288 MHz from clock generator
            input wire rec_data,
            output wire muten,
            output wire mclk,
            output reg bclk = 0,
            output reg lrclk = 0,
            output wire pblrc,
            output wire pbdata,
            output reg left_data_rdy = 0,
            output reg right_data_rdy = 0,
            output reg [23:0]left_data = 0, //ADC data collected 
            output reg [23:0]right_data = 0,
            input wire rdata_read,
            input wire ldata_read,
            output wire reset_rtl
    );
    
    assign reset_rtl = 'd0;
    assign mclk = CLK;
    assign muten = 'd0;
    assign pblrc = 'd0;
    
    reg [3:0]genBCLK = 0;
    reg [8:0]genLRC = 0;
    reg [23:0]data = 0;
    reg [6:0]bitCount = 0;
    reg [23:0]left_data_temp;
    reg [23:0]right_data_temp;
  
    assign pblrc = 'd0; 
    
    //Generate bclk
    always @ (posedge CLK) begin
       if (genBCLK >= 'd1) begin
          bclk = ~bclk;
          genBCLK = 0;
       end
       else begin
          genBCLK = genBCLK + 1;
       end
    end
    
    //Generate lrclk (2 * fs, or 2 * 48 kHZ)
    always @ (posedge CLK) begin
       if (genLRC >= 'd127) begin
          lrclk = ~lrclk;
          genLRC = 0;
       end
       else begin
          genLRC = genLRC + 1;
       end
    end
    
    //clock in data
    //note that data is delayed one cycle after lrclk changing
    always @ (posedge bclk) begin
       
       if (bitCount >= 1 && bitCount <= 24) begin
          data[24 - bitCount] = rec_data; 
       end
       else if (bitCount == 25) begin //data goes to 0 just before LR clock changes, so make a temp variable
          if (lrclk < 'd1) begin
             left_data = data;            
          end
          else begin //sum to mono!
             left_data = data;
             left_data_rdy = ~left_data_rdy;
          end
       end
                 
       bitCount = bitCount + 'd1; //<- this should be an integer
       if (bitCount > 'd31) begin
          bitCount = 0;
          data = 'd0;
       end
    end
    
endmodule
