`timescale 1ns/1ns

module testbench;

logic clk = 0;
logic rst = 1;
logic scl_m = 1;
logic sda_m = 1;

wire scl_s;
wire sda_s;

i2c_address_translator #(
    .VIRT_ADDR(7'h49),
    .REAL_ADDR(7'h48)
) dut (

    .clk(clk),
    .rst(rst),
    .scl_m(scl_m),
    .sda_m(sda_m),
    .scl_s(scl_s),
    .sda_s(sda_s)

);

always #5 clk = ~clk;

task i2c_transaction(input [6:0] addr, input rw, input [7:0] data);

integer i;

begin

    sda_m = 0; #5000;
    scl_m = 0; #5000;

    for (i=6; i>=0; i=i-1) begin
        sda_m = addr[i];
        #5000 scl_m = 1;
        #5000 scl_m = 0;
    end

    sda_m = rw;
    #5000 scl_m = 1;
    #5000 scl_m = 0;

    sda_m = 1'bz;
    #5000 scl_m = 1;
    #5000 scl_m = 0;

    for (i=7; i>=0; i=i-1) begin
        sda_m = data[i];
        #5000 scl_m = 1;
        #5000 scl_m = 0;
    end

    sda_m = 1'bz;
    #5000 scl_m = 1;
    #5000 scl_m = 0;

    sda_m = 0;
    #5000;

    scl_m = 1;
    #5000;

    sda_m = 1;
    #10000;

end

endtask


initial begin

    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);

    #100 rst = 0;
    #1000;

    $display("Transaction 1: Non Target Address");
    i2c_transaction(7'h55,0,8'hAA);

    $display("Transaction 2: Address Translation");
    i2c_transaction(7'h49,0,8'hBB);

    #50000;

    $display("Simulation Finished");

    $finish;

end

endmodule