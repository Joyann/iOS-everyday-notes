- A对象retain了B对象，B对象retain了A对象，那么两个对象永远都无法释放，造成内存泄露。
  
- 解决方案：
  
  当两端互相引用时，应该一端用retain、一端用assign。
  
- 例：
  
  ``` objective-c
  // Person类
  #import <Foundation/Foundation.h>
  
  @class Dog;
  
  @interface Person : NSObject
  
  @property (nonatomic, retain) Dog *dog;
  
  @end
  
  #import "Person.h"
  
  @implementation Person
  
  - (void)dealloc {
      NSLog(@"%s", __func__);
      [_dog release];
      [super dealloc];
  }
  
  @end
  ```
  
  ``` objective-c
  // Dog类
  #import <Foundation/Foundation.h>
  
  @class Person;
  @interface Dog : NSObject
  
  @property (nonatomic, retain) Person *person;
  
  @end
  
  #import "Dog.h"
  
  @implementation Dog
  
  - (void)dealloc
  {
      NSLog(@"%s", __func__);
      [_person release];
      [super dealloc];
  }
  
  @end
  ```
  
  ``` objective-c
  #import <Foundation/Foundation.h>
  #import "Person.h"
  #import "Dog.h"
  
  int main(int argc, const char * argv[]) {
      @autoreleasepool {
          Person *person = [Person new]; // person引用计数为1
          Dog *dog = [Dog new]; // dog引用计数为1
          
          person.dog = dog; // person引用计数为2
          dog.person = person; // dog引用计数为2
          
          [dog release]; // dog引用计数为1 内存泄露
          [person release]; // person引用计数为1 内存泄露
      }
      return 0;
  }
  
  ```
  
  可以看到我们有一个Person类，有一个Dog类，Person类有一个dog属性，dog类有一个person属性，这样就造成了循环retain。
  
  解决办法是将Dog类中的@property修改：
  
  ``` objective-c
  @property (nonatomic, assign) Person *person;
  ```
  
  并将set方法中的[_person release];删去。（因为一个retain对应一个release，但是此时是assign，所以不需要release了）
  
  那么此时在main函数中：
  
  ``` objective-c
  int main(int argc, const char * argv[]) {
      @autoreleasepool {
          Person *person = [Person new]; // person引用计数为1
          Dog *dog = [Dog new]; // dog引用计数为1
          
          person.dog = dog; // dog引用计数为2
          dog.person = person; // person引用计数依然为1
          
          [dog release]; // dog引用计数为1
          [person release]; // person引用计数为0，即将销毁，调用dealloc方法给_dog发送release消息，那么dog的引用计数-1，所以dog引用计数变为0，所以person销毁，dog也随之销毁。
      }
      return 0;
  }
  ```
  
  运行程序，可以看到程序没有问题了。
  
  ​