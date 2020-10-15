# Makefile for testbench
cfilter.out: myfilterii.o
	$(CC) $^ -o $@

myfilterii.o: myfilterii.c
	$(CC) -c -Wall -Werror $^

clean:
	$(RM) -f *.out *.o
