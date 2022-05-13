//---------------------------------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Proiect     : Limbaje de descriere hardware
// Autor       : Olteanu Eduard Daniel
// Data        : 13.05.2022
//---------------------------------------------------------------------------------------
// Descriere   : Modulul de impartire cu restaurare
//---------------------------------------------------------------------------------------
module impartitor_cu_restarurare #(parameter N=4)(
input 				clk		,
input 				reset	,
input 				start	,
input 		[N-1:0] a		,
input 		[N-1:0] b		,
output	reg	[N-1:0] A		,
output  reg [N  :0]	B		,
output	reg	[N	:0] P		,
output 				ready
);


//Starile
localparam INIT 	= 3'b000; //Initializarea valori
localparam LOAD		= 3'b001; // Incarcare registrii
localparam DIVIDE 	= 3'b010; // Operatia de impartire
localparam CHECKING = 3'b011; // Verificare MSb P
localparam READY 	= 3'b100; //Starea finala

reg [2:0]   state;
reg [N-1:0] iteratii;
wire 		MSb_P;
wire		MSb_A;

assign ready  = (state == READY);
assign MSb_A  = A[N-1];
assign MSb_P  = P[N];

//---------------------------------------------
//Calea de date
//---------------------------------------------

always @(posedge clk or negedge reset) begin
  if(~reset) 
	A <= 0;								  	//Initializarea lui A cu 0
  else
	case(state)								
	  LOAD: A <= a;							//Incarcarea lui A
      DIVIDE: A <= {A[N-2:0],MSb_P};		//(LSb A == MSb P)
	  CHECKING: A[0] <= (MSb_P ? 0 : 1);	//Daca MSb P = 1 => LSb A <= 0 iar daca  MSb P = 0 => LSb A <= 1
	endcase
end

always @(posedge clk or negedge reset) begin
  if(~reset) 
    B <= 0;							     	//Initializarea lui B cu 0
  else
    case(state)								
	  LOAD: B <= b;						 	//Incarcarea lui B
	endcase
end

always @(posedge clk or negedge reset) begin
  if(~reset)
    P <= 0;							     	//Initializarea lui P cu 0
  else
    case(state)								//Alegerea starii
	  LOAD: P <= 0;						 	//Incarcarea lui P cu 0
	  DIVIDE: P <= {P[N-1:0],MSb_A} - B; 	//deplasare stânga {P, A} si P = P -B
	  CHECKING: if(MSb_P)                	//Daca MSb P = 1
				  P <= P + B;			 	//P <= P + B (restaurare P)
	endcase
end

//---------------------------------------------
//Calea de control
//---------------------------------------------

always @(posedge clk or negedge reset) begin
  if(~reset)
    state <= INIT;
  else
    case(state)
	  INIT: if(start)
			  state <= LOAD; 	//automatul se afla in starea INIT si start_i este pe HIGH atunci automatul trece in starea LOAD, de incarcare
			else
			  state <= INIT;
	  LOAD: begin
	          iteratii <= N;    //automatul incarca numarul de iteratii
			  state <= DIVIDE;  //si trece in starea de impartire
	        end
	  DIVIDE: if(iteratii > 0)  //automatul sta in starea de multiply pana cand iteratiile ajung la valoarea 0 si apoi trece in READY
				begin
				  iteratii <= iteratii -1;
				  state <= CHECKING;
				end
			  else
			    state <= READY;
	  CHECKING: state <= DIVIDE; //automatul este in starea de verificare a MSb-urilor si LSb-urilor
	  default: state <= INIT;    
	endcase
end




endmodule
