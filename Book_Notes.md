# Hands-On FPGA Projects Notes

## System Verilog 
- The logic keyword replaces wire and reg. Its more general reduces confusion
    - input logic clk_100MHz
- The always_ff keyword to explicitly tell the synthesis tool to create sequential flip-flop logic
    -   always_ff @ (posedge clk) begin end
- (* ASYNCHRONOUS_REG = "TRUE" *)
    - This attribute prevents synthesis from optimizing away the redundant registers
    - This ensures they are placed in the same slice to reduce signal travel time
- Shift register
    - reg [1:0] sync_ff = 2'b00;
    - sync_regs <= {sync_ff[0], async_in};

## Docker

## TCL Script
- Set a variable
    - set project_name "Test_Project"
- Create a folder
    - file mkdir "directory_name"
- Move into the directory
    - cd "./directory_name"
- Create a project and add the part
    - create_project "project_name" -part "xc7z020clg484-1" -force
- Add files to a project
    - add_files -fileset constrs_1 ./constraints/arty_a7_master.xdc
- Set the target language to system verilog
    - set_property target_language SystemVerilog [current_project]

## Vivado 
- You can start vivado from the command line in the gui mode
    - vivado -mode gui -source MyTCL.tcl
- Gated Clock
    - Clock created by toggling a logic signal. Introduces phase noise and skew
- To generate clocks we use PLL and Mixed Mode Clock Manager MMCM
    - This can be done with the GUI clock wizard or using Xilinx Paramterized Macros (primitives / XPM)
- Global Clock Buffer
    - The output of the MMCM cannot drive thousands of flip flops directly
    - Distributes the signal across the chips dedicated low-skew clocking backbone
    - Without the BUFG primitives your clock would travel through regular routing wires accumulating delay
    - Example: BUFG clkout0_buf (.I(name_clk_i), .O(name_clk_o));
- (* ASYNCHRONOUS_REG = "TRUE" *)
    - This attribute prevents synthesis from optimizing away the redundant registers
    - This ensures they are placed in the same slice to reduce signal travel time
- Use synchronizers to help with Cross Domain Clocks
    - This allows metastability issues to settle

# Constraints
- The FPGA doesnt inherently know what the signal named clk in your code is connected to on the board. XDC acts as the bridge between your logical names and the physical pins
-   Constraints are set using the pin IOStandard and the pin location (or in single line)
    - set_property PACKAGE_PIN A16 [get_ports {clk}];  # "clk"
    - set_property IOSTANDARD LVCMOS33 [get_ports {clk}];
    - set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS33} [get_ports {clk}];
- Create a clock constraint <clock_name> <clock_period> <clock_duty> this tells Vivado implementation it must ensure signals can travel through your logic within 10ns to meet timing requirements
    - create_clock -add -name sys_clk_pin -period 10.00 -waveform {0,5} [get_ports {clk}];
- Derive constraints for MMCM/PLL outputs
    - derive_pll_clocks
