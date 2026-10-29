`timescale 1ns/1ps
module tb_fsm_controller;
    reg clk, rst_n, start, finish;
    wire busy, done;
    integer errors;

    fsm_controller dut (
        .clk(clk), .rst_n(rst_n), .start(start), .finish(finish),
        .busy(busy), .done(done)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk; // 10 ns clock period

    task check_outputs;
        input expected_busy;
        input expected_done;
        input [255:0] test_name;
        begin
            #1;
            if (busy !== expected_busy || done !== expected_done) begin
                $display("FAIL: %0s | busy=%b done=%b expected_busy=%b expected_done=%b",
                    test_name, busy, done, expected_busy, expected_done);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s", test_name);
            end
        end
    endtask

    initial begin
        errors = 0;
        rst_n = 0;
        start = 0;
        finish = 0;

        @(posedge clk);
        #1;
        check_outputs(0, 0, "reset enters IDLE");

        rst_n = 1;
        @(negedge clk);
        check_outputs(0, 0, "IDLE outputs are low");

        start = 1;
        @(posedge clk);
        #1;
        check_outputs(1, 0, "start enters ACTIVE and asserts busy");
        start = 0;

        repeat (2) begin
            @(negedge clk);
            check_outputs(1, 0, "ACTIVE holds while finish is low");
        end

        finish = 1;
        @(posedge clk);
        #1;
        check_outputs(0, 1, "finish enters DONE and asserts done");
        finish = 0;

        @(posedge clk);
        #1;
        check_outputs(0, 0, "DONE returns to IDLE after one cycle");

        @(negedge clk);
        start = 1;
        @(posedge clk);
        #1;
        check_outputs(1, 0, "second start enters ACTIVE");
        start = 0;

        @(negedge clk);
        rst_n = 0;
        @(posedge clk);
        #1;
        check_outputs(0, 0, "reset returns ACTIVE controller to IDLE");

        rst_n = 1;
        @(negedge clk);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d error(s)", errors);
        $finish;
    end
endmodule
