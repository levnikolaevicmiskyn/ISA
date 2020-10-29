#include <stdio.h>
#include <stdlib.h>

#define NBINT 8
#define NB 7 //Interface
#define N 1
const int b0 = 53 >> (NBINT-NB);
const int b1 = 53 >> (NBINT-NB);
const int ASQ = 3 >> (NBINT-NB);
const int a1 = 21 >> (NBINT-NB);

/// Perform fixed point filtering assuming the structure derived by applying the
/// lookahead method
int myfilter(int x){
    static int sw[N]; // Temporary variable shift register
    static int first_run = 0; // Flag
    int w;
    int y;
    int i;
    static int x_reg=0;

    if (first_run == 0){
        first_run = 1;
        for(i=0; i < N; i++)
            sw[i] = 0;
    }

    /// Adapt x to the internal representation
    x = x >> (NBINT-NB);

    /// Calculate feedback and feedforward terms
    w = x + ((ASQ*sw[0])>>(NB-1)) + (a1*x_reg >> (NB-1));
    y = ((w*b0) >> (NB-1)) + ((sw[0]*b1) >> (NB-1));

    // Push a the last value of w into the shift register
    for (i=N-1; i > 0; i--)
        sw[i] = sw[i-1];
    sw[0] = w;
    x_reg = x;
    return (y << (NBINT-NB));
}

int main(int argc, char* argv[]) {
    FILE* fp_in;
    FILE* fp_out;

    int x, y;

    if (argc != 3){
        printf("Use %s <input_file> <output_file>\n", argv[0]);
        exit(1);
    }


    fp_in = fopen(argv[1], "r");
    if (fp_in == NULL) {
        printf("Cannot open %s", argv[1]);
        exit(2);
    }

    fp_out = fopen(argv[2], "w");

    fscanf(fp_in, "%d", &x);
    do{
        y = myfilter(x);
        fprintf(fp_out, "%d\n", y);
        fscanf(fp_in, "%d", &x);
    }while(!feof(fp_in));

    fclose(fp_in);
    fclose(fp_out);

    return 0;
}
