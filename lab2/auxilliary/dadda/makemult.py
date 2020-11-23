f = open("template.vhd", "r")
conts = f.readlines()
start = conts.index("-- BEGIN AUTOGEN DECL\n")
end = conts.index("-- END AUTOGEN DECL\n")
f2 = open("decl.txt", "r")
declarations = f2.readlines()
f2.close()
conts = conts[0:start+1] + declarations + conts[end:]
f3 = open("comps.txt", "r")
body = f3.readlines()
start = conts.index("-- BEGIN AUTOGEN COMPS\n");
end = conts.index("-- END AUTOGEN COMPS\n");
conts = conts[0:start+1] + body + conts[end:]
fout = open("multiplier.vhd", "w")
fout.writelines(conts)
