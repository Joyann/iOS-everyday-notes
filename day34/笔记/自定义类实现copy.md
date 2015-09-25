- 实现类的copy/mutableCopy，需要遵守__NSCopying__和__NSMutableCopying__协议。
  
- 在遵守协议后，需要实现__-(id)copyWithZone:(NSZone *)zone__和__-(id)mutableCopyWithZone:(NSZone *)zone__写法。
  
- 具体实现：
  
  ``` objective-c
  // Person.h
  #import <Foundation/Foundation.h>
  
  @interface Person : NSObject <NSCopying, NSMutableCopying>
  
  @property (nonatomic, copy) NSString *name;
  @property (nonatomic, assign) int age;
  
  @end
    
  // Person.m
  #import "Person.h"
  
  @implementation Person
  
  - (id)copyWithZone:(NSZone *)zone {
      id person = [[[self class] allocWithZone:zone] init];
      
      [person setName:_name]; // 注意，id类型不可以用点语法
      [person setAge:_age];
      
      return person;
  }
  
  - (id)mutableCopyWithZone:(NSZone *)zone {
      id person = [[[self class] allocWithZone:zone] init];
      
      [person setName:_name];
      [person setAge:_age];
      
      return person;
  }
  
  - (NSString *)description {
      return [NSString stringWithFormat:@"name: %@, age: %i", _name, _age];
  }
  
  @end
    
  // main.m
  #import <Foundation/Foundation.h>
  #import "Person.h"
  
  int main(int argc, const char * argv[]) {
      
      Person *person = [[Person alloc] init];
      person.name = @"joyann";
      person.age = 21;
      NSLog(@"%@", person);
      
      Person *person1 = [person copy];
      NSLog(@"%@", person1);
    
    	Person *person2 = [person mutableCopy];
      NSLog(@"%@", person2);
    
      return 0;
  }
  ```
  
  可以看到，输出person2，person1和person是一样的。
  
  总结：
  
  1. 遵守NSCopying和NSMutableCopying协议。
  2. 实现copyWithZone:和mutableCopyWithZone:方法。
     - 在方法中创建新的对象（通过[[[self class] allocWithZone:zone] init]来创建，这里allocWithZone就相当于alloc）。
     - 给新的对象赋值，使得与旧对象相同。
     - 返回新对象。
  
- 子父类中的拷贝：
  
  因为父类中实现了协议并且实现了方法，那么子类中都将继承过来，也就是说可以直接使用父类的copy/mutableCopy方法。（父类已经实现）
  
  ``` objective-c
  // Student.h
  #import "Person.h"
  
  @interface Student : Person
  
  @property (nonatomic, assign) double height;
  
  @end
    
  // Student.m
  #import "Student.h"
  
  @implementation Student
  
  - (NSString *)description {
      return [NSString stringWithFormat:@"name: %@, age: %i, height: %f", [self name], [self age], _height];
  }
  
  @end
    
  // main.m
  #import <Foundation/Foundation.h>
  #import "Person.h"
  #import "Student.h"
  
  int main(int argc, const char * argv[]) {
      
      Student *student = [[Student alloc] init];
      student.name = @"rudy";
      student.age = 30;
      student.height = 1.80;
      NSLog(@"%@", student);
  
      Student *student1 = [student copy];
      NSLog(@"%@", student1);
      
      return 0;
  }
  ```
  
  运行程序，会发现打印student的时候是正确的，但是打印student1的时候，height = 0.000000。这是因为student1是通过[student copy]产生的，给student发送copy方法，但是student本身并没有实现这个方法，而是它的父类Person实现了copy方法，那么在Person的copy方法中，创建了一个Person对象，并将其age和name赋值，并返回这个对象。注意，这里并没有给height赋值（Person中也没有height这个属性），所以说当给student发送copy消息的时候，能成功给age和name赋值，但是无法给height赋值。
  
  那么此时，需要我们重写父类的copy方法，并且保留父类的copy方法，在这个基础上给我们的新属性height赋值：
  
  ``` objective-c
  // Student.m
  #import "Student.h"
  
  @implementation Student
  
  - (id)copyWithZone:(NSZone *)zone {
      id stu = [super copyWithZone:zone];
      [stu setHeight:_height];
      return stu;
  }
  
  - (NSString *)description {
      return [NSString stringWithFormat:@"name: %@, age: %i, height: %f", [self name], [self age], _height];
  }
  
  @end
  ```
  
  这样就完成了子父类的copy。