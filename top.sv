module top;

    bit clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    APB_Interface apb_if(.PCLK(clk));
    APB_Wrapper #(
        .DATA_WIDTH(32),
        .ADDR_WIDTH(16)
    ) apb_wrapper (
        .PCLK(apb_if.PCLK),
        .PRESETn(apb_if.PRESETn),
        .PADDR(apb_if.PADDR),
        .PSELx(apb_if.PSELx),
        .PWRITE(apb_if.PWRITE),
        .PWDATA(apb_if.PWDATA),
        .PENABLE(apb_if.PENABLE),
        .PREADY(apb_if.PREADY),
        .PRDATA(apb_if.PRDATA)
    );
    apb_slave_tb TEST (apb_if);


    // bind APB_Wrapper apb_assertions assertions_module (apb_if);


endmodule