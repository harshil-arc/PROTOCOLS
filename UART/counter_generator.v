
module baud_rate_generater(input vlk,output tx_enab,output rx_enab );
  reg [12:0 ] tx_counter;
  reg[9:0] rx_counter;
  
  always@(posedge clk)
    begin
      if(tx_counter == 5208)
        tx_counter=0;
      else 
        tx_counter =tx_counter+1'b1;
      
    end
  
    always@(posedge clk)
    begin
      if(rx_ounter == 325)
        rx_counter=0;
      else 
        rx_counter =rx_counter+1'b1;
      
    end
  
  assign tx_enab =  (tx_counter == 0 ) ? 1'b1 :1'b0;
  assign rx_enab = (rx_counter == 0) ? 1'b1 :1'b0;

  endmodule;