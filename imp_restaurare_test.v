//---------------------------------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Proiect     : Limbaje de descriere hardware
// Autor       : Olteanu Eduard Daniel
// Data        : 13.05.2022
//---------------------------------------------------------------------------------------
// Descriere   : Modulul de test 
//---------------------------------------------------------------------------------------
module impartitor_cu_restarurare_Test #(parameter N = 4)();

wire 			clk_inst;
wire 			reset_inst;
wire			start_inst;
wire [N-1:0] 	a_inst;
wire [N-1:0]    b_inst;
wire [N-1:0]    A_inst;
wire [N  :0]    B_inst;
wire [N  :0]	P_inst;
wire 			ready_inst;

impartitor_cu_restarurare_Tb #(.N(N)) TB (
  .clk(clk_inst),
  .reset(reset_inst),
  .start(start_inst),
  .a(a_inst),
  .b(b_inst)
	
);

impartitor_cu_restarurare #(.N(N)) DUT (
  .clk(clk_inst),
  .reset(reset_inst),
  .start(start_inst),
  .a(a_inst),
  .b(b_inst),
  .A(A_inst),
  .B(B_inst),
  .P(P_inst),
  .ready(ready_inst)
	
);

endmodule