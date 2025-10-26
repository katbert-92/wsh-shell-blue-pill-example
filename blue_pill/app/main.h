#ifndef __MAIN_H
#define __MAIN_H

#include "stm32f1xx_hal.h"
#include <stdarg.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * @brief The Berry Script Language
 */
#ifndef BERRY_LANG
    #define BERRY_LANG 1
#endif /* BERRY_LANG */

void Error_Handler(void);

#endif /* __MAIN_H */
