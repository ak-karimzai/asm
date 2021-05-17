#include <stdio.h>
#include <assert.h>
#include <string.h>

extern char* _strcpy(char *dst, const char *src);

size_t _strlen(const char *str)
{
    size_t len = 0;
    __asm__(
        "\n\t mov rcx, -1"
        "\n\t mov rdi, %1"
        "\n\t cld"
        "\n\t repnz scasb"
        "\n\t not rcx"
        "\n\t dec rcx"
        "\n\t mov %0, rcx"
        : "=r" (len)
        : "r" (str)
        : "rcx", "rdi"
    );
    return len;
}

void test_strcpy(char *dst, const char *src)
{
    _strcpy(dst, src);
    assert(strlen(src) == strlen(dst));
    for (size_t i = 0; i < strlen(src); i++)
        assert(*(src + i) == *(dst + i));
    printf("%s == %s\n\n", dst, src);
    printf("%s passed\n", __func__);
}

void test_strlen(const char *str)
{
    printf("%lu == %lu\n", _strlen(str), strlen(str));
    printf("%s passed\n", __func__);
}

void test(const char *str)
{
    char copy_str[100];
    test_strcpy(copy_str, str);
    test_strlen(str);
    test_strlen(copy_str);
}

int main(void)
{
    test("Test String");
    test("Lab_08 Lab_08 Lab_08 Lab_08 Lab_08");
    test("a");
    test("\0\0");
    test("");
    return 0;
}