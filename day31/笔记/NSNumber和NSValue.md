- NSNumber用于将基本数据(比如int)放进数组或字典中。
  
- 将基本类型装入NSNumber对象：
  
  ``` objective-c
  + (NSNumber *)numberWithInt:(int)value;
  + (NSNumber *)numberWithDouble:(double)value;
  + (NSNumber *)numberWithBool:(BOOL)value;
  ...
  ```
  
- 从NSNumber对象中的到基本类型数据：
  
  ``` objective-c
  - (char)charValue;
  - (int)intValue;
  - (long)longValue;
  - (double)doubleValue;
  - (BOOL)boolValue;
  - (NSString *)stringValue;
  - (NSComparisonResult)compare:(NSNumber *)otherNumber;
  - (BOOL)isEqualToNumber:(NSNumber *)number;
  ```
  
- 注意，创建NSNumber简便写法：
  
  - 如果是__字面量（如：10，10.3，YES）__，那么可以直接在前面加上@就可以变成NSNumber对象。
    
    ``` objective-c
    @10;
    @10.3;
    @YES;
    ```
    
  - 如果是变量（如 int number = 5），那么需要用@()才可以：
    
    ``` objective-c
    @(number);
    ```
  
- __NSNumber是NSValue的子类， 但NSNumber只能包装数字类型。__
  
- __因为NSNumber并不能将类似于结构体类型的变量加入到数组/字典中，而NSValue可以。__
  
- 将结构体包装成NSValue对象：
  
  ``` objective-c
  + (NSValue *)valueWithPoint:(NSPoint)point;
  + (NSValue *)valueWithSize:(NSSize)size;
  + (NSValue *)valueWithRect:(NSRect)rect;
  ```
  
- 从NSValue对象取出之前包装的结构体：
  
  ``` objective-c
  - (NSPoint)pointValue;
  - (NSSize)sizeValue;
  - (NSRect)rectValue;
  ```
  
- 我们可以将任意类型包装进NSValue：
  
  ``` objective-c
  + (NSValue )valueWithBytes:(const void )value objCType:(const char *)type;
  ```
  
  > value参数 : 所包装数据的地址
  > 
  > type参数 : 用来描述这个数据类型的字符串, 用@encode指令来生成
  
- 从NSValue中取出所包装的数据：
  
  ``` objective-c
  - (void)getValue:(void *)value;
  ```
  
- 将结构体包装进NSValue，并从NSValue中解包输出：
  
  ``` objective-c
  #import <Foundation/Foundation.h>
  
  typedef struct {
      char *name;
      int age;
  } Person;
  
  int main(int argc, const char * argv[]) {
      @autoreleasepool {
          
          Person person = {"joyann", 21};
          
          NSValue *personValue = [NSValue valueWithBytes:&person objCType:@encode(Person)];
          NSArray *personArray = @[personValue];
          NSLog(@"%@", personArray); // bytes
          
          Person otherPerson;
          [personValue getValue:&otherPerson];
          NSLog(@"name: %s, age: %i", otherPerson.name, otherPerson.age);
          
      }
      return 0;
  }
  ```
  
  ​