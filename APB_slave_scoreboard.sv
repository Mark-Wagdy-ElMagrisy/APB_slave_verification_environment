package APB_Slave_Scoreboard;
// APB Slave Scoreboard
// This scoreboard monitors APB transactions and verifies correctness.

class APB_Slave_Scoreboard;

int corr_count, err_count;
virtual APB_Interface bfm;

// Constructor
function new(virtual APB_Interface bfm_in);
    bfm = bfm_in;
    corr_count = 0;
    err_count = 0;
endfunction

task update(virtual APB_Interface bfm_in);
    bfm = bfm_in;
    // Check for transactions
    if (bfm.PSELx && bfm.PENABLE) begin
        if (!bfm.PWRITE) begin

            // Read transaction
            @(posedge bfm.PREADY);
            if (bfm.PRDATA != bfm.out_expected) begin
                err_count++;
                $display("Error: Expected %h, got %h", bfm.out_expected, bfm.PRDATA);
            end else begin
                corr_count++;
                $display("Read transaction successful: %h", bfm.PRDATA);
            end

        end
    end
endtask


endclass
endpackage