- Block是一种__数据类型__。
  
- Block作用：
  
  - 用来保存某一段代码, 可以在恰当的时间再取出来调用
  - 功能类似于函数和方法
  
- Block的定义格式
  
  ``` objective-c
  返回值类型 (^block变量名)(形参列表) = ^(形参列表) {
  
  };
  ```
  
  ``` objective-c
  int (^myBlock)(int, int) = ^(int num1, int num2){ return num1 + num2; };
  ```
  
  注意，block是需要调用的：
  
  ``` objective-c
  int result = myBlock(2, 3);
  ```
  
- 注意，block是需要^号的，并且不需要写上返回值。并且这个时候你要写上参数名，因为在block体中你是需要用到参数的，不写参数名就没有办法访问参数了。
  
- typedef和block
  
  给block使用typedef，首先回忆如何给函数指针使用typedef：
  
  ``` objective-c
  typedef int (*calculate) (int, int); // 和给其他类型使用typedef不同，calculate就是typedef后的名字
  
  calculate sumP = sum;
  int res = sumP(10, 20);
  ```
  
  给block使用typedef与函数指针一样：
  
  ``` objective-c
  typedef int (^calculateBlock) (int, int);
  
  calculateBlock sumBlock = ^(int num1, int num2) { return num1 + num2; }
  int result = sumBlock(2, 3);
  ```
  
- 个人理解block与函数指针不同的是，函数指针需要依赖一个已经存在的函数，函数指针指向一个函数才可以发挥作用调用这个函数；而block则是在后面直接实现block体，因为block本身就是一种数据类型。
  
- block的注意事项：
  
  - 在block内部可以访问block外部的变量
    
    ``` objective-c
    int  a = 10;
    void (^myBlock)() = ^{
        NSLog(@"a = %i", a);
    }
    myBlock();
    输出结果: 10
    ```
    
  - block内部也可以定义和block外部的同名的变量(局部变量),此时局部变量会暂时屏蔽外部
    
    ``` objective-c
    int  a = 10;
    void (^myBlock)() = ^{
        int a = 50;
        NSLog(@"a = %i", a);
        }
    myBlock();
    输出结果: 50
    ```
    
  - 默认情况下, Block内部不能修改外面的局部变量
    
    ``` objective-c
    int b = 5;
    void (^myBlock)() = ^{
        b = 20; // 报错
        NSLog(@"b = %i", b);
        };
    myBlock();
    
    // 相当于传的是值的拷贝,不允许修改
    
    // 另一种情况：
    int b = 5;
    void (^myBlock)() = ^{
        NSLog(@"b = %i", b);
        };
    b = 10;
    myBlock();
    
    // 此时输出仍然是5，因为用的是值的拷贝，修改变量并无影响
    ```
    
  - Block内部可以修改使用__block修饰的局部变量
    
    ``` objective-c
    __block int b = 5;
    void (^myBlock)() = ^{
      b = 20;
      NSLog(@"b = %i", b);
      };
    myBlock();
    输出结果: 20
    
    // 相当于传址
    ```
    
  - Block是默认存储在栈空间的，但是如果使用Block_copy(yourBlock)会将block从栈空间拷贝到堆空间，所以block是可堆可栈的。
    
  - block如果在栈中，是不会对外界对象进行retain的；但是如果block在堆中，会对外界的对象进行一次retain，那么这样会给我们带来内存泄露的问题，解决办法是给对象加上\_\_block，这样哪怕block在堆中，也不会对外界对象进行retain。所以如果在block中访问外界对象，要给外界对象加上\__block。
  
- 理解block就像函数一样，但是它要比函数更灵活，它可以作为函数的参数和返回值，其本身就是一种数据类型。定义一个block除了要注意block的特定语法，那么写其body的时候基本就和写一个函数差不多。block的用途广泛，比如说当实现多个方法的时候，这些方法的前面部分和后面部分都是一样的，只有中间部分不一样，那么此时我们就可以用block作为方法的参数，然后在这些方法中间部分来执行传进来的block。也就是说block保存了一段代码，而且可以当参数，当我们想要执行这段代码的时候，我们可以在方法中任意的位置重新调用这段代码，非常的灵活方便。
  
  由此也可以想到，当我们在进行网络请求的时候，会通常调用某个类的某个网络请求的方法，在调用的过程中可能要求我们首先传入一个url，然后再传入一个handler用于处理从网络上拿回的数据。这个过程，首先给发送网络请求的方法传入一个url，然后在网络类中的网络请求方法会根据这个url发送请求，然后这个方法一直执行（异步），然后当成功拿回数据，这个时候这个方法会__调用我们传入的block__，将得到的数据传入block，这样一来，在最初调用网络请求方法的地方，block的参数就被赋予了从网络请求回来的数据，这样在block(也就是handler)中，我们就可以直接使用拿回的数据了，其过程类似于下面：
  
  ``` objective-c
  // Person.h
  #import <Foundation/Foundation.h>
  @interface Person : NSObject
  (void)getSomething: (void (^) (int height, int weight)) myBlock;
  @end
  
  // Person.m
  #import "Person.h"
  @implementation Person
  (void)getSomething: (void (^) (int height, int weight)) myBlock {
    NSLog(@"step1");
    NSLog(@"step2");
    NSLog(@"complete");
    myBlock(10, 20);   
  }
  @end
    
  // main.m
  #import <Foundation/Foundation.h>
  #import "Person.h"
    
  int main(int argc, const char * argv[]) {
    @autoreleasepool {
      Person *person = [[Person alloc] init];
      [person getSomething:^(int height, int weight) {
          NSLog(@"我被调用了，这个时候我被传入数据了");
          NSLog(@"height = %i, weight = %i", height, weight);
      }];
     }
    return 0;
  }
  
  // step1 
  
  // step2
  
  // complete
  
  // 我被调用了，这个时候我被传入数据了 
  
  // height = 10, weight = 20
  ```

  ​

  ​