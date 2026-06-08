//-------------------------------------------------------------------------------
// Algorytm ma zoptymalizowac działanie mnożenia wektora przez macierz
// (maks. 8 punktów): jednym sposobem
// (maks. 10 punktów): dwoma sposobami

// Uwaga: prosze użyć biblioteki eval_time do porównania czasów
//-------------------------------------------------------------------------------

#include <stdio.h>
#include <math.h>
// #include <x86intrin.h> <- mi nie działa, więc zakomentowałem
#include "eval_time.h"

// Rozmiar glownych macierzy
#define SIZE 10000

static double a[SIZE * SIZE];
static double x[SIZE];
static double y[SIZE];
static double z[SIZE];

double t1, t2;

void mat_vec_naive(int, double *, double *, double *);
void mat_vec_optim(int, double *, double *, double *);

int main(void)
{

  unsigned int i, j, n;
  unsigned long f;
  double time_tabl[3];

  n = SIZE;

  // Liczba operacji zmiennoprzecinkowych:
  f = 2 * (unsigned long)n * (unsigned long)n;

  // INIT - wypelnienie tablic a i b wartosciami poczatkowymi,

  for (i = 0; i < SIZE * SIZE; ++i)
    a[i] = (double)i;
  for (i = 0; i < SIZE; ++i)
    x[i] = (double)(SIZE - i);


  init_time();
  mat_vec_naive(n, a, x, y);
  read_time(time_tabl);
  t1 = time_tabl[1];
  printf("naive       = %lf s\n", t1);
  printf("GFLOPS      = %lf\n\n", (double)f / time_tabl[1] * 1.0e-9);


  init_time();
  mat_vec_optim(n, a, x, z);
  read_time(time_tabl);
  t2 = time_tabl[1];
  printf("optim       = %lf s\n", t2);
  printf("GFLOPS      = %lf\n\n", (double)f / time_tabl[1] * 1.0e-9);
  printf("Speedup       = %3.3lf \n\n", t1 / t2);

  // Test poprawnosci mnozenia - sprawdzenie czy oba algorytmy daly ten sam wynik.

  for (i = 0; i < SIZE; ++i)
    if (fabs(y[i] - z[i]) > 1.0e-9)
    {
      printf("Error!\n");
      goto rtrn;
    }

rtrn:
  return (0);
}

//---------------------------------------------------------------------

void mat_vec_naive(int n, double *a, double *x, double *y)
{
  register int i, j;

  for (i = 0; i < n; ++i)
    for (j = 0; j < n; ++j)
      y[i] += a[i + n * j] * x[j];
}

//---------------------------------------------------------------------

void mat_vec_optim(int n, double *a, double *x, double *y)
{
  register int i, j;

  // SPOSÓB 1: Zamiana kolejnosci petli (j na zewnatrz)
  for (j = 0; j < n; ++j)
  {
    // SPOSÓB 2: Wyciagniecie stalej wartosci x[j] przed wewnetrzna petle
    double xj = x[j];

    for (i = 0; i < n; ++i)
    {
      y[i] += a[i + n * j] * xj;
    }
  }
}

//---------------------------------------------------------------------

// Kompilacja
// gcc kol2_2.c eval_time.c -o main -lm
// ./main
