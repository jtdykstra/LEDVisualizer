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
            input CLK, //12.288 MHz from clock generator
            input rec_data,
            output muten,
            output mclk,
            output bclk,
            output lrclk,
            output pblrc,
            input pbdata,
            output left_data_rdy,
            output right_data_rdy,
            output [23:0]left_data, //ADC data collected 
            output [23:0]right_data,
            input rdata_read,
            input ldata_read,
            output reset_rtl
    );
    
    logic reset_rtl;
    assign reset_rtl = 'd0;
    logic mclk;
    assign mclk = CLK;
    logic muten;
    assign muten = 'd0;
    logic bclk; //mclk / 4
    logic lrclk; //96 kHZ 
    logic [3:0]genBCLK;
    logic [8:0]genLRC;
    logic [23:0]data;
    logic left_data_rdy;
    logic right_data_rdy;
    logic rdata_read;
    logic ldata_read;
    logic [23:0]left_data;
    logic [23:0]right_data;
    logic pbdata;
    logic pblrc;
    integer bitCount = 0;
    assign pblrc = 'd0;
    
    //Generate bclk
    always @ (posedge CLK) begin
       if (genBCLK >= 'd4) begin
          bclk = ~bclk;
          genBCLK = 0;
       end
       else begin
          ++genBCLK;
       end
    end
    
    //Generate lrclk (2 * fs, or 2 * 48 kHZ)
    always @ (posedge CLK) begin
       if (genLRC >= 'd128) begin
          lrclk = ~lrclk;
          genLRC = 0;
       end
       else begin
          ++genLRC;
       end
    end
    
    //clock in data
    //note that data is delayed one cycle after lrclk changing
    always @ (posedge bclk) begin
       
       //think about this   
       if (bitCount >= 1 && bitCount <= 24) begin
          data = rec_data; 
       end
       
       bitCount += 1; //<- this should be an integer
       if (bitCount > 'd32) begin
          bitCount = 0;
          //data = 'd0;
       end
    end
    
    //update left_data rising edge of lrclk
    //previous read was for right channel
    always @ (posedge lrclk) begin

      // if (ldata_read > 'd0) begin //data has been read, start updating again
          left_data = data; //fine if outside of this if statement
          left_data_rdy = 'd1;
       //end 
       
       if (bitCount > 'd24) begin
          left_data_rdy = 'd1;
       end
       
    end
    
    //update right_data on falling edge of lrclk 
    // (previous read was for left channel)
    always @ (negedge lrclk) begin
    
       //if (rdata_read > 'd0) begin
          right_data = data;
          right_data_rdy = 'd1;
       //end
       
       if (bitCount > 'd24) begin
          right_data_rdy = 'd1;
       end
                                
    end
endmodule
