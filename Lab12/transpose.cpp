#include "transpose.h"
int min(int, int);

// modify this function to add tiling
void transpose_tiled(int **A, int **B) {
    for (int i = 0; i < SIZE; i ++) {
        for (int j = 0; j < SIZE; j ++) {
            B[i][j] = A[j][i];
        }
    }
}
