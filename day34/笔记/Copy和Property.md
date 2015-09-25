- 当copy用作@property修饰符的时候，可以防止外界值的改变影响一个类相应属性的改变。
  
  如果我们有一个Person类，有一个属性：
  
  ``` objective-c
  @property(nonatomic, retain) NSString *name;
  ```
  
  假设我们现在有一个NSMutableString:
  
  ``` objective-c
  NSMutableString *strM = [NSMutableString stringWithFormater:@"joy"];
  ```
  
  然后将strM的值赋给name:
  
  ``` objective-c
  Person *person = [Person new];
  person.name = strM;
  ```
  
  此时是没有问题的。但是，如果修改strM的值：
  
  ``` objective-c
  [strM appendString:@"ann"];
  ```
  
  __那么如果查看person中的name，会发现也会被修改了。__因为person的name也指向strM所指向的内容，当strM指向的内容发生了改变，那么person.name也被修改了，如果我们不想让这种情况发生，那么我们需要将name的修饰符改为copy:
  
  ``` objective-c
  @property(nonatomic, copy) NSString *name;
  ```
  
  此时，在给name赋值的时候，因为是copy，所以实际上是strM首先copy一下，产生一个新的对象（深拷贝），然后再将新的对象赋值给name。这样一来，即使strM所指向的字符串发生变化，但是person.name也不会变，因为它们两个指向不同的对象。
  
  总结：当你不希望类的某个属性（NSString, NSArray, NSDictionary）会跟着外界的值的修改而修改，那么要将@property的修饰符改为copy。没有特殊情况，字符串属性基本都用copy。（我是这么理解的）
  
- 当一个类有一个block属性的时候，使用copy修饰符可以保证在实例对象释放前，这个block属性是一直存在的。
  
  前面提到过，默认的block是在栈中，所以如果block引用了外面的对象，那么并不会对这个对象发送retain消息。如果使用Block_copy()，那么block被放到堆中，如果在block中访问外界对象，那么会给外界对象发送一次retain消息。
  
  比如下面的例子：
  
  我们有一个Person类，它有一个block属性。注意，此时用assgn来修饰block属性：
  
  ``` objective-c
  // Person.h文件
  #import <Foundation/Foundation.h>
  
  typedef void (^personBlock) ();
  
  @interface Person : NSObject
  
  @property (nonatomic, assign) personBlock pBlock;
  
  @end
  
  // Person.m文件
  @implementation Person
  
  - (void)dealloc {
      NSLog(@"%s", __func__);
      [super dealloc];
  }
  
  @end
  ```
  
  我们还有一个Dog类，只是简单的实现dealloc方法：
  
  ``` objective-c
  // Dog.h文件
  
  import <Foundation/Foundation.h>
  
  @interface Dog : NSObject
  
  @end
  
  // Dog.m文件
  
  import "Dog.h"
  
  @implementation Dog
  
  (void)dealloc {
  
    NSLog(@"%s", func);
  
    [super dealloc];
  
  }
  
  @end
  ```
  
  ​

``` objective-c

  在main.m中，我们对Person和Dog进行操作：

  int main(int argc, const char * argv[]) {

      Person *person = [[Person alloc] init];
      Dog *dog = [[Dog alloc] init];

      person.pBlock = ^ {
          NSLog(@"%@", dog);
      };

      [dog release];

      person.pBlock(); // 此时dog已经被释放，访问的是僵尸对象

      [person release];

      return 0;
  }
```

  在这种情况下，我们在person.pBlock中访问了dog，但是随后给dog发送release消息。那么当执行到person.pBlock()的时候，dog对象已经被释放，那么在pBlock中访问的dog就是一个僵尸对象，如果开启监控僵尸对象的功能，那么程序会crash。

  问题的原因是，在person还存在的时候，dog被提前释放，当执行person中的block，因为此时修饰block的是assign，并且__block此时在栈中__，__所以并不会给dog发送retain消息__，当执行[dog release];的时候，dog引用计数已经是0，被释放。

  这种情况在开发中是有可能发生的，因为block什么时候执行并不确定（注意block执行需要我们主动来调用，而不是自动执行），所以很可能在执行block的时候，block中所引用的对象已经被释放。

  解决的办法是将block放在堆里，那么在block中引用对象，就会给这个对象发送retain消息，这样就能保证这个对象引用计数不为0。

  在之前我们将block放到堆里是通过Block_copy()来完成。现在如果想把一个类的block属性的值拷贝到堆中，我们是通过修改@property的修饰符来完成的。

``` objective-c
  @property(nonatomic, copy) personBlock pBlock;
```

  我们修改了Person中的pBlock属性。此时：

``` objective-c
  person.pBlock = ^ {
  	NSLog(@"%@", dog);
  };
```

  pBlock会给dog发送retain消息，那么就能保证person存在的时候，dog也是存在的。

  但是，这样又会造成内存泄露：

``` objective-c
  int main(int argc, const char * argv[]) {

      Person *person = [[Person alloc] init]; // person引用计数1
      Dog *dog = [[Dog alloc] init]; // dog引用计数1

      person.pBlock = ^ {
          NSLog(@"%@", dog); // dog引用计数2
      };

      [dog release]; // dog引用计数1

      person.pBlock(); // dog没有被释放，可以成功执行

      [person release];  // person引用计数1

      return 0;
  }
```

  可以看到，当person被释放，dog指向的对象的引用计数并不为0，所以造成内存泄露。

  解决方法是，在Person类的dealloc方法中使用Block_release()来对block中的对象发送release消息：

``` objective-c
  - (void)dealloc {
  	Block_release(_pBlock);
      NSLog(@"%s", __func__);
      [super dealloc];
  }
```

  这样就没有问题了。

  注意：__将block属性的修饰符改为copy，是将block从栈中拷贝到堆中的意思。__

- copy block之后引发循环引用
  
  - ARC下以后再说。
    
  - MRC下：
    
    接着我们上面的例子，我们在Person类中添加一个name属性：
    
    ``` objective-c
    // Person.h文件
    #import <Foundation/Foundation.h>
    
    typedef void (^personBlock) ();
    
    @interface Person : NSObject
    
    @property (nonatomic, copy) NSString *name;
    @property (nonatomic, copy) personBlock pBlock;
    
    @end
    
    // Person.m文件
    @implementation Person
    
    - (void)dealloc {
        NSLog(@"%s", __func__);
        [super dealloc];
    }
    
    @end
    ```
    
    然后在main.m中：
    
    ``` objective-c
    int main(int argc, const char * argv[]) {
    
        Person *person = [[Person alloc] init]; // person引用计数1
        person.name = @"joyann";
        person.pBlock = ^ {
            NSLog(@"%@", person.name); // person引用计数2
        };
    
        person.pBlock();
    
        [person release];  // person引用计数1
    
        return 0;
    }
    ```
    
    此时，我们在pBlock中访问person.name，因为pBlock是copy修饰的，也就是说pBlock在堆中，会对block里面用到的对象发送retain消息（上一个例子是在block中引用其他对象，而这个例子是在block中引用block所在的对象），那么当给person发送release消息的时候，其引用计数实际还是1，所以造成了内存泄露。（这种情况就相当于，用copy修饰block，将block拷贝到了堆中，那么block属于一个类，说明这个类对这个block进行了retain；反过来，block在堆中会对引用到的对象retain一次，也就是block对这个类进行了一次retain，这就是造成了循环引用。）
    
    解决办法有两个：
    
    1. 再次给person发送release消息：
       
       ``` objective-c
       int main(int argc, const char * argv[]) {
       
           Person *person = [[Person alloc] init]; // person引用计数1
           person.name = @"joyann";
           person.pBlock = ^ {
               NSLog(@"%@", person.name); // person引用计数2
           };
       
           person.pBlock();
       
           [person release];  // person引用计数1
           [person release];  // person引用计数0
       
           return 0;
       }
       ```
       
       但是这种方法会让人迷惑，而且不符合我们之前说的”一个alloc对应一个release”的原则。
       
    2. 用__block来修饰对象
       
       ``` objective-c
       int main(int argc, const char * argv[]) {
       
           __block Person *person = [[Person alloc] init]; // person引用计数1
           person.name = @"joyann";
           person.pBlock = ^ {
               NSLog(@"%@", person.name); // person引用计数仍然为1
           };
       
           person.pBlock();
       
           [person release];  // person引用计数0
       
           return 0;
       }
       ```
       
       因为前面也提到过，如果用__block来修饰对象，当一个block引用到这个对象的时候，哪怕这个block被拷贝到堆中，那么也不会给这个对象发送retain消息。所以这样的结果就是正确的了。
  
- 总结：
  
  - NSString/NSMutableString 如果不想被外界的修改影响，那么就将property修饰符改为copy。
  - 如果一个类中有block属性，那么将property的修饰符改为copy以保证block中用到的对象，在执行block的时候依然是存在的。
  - 当一个类中的block属性引用到这个类（比如访问这个类的其他属性），那么会造成引用循环。解决办法是在创建这个类的对象的时候用__block来修饰。