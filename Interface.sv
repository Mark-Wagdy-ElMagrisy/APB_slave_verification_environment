interface APB_Interface (PCLK);

    parameter ADDR_WIDTH = 16;
    parameter DATA_WIDTH = 32;

    // Clock and Reset
    input logic PCLK;

    logic PRESETn;

    logic [ADDR_WIDTH-1:0] PADDR;
    logic PSELx;
    logic PWRITE;
    logic [DATA_WIDTH-1:0] PWDATA;
    logic PENABLE;

    logic PREADY;
    logic [DATA_WIDTH-1:0] PRDATA;

    modport DUT (
        input  PCLK, PRESETn, PADDR, PSELx, PWRITE, PWDATA, PENABLE,
        output PREADY, PRDATA
    );

    modport TEST (
        output PRESETn, PADDR, PSELx, PWRITE, PWDATA, PENABLE,
        input  PREADY, PRDATA, PCLK
    );

endinterface