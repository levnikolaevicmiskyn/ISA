class packet_in extends uvm_sequence_item;
    rand integer A_sig;
    rand integer B_sig;
	rand integer A_exp;
    rand integer B_exp;
	rand integer A_sign;
	rand integer B_sign;

	constraint fp_constrs{A_exp inside {[1:254]}; B_exp inside {[1:254]}; A_sign inside {[0:1]}; B_sign inside{[0:1]}; A_sig inside{[0:(2**23-1)]}; B_sig inside{[0:(2**23-1)]}; B_exp > 128 - A_exp; B_exp < 380 - A_exp; solve A_exp before B_exp;}

	rand integer A;
	rand integer B;
	constraint final_constr{ A == ((A_sign << 31) + (A_exp << 23) + A_sig); B == ((B_sign << 31) + (B_exp << 23) + B_sig);solve A_sign before A; solve A_exp before A;solve A_sig before A;solve B_sign before B; solve B_exp before B;solve B_sig before B;}


    `uvm_object_utils_begin(packet_in)
        `uvm_field_int(A, UVM_ALL_ON|UVM_HEX)
        `uvm_field_int(B, UVM_ALL_ON|UVM_HEX)
    `uvm_object_utils_end

    function new(string name="packet_in");
        super.new(name);
    endfunction: new
endclass: packet_in
