- Category的作用：
  
  - 可以在不修改原来类的基础上, 为这个类扩充一些方法
  - 一个庞大的类可以分模块开发
  - 一个庞大的类可以由多个人来编写,更有利于团队合作
  
- Category的格式
  
  - 名称为__原始类名+category__的名字。
    
  - 在.h文件中声明类别
    
    1. 新添加的方法必须写在 @interface 与 @end之间
       
    2. 格式：
       
       ``` objective-c
       @interface ClassName (CategoryName)
       NewMethod; //在类别中添加方法
       //不允许在类别中添加变量
       @end
       ```
    
  - 在.m文件中实现类别
    
    1. 新方法的实现必须写在@ implementation与@end之间
       
    2. 格式：
       
       ``` objective-c
       @implementation ClassName(CategoryName)
       NewMethod
       ... ...
       @end
       ```
    
  - 使用Xcode创建category
    
    1. Source -> Objective-C File
    2. File(分类名称) - File Type(选择Category) - Class(原始类)
  
- __Category注意事项__
  
  - 分类只能增加方法, 不能增加成员变量。
    
    ``` objective-c
    @interface Person (other)
    {
    //    错误写法,Xcode会报错
    //    int _age;
    }
    - (void)eat;
    @end
    ```
    
  - 分类中写property只会生成方法声明。
    
    ``` objective-c
    @interface Person (other)
    // 只会生成getter/setter方法的声明, 不会生成实现和私有成员变量
    @property (nonatomic, assign) int age; // 此时只生成声明，但是没有方法的实现和_age成员变量。
    @end
    ```
    
  - 分类可以访问原来类中的成员变量。
    
    ``` objective-c
    @interface Person : NSObject
    {
        int _no;
    }
    @end
    
    @implementation Person (other)
    - (void)say
    {
        // 可以访问原有类中得成员变量
        NSLog(@"no = %i", _no);
    }
    @end
    ```
    
    注意，这里访问的成员变量是在.h文件中声明的（默认是protected的成员变量），但是如果在Person的.h文件中没有对外公开，那么other这个分类依旧是访问不了的。
    
  - 分类的方法要在.h中声明，否则这个方法就没意义了。如果写了一个私有方法在分类中，并没有对外公开，那么当别的类想要用分类中的方法的时候，要导入分类的.h文件，而.h文件中并没有分类方法的声明，那么即使是原类想访问分类中的私有方法都是访问不到的。所以，用分类增加方法那么就一定要在.h文件中声明。
    
  - 注意，.m文件的@implementation 原类名 （分类名），而不是@implementation 原类名 这种普通写法。
    
  - 如果有一个Person类，Person类有一个分类里面有些方法。Person有一个子类Student，那么Student类是会继承Person分类里的方法的（前提是导入分类的.h文件，并且这些方法在.h文件中是有声明的。如果category里的方法不在.h文件里声明，那么即使是子类，也是访问不到的。）所以总结来说，分类里声明的方法就和本类声明方法一样，如果在分类的.h文件中声明这些方法说明是对外开放的，那么其他类和子类是可以访问的；如果只在.m文件实现，那么即使是子类也无法调用，这和原类是一样的。
    
  - 如果分类和原来类出现同名的方法, 优先调用分类中的方法, 原来类中的方法会被忽略。
    
    ``` objective-c
    @implementation Person
    
    - (void)sleep
    {
        NSLog(@"%s", __func__);
    }
    @end
    
    @implementation Person (other)
    - (void)sleep
    {
        NSLog(@"%s", __func__);
    }
    @end
    
    int main(int argc, const char * argv[]) {
        Person *p = [[Person alloc] init];
        [p sleep];
        return 0;
    }
    
    输出结果:
    -[Person(other) sleep]
    ```
    
    可以看到，这里是优先调用分类中的方法的。
    
  - 分类的编译的顺序
    
    - 多个分类中有同名方法,则执行最后编译的文件方法(注意开发中千万不要这么干)
      
      ``` objective-c
      @implementation Person
      
      - (void)sleep
      {
          NSLog(@"%s", __func__);
      }
      @end
      
      @implementation Person (other1)
      - (void)sleep
      {
          NSLog(@"%s", __func__);
      }
      @end
      
      @implementation Person (other2)
      - (void)sleep
      {
          NSLog(@"%s", __func__);
      }
      @end
      
      int main(int argc, const char * argv[]) {
          Person *p = [[Person alloc] init];
          [p sleep];
          return 0;
      }
      
      输出结果:
      -[Person(other2) sleep]
      ```
      
      注意，可以在Build Phases -> Compile Sources里面改变编译顺序，在下面为后编译。
    
  - 总结方法调用的优先级：
    
    - 分类(最后参与编译的分类优先)
    - 原类
    - 父类

------

- Extension是Category的一个特例，相当于__匿名category__。
  
- 格式：
  
  ``` objective-c
  @interface 类名 ()
  @end
  // 对比分类, 就少了一个分类名称,因此也有人称它为”匿名分类”
  ```
  
- 作用：
  
  将extension写在.m文件中，可以为某个类扩充一些__私有的成员变量__和__方法__。
  
  注意这里，extension是可以提供__成员变量__的，而category是不可以的。