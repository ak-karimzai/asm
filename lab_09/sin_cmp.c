#include <math.h>
#include <stdio.h>
#include <time.h>

#include "inc/sin_cmp.h"

void c_compare_sin(void)
{
    printf("[C]\n");
    printf("sin(PI) = %g\n", sin(M_PI));
    printf("sin(PI / 2) = %g\n", sin(M_PI / 2));
    printf("sin(3.14) = %g\n", sin(3.14));
    printf("sin(3.141596) = %g\n\n\n", sin(3.141596));
}

void asm_compare_sin(void)
{
    printf("[asm]\n");

    double res = 0.0;
    __asm__(
        "\n\t fldpi"
        "\n\t fsin"
        "\n\t fstp %0"
        : "=mam"(res)
    );
    printf("sin(pi) = %g\n", res);

    res = 2.0;
    __asm__(
        "\n\t fldpi"
        "\n\t fld %1"
        "\n\t fdivp"
        "\n\t fsin"
        "\n\t fstp %0"
        : "=m"(res) : "m"(res) 
    );
    printf("sin(pi / 2) = %g\n", res);

    res = 3.14;
    __asm__(
        "\n\t fld %1"
        "\n\t fsin"
        "\n\t fstp %0" : "=m" (res)  : "m" (res)
    );
    printf("sin(3.14) = %g\n", res);

    res = 3.141596;
    __asm__(
        "\n\t fld %1"
        "\n\t fsin"
        "\n\t fstp %0" : "=m" (res)  : "m" (res)
    );
    printf("sin(3.141596) = %g\n", res);
}

void compare_sin(void)
{
    c_compare_sin();
    asm_compare_sin();
}