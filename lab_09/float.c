#include <float.h>
#include <stdio.h>
#include <time.h>

#include "inc/float_cmp.h"

static void add_fpu(float lhs, float rhs, size_t n_times)
{
    float res;
    for (size_t i = 0; i < n_times; i++)
        res = lhs + rhs;
}

static void asm_add_fpu(float lhs, float rhs, size_t n_times)
{
    float res;
    for (size_t i = 0; i < n_times; i++)
    {
        __asm__ (
            "\n\t fld %1"
            "\n\t fld %2"
            "\n\t faddp"
            "\n\t fstp %0" : "=m" (res) : "m" (lhs), "m" (rhs)
        );
    }
}

static void mul_fpu(float lhs, float rhs, size_t n_times)
{
    float res;
    for (size_t i = 0; i < n_times; i++)
        res = lhs * rhs;
}

static void asm_mul_fpu(float lhs, float rhs, size_t n_times)
{
    float res;
    for (size_t i = 0; i < n_times; i++)
    {
        __asm__ (
            "\n\t fld %1"
            "\n\t fld %2"
            "\n\t fmulp"
            "\n\t fstp %0" : "=m" (res) : "m" (lhs), "m" (rhs)
        );
    }
}

static double function_exec_time(void (*_func)(float, float, size_t), \
                          float lhs, float rhs, size_t repeat_time)
{
    clock_t start_time, end_time;
    start_time = clock();
    _func(lhs, rhs, repeat_time);
    end_time = clock();
    return ((double)(end_time - start_time) / CLOCKS_PER_SEC) / repeat_time;
}

static void print_result(const double *arr, const char *msg)
{
    printf("Type name = %s\n", msg);
    printf("C Addition time = %g\n", arr[0]);
    printf("Asm Addition time = %g\n", arr[1]);
    printf("C Multiplication time = %g\n", arr[2]);
    printf("Asm Multiplication time = %g\n", arr[3]);
    printf("\n\n");
}

void compare_float()
{
    float a = FLT_MAX / 6, b = a;
    double exec_time[4];
    exec_time[0] = function_exec_time(add_fpu, a, b, RTime);
    exec_time[1] = function_exec_time(asm_add_fpu, a, b, RTime);
    exec_time[2] = function_exec_time(mul_fpu, a, b, RTime);
    exec_time[3] = function_exec_time(asm_mul_fpu, a, b, RTime);
    print_result(exec_time, "float");
}