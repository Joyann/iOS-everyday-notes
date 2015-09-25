//
//  main.c
//  for循环嵌套问题
//
//  Created by joyann on 15/8/15.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[]) {
    
    /*
     
     *
     **
     ***
     ****
     
    */
    
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j <= i; j++) {
            printf("*");
        }
        printf("\n");
    }
    
    printf("----------");
    
    /*
     
     ****
     ***
     **
     *
     
     */
    
    for (int i = 0; i < 4; i++) {
        for (int j = i; j < 4; j++) {
            printf("*");
        }
        printf("\n");
    }
    
    printf("----------\n");

    /*
     
     1
     12
     123
     1234
     
    */
    
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j <= i; j++) {
            printf("%i", j + 1);
        }
        printf("\n");
    }
    
    printf("----------\n");

    /*
     
     1
     22
     333
     4444
     
     */
    
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j <= i; j++) {
            printf("%i", i + 1);
        }
        printf("\n");
    }
    
    printf("----------\n");
    
    /*
    
     --*
     -***
     *****
     
    */
    
    for (int i = 0; i < 3; i++) {
        for (int j = i; j < 2; j++) {
            printf("-");
        }
        for (int n = 0; n <= i * 2; n++) {
            printf("*");
        }
        printf("\n");
    }
    
    printf("----------\n");
    
    /*
    
     1 * 1 = 1
     1 * 2 = 2     2 * 2 = 4
     1 * 3 = 3     2 * 3 = 6     3 * 3 = 9
     
    */
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j <= i; j++) {
            printf("%i * %i = %i\t", (j + 1), (i + 1), ((i + 1) * (j + 1)));
        }
        printf("\n");
    }
    
    return 0;
}
