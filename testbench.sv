import APB_slave_pkg::*;
module apb_slave_tb(APB_Interface.TEST apb_if);

    // Parameters
    parameter ADDR_WIDTH = 16;
    parameter DATA_WIDTH = 32;

    // Testbench signals
    logic                  PCLK;
    logic                  PRESETn;
    logic  [ADDR_WIDTH-1:0] PADDR;
    logic                  PWRITE;
    logic  [DATA_WIDTH-1:0] PWDATA;
    logic                  PENABLE;
    logic                  PSELx;
    logic                  PREADY;
    logic [DATA_WIDTH-1:0] PRDATA;

    // Assign signals to interface
    assign apb_if.PRESETn = PRESETn;
    assign apb_if.PADDR   = PADDR;
    assign apb_if.PWRITE  = PWRITE;
    assign apb_if.PWDATA  = PWDATA;
    assign apb_if.PENABLE = PENABLE;
    assign apb_if.PSELx   = PSELx;
    assign PCLK = apb_if.PCLK;
    assign PREADY = apb_if.PREADY;
    assign PRDATA = apb_if.PRDATA;

    // Test sequence
    integer i;
    APB_slave_covergroup cvrgrp = new();
    APB_slave_constraints cnstr = new();


    initial begin
        // Reset
        cvrgrp.apb_cg.start();
        PRESETn = 0;
        PSELx = 0;
        PENABLE = 0;
        PWRITE = 0;
        PADDR = 0;
        PWDATA = 0;
        #20;
        PRESETn = 1;
        cvrgrp.sample(PADDR, PWRITE, PSELx);

        // Write transaction
        @(negedge PCLK);
        PSELx = 1;
        PWRITE = 1;
        PADDR = 8'hC0;
        PWDATA = 32'hDEADBEEF;
        @(negedge PCLK);
        PENABLE = 1;
        @(negedge PCLK);
        @(negedge PCLK);
        @(negedge PCLK);
        PENABLE = 0;
        PSELx = 0;
        cvrgrp.sample(PADDR, PWRITE, PSELx);

        // Read transaction
        @(negedge PCLK);
        PSELx = 1;
        PWRITE = 0;
        PADDR = 8'hC0;
        @(negedge PCLK);
        PENABLE = 1;
        @(negedge PCLK);
        PENABLE = 0;
        PSELx = 0;
        @(negedge PCLK);
        cvrgrp.sample(PADDR, PWRITE, PSELx);
        check_output();

        // Write transaction
        @(negedge PCLK);
        PSELx = 1;
        PWRITE = 1;
        PADDR = 8'hC0;
        PWDATA = 32'hDEADBEE2;
        @(negedge PCLK);
        PENABLE = 1;
        @(negedge PCLK);
        @(negedge PCLK);
        @(negedge PCLK);
        cvrgrp.sample(PADDR, PWRITE, PSELx);
        PENABLE = 0;
        PSELx = 0;

        // Read transaction
        @(negedge PCLK);
        PSELx = 1;
        PWRITE = 0;
        PADDR = 8'hC0;
        @(negedge PCLK);
        PENABLE = 1;
        @(negedge PCLK);
        cvrgrp.sample(PADDR, PWRITE, PSELx);
        check_output();

        // Write transaction
        @(negedge PCLK);
        PSELx = 1;
        PWRITE = 1;
        PADDR = 8'hC0;
        PWDATA = 32'hDEADBEE3;
        @(negedge PCLK);
        PENABLE = 1;
        @(negedge PCLK);
        @(negedge PCLK);
        @(negedge PCLK);
        
        // Write transaction
        @(negedge PCLK);
        PADDR = 16'hB0C0;
        PWDATA = 32'hDEADBEE4;
        // PENABLE = 0;
        PSELx = 1;
        @(negedge PCLK);
        PENABLE = 1;
        @(negedge PCLK);
        @(negedge PCLK);
        @(negedge PCLK);
        PENABLE = 0;

        #50;
        // Reset
        PRESETn = 0;
        PSELx = 0;
        PENABLE = 0;
        PWRITE = 0;
        PADDR = 0;
        PWDATA = 0;
        #20;
        PRESETn = 1;

        //randomized test (write)

        PWRITE = 1;
        PSELx = 1;
        PENABLE = 1;
        for (i = 0;i< 1000 ; i++) begin
            assert(cnstr.randomize()) else $error("Randomization failed!");
            PWDATA = cnstr.PWDATA;
            PADDR = cnstr.PADDR;
            cvrgrp.sample(PADDR, PWRITE, PSELx);
            @(negedge PCLK);
        end
        PADDR = 'h02c0;
        @(negedge PCLK);
        @(negedge PCLK);
        PADDR = 'h0380;
        @(negedge PCLK);
        @(negedge PCLK);
        @(negedge PCLK);
        @(negedge PCLK);
        @(negedge PCLK);
        @(negedge PCLK);

        //randomized test (read)
        PWRITE = 0;
        for (i = 0;i< 1000 ; i++) begin
            assert(cnstr.randomize()) else $error("Randomization failed!");
            PADDR = cnstr.PADDR;
            cvrgrp.sample(PADDR, PWRITE, PSELx);
            @(negedge PCLK);
        end
        PADDR = 'h02c0;
        @(negedge PCLK);
        @(negedge PCLK);
        PADDR = 'h0380;
        @(negedge PCLK);
        @(negedge PCLK);
        PADDR = 'h0080;
        @(negedge PCLK);
        @(negedge PCLK);
        PADDR = 'h0100;
        @(negedge PCLK);
        @(negedge PCLK);
        @(negedge PCLK);
        @(negedge PCLK);
        PADDR = 'h0200;

        //different addresses
        PWRITE = 1;
        PSELx = 1;
        PENABLE = 1;
        cnstr.paddr_constraint.constraint_mode(0);
        for (i = 0;i< 1000 ; i++) begin
            assert(cnstr.randomize()) else $error("Randomization failed!");
            PADDR = cnstr.PADDR;
            cvrgrp.sample(PADDR, PWRITE, PSELx);
            @(negedge PCLK);
        end

        //Address encoding
        PSELx = 0;
        PADDR = 'hA000;
        @(negedge PCLK);
        PSELx = 1;
        PADDR = 'h0000;
        @(negedge PCLK);
        PADDR = 'hC000;
        @(negedge PCLK);
        PADDR = 'h5000;
        @(negedge PCLK);
        PADDR = 'hA000;
        @(negedge PCLK);
        cvrgrp.apb_cg.stop();


        //Finish simulation
        $finish;
    end

    task check_output();
        if(PRDATA == 32'hDEADBEEF) begin
            if(PREADY && PENABLE && PSELx) begin
                $display("Read data matches expected value: %h", PRDATA);
            end else begin
                $error("Read operation shouldn't happen!");
            end
        end else begin
            $error("Read data does not match expected value! Expected: %h, Got: %h", 32'hDEADBEEF, PRDATA);
        end
    endtask
    // property reset_check;
    // @(negedge apb_if.PRESETn)
    // (1) |-> ( (apb_if.PREADY == 1'b0 || $fell(apb_if.PREADY))
    // && (apb_if.PRDATA == 32'b0 || $fell(apb_if.PRDATA)) );
    // endproperty
    // reset_check_assert: assert property (reset_check) else $error("Reset check failed!");
    // reset_check_cover: cover property (reset_check);


    // Assertions
    // always @(negedge apb_if.PRESETn) begin
    //     if (!apb_if.PRESETn) begin
    //         // Check that signals are properly reset when reset is active
    //         if (!$isunknown(apb_if.PREADY)) begin
    //             assert (apb_if.PREADY == 1'b0)
    //                 else $error("Signal did not reset properly during asynchronous reset!");
    //         end
    //         if (!$isunknown(apb_if.PRDATA)) begin
    //             assert (apb_if.PRDATA == 32'b0)
    //                 else $error("Signal did not reset properly during asynchronous reset!");
    //         end
    //     end
    // end
    ap_async_rst: assert property(@(negedge apb_if.PRESETn) 1'b1 |=>  @(posedge apb_if.PCLK) apb_if.PREADY==0);
    // always @(negedge apb_if.PRESETn) begin
    //     if (!apb_if.PRESETn) begin
    //         assert (apb_if.PREADY == 1'b0)
    //             else $error("Signal 'PREADY' is not 0 during asynchronous reset!");
    //     end
    // end

    // Assertion: Read operation
    logic read_op_active;
    assign read_op_active = apb_if.PSELx && apb_if.PADDR[15:14] == 0 && !apb_if.PWRITE && apb_if.PENABLE;
    property read_op;
        @(posedge PCLK) ##0 // generated by the testbench or slave
        $rose (!PWRITE && PSELx) |->  ##1
        $stable(PADDR) && $stable(PRDATA)    ##0
        $rose (PENABLE) ##1 PREADY [-> 1] ##1 // PREADY is asserted for one cycle
        (!PSELx && !PENABLE);
    endproperty
    read_op_assert: assert property (read_op) else $error("Read operation failed!");
    read_op_cover: cover property (read_op);


    // Assertion: Write operation
    logic write_op_active;
    assign write_op_active= apb_if.PSELx && apb_if.PADDR[15:14] == 0 && apb_if.PWRITE && apb_if.PENABLE;
    property write_op;
        @(posedge PCLK) ##0 // generated by the testbench or slave
        $rose (PWRITE && PSELx) |->  ##1
        $stable(PADDR) && $stable(PWDATA)    ##0
        $rose (PENABLE) ##1 PREADY [-> 1] ##1 // PREADY is asserted for one cycle
        (!PSELx && !PENABLE);
    endproperty
    write_op_assert: assert property (write_op) else $error("Write operation failed!");
    write_op_cover: cover property (write_op);


endmodule