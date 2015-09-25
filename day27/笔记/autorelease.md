- autorelease用于MRC下。
  
- 在@autoreleasepool{}中给对象发送一条autorelease消息，那么在@autoreleasepool的右大括号结束的时候，会自动对对象进行一次release操作。
  
- autorelease方法会返回对象本身。
  
  ``` objective-c
  Person *p = [Person new];
  p = [p autorelease];
  ```
  
- __给对象发送autorelease消息，但是对象的计数器是不变的__。
  
  ``` objective-c
  Person *p = [Person new];
  p = [p autorelease];
  NSLog(@"count = %lu", [p retainCount]); // 1
  ```
  
- __一般来说，系统提供给我们的类工厂方法，大部分创建出来的对象都是发送过autorelease消息的；而init开头的初始化方法则没有。__
  
  举例：
  
  ``` objective-c
  inr main(int argc, const char * argv[]) {
    @autoreasepool {
      NSArray *arr = [NSArray array]; // 这时我们并不需要再给arr发送release/autorelease消息，因为NSArray在实现array这个类工厂方法的时候，已经发送过autorelease消息了，所以当释放池被释放的时候，会给这个对象发送release消息，那么这个对象就会被成功释放。
    }
    return 0;
  }
  
  int main(int argc, const char *  argv[]) {
    @autoreleasepool {
      NSArray *arr = [[NSArray alloc] init]; // 这时因为是init开头的初始化方法，返回的是一个self，并且生成的方式固定，而不像类工厂方法那样相对更自由，所以是没有发送autorelease消息的，所以需要我们自己来release/autorelease。
      [arr autorelease];
    }
    return 0;
  }
  ```
  
- autorelease的好处：
  
  1. 不用再关心对象释放的时间
  2. 不用再关心什么时候调用release
  
- 在开始没有用自动释放池的时候：
  
  ``` objective-c
  int main(int argc, const char *argv[]) {
  	Person *person = [Person new];
     	// 要进行的操作
      // 当不需要person的时候需要进行release
      [person release];
  	return 0;
  }
  ```
  
  可以看到，我们需要时刻关心person对象的内存，等到不用了时刻不能忘记release，但是当代码多起来，这样明显很不方便。如果使用自动释放池：
  
  ``` objective-c
  int main(int argc, const char *argv[]) {
    @autoreleasepool {
  	 Person *person = [Person new];
       person = [person autorelease]; // 可以合并来写：Person *person = [[Person new] autorelease];
    } // 右大括号
    return 0; 
  }
  ```
  
  这样一来，当执行完autoreleasepool的右大括号，代表@autoreleasepool将要结束，那么它会对池子里的对象全都进行一次release操作。这样我们就不用时刻担心要对对象发送release消息了，因为当自动释放池结束，系统会自动帮我们发消息。
  
- autorelease的原理
  
  __实际上这就是将release消息延迟发送，并且这一操作自动完成__。以前我们要自己来决定什么时候发送release消息，但是现在我们把对象放入自动释放池里面，当自动释放池将要结束（右大括号执行完结束）会对对象统一发送一次release消息，release这一操作不再由我们完成，而是由自动释放池在结束的时候统一来完成（这就相当于延迟发送）。这样解决了我们的”后顾之忧”。
  
- 注意，使用自动释放池的前提是：
  
  - __要在@autoreleasepool{}中给对象发送autorelease消息__。
    
    ``` objective-c
    int main(int argc, const char *argv[]) {
      @autoreleasepool {
        Person *person = [[[Person alloc] init] autorelease];
      } 
      return 0;
    }
    ```
    
  - 以前的写法：
    
    ``` objective-c
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    Person *p = [[[Person alloc] init] autorelease];
    
    [autoreleasePool drain];
    ```
    
  - 这样也是可以的：
    
    ``` objective-c
    int main(int argc, const char *argv[]) {
    	Person *person = [[[Person alloc] init];
      @autoreleasepool {
         person = [person autorelease];
      } 
      return 0;
    }
    ```
    
  - 但是这样是不行的：
    
    ``` objective-c
    int main(int argc, const char *argv[]) {
      @autoreleasepool {
    		Person *person = [[[Person alloc] init]; // 在@autoreleasepool里面，但是没有发送autorelease消息是没有放在自动释放池的
      } 
      person = [person autorelease] // 这样本身就是错的，因为person已经超出作用域了；并且autorelease只有在自动释放池里才有效。
      return 0;
    }
    ```
    
  - autorelease是一个方法，只有在自动释放池中调用才有效。
  
- autoreleasepool的创建：
  
  - iOS 5.0前
    
    ``` objective-c
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    // 创建自动释放池
    [pool release]; 
    // [pool drain]; 销毁自动释放池
    ```
    
  - iOS 5.0 开始
    
    ``` objective-c
    @autoreleasepool
    { //开始代表创建自动释放池
    
    } //结束代表销毁自动释放池
    ```
  
- 在iOS程序运行过程中，会创建无数个池子。这些池子都是以栈结构存在（先进后出）。
  
- 当一个对象调用autorelease方法时，会将这个对象放到栈顶的释放池。
  
- 一个程序可以创建N个自动释放池，并且自动释放池可以嵌套。
  
  ``` objective-c
  @autoreleasepool { // 1
  	@autoreleasepool { // 2
      	@autoreleasepool { // 3
          	Person *person1 = [[[Person alloc] init] autorelease];
          }
        	Person *person2 = [[[Person alloc] init] autorelease];
      }
  }
  ```
  
  这也是为什么__当一个对象调用autorelease方法时，会将这个对象放到栈顶的释放池__。因为person1在第3个释放池（即为栈顶），那么创建person2的时候，第三个释放池已经释放，那么第2个释放池则处在栈顶，所以person2相当于在栈顶的释放池。
  
- 性能问题：
  
  ``` objective-c
  int main(int argc, const char *argv[]) {
    @autoreleasepool {
      for (int i = 0; i < 9999; i++) { // 在一个释放池创建太多对象，消耗性能
        Person *person = [[Person new] autorelease];
      }
    } 
    return 0;
  }
  
  int main(int argc, const char *argv[]) {
    for (int i = 0; i < 9999; i++) { // 创建多个释放池，相对来说更节省效率
    	@autoreleasepool {
  	  Person *person = [[Person new] autorelease];
    	} 
    }
    return 0;
  }
  ```
  
  另外还要注意，不要在自动释放池中使用比较消耗内存的对象：
  
  ``` objective-c
  @autoreleasepool {
  	Person *person = [[Person new] autorelease];
      // 假如person只在前100行使用，以后都不用了。
      // 接下来是很多其他的代码。
      // 这时候person依然要一直存在，因为自动释放池还没结束。
      // 所以要保证person尽量不要过于消耗内存。
  }
  ```
  
- 前面说过，autorelease返回对象本身，所以我们也可以将这个操作封装在类的类工厂方法里面：
  
  ``` objective-c
  int main(int argc, const char *argv[]) {
    	@autoreleasepool {
        Person *person = [Person person];
    	} 
    return 0;
  }
  
  // Person类
  @interface Person: NSObject
  
  + (instancetype)person;
  
  @end
  
  @implementation Person
  
  + (instancetype)person {
    Person *person = [[[self alloc] init] autorelease];
    return person;
  }
  
  @end​
  ```
  
- autorelease的错误用法：
  
  - 不要连续调用autorelease
    
    ``` objective-c
     @autoreleasepool {
     // 错误写法, 过度释放
        Person *p = [[[[Person alloc] init] autorelease] autorelease];
     }
    ```
    
  - 调用autorelease后又调用release
    
    ``` objective-c
     @autoreleasepool {
        Person *p = [[[Person alloc] init] autorelease];
        [p release]; // 错误写法, 过度释放
     }
    ```
    
    ​