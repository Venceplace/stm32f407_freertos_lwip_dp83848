#include "retarget_stdio.h"

#ifdef __cplusplus
extern "C" {
#endif

#include "stm32f4xx_hal.h"
#include "usart.h"

static int read_bc = 0;

static int __serial_send(char *buf, uint16_t size)
{
    HAL_UART_Transmit(&huart1, (uint8_t *)buf, size, 100);
    return size;
}

#ifdef __GNUC__
int _write(int fd, char *ptr, int len)
{
    int i = 0;

    /* only work for STDOUT, STDIN, and STDERR */
    if (fd > 2)
    {
        return -1;
    }

    while (*ptr && (i < len))
    {
        if (*ptr == '\n' && !read_bc)
            __serial_send("\r", 1);

        read_bc = ((*ptr == '\r') ? 1 : 0);

        __serial_send(ptr, 1);

        i++;
        ptr++;
    }

    return i;
}
#else
#define PRINT_BUF_SIZE 2
static char buf[PRINT_BUF_SIZE];

int fputc(int ch, FILE *f)
{
    buf[0] = ch;
    if (ch == '\r')
    {
        read_bc = 1;
    }
    else if (ch == '\n')
    {
        if (!read_bc)
        {
            buf[0] = '\r';
            buf[1] = '\n';
            __serial_send(buf, 2);
            return ch;
        }
        read_bc = 0;
    }
    else if (read_bc)
    {
        read_bc = 0;
    }

    __serial_send(buf, 1);

    return ch;
}
#endif

#ifdef __cplusplus
}
#endif


