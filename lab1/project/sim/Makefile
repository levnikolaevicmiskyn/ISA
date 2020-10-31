# Makefile for testbench
cfilter.out: myfilterii.o
	$(CC) $^ -o $@

myfilterii.o: myfilterii.c
	$(CC) -c -Wall -Werror $^

cfilter_fast.out: cfilter_fast.o
	$(CC) $^ -o $@

cfilter_fast.o: cfilter_fast.c
	$(CC) -c -Wall -Werror $^

clean:
	$(RM) -f *.out *.o
