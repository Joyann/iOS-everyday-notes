- @property是编译器指令。（告诉编译器做什么）
  
- @propety让编译器做的事：
  
  - @property用在声明文件中告诉编译器__声明__成员变量的getter/setter方法，这样就不需要我们手写getter和setter方法的声明了。
  
- @property用在@interface...@end中，用来自动生成setter和getter的声明：
  
  ``` objective-c
  @property int age; //等价于下面两行
  
  - (int)age;
  - (void)setAge:(int)age;
  ```
  
- 以__@property int age__为例，这里的age不像是我们之前声明成员变量需要加上下划线。@property会根据age来生成setter和getter方法的声明，因为在setter/getter方法的声明中不需要下划线：
  
  ``` objective-c
  - (int)_age;
  - (void)set_age:(int)age;
  ```
  
  所以在这里我们也不加下划线。
  
  ------
  
  ​
  
- ​@synthesize是编译器指令。
  
- @synthesize与@property对应，告诉编译器在实现文件里__实现__成员变量的setter/getter方法。
  
- @synthesize用在@implementation...@end中，用来自动生成setter和getter的实现：
  
  ``` objective-c
  用@synthesize age = _age; // 等价于下面两行
  
  - (int)age{
      return _age;
  }
  - (void)setAge:(int)age{
      _age = age;
  }
  ```
  
- 以__@synthesize age = _age__为例，这里我们比@property多出一步操作。
  
  因为在setter/getter的实现方法里，我们需要确定__将传进来的值赋值给谁__（setter方法）和__返回哪个实例变量__(getter方法)。所以@synthsize age生成实现方法，然后age = \_age的意思就是在实现的setter方法中将传进来的age赋给\_age，在getter方法里返回\_age。
  
- 注意，如果这里不写”= _age”：
  
  ``` objective-c
  @synthesize age;
  ```
  
  那么相当于__@synthesize age = age__，所以上面说的\_age都将换成age。（传来的age赋值给成员变量age；返回的是成员变量age）。如果age成员变量不存在，那么会自动生成一个@private的成员变量age。
  
- 也就是说，在@synthsize后面的名字是生成setter/getter方法的名字，等号后面的名字是setter/getter方法里赋值和返回的成员变量的名字。
  
  ``` objective-c
  @interface Person : NSObject
  {
      @public
      int _age;
      int _number;
  }
  
  @property int age;
  
  @end
  
  @implementation Person
  
  @synthesize age = _number;
  
  @end
  ```
  
  如果是这样，那么
  
  ``` objective-c
  Person *p = [Person new];
  [p setAge:30];
  ```
  
  实际上是给__\_number__赋值30。
  
- @synthesize注意点：
  
  - @synthesize age = _age;
    
    - setter和getter实现中会访问成员变量_age。
    - 如果成员变量\_age不存在，就会自动生成一个@private的成员变量\_age。
    
  - @synthesize age;
    
    - setter和getter实现中会访问@synthesize后同名成员变量age。
    - 如果成员变量age不存在，就会自动生成一个@private的成员变量age。
    
  - 多个属性可以通过一行@synthesize搞定,多个属性之间用逗号连接。
    
    ``` objective-c
    @synthesize age = _age, number = _number, name  = _name;
    ```
    
  - 注意，@property和@synthsize都不写在成员变量的{}里面，不要弄混了。

------



- __@property增强__
  
  - 自从Xcode 4.x后，@property可以__同时生成setter和getter的声明和实现__。
    
  - 默认情况下，setter和getter方法中的实现，__会去访问下划线 _ 开头的成员变量__。
    
    ``` objective-c
    @interface Person : NSObject
    {
        @public
        int _age;
        int age;
    }
    @property int age;
    
    @end
    
    int main(int argc, const char * argv[]) {
    
        Person *p = [Person new];
        [p setAge:30];
        NSLog(@"age = %i, _age = %i", p->age, p->_age);
    
        return 0;
    }
    ```
    
  - 如果类中没有下划线开头的成员变量，那么@property会__自动生成一个下划线开头的私有成员变量，声明在.m文件中，也就是说在其它文件中无法查看，只有自己的类才可以访问。__
    
  - 如果需要对数据进行判断需要我们之间重写getter/setter方法。
    
    - 若手动实现了setter方法，编译器就只会自动生成getter方法。
    - 若手动实现了getter方法，编译器就只会自动生成setter方法。
    - 若同时手动实现了setter和getter方法，编译器就不会自动生成不存在的成员变量。（如果是这样，需要@synthesize age = \_age来告诉setter/getter该给哪个成员变量赋值和返回哪个成员变量。注意，这里如果我们没有手动声明一个\_age成员变量，那么@synthesize将自动帮我们生成一个\_age成员变量，并且是私有变量。）
    
    ​
  
- @property修饰符
  
  - readonly
    
    ``` objective-c
    @property (readonly) int age; // 只生成getter方法，不生成setter方法
    ```
    
  - getter=和setter=
    
    ``` objective-c
    @property (getter=isMarried)  BOOL  married; // 生成的getter方法变为isMarried
    ```