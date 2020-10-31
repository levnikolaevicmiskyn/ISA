#include <stdio.h>
#include <stdlib.h>

#define N 1
#define NBINT 8
#define NB 7 //Interface
const int b0 = 53 >> (NBINT-NB);
const int b[N] = {53 >> (NBINT-NB)};
const int a[N] = {21 >> (NBINT-NB)};
const int ASQ = 3 >> (NBINT-NB);

/// Perform fixed point filtering assuming the structure derived by applying the
/// lookahead method
int myfilter(int x){
    static int sw[3]; // Temporary variable shift register
    static int first_run = 0; // Flag
    static int xreg = 0;
    int w;
    int y;
    int i;

    if (first_run == 0){
        first_run = 1;
        for (i=0; i < 3; i++)
            sw[i]=0;
        xreg = 0;
    }

    /// Adapt x to the internal representation
    x = x >> (NBINT-NB);

    /// Calculate feedback and feedforward terms
    w = (sw[2]*ASQ >> (NB-1)) + (a[0]*xreg >> (NB-1)) + x;
    y = w*b0 >> (NB-1);

    for (i=N-1; i >= 0; i--){
        y += (b[i]*sw[i] >> (NB-1));
    }

    xreg = x;

    // Push a the last value of w into the shift register
    for (i=1; i < 3; i++)
        sw[i] = sw[i-1];
    sw[0] = w;


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
