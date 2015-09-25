- 实例变量修饰符：
  
  - __@public (公开的)__  在有对象的前􏰀下,任何地方都可以直接访问。
  - __@protected (受保护的)__  只能在当前类和子类的对象方法中访问。
  - __@private (私有的)__  只能在当前类的对象方法中才能直接访问。
  - __@package (框架级别的)__  作用域介于私有和公开之间,只要处于同一个框架中相当于@public,在框架外部相当于@private。
  
- 在@implementation...@end间声明成员变量，即使是public，外界也是完全不可见的。在@interface...@end中，虽然有的实例变量并不能被访问，但是是可见的。
  
- description：
  
  - 当使用NSLog：
    
    ``` objective-c
    NSLog(@"%@", objectA);
    ```
    
    这会自动调用objectA的__description__方法来输出ObjectA的描述信息。
    
  - description方法默认返回对象的描述信息(默认实现是返回类名和对象的内存地址)。
    
    ``` objective-c
    <objectA:地址>
    ```
    
  - > description方法是基类NSObject 所带的方法,因为其默认实现是返回类名和对象的内存地址, 这样的话,使用NSLog输出OC对象,意义就不是很大,因为我们并不关心对象的内存地址,比较关心的是对象内部的一些成变量的值。因此,会经常重写description方法,覆盖description方法 的默认实现。
    
  - 事实上一共有两个description方法：
    
    - 对象方法：
      
      ``` objective-c
      -(NSString *) description // 当使用NSLog输出该类的实例对象的时候调用
      ```
      
    - 类方法：
      
      ``` objective-c
      +(NSString *) description // 当使用NSLog输出该类的类对象的时候调用
      ```
    
  - 也就是说，我们如果有一个类，如果基类是NSObject，那么我们就可以重写description方法。在description方法返回的字符串中，我们可以返回一些想要打印的信息。这样，在使用NSLog方法打印这个类/对象的时候，控制台就会输出我们在description方法中返回的字符串。
    
    ``` objective-c
    NSLog(@"%@", myObject);
    NSLog(@"%@", [MyClass class]);
    ```
    
  - description陷阱
    
    - 千万不要在description方法中同时使用%@和self,下面的写法是错误的：
      
      ``` objective-c
      - (NSString *)description {
          return [NSString stringWithFormat:@"%@", self];
      }
      ```
      
    - 同时使用了%@和self,代表要调用self的description方法,因此最终会导致程序陷入死循环,循环调用description方法。
      
    - 当[NSString stringWithFormat:@“%@”, self]; 使用它时，循环调用，导致系统会发生运行时错误。
      
    - 当该方法使用NSLog(“%@”,self) 时候， 系统做了相关的优化，循坏调用3次后就会自动退出。