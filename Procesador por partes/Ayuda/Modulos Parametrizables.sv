/*Se recuerda que la forma correcta para instanciar un modulo es la sgte.
MUX2to1 MuxDeEjemplo(In'n'out declaration);

Ahora, para instanciar un modulo y cambiar sus parametros es de la sgte. manera
MUX2to1 #(.nombredelparametro(nuevovalor)) MuxDeEjemplo(In'n'out declaration);
*/


//MUXs reutilizables

/////////////////////////MUX2to1/////////////////////////////////////
module MUX2to1 #(parameter BusWidth = 32, parameter SelWidth = 1)( //MUX2to1 #(.WIDTH(16)) newname(in'n outs); para instanciar con un parametro diferente
    input logic [BusWidth-1:0] in0, in1,
    input logic [SelWidth-1:0] selector,
    output logic [BusWidth-1:0] out
    );
    
    always_comb begin
        case(selector)
            1'b0: out = in0;
            1'b1: out = in1;
            default: out = {BusWidth{1'b0}};    //Genera un vector de BusWidth bits con valor 0
        endcase
    end
endmodule

/////////////////////////MUX4to1/////////////////////////////////////    
module MUX4to1 #(parameter BusWidth = 32, parameter SelWidth = 2)( //MUX2to1 #(.WIDTH(16)) newname(in'n outs); para instanciar con un parametro diferente
    input logic [BusWidth-1:0] in00, in01, in10, in11,
    input logic [SelWidth-1:0] selector,
    output logic [BusWidth-1:0] out
    );