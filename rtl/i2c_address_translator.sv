`timescale 1ns/1ns

module i2c_address_translator #(
    parameter [6:0] VIRT_ADDR = 7'h49,
    parameter [6:0] REAL_ADDR = 7'h48
)(
    input  logic clk,
    input  logic rst,
    input  logic scl_m,
    input  logic sda_m,
    output logic scl_s,
    output logic sda_s
);

    logic [3:0] bit_cnt;
    logic [6:0] addr_buffer;
    logic sda_m_reg, scl_m_reg;
    logic is_target_addr;

    typedef enum logic [1:0] {IDLE, ADDR_PHASE, DATA_PHASE} state_t;
    state_t state;

    // Register previous values
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            sda_m_reg <= 1'b1;
            scl_m_reg <= 1'b1;
        end else begin
            sda_m_reg <= sda_m;
            scl_m_reg <= scl_m;
        end
    end

    // Detect START condition
    wire start_cond = (sda_m_reg && !sda_m && scl_m);

    // Detect rising edge of SCL
    wire scl_rise = (scl_m && !scl_m_reg);

    // FSM
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            bit_cnt <= 0;
            addr_buffer <= 0;
            is_target_addr <= 0;
        end

        else if (start_cond) begin
            state <= ADDR_PHASE;
            bit_cnt <= 0;
            addr_buffer <= 0;
            is_target_addr <= 0;
        end

        else begin
            case (state)

                ADDR_PHASE: begin
                    if (scl_rise) begin
                        addr_buffer <= {addr_buffer[5:0], sda_m};

                        if (bit_cnt == 6) begin
                            is_target_addr <= ({addr_buffer[5:0], sda_m} == VIRT_ADDR);
                        end

                        if (bit_cnt == 7)
                            state <= DATA_PHASE;
                        else
                            bit_cnt <= bit_cnt + 1;
                    end
                end

                DATA_PHASE: begin
                    // Pass-through state
                end

                default: state <= IDLE;

            endcase
        end
    end

    // Forward clock
    assign scl_s = scl_m;

    // SDA Logic
    always_comb begin

        if (state == ADDR_PHASE && bit_cnt < 7) begin

            if (is_target_addr)
                sda_s = REAL_ADDR[6 - bit_cnt];   // Translate
            else
                sda_s = sda_m;                   // Pass-through

        end

        else begin
            sda_s = sda_m;                       // Data phase pass-through
        end

    end

endmodule