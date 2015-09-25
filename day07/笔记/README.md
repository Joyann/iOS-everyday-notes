- Xcode函数（方法）注释方法:

  - /** 函数（方法）的解释 */
  - @param 参数名 参数解释
  - @warning 提醒注意的内容
  - @return 返回值 返回值解释

- C语言中函数的定义只能有一个，不能重名（与其它语言不同的是，只要名字一样就算重名，即使参数和返回值不同，比如int sayHello();和void sayHello(int a)是同名的）。

- 关于main函数：

  ``int main(int argc, const char * argv[])``

  argc代表__程序在进入main函数时的参数的个数__。默认为__1__。

  argv代表__包含的各个参数__。默认为__程序的名字__。

  ``printf(“argc: %i, argv: %s”, argc, argv[0]);``

  点击Xcode的停止键右边的按钮，可以找到__Edit Scheme__，点击进入，左面菜单里找到Run，之后在右边找到__Arguments__，找到__Arguments Passed On Launch__，里面添加启动参数。比如添加了一个”Hello”：

  ``printf(“argc: %i, argv: %s”, argc, argv[1]);``

  现在则是:

  `argc: 2, argv: Hello`

- 递归很消耗内存，因为每次调用都会开辟新的空间。通常来说一个函数写递归要分下面几步：

  - 找到__结束条件__，否则会无限递归下去。通常来说用if-else中的if来写。

  - 找到__递归公式__，即是以什么样的规律来递归的。通常用if-else中的else来写。

  - 用递归法求N的阶乘：

    > 分析
    >
    > ```
    > 4!=4*3*2*1
    >   =4*3!
    >   =4*3*2!
    >   =4*3*2*1!
    >
    > n!=(n-1)!*n;
    > (n-1)!=(n-2)!*(n-1);
    > ... ...
    >
    > 1!=1; 作为递归的结束条件
    > ```
    >
    > 实现
    >
    > ```
    > int factorial(int n){
    > int result = 0; //定义变量用于存放阶乘的结果
    > if (n==1) { //如果n=1的时候,1!的结果还是1
    >     result = 1;
    > }else{
    >     result = factorial(n-1)*n;//如果不是1,阶乘=(n-1)!*n;
    > }
    > return result;
    > }
    > ```

  - 设计一个函数用来计算B的n次方:

    > 分析
    >
    >   result = 1;
    >
    >   result =  b
    >
    >   result =  result * b
    >
    >   result =  result * b
    >
    >    myPow2(b, 0) = 1
    >
    >    myPow2(b, 1) = b == myPow2(b, 0) * b
    >
    >    myPow2(b, 2) = b * b == myPow2(b, 1) * b
    >
    >    myPow2(b, 3) = b * b * b == myPow2(b, 2) * b
    >
    > 实现
    >
    > ```
    > int myPow2(int base, int n)
    > {
    >   if (n <= 0) {
    >       return 1;
    >   }
    >   return myPow2(base, n - 1) * base;
    > }
    > ```
    >
    > ​


- \#include的头文件不参与编译。

- \#include <yourFile.h>和\#include “yourFile.h”：

  - 二者的区别在于：__当被include的文件路径不是绝对路径的时候，有不同的搜索顺序。__

  - 对于使用双引号""来include文件，搜索的时候按以下顺序：

    - 先在这条include指令的父文件所在文件夹内搜索，所谓的父文件，就是这条include指令所在的文件;
    - 如果上一步找不到，则在父文件的父文件所在文件夹内搜索；
    - 如果上一步找不到，则在编译器设置的include路径内搜索；
    - 如果上一步找不到，则在系统的include环境变量内搜索

  - 对于使用尖括号<>来include文件，搜索的时候按以下顺序：

    - 在编译器设置的include路径内搜索；
    - 如果上一步找不到，则在系统的include环境变量内搜索

  - > 如果你是自己安装clang编译器，clang设置include路径是（4.2是编译器版本）：
    >
    > /usr/lib/clang/4.2/include
    >
    > ​
    >
    > Xcode自带编译器, clang设置include路径是：
    >
    > /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/usr/include
    >
    > ​
    >
    > Mac系统的include路径有：
    >
    > /usr/include
    >
    > /usr/local/include
    >
    > ​
    >
    > 如果没有这个目录,可参考如下:
    >
    > 打开终端输入:xcode-select --install
    >
    > 安装Command Line Tools之后就会出现


- \#include注意事项：

  - include 不一定非要写在第一行（因为它的作用就相当于拷贝代码）

    > int main()
    >
    > {
    >
    >   \#include “yourFile.h"
    >
    >   return 0;
    >
    > }

  - include的时候,可以包含路径

    > \#include “yourDocument/yourFile.h"
    >
    > int main()
    >
    > {
    >
    >   return 0;
    >
    > }

  - include 语句之后不需要加";"(因为#include它是一个预处理指令,不是一个语句)

- Xcode运行原理：编译--->.o(目标文件)--->链接--->.out 执行。先将自己的代码编译成二进制(.o文件)，再与所依赖的函数（类似于stdio.h中的）链接，最后生成.out可执行文件。

- Mac下手动编译

  > cc -c main.c    // 编译
  >
  > cc main.o        // 链接
  >
  > ./a.out              // 执行
