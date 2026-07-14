#define N 3

int A[N][N] = {
    {1,2,3},
    {4,5,6},
    {7,8,9}
};

int B[N][N] = {
    {9,8,7},
    {6,5,4},
    {3,2,1}
};

int C[N][N];

int main(void)
{
    int i, j, k;

    for (i = 0; i < N; i++) {
        for (j = 0; j < N; j++) {
            C[i][j] = 0;

            for (k = 0; k < N; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }

    while (1);

    return 0;
}