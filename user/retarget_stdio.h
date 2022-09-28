#ifndef RETARGET_STDIO_H
#define RETARGET_STDIO_H

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

#ifdef __GNUC__
int _write(int fd, char *ptr, int len);
#else
int fputc(int ch, FILE *f);
#endif

#ifdef __cplusplus
}
#endif

#endif /* RETARGET_STDIO_H */
