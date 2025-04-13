// module apb_assertions (APB_Interface.DUT apb_if);

//     always @(negedge apb_if.PRESETn) begin
//         if (!apb_if.PRESETn) begin
//             // Check that signals are properly reset when reset is active
//             assert (apb_if.PREADY == 1'b0) else $error("Signal did not reset properly during asynchronous reset!");
//             assert (apb_if.PRDATA == 32'b0) else $error("Signal did not reset properly during asynchronous reset!");
//         end
//     end

//     // Assertion: Read operation
//     property read_op;
//         @(posedge apb_if.PCLK) disable iff (!apb_if.PRESETn)
//         (apb_if.PSELx && apb_if.PADDR[31:30] == 0 && !apb_if.PWRITE && apb_if.PENABLE) |->
//         (apb_if.PREADY &&  apb_if.PRDATA == apb_wrapper.reg_file.read_data &&
//         apb_if.PADDR == apb_wrapper.reg_file.addr);
//     endproperty
//     read_op_assert: assert property (read_op) else $error("Read operation failed!");
//     read_op_cover: cover property (read_op);

//     // Assertion: Write operation
//     property write_op;
//         @(posedge apb_if.PCLK) disable iff (!apb_if.PRESETn)
//         (apb_if.PSELx && apb_if.PADDR[31:30] == 0 && apb_if.PWRITE && apb_if.PENABLE) |->
//         (apb_wrapper.reg_file.write_data == apb_if.PWDATA &&
//         apb_if.PADDR == apb_wrapper.reg_file.addr && apb_wrapper.reg_file.wr &&
//         apb_wrapper.reg_file.enable);
//     endproperty
//     write_op_assert: assert property (write_op) else $error("Write operation failed!");
//     write_op_cover: cover property (write_op);

// endmodule