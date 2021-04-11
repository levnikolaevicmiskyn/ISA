class refmod extends uvm_component;
    `uvm_component_utils(refmod)
    
    packet_in tr_in;
    packet_out tr_out;
    uvm_get_port #(packet_in) in;
    uvm_put_port #(packet_out) out;

	logic[31:0] A1, A2, B1, B2, delayed_Z;
    function new(string name = "refmod", uvm_component parent);
        super.new(name, parent);
        in = new("in", this);
        out = new("out", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr_out = packet_out::type_id::create("tr_out", this);
    endfunction: build_phase
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        	A2 = 0;
			B2 = 0;
			A1 = 0;
			B1 = 0;
        forever begin
            in.get(tr_in);
            //tr_out.data = tr_out.data1;
			//tr_out.data1 = tr_out.data2;
			A2 <= A1;
			B2 <= B1;
			A1 <= tr_in.A;
			B1 <= tr_in.B;

			tr_out.data = $shortrealtobits($bitstoshortreal(A1) * $bitstoshortreal(B1));		
			delayed_Z <= tr_out.data;
            $display("refmod: input A = %f, input B = %f, output OUT = %f",$bitstoshortreal(A2), $bitstoshortreal(B2), $bitstoshortreal(delayed_Z));
			$display("refmod: input A = %b, input B = %b, output OUT = %b", A2, B2, delayed_Z);
            out.put(tr_out);
        end
    endtask: run_phase
endclass: refmod
