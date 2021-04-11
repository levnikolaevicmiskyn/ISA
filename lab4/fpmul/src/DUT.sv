module DUT(dut_if.port_in in_inter, dut_if.port_out out_inter, output enum logic [1:0] {INITIAL,WAIT,SEND} state);

    FPmul fpmul_under_test(.FP_A(in_inter.A),.FP_B(in_inter.B),.FP_Z(out_inter.data),.clk(in_inter.clk));

	logic[31:0] A1, B1, A2, B2;

    always_ff @(posedge in_inter.clk)
    begin
        if(in_inter.rst) begin
            in_inter.ready <= 0;
            out_inter.data <= 'x;
            out_inter.valid <= 0;
            state <= INITIAL;
			A1 <= 0;
			A2 <= 0;
			B1 <= 0;
			B2 <= 0;
        end
        else
				case(state)
                INITIAL: begin
                    in_inter.ready <= 1;
                    state <= WAIT;
                end

                WAIT: begin
                    if(in_inter.valid) begin
						A2 <= A1;
						B2 <= B1;
						A1 <= in_inter.A;
						B1 <= in_inter.B;

                        in_inter.ready <= 0;
                        //out_inter.data <= in_inter.A + in_inter.B;
                        $display("fpmul: input A = %f, input B = %f, output OUT = %f",$bitstoshortreal(A2),$bitstoshortreal(B2),$bitstoshortreal(out_inter.data));
                        $display("fpmul: input A = %b, input B = %b, output OUT = %b",A2,B2,out_inter.data);
                        out_inter.valid <= 1;
                        state <= SEND;
                    end
                end

                SEND: begin
                    if(out_inter.ready) begin
                        out_inter.valid <= 0;
                        in_inter.ready <= 1;
                        state <= WAIT;
                    end
                end
        endcase
    end
endmodule: DUT
