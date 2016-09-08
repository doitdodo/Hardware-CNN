`include <network_parameters.h>
module sub_sample( // Mean pooling
  input clock,
  input reset,
  input [NH_VECTOR_BITWIDTH:0] nh_vector, // ` indicates a difined macro
  output [`NN_BITWIDTH:0] pool_out;
);

// wires
wire [`ADDER_TREE_BITWIDTH:0] adder_tree_wire [`NUM_NH_LAYERS+1][`NEIGHBORHOOD_SIZE];

// regs


// assign statments
assign pool_out = adder_tree_wire[`NUM_NH_LAYERS+1][`NEIGHBORHOOD_SIZE/2] / `ADDER_TREE_BITWIDTH'd`NEIGHBORHOOD_SIZE;

genvar i
genvar j
generate
for(i=0; i < `NUM_NH_LAYERS; i=i+1) begin
  for(j=0; j < `NEIGHBORHOOD_SIZE - i; j=j+2) begin
    add add_inst ( 
      .add_a(adder_tree_wire[i][j]),
      .add_b(adder_tree_wire[i][j+1]),
      .out(adder_tree_wire[i+1][j/2])
    );
  end 
end
endgenerate

endmodule


module add (
  input [`ADDER_TREE_BITWIDTH:0] add_a,
  input [`ADDER_TREE_BITWIDTH:0] add_b,
  output [`ADDER_TREE_BITWIDTH:0] out
);
assign out = add_a + add_b;
endmodule