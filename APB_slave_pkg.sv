package APB_slave_pkg;
class APB_slave_covergroup;

    logic [15:0] PADDR; // Address bus
    logic PWRITE;      // Write enable
    logic PSELx;      // Select signal
    
    // Covergroup for APB signals
    covergroup apb_cg;
        // Covergroup for PADDR registers
        address: coverpoint PADDR {
            bins SYS_STATUS_bin = {16'h0000};
            bins INT_CTRL_bin = {16'h0040};
            bins DEV_ID_bin = {16'h0080};
            bins MEM_CTRL_bin = {16'h00c0};
            bins TEMP_SENSOR_bin = {16'h0100};
            bins ADC_CTRL_bin = {16'h0140};
            bins DBG_CTRL_bin = {16'h0180};
            bins GPIO_DATA_bin = {16'h01c0};
            bins DAC_OUTPUT_bin = {16'h0200};
            bins VOLTAGE_CTRL_bin = {16'h0240};
            bins CLK_CONFIG_bin = {16'h0280};
            bins TIMER_COUNT_bin = {16'h02c0};
            bins INPUT_DATA_bin = {16'h0300};
            bins OUTPUT_DATA_bin = {16'h0340};
            bins DMA_CTRL_bin = {16'h0380};
            bins SYS_CTRL_bin = {16'h03c0};
            illegal_bins others = default;
        }

        // Covergroup for PWRITE
        write: coverpoint PWRITE {
            bins write_bin = {1};
        }

        // Covergroup for PSELx
        select: coverpoint PSELx {
            bins sel_bin = {1};
        }

        cross address, PWRITE, PSELx;

    endgroup

    // Constructor
    function new();
        apb_cg = new();
    endfunction

    task sample(input logic [15:0] PADDRt, // Address bus
    logic PWRITEt,     // Write enable
    logic PSELxt      // Select signal
    );
        // Sample the covergroup
        PADDR = PADDRt;
        PWRITE = PWRITEt;
        PSELx = PSELxt;
        apb_cg.sample();
    endtask

endclass




class APB_slave_constraints;

    rand bit [15:0] PADDR;       // Address
    rand bit [31:0] PWDATA;      // Write data
    rand bit        PWRITE;      // Write enable
    rand bit        PSELx;        // Select signal
    rand bit        PENABLE;     // Enable signal
    rand bit        PRESETn;     // Reset signal

    constraint PRESETn_constraint {
        // Assert PRESETn less often
        PRESETn dist {0 := 80, 1 := 20};
    }

    constraint penable_psel_constraint {
        // PENABLE and PSELx to be 1 most of the time
        PENABLE dist {1 := 80, 0 := 20};
        PSELx dist {1 := 80, 0 := 20};
    }

    constraint pwrite_constraint {
        // PWRITE to have equal distribution between read and write
        PWRITE dist {0 := 50, 1 := 50};
    }

    constraint paddr_constraint {
        // PADDR to have addresses of the registers
        PADDR inside {
            16'h0000, // SYS_STATUS_bin
            16'h0040, // INT_CTRL_bin
            16'h0080, // DEV_ID_bin
            16'h00c0, // MEM_CTRL_bin
            16'h0100, // TEMP_SENSOR_bin
            16'h0140, // ADC_CTRL_bin
            16'h0180, // DBG_CTRL_bin
            16'h01c0, // GPIO_DATA_bin
            16'h0200, // DAC_OUTPUT_bin
            16'h0240, // VOLTAGE_CTRL_bin
            16'h0280, // CLK_CONFIG_bin
            16'h02c0, // TIMER_COUNT_bin
            16'h0300, // INPUT_DATA_bin
            16'h0340, // OUTPUT_DATA_bin
            16'h0380, // DMA_CTRL_bin
            16'h03c0  // SYS_CTRL_bin
        };
    }
endclass
endpackage: APB_slave_pkg