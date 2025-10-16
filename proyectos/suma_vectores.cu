#include <iostream>
#include <cuda_runtime.h>

using namespace std;

__global__ void sumar_vectores(float* A, float* B, float* C, int N) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < N) {
        C[i] = A[i] + B[i];
    }
}

int main() {
    // Cantidad de elementos
    const int N = 5000;
    size_t size = N * sizeof(float);

    // Reservar memoria en la CPU
    float* h_A = new float[N];
    float* h_B = new float[N];
    float* h_C = new float[N];

    // Inicializar vectores
    for (int i = 0; i < N; i++) {
        h_A[i] = i + 1;
        h_B[i] = 2 * i + 2;
    }

    // Reservar memoria en la GPU
    float *d_A, *d_B, *d_C;
    cudaMalloc(&d_A, size);
    cudaMalloc(&d_B, size);
    cudaMalloc(&d_C, size);

    // Transferir datos a la GPU
    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

    // Configurar grid y blocks
    int threadsPorBloque = 1024;        // No puede superar 1024 hilos por bloque
    int bloquesPorGrid = (N + threadsPorBloque - 1) / threadsPorBloque;

    // Ejecutar kernel
    sumar_vectores<<<bloquesPorGrid, threadsPorBloque>>>(d_A, d_B, d_C, N);

    // Transferir resultados a la CPU
    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);

    // Mostrar algunos resultados
    for (int i = 0; i < N; i++) {
        cout << i + 1 << ". " << h_A[i] << " + " << h_B[i] << " = " << h_C[i] << endl;
    }

    // Liberar memoria
    delete[] h_A;
    delete[] h_B;
    delete[] h_C;
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    return 0;
}