- @class只是告诉编译器有这个类，但并不会拷贝这个类的.h文件。
  
- 具体使用：
  
  - 在.h文件中使用@class引用一个类
  - 在.m文件中使用#import包含这个类的.h文件
  
- @class应用场景（为什么要在.h中用@class而不是直接#import的方式）
  
  - 对于循环依赖关系来说，比方A类引用B类，同时B类也引用A类，这种嵌套包含的代码编译会报错
    
    ``` objective-c
    #import "B.h"
    @interface A : NSObject
    {
        B *_b;
    }
    @end
    
    #import "A.h"
    @interface B : NSObject
    {
        A *_a;
    }
    @end
    ```
    
  - 当使用@class在两个类相互声明，就不会出现编译报错
    
    ``` objective-c
    @class B;
    @interface A : NSObject
    {
        B *_b;
    }
    @end
    
    @class A;
    @interface B : NSObject
    {
        A *_a;
    }
    @end
    ```
    
    因为@class只是告诉编译器有这个类，并没有真正的拷贝.h文件里的内容；而#import则是真正的拷贝内容，这样就会造成循环拷贝。
    
  - 还有一种情况是因为，如果有一个类的.h文件进行修改，那么所有#import这个类的文件都会重新修改；相对来说，@class就不会出现这种问题。
  
- 总结@class和#import：
  
  - 作用上的区别
    - \#import会包含引用类的所有信息(内容),包括引用类的变量和方法。
    - @class仅仅是告诉编译器有这么一个类, 具体这个类里有什么信息, 完全不知。
  - 效率上的区别
    - 如果有上百个头文件都#import了同一个文件，或者这些文件依次被#import,那么一旦最开始的头文件稍有改动，后面引用到这个文件的所有类都需要重新编译一遍 , 编译效率非常低。
    - 相对来讲，使用@class方式就不会出现这种问题了。
  - \#import有可能造成循环拷贝，@class则不会。