- SEL类型代表着__方法的签名__，在类对象的方法列表中存储着该签名与方法代码的对应关系。
  
- 每个类的方法列表（对象方法）都存储在类对象中，每个方法都有一个与之对应的SEL类型的对象，根据一个SEL对象就可以找到方法的地址，进而调用方法。
  
- 步骤：
  
  1. 首先把方法名包装成SEL类型的数据。
  2. 根据SEL数据到该类的类对象中，去找对应的方法的代码，如果找到了就执行该代码。
  3. 如果没有找到，根据类对象上的父类的类对象指针，去父类的类对象中查找，如果找到了，则执行父类的代码。
  4. 如果没有找到，一直像上找，直到基类(NSObject)。
  5. 如果都没有找到就报错。
  6. 在这个操作过程中有缓存,第一次找的时候是一个一个的找，非常耗性能，之后再用到的时候就直接使用。
  
- __SEL eat__ 等价于 __-(void) eat代码地址__。
  
- SEL定义普通变量：
  
  ``` objective-c
  SEL sel = @selector(eat);
  ```
  
- 检验对象是否实现了某个方法：
  
  - [类 respondsToSelector:]用于判断是否包含某个类方法
    
    ``` objective-c
     BOOL flag = [Person respondsToSelector:@selector(eat)];
    ```
    
  - [对象 respondsToSelector:]用于判断是否包含某个对象方法
    
    ``` objective-c
    BOOL flag = [obj respondsToSelector:@selector(eat)]; 
    ```
    
  - [类名 instancesRespondToSelector]用于判断是否包含某个对象方法。等价于 [对象 respondsToSelector:]。
    
    ``` objective-c
     BOOL flag = [Person instancesRespondToSelector:@selector(eat)];
    ```
  
- 让对象执行某个方法：
  
  ``` objective-c
  - (id)performSelector:(SEL)aSelector;
  - (id)performSelector:(SEL)aSelector withObject:(id)object;
  - (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;
  
  SEL s = @selector(classFun:value2:);
  [Person performSelector:s6 withObject:@"hello" withObject:@"world"];
  ```
  
  这些方法的object参数表示SEL方法的参数，并且最多是两个参数。
  
- 作为方法形参：
  
  ``` objective-c
  @implementation Person
  
  - (void)makeObject:(id) obj performSelector:(SEL) selector
  {
      [obj performSelector:selector];
  }
  @end
  
  int main(int argc, const char * argv[]) {
  
      Person *p = [Person new];
      SEL s1 = @selector(eat);
      Dog *d = [Dog new];
      [p makeObject:d performSelector:s1];
  
      return 0;
  }
  ```
  
  ​
  
  ​