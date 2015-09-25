- 全局变量：
  
  - 程序一启动就会分配空间，直到程序结束。
  - 存储位置在__静态存储区__。
  - 多个同名的全局变量指向__同一块存储空间。__
  - 全局变量默认为__0__。
  - 分类：
    - 内部变量：只能在这个文件内部访问（加上static关键字）
    - 外部变量：可以在其他文件中访问的变量,默认__所有全局变量都是外部变量__。(什么都不加或是有extern声明)
  
- static:
  
  - static对局部变量的作用：
    
    - 延长局部变量的生命周期,从程序启动到程序退出,但是__它并没有改变变量的作用域__。也就是说，虽然保证它一直存在，但是该不能用的时候还是不能用。
    - 定义变量的代码在整个程序运行期间__仅仅会执行一次。__注意，是__定义变量__的代码，也就是说只会定义一次。
    
  - static对全局变量的作用：
    
    - __由于静态全局变量的作用域局限于一个源文件内,只能为该源文件内的函数公用,因此可以 避免在其它源文件中引起错误。__
    
    ​
  
- extern:
  
  - 如果声明的时候没有写extern，那系统会自动定义这个变量,并将其初始化为0。
  - 如果声明的时候写extern了，那系统不会自动定义这个变量。
  - 一般时候用extern来声明变量是其他文件的外部变量。(？)
  
- static 与 extern对函数的作用：
  
  - C语言默认所有函数都是外部函数，可以被其他文件访问；而内部函数只能在本文件中访问。
    
  - 同样地，加上static关键字可以声明和定义一个函数变为内部函数，extern则可以声明和定义一个外部函数。
    
  - 例：
    
    ``` C
    // 声明一个内部函数
    static int sum(int num1,int num2);
    
    // 定义一个内部函数
    static int sum(int num1,int num2)
    {
    	return num1 + num2;
    }
    ```
    
    ``` c
    // 声明一个外部函数
    extern int sum(int num1,int num2);
    
    // 定义一个外部函数
    extern int sum(int num1,int num2)
    {
    	return num1 + num2;
    }
    ```
    
    ​
  
- typedef:
  
  - 宏定义也可以完成typedef的工作，但是宏定义是由预处理完成的，而typedef则是在编译时完成的，后者更为灵活方便且不易出错。
    
  - 例：
    
    ``` c
    typedef int INTEGER;
    
    typedef Integer MyInteger;
    
    typedef char NAME[20]; // 表示NAME是字符数组类型,数组长度为20。然后可用NAME 说明变量。
    NAME a; // 等价于 char a[20];
    
    typedef char * String;
    String myString = "hello";
    ```
    
    与结构体的声明定义一样，在对结构体使用typedef时，也有三种形式：
    
    ``` C
    struct Person{
        int age;
        char *name;
    };
    
    typedef struct Person PersonType; // PersonType person; person.age = ...
    
    /////////////////////////////////////////////////////////////////////
    
    typedef struct Person{
        int age;
        char *name;
    } PersonType;
    
    注意这个和结构体在定义的时候直接初始化一个值的区别，这个是由typedef关键字的，且是别名，而不是一个变量。
    
    /////////////////////////////////////////////////////////////////////
    
    typedef struct {
        int age;
        char *name;
    } PersonType;
    
    省略结构体名。
    
    /////////////////////////////////////////////////////////////////////
    
    // typedef和指向结构体的指针
    // 首先定义一个结构体并起别名 
      typedef struct { float x; float y; } Point;
    // 起别名
      typedef Point *PP;
    ```
    
    与枚举的声明定义一样，在对枚举使用typedef时，也有三种形式：
    
    ``` C
    enum Sex{
        SexMan,
        SexWoman,
        SexOther
    };
    typedef enum Sex SexType;
    
    /////////////////////////////////////////////////////////////////////
    
    typedef enum Sex{
        SexMan,
        SexWoman,
        SexOther
    } SexType;
    
    /////////////////////////////////////////////////////////////////////
    
    typedef enum{
        SexMan,
        SexWoman,
        SexOther
    } SexType;
    ```
    
    __typedef和函数指针:（重要！）__
    
    ``` C
    int add(int a, int b) {
    	return a + b;
    }
    
    int main() {
      	typedef int (*myFunction) (int, int); 
      //注意此时myFunction就是int (*myFunction) (int, int)的别名。表示这是一种指向函数的指针的类型。
      	myFunction p = add; 
      	p();
    	return 0;
    }
    ```
    
    ​
    
    ​
  
- 宏
  
  - 不带参数的宏定义：
    
    - 格式： #define 标示符 字符串(“字符串”可以是常数、表达式、格式串等。)
    - 宏名的有效范围是从定义位置到文件结束。如果需要终止宏定义的作用域，可以用#undef命令。
    
  - 带参数的宏定义：
    
    - 对带参数的宏,在调用中,不仅要宏展开,而且要用实参去代换形参。
      
    - \#define 宏名(形参表) 字符串
      
    - \#define average(a, b) (a+b)/2
      
    - 宏名和参数列表之间不能有空格，否则空格后面的所有字符串都作为替换的字符串。
      
    - 带参数的宏在展开时，只作简单的字符和参数的替换，不进行任何计算操作。所以在定义宏时，一般用一个小括号括住字符串的参数。并且计算结果最好也括起来防止错误。
      
      ``` C
      #define Pow(a) ( (a) * (a) )
      ```
  
- 条件编译
  
  - 在很多情况下，我们希望程序的其中一部分代码只有在满足一定条件时才进行编译，否则不参与编译(只有参与编译的代码最终才能被执行)，这就是条件编译。换句话说，在条件编译中，不满足条件的会直接被删去，并不会参与编译。
  - 条件编译和宏定义经常一起使用。

``` 

#define SCORE 67
#if SCORE > 90
    printf("优秀\n");
#else
    printf("不及格\n");
#endif

// 条件编译后面的条件表达式中不能识别变量,它里面只能识别常量和宏定义

#if 条件1
  ...code1...
 #elif 条件2
  ...code2...
 #else
  ...code3...
 #endif

#define SCORE 67
#if SCORE > 90
    printf("优秀\n");
#elif SCORE > 60
    printf("良好\n");
#else
    printf("不及格\n");
#endif

```

- 注意，条件一般是判断宏定义而不是判断变量，因为条件编译是在编译之前做的判断，宏定义也是编译之前定义的，而变量是在运行时才产生的。
- 一定不要忘记在最后加上 __#endif__  !
- ifndef 条件编译指令 与 上面用法类似，不过是条件相反的。


- 使用条件编译指令调试 bug
  
  ``` C
  #define DEBUG1 0
  #if DEBUG1 == 0 //format是格式控制,##表示可以没有参数,__VA_ARGS__表示变量 #define Log(format,...) printf(format,## __VA_ARGS__)
  #else
  #define Log(format,...)
  #endif
  
  void test(){
      Log("xxxxx");
  }
  int main(int argc, const char * argv[]) {
      Log("%d\n",10);
      return 0;
  }
  ```
  
  这种场景用Log代替printf，在调试的时候我们只需要改变宏定义的值，就可以灵活的控制输出的语句。比如把DEBUG1设置为0，变为调试状态，那么所有的printf就会替代Log输出一些信息；把DEBUG1设置为1，则关闭调试状态，则会将Log代替为空，则不会有输出。
  
  > 这里,‘...’指可变参数。这类宏在被调用时,##表示成零个或多个参数,包括里面的逗号,一直到到右括弧结束为止。当被调用时,在宏体(macro body)中,那些符号序列集合将代替里面 的VA_ARGS标识符。
  
- 或者用条件指令在调试阶段设置一些默认值，比如账号密码，等结束调试只需要改变宏命令就可以关闭这个功能。
  
- 在C语言中防止重复导入头文件的问题：
  
  ``` C
  #ifndef __xxxxxx__x__
  #define __xxxxxx__x__
  
  #include <stdio.h>
  
  #endif /* defined(__xxxxxx__x__) */
  ```
  
  比如这是xxxxx里面的x.h文件，当别的文件导入这个文件的时候（\#include），相当于复制这个文件里的内容。如果导入了多个文件不小心重复导入了同一个，那么像上面这样写是没有问题的。因为预处理指令会首先检查是否定义了
  
  ``` 
  __xxxxxx__x__
  ```
  
  如果没有定义，那么就定义，并且导入stdio.h文件。
  
  那么如果下次遇到（这时候都是在预编译的时候完成的），它仍然检查是否定义了
  
  ``` 
  __xxxxxx__x__
  ```
  
  这次因为刚才我们已经定义了，那么它就会直接结束这个指令，所以不会重复导入相同的头文件。
  
- 如果出现重复导入循环（比如a.h文件里导入了b.h，而b.h文件里导入了a.h），解决方法：
  
  如果a.h声明了一个add方法，b.h里面声明了一个minus方法，但是此时重复引用循环，编译器会报错，那么可以在b.h里面不再导入a.h就不会出现循环导入的问题。但是我又想在b.h里面访问a.h里面的add方法，但是此时b.h里面并没有导入a.h，那么我们就直接将add方法的声明复制到b.h里面即可。
  
- const
  
  const的作用主要是两个:
  
  1. 节省空间,避免不必要的内存分配。（Swift中建议使用let也是这个原因？）
     
     ``` C
     #define PI 3.14159 //常量宏
     const doulbe Pi=3.14159; //此时并未将Pi放入ROM中 ...... double i=Pi; //此时为Pi分配内存,以后不再分配!
     double I=PI; //编译期间进行宏替换,分配内存
     double j=Pi; //没有内存分配
     double J=PI; //再进行宏替换,又一次分配内存! const定义常量从汇编的角度来看,只是给出了对应的内存地址,而不是象#define一样给出的是立即数,所以,const定义的常量在程序运行过程中只有一份拷贝,而#define定义的常量在内存中有若干个拷贝。
     ```
     
     编译器通常不为普通const常量分配存储空间,而是将它们保存在符号表中,这使得它成为一个编译期间的常量,没有了存储与读内存的操作,使得它的效率也很高。
     
  2. 更加安全。
  
  使用：
  
  1. 在变量名前或变量名后。 
     
     int const x = 2; 
     
     const int x = 2;
     
  2. 注意用const修饰指针：
     
     - const int *A; //const修饰指针,A可变,A指向的值不能被修改 
       
     - int const *A; //const修饰指向的对象,A可变,A指向的对象不可变 
       
     - int *const A; //const修饰指针A, A不可变,A指向的对象可变 
       
     - const int *const A;//指针A和A指向的对象都不可变
       
       ​
     
     > 先看“*”的位置
     > 
     > 如果const 在 *的左侧 表示值不能修改,但是指向可以改。
     > 
     > 如果const 在 *的右侧 表示指向不能改,但是值可以改
     > 
     > 如果在“*”的两侧都有const 标识指向和值都不能改。