//---------------------------------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Proiect     : Limbaje de descriere hardware
// Autor       : Olteanu Eduard Daniel
// Data        : 13.05.2022
//---------------------------------------------------------------------------------------
// Descriere   : Modulul de testbench pentru modulul de impartire cu restaurare
//---------------------------------------------------------------------------------------
module impartitor_cu_restarurare_Tb #(parameter N = 4)(
output reg clk		,
output reg reset	,
output reg start	,
output reg[N-1:0] a	,
output reg[N-1:0] b	
);

//Initializare semnal clk
initial begin
  clk <= 1'b0;
  forever #5 clk <= ~clk;
end

//Initializare semnal reset
initial begin
  reset<=1'b1;
  @(posedge clk);
  @(posedge clk);
  reset<=1'b0;
  @(posedge clk);
  reset<=1'b1;
  @(posedge clk);

end

//Initializare semnal de stare start
initial begin
  start <= 1'b0;
  repeat(4) @(posedge clk);
  start <= 1'b1;
  @(posedge clk);
  start <= 1'b0;
end

//Initializare semnale pentru deimpartit si impartitorul
initial begin
  repeat(4) @(posedge clk);
  a<=4'b1110;
  b<=4'b0011;
end

endmodule