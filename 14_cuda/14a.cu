#include <cstdio>
#include <cstring>
#include <iomanip>
#include <iostream>

int const MARKS = 256;
int const ROWS = 128;

__global__
void knotHash(unsigned char const *input, int inputSize, int *usedSquares) {
  int row = blockIdx.x * blockDim.x + threadIdx.x;

  unsigned char lengths[64];
  int numLengths = 0;
  for (int i = 0; i < inputSize; i++) {
    lengths[numLengths++] = input[i];
  }
  lengths[numLengths++] = '-';
  if (row >= 100) {
    lengths[numLengths++] = '0' + (row / 100);
  }
  if (row >= 10) {
    lengths[numLengths++] = '0' + ((row % 100) / 10);
  }
  lengths[numLengths++] = '0' + (row % 10);
  unsigned char const APPEND[] = { 17, 31, 73, 47, 23 };
  int const APPEND_SIZE = sizeof(APPEND) / sizeof(unsigned char);
  for (int i = 0; i < APPEND_SIZE; i++) {
    lengths[numLengths++] = APPEND[i];
  }

  int items[MARKS];
  for (int i = 0; i < MARKS; i++) {
    items[i] = i;
  }

  int start = 0;
  int skip = 0;
  for (int round = 0; round < 64; round++) {
    for (int i = 0; i < numLengths; i++) {
      int length = lengths[i];
      for (int j = 0; j < length / 2; j++) {
        int a = (start + j) % MARKS;
        int b = (start + length - 1 - j) % MARKS;
        unsigned char t = items[a];
        items[a] = items[b];
        items[b] = t;
      }
      start = (start + length + skip) % 256;
      skip = (skip + 1) % 256;
    }
  }

  unsigned char hash[16];
  for (int i = 0; i < 16; i++) {
    unsigned char xored = 0;
    for (int j = 0; j < 16; j++) {
      xored ^= items[16 * i + j];
    }
    hash[i] = xored;
  }

  int bitCount = 0;
  for (int i = 0; i < 16; i++) {
    for (int j = 1; j < 0x100; j <<= 1) {
      if (hash[i] & j) {
        bitCount++;
      }
    }
  }
  usedSquares[row] = bitCount;
}

int main(void) {
  std::string inputStr;
  std::getline(std::cin, inputStr);
  int n = inputStr.size();

  unsigned char *input;
  cudaMallocManaged(&input, n);
  memcpy(input, inputStr.data(), n);

  int *usedSquares;
  cudaMallocManaged(&usedSquares, ROWS * sizeof(int));

  knotHash<<<1, ROWS>>>(input, n, usedSquares);

  cudaDeviceSynchronize();

  int totalUsedSquares = 0;
  for (int i = 0; i < ROWS; i++) {
    totalUsedSquares += usedSquares[i];
  }
  std::cout << totalUsedSquares << '\n';

  cudaFree(input);
  cudaFree(usedSquares);

  return 0;
}
