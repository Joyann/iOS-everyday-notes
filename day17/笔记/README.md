- 类和对象在内存中的存储
  
  - 类本身在内存中占据一份存储空间。
  - 类中有__方法列表__，如果向对象发送消息，会在方法列表中查找是否有这个方法。
  - 每个对象在内存中各占据一份存储空间。
  - 每个对象都有一份属于自己的成员变量，互不影响。
  - 方法在整个内存中__只有一份__，存储于类存储的空间。
  - 所有的对象__共用__一份方法。
  - 类所占的空间相当于系统为我们创建，而对象的空间需要我们手动申请。
  
- __isa__指针
  
  - 系统为每个对象都创建了一个__isa指针__，这个指针指向__当前对象所属的类__。
    
  - 例如：
    
    ``` objective-c
    [person sayHello];  // person为Person的实例
    ```
    
    当执行到这一句的时候，表示给person这个对象发送sayHello方法，person会通过内部的isa指针找到Person类，如果在Person的__方法列表__中找到”sayHello”这个方法，那么就会执行。
    
  - 注意，isa并不是__这个对象的地址__，而是__这个对象所属的类的地址__。所以说同一个类实例化出的所有对象，它们的isa都是一样的，因为都指向这个类。而各个对象本身的地址返回给了我们创建的指针，例子：
    
    ``` objective-c
    Person *person = [Person new]; // person就是这个对象本身的地址
    ```
    
  - 如何查看isa指针所指向的地址：
    
    在实例化后打断点，然后在下面的debug面板中找到isa指针，然后点击”回车"，可以查到地址。
  
- 函数与方法的对比：
  
  - 方法：
    - 对象的声明只能写在@interface...@end中，实现只能写在@implementation...@end中。
    - 方法以”-“或”+”开头。
    - 对象方法/类方法 只能由 对象/类 调用，不能当作函数一样调用。
    - 方法归类/对象所有。
  - 函数：
    - 所有的函数都是平行的。
    - 函数不存在隶属关系。
    - 函数在使用的时候可以直接调用。
    - 虽然函数可以写在@implementation...@end中，但是它和方法是不同的，函数是__不可以访问成员变量__的。
    - 函数属于整个文件，除了__@interface...@end__中，函数的实现可以写在任何位置（包括@implementation...@end中）。写在@interface...@end中会无法识别。
    - 函数的声明可以在main函数内部也可以在main函数外部。
    - 不管将函数在@implementation...@end中实现（@interface...@end中是不能实现的）还是在类的外面实现，都可以正常的直接调用函数，而不必像方法那样需要类/对象。
  
- 注意，__成员变量是不能脱离对象独立存在的__，所以无论是__类方法__还是__函数__，在没有对象的前提下，都没法访问成员变量。
  
- __成员变量和方法不能用static关键字修饰，不要和C语言混淆。__
  
- 如果在类中有成员变量是结构体要注意。以下面为例：
  
  ``` objective-c
  import <Foundation/Foundation.h>
  typedef struct {
  	int year;
  	int month;
  	int day;
  }Birthday;
  
  @interface Person : NSObject
  {
  @public
  	NSString *_name;
  	Birthday _birthday;
  }
  @end
  
  @implementation Person
  @end
  
  int main(int argc, const char * argv[]) {
    	Person *person = [Person new];
    	person -> _name = @"Jay";
    	person -> _birthday = {1992, 2, 1};
  
    	NSLog(@"My birthday: %i,%i,%i", person->_birthday.year, person->_birthday.month, person->_birthday.day);
  
    	return 0;
  }
  ```

	这里有一个Person类，有两个成员变量，一个是NSString类型的name，一个是一个自定义结构体类型的生日。在main函数中我们为实例person的各个成员变量赋值，但是会在

``` objective-c
person -> _birthday = { 1994, 2, 1 };
```

  这一行报错（Expected expression），这是怎么回事呢？

  事实上，我们前面提到过，在类实例化时（[Person new]）做了三件事：

1. 为对象分配空间。
   
2. __初始化每一个成员变量__。
   
3. 返回这个实例的地址。
   
   所以\_birthday这个成员变量__已经被初始化__了。
   
   我们知道，如果结构体初始化之后，如果再想用{ }这种方式给它赋值，需要进行强制类型转换（因为编译器不知道这是数组还是结构体，如果是数组是不允许在初始化后再用{}的）。
   
   所以我们将出错的一行改成下面的代码就可以了：
   
   ``` objective-c
   person -> _birthday = (Birthday){ 1994, 2, 1 };
   ```
   
   还有另一种方法：
   
   删掉出错的那一行，然后改成单个赋值：
   
   ``` objective-c
   person -> _birthday.year = 1992;
   person -> _birthday.month = 2;
   person -> _birthday.day = 1;
   ```