#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <time.h>

#define N_MAX 25600

float c_dot_product(const float *lhs, const float *rhs, size_t size)
{
    assert(lhs && rhs);
    float sum = 0;
    for (size_t i = 0; i < size; i++)
        sum += lhs[i] * rhs[i];
    return sum;
}

float asm_dot_product(const float *lhs, const float *rhs, size_t size)
{
    assert(lhs && rhs);
    float res = 0.0f;
    __asm__(
        "\n\t mov rsi, %1"
        "\n\t mov rdi, %2"
        "\n\t mov rax, %3"
        "\n\t xor rcx, rcx"
        "\n\t xorps xmm0, xmm0"
        "\n\t _start:"
        "\n\t\t cmp rax, 4"
        "\n\t\t jl _end"
        "\n\t\t movdqu xmm3, [rsi + rcx]"
        "\n\t\t movdqu xmm2, [rdi + rcx]"
        "\n\t\t vmulps xmm1, xmm2, xmm3"
        "\n\t\t haddps xmm1, xmm1"
        "\n\t\t haddps xmm1, xmm1"
        "\n\t\t psrldq xmm1, 4"
        "\n\t\t addss xmm0, xmm1"
        "\n\t\t xorps xmm1, xmm1"
        "\n\t\t sub rax, 4"
        "\n\t\t add rcx, 16"
        "\n\t\t jmp _start"
        "\n\t _end:"
        "\n\t\t test rax, rax"
        "\n\t\t jz _return"
        "\n\t\t dec rax"
        "\n\t\t movss xmm1, [rsi + rcx]"
        "\n\t\t movss xmm2, [rdi + rcx]"
        "\n\t\t mulss xmm1, xmm2"
        "\n\t\t addss xmm0, xmm1"
        "\n\t\t jmp _end"
        "\n\t _return:"
        "\n\t\t movss %0, xmm0"
        : "=m" (res)
        : "m"(lhs), "m"(rhs), "m"(size)
        : "rax", "rcx", "rsi", "rdi", "xmm0", "xmm1", "xmm2", "xmm3", "xmm7"
    );
    return res;
}

static inline void make_radnom_arrays(float *fst, float *snd)
{
    for (size_t i = 0; i < N_MAX; i++)
    {
        *(fst + i) = 1;
        *(snd + i) = 1.0f / ((int) i + N_MAX);
    }
}

double get_function_excec_time(const float *lhs, const float *rhs, \
                                float (*func)(const float *, const float *, size_t), \
                                float *res)
{
    clock_t start;
    start = clock();
    for (int i = 0; i < 1000; i++)
        *res = func(lhs, rhs, N_MAX);
    return ((double) clock() - start) / CLOCKS_PER_SEC;
}

int main()
{
    float a[N_MAX];
    float b[N_MAX];
    float c_res, asm_res;
    make_radnom_arrays(a, b);

    double c_excec_time = get_function_excec_time(a, b, c_dot_product, &c_res);
    printf("[C] Excec time = %lf\n\t   res = %f\n", c_excec_time, c_res);

    double asm_excec_time = get_function_excec_time(a, b, asm_dot_product, &asm_res);
    printf("[ASM] Excec time = %lf\n\t   res = %f\n", asm_excec_time, asm_res);
    return 0;
}