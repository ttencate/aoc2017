#include <cstdio>
#include <cstring>
#include <iomanip>
#include <iostream>

int const MARKS = 256;
int const ROWS = 128;
int const COLS = 128;

__global__
void knotHash(unsigned char const *input, int inputSize, int *grid) {
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

  for (int i = 0; i < COLS; i++) {
    int index = COLS * row + i;
    grid[index] = (hash[i / 8] & (1 << (7 - (i % 8)))) ? -1 : 0;
  }
}

class Fifo {
  static int const SIZE = ROWS * COLS;
  int elements[SIZE];
  int head;
  int tail;

public:
  __device__
  Fifo() {
    head = 0;
    tail = 0;
  }

  __device__
  void add(int element) {
    elements[tail] = element;
    tail = (tail + 1) % SIZE;
  }

  __device__
  int remove() {
    int element = elements[head];
    head = (head + 1) % SIZE;
    return element;
  }

  __device__
  bool isEmpty() const {
    return head == tail;
  }
};

__device__
int idx(int i, int j) {
  return i * COLS + j;
}

__device__
void floodFill(int *grid, int i, int j, int label) {
  Fifo queue;
  queue.add(idx(i, j));
  while (!queue.isEmpty()) {
    int index = queue.remove();
    if (grid[index] >= 0) {
      continue;
    }
    grid[index] = label;
    int i = index / COLS;
    int j = index % COLS;
    if (i > 0) queue.add(idx(i - 1, j));
    if (i < ROWS - 1) queue.add(idx(i + 1, j));
    if (j > 0) queue.add(idx(i, j - 1));
    if (j < COLS - 1) queue.add(idx(i, j + 1));
  }
}

__global__
void labelConnectedComponents(int *grid, int *numConnectedComponents) {
  int numLabels = 0;
  for (int i = 0; i < ROWS; i++) {
    for (int j = 0; j < COLS; j++) {
      if (grid[i * COLS + j] < 0) {
        numLabels++;
        floodFill(grid, i, j, numLabels);
      }
    }
  }
  *numConnectedComponents = numLabels;
}

int main(void) {
  std::string inputStr;
  std::getline(std::cin, inputStr);
  int n = inputStr.size();

  unsigned char *input;
  cudaMallocManaged(&input, n);
  memcpy(input, inputStr.data(), n);

  int *grid;
  cudaMallocManaged(&grid, ROWS * COLS * sizeof(int));

  int *numConnectedComponents;
  cudaMallocManaged(&numConnectedComponents, sizeof(int));

  cudaDeviceSetLimit(cudaLimitStackSize, 10 * (1 << 20));

  knotHash<<<1, ROWS>>>(input, n, grid);
  cudaDeviceSynchronize(); // Not sure if needed to prevent both kernels running in parallel.
  labelConnectedComponents<<<1, 1>>>(grid, numConnectedComponents);
  cudaDeviceSynchronize();

  std::cout << *numConnectedComponents << '\n';

  cudaFree(input);
  cudaFree(grid);
  cudaFree(numConnectedComponents);

  return 0;
}

