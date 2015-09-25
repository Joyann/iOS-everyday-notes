//
//  main.m
//  第二天作业
//
//  Created by joyann on 15/8/12.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        // 1. scanf方法错误，缺少&
        // 2. double不能用于%操作
        // 3. 120 10 30 260
        // 接受用户从键盘上输入的两个字符，然后输出他们
//        char charA, charB;
//        scanf("%c,%c", &charA, &charB);
//        printf("%c %c", charA, charB);
        // 接受用户从键盘上如何的连个双精度浮点数，然后输出他们
//        double doubleA, doubleB;
//        scanf("%lf,%lf", &doubleA, &doubleB);
//        printf("%lf %lf", doubleA, doubleB);
        // 接受用户从键盘上如何的连个单精度浮点数，然后输出他们(保留两位整数))
        float floatA, floatB;
        scanf("%f,%f", &floatA, &floatB);
        printf("%.2f %.2f", floatA, floatB);
        // 用户从键盘上输入两个整数，然后输出他们和
//        int intA, intB;
//        scanf("%i,%i", &intA, &intB);
//        printf("%i", intA + intB);
        // 用户从键盘上输入两个整数，然后输出他们差
//        scanf("%i,%i", &intA, &intB);
//        printf("%i", intA - intB);
        // 用户从键盘上输入两个整数，输出他们的商
//        scanf("%i,%i", &intA, &intB);
//        printf("%i", intA / intB);
        // 用户从键盘上输入两个整数，输出他们的余数
//        scanf("%i,%i", &intA, &intB);
//        printf("%i", intA % intB);
        // 在控制台输出 %
//        printf("%%");
        
    }
    return 0;
}
