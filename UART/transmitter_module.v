module transmitter (
    input clk,
    input rst,
    input wr_enb,
    input enb,             
    input [7:0] data_in,
    output reg tx,
    output busy
);

    parameter idle_state  = 2'b00;
    parameter start_state = 2'b01;
    parameter data_state  = 2'b10;
    parameter stop_state  = 2'b11;

    reg [7:0] data;
    reg [2:0] index;
    reg [1:0] state;

    // The module is busy in any state other than IDLE
    assign busy = (state != idle_state);

    always @(posedge clk) begin
        if (rst) begin
            state <= idle_state;
            tx    <= 1'b1;       // UART idle line is high
            data  <= 8'h00;
            index <= 3'h0;
        end else begin
            case (state)
                idle_state: begin
                    tx <= 1'b1;  // Keep line high
                    if (wr_enb) begin
                        state <= start_state;
                        data  <= data_in;
                        index <= 3'h0;
                    end
                end  
                
                start_state: begin
                    if (enb) begin
                        tx    <= 1'b0; // Send start bit (low)
                        state <= data_state;
                    end
                end
                
                data_state: begin 
                    if (enb) begin
                        tx <= data[index]; // Send current bit
                        if (index == 3'h7) begin
                            state <= stop_state;
                        end else begin
                            index <= index + 3'h1; // Kept as non-blocking
                        end
                    end
                end
                
                stop_state: begin
                    if (enb) begin
                        tx    <= 1'b1; // Send stop bit (high)
                        state <= idle_state;
                    end
                end
                
                default: state <= idle_state;
            endcase
        end
    end

endmodule
