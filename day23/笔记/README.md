# 手动内存管理

- 每一个对象都有一个__引用计数器__（整形4个字节），可以理解为”对象被引用的次数”，也可以理解为”有多少人正在用这个对象”。
  
- 任何一个对象，刚出来的时候引用计数器都为1。当使用alloc,new或者copy创建一个对象的时候，对象的引用计数器默认为1。
  
  ``` objective-c
  Person *person = [Person new];
  // 也就是说，此时person指向的对象的引用计数器为1。我们用person来指向它，以后可以用过给person发送release消息来对引用计数器减1以释放对象。
  
  [Person new];
  // 此时Person类的新对象引用计数器为1，不过我们没有指针指向它，也就是说这个对象会一直存在，因为我们无法访问到它进行release操作。
  ```
  
- 给对象发送__retain__消息，可以使这个对象的引用计数器+1。注意，retain方法会返回对象本身；给对象发送__release__消息，可以使这个对象的引用计数器-1。给对象发送__retainCount__消息，可以获得当前的引用计数器的值。
  
- 注意，release并不表示销毁对象，而是引用计数器-1。
  
- Java的垃圾回收是语言本身的特性，而OC的引用计数是编译器特性。
  
- 当一个对象的引用计数器的值为0时，对象即将销毁，系统会给对象发送一条dealloc消息，因此，从dealloc方法有没有被调用，就可以判断对象是否销毁。
  
- 重写dealloc方法要注意：
  
  - 在dealloc方法里释放相关资源。比如这个对象引用了其他对象，那么这个对象马上就要销毁了，需要对被引用的对象发送release消息让其引用计数器-1。
  - 一旦重写dealloc方法，就必须__在最后面调用[super dealloc]方法。__
  
- 一旦对象被回收了, 它占用的内存就不再可用,坚持使用会导致程序崩溃（野指针错误）。
  
- 内存管理的原则：有增就有减。1个alloc对应1个release，1个retain对应1个release。
  
- 关于僵尸对象/野指针/空指针
  
  - 僵尸对象是指已经被销毁的对象（不能再使用的对象），野指针就是指向僵尸对象的指针。
    
    ``` objective-c
    Person *person = [Person new]; // 引用计数器的值为1
    [person release]; // 向person发送release方法，引用计数器为0，此时person所指向的对象被销毁，那么即为僵尸对象。
    [person sayHello]; // 此时，person所指向的是僵尸对象，person即为野指针。
    // 这样Xcode并不会直接报错。可以开启监视僵尸对象，就会报像已经销毁的对象发消息的错误。
    // 如果继续访问指向僵尸对象的野指针，Xcode就会报EXC_BAD_ACCESS错误。
    ```
    
  - 空指针则可以理解成nil，给空指针发消息是没有反应也不会报错的，而给野指针发送消息则会报错。
    
  - 所以为了避免给野指针发送消息的错误，在对象的引用计数器值为0后，可以将指向对象的指针（此时已经为野指针）变为空指针。
    
    ``` objective-c
    Person *person = [Person new];
    [person release];
    person = nil;
    ```
  
- 我们可以设置Xcode来监控僵尸对象：
  
  > Edit Scheme -> Diagnostics -> Enable Zombie Objects
  
  如果不开启这个选项，那么当访问野指针的时候只会提醒EXC_BAD_ACCESS，开启这个选项之后会提示：
  
  >  -[Person sayHello]: message sent to deallocated instance 0x1002065d0
  
  看到这个提示我们就知道是在向已经销毁的对象发消息的错误。
  
- 内存管理原则
  
  - 谁创建谁release
    - 如果你通过alloc、new、copy或mutableCopy来创建一个对象，那么你必须调用release或autorelease。
  - 谁retain谁release:
    - 只要你调用了retain，就必须调用一次release
  - 有加就有减。曾经让对象的计数器+1，就必须在最后让对象计数器-1。
  
- 多对象内存管理：
  
  - 只要还有人在用某个对象，那么这个对象就不会被回收。
  - 只要你想用这个对象，就让对象的计数器+1。
  - 当你不再使用这个对象时（自身销毁时），就让对象的计数器-1。
  
- __set方法内存管理__
  
  我们在有多个对象的时候，避免不了对象之间的引用。比如我有一个Person类，有一个Dog类，Person类有一个成员变量是Dog *dog，那么在给Person类的dog赋值的时候要注意，因为Person类中的dog指向一个Dog的实例，就说明Person在用Dog，那么需要给dog这个对象的引用计数器+1表示别人在用。当Person的对象销毁的时候，表示不再用dog这个对象，那么需要给dog这个对象的引用计数器-1表示不再使用。我们要保证，当Person的实例存在的时候，它的变量dog所指向的对象一定也要存在，不能是野指针，因为Person类的成员变量dog在对其所指向的对象引用，那么所指向的对象就不应该被销毁。以下面为例：
  
  ``` objective-c
  // Dog类
  #import <Foundation/Foundation.h>
  
  @interface Dog : NSObject
  
  @end
  
  #import "Dog.h"
  
  @implementation Dog
  
  - (void)dealloc
  {
      NSLog(@"%s", __func__);
      [super dealloc];
  }
  
  @end
  
  ///////////////////////////////////////////////
  
  // Person类
  #import <Foundation/Foundation.h>
  #import "Dog.h"
  
  @interface Person : NSObject
  {
      Dog *_dog;
  }
  
  - (void)setDog:(Dog *)dog;
  - (Dog *)dog;
  
  @end
  
  #import "Person.h"
  
  @implementation Person
  
  - (void)setDog:(Dog *)dog {
      _dog = dog;
  }
  
  - (Dog *)dog {
      return _dog;
  }
  
  - (void)dealloc {
      NSLog(@"%s", __func__);
      [super dealloc];
  }
  
  @end
  
  /////////////////////////////////////////////////
  
  #import <Foundation/Foundation.h>
  #import "Person.h"
  
  int main(int argc, const char * argv[]) {
      @autoreleasepool {
          Person *person = [Person new];
          Dog *dog = [Dog new];
  
          [dog release];  
          [person release];
      }
      return 0;
  }
  ```
  
  我们在main函数里面创建了一个person实例，一个dog实例，并且在最后各自将其release。到目前为止我们的代码是没有问题的，因为一个new对应一个release，所以不会发生内存泄露。
  
  但是如果我们想在person中引用dog，那么在main函数里面：
  
  ``` objective-c
  int main(int argc, const char * argv[]) {
      @autoreleasepool {
          Person *person = [Person new];
          Dog *dog = [Dog new];
  
          person.dog = dog; // 将dog赋值给person的成员变量
  
          [dog release];
  
          [person release];
      }
      return 0;
  }
  ```
  
  那么此时就会有问题。
  
  输出结果：
  
  ``` objective-c
  -[Dog dealloc]
  -[Person dealloc]
  ```
  
  因为我们并未采取其他操作，在[dog release]之前，person和dog的引用计数器的值都为1，当执行到[dog release]，dog的引用计数器为0，则将释放dog所指向的对象，但是问题来了，我们在person里面是在引用dog的，那么一旦dog指向的对象被释放，那么我们的person里面的dog变量相当于指向了一块被释放的空间，也就是变成了野指针，所以person里面的dog变量就不再可用了，因为已经被释放了。也就是说，我们还在person中引用dog，person还存在，但是dog却先销毁了，很明显这是不正确的。
  
  为解决这一问题，我们前面说过，当有人使用这个对象的时候，我们要给对象发送retain消息来让这个对象的引用计数器+1表示有人在使用，当不再使用的时候，需要发送release消息来让这个对象的引用计数器-1。所以解决方法是：
  
  当给person.dog赋值是，会给person发送-setDog:的消息，所以我们在Person的-setDog:方法里面加入下面代码：
  
  ``` objective-c
  - (void)setDog:(Dog *)dog {
      [dog retain];
      _dog = dog;
  }
  ```
  
  这表示当person中引用dog的时候，给dog发送retain消息表示多了一个人在引用，所以让dog的引用计数器+1。不要忘记我们的原则，有加就有减。当person将被销毁的时候，那么就表示也不再引用dog了，所以在Person的dealloc方法中：
  
  ``` objective-c
  - (void)dealloc {
      NSLog(@"%s", __func__);
      [_dog release];
      [super dealloc];
  }
  ```
  
  给_dog发送消息告知引用计数器值-1表示我不再使用你了。
  
  此时运行程序，发现输出结果是：
  
  ``` objective-c
  -[Person dealloc];
  -[Dog dealloc];
  ```
  
  很明显结果是正确的。我们再来分析一下过程。
  
  在最开始的main函数中，new出来的person引用计数器值为1，new出来的dog引用计数器值为1，当执行person.dog = dog时，dog的引用计数器值为2，因为person对其引用。那么当[dog release]的时候，dog的引用计数器值-1，变为1，不会销毁（因为person在对其引用）。继续执行，当[person release]的时候，person的引用计数器-1变为0，则person对象将销毁，在销毁之前系统发送dealloc消息，我们在Person中重写dealloc方法，将_dog（即引用的dog）的引用计数器值-1，那么dog的引用计数器的值为0。接着person销毁输出-[Person dealloc]，再接着dog引用计数器值为0也将销毁，在dealloc方法中输出-[Dog dealloc]。这样一来就保证了person在，那么dog就在，person不在，若dog引用计数器值变为0，则也不在。

------

  上面说的只是一种情况，第二种情况就是，你想让dog这个变量指向另一个对象，那么又会有新的内存问题：

``` objective-c
  int main(int argc, const char * argv[]) {
      @autoreleasepool {
          Person *person = [Person new];
          Dog *dog = [Dog new];
          Dog *newDog = [Dog new];

          person.dog = dog;
          person.dog = newDog;

          [newDog release];
          [dog release];
          [person release];
      }
      return 0;
  }
```

  可以看到我们改变dog的指向让其指向一个新的Dog对象，并且也在后面给newDog发送release消息来遵守有增有减的原则。但是此时运行会发现输出是有内存泄露的：

``` objective-c
  -[Person dealloc]
  -[Dog dealloc]
```

  此时应该还有一个-[Dog dealloc]的，因为我们有三个对象。问题出在哪里了呢？

  当person.dog = dog的时候，dog的引用计数变为2，并且_dog是dog；

  当person.newDog = dog的时候，newDog的引用计数变为2，__但是_dog变为了newDog__；

  继续执行，[newDog release]后，newDog的引用计数变为1；

  [dog release]后，dog的引用计数变为1；

  [person release]后，person引用计数变为0，触发dealloc方法，那么在dealloc方法中，将执行__[\_dog release]__，注意，此时\_dog已经变为了__newDog__，所以newDog的引用计数-1，变为了0。接着person销毁输出信息，newDog销毁输出信息，但是，此时原来的dog的引用计数一直为1，不会销毁，所以造成了内存泄露。

  也就是说，在dealloc方法中是给新的dog引用计数-1，所以新的dog成功销毁，而原来的dog则无法访问到了，所以没有release造成内存泄露。

  解决办法：

  这个例子中造成内存泄露的原因是当有新对象的时候，那么就表示不再引用原来的对象了，所以应该及时release原来的对象，再retain新的对象。这样一来相当于有新对象的时候表示不再使用原来对象，而是拥有新的对象，并且在dealloc的时候release新对象。所以在set方法中：

``` objective-c
  - (void)setDog:(Dog *)dog {
      [_dog release];
      [dog retain];
      _dog = dog;
  }
```

  这样三个对象都将成功销毁。

------

  还有第三种情况，那就是person对象的dog变量重复赋同一个值：

``` objective-c
  int main(int argc, const char * argv[]) {
      @autoreleasepool {
          Person *person = [Person new];
          Dog *dog = [Dog new];

          person.dog = dog;
          [dog release];

          person.dog = dog;

          [person release];
      }
      return 0;
  }
```

  如果按照上面输出的话，程序会出错。

  因为开始person和dog引用计数都为1；

  person.dog = dog后，首先将旧值\_dog进行release，因为最开始person.dog还未赋值，所以_dog为nil，那么对nil发送release消息则什么也不做；接着对dog发送retain消息，dog引用计数变为2；

  接着[dog release]，则dog引用计数-1变为1;

  再接着，person.dog = dog的时候，首先将旧的\_dog进行release，注意，此时\_dog已经变为了dog，那么就是对dog进行release，那么dog的引用计数-1则变为了0，也就是说dog变为了野指针，在set方法里我们刚才执行完了给旧值release的操作，导致的结果是dog变为了野指针；接下来，对dog发送retain消息，很明显已经出错了，因为dog的引用计数已经变为0了。

  解决方法：

  很明显只有当不同的对象的时候，我们才需要进行release旧值，retain新值。如果一样的对象，这么做有的时候不仅多余，甚至会给我们带来错误。

``` objective-c
  - (void)setDog:(Dog *)dog {
      if (_dog != dog) {
          [_dog release];
          [dog retain];
          _dog = dog;
      }
  }
```

  解决办法很简单，在赋值前我们检查一下新的对象和旧的对象是否相同。如果不同则对旧的对象进行release，对新的对象进行retain；如果相同则什么也不用做。

- 所以总结来说，MRC模式的成员变量是对象，那么set方法需要：
  
  - release之前的对象
    
  - retain需要使用的对象
    
  - 只有传入的对象和之前的不同才需要release和retain
    
    ``` objective-c
    - (void)setRoom:(Room *)room
    {
        // 避免过度释放
        if (room != _room)
        {
            // 对当前正在使用的房间（旧房间）做一次release
            [_room release];
    
            // 对新房间做一次retain操作
             _room = [room retain];
        }
    }
    ```
  
- 前面说过，向对象发送retain消息会返回这个对象，所以
  
  ``` objective-c
  [room retain];
  _room = romm;
  ```
  
  可以合起来写成：
  
  ``` objective-c
  _room = [room retain];
  ```
  
- 如果我们有多个成员变量都是对象，那么每一个都要我们自己来写setter/getter方法并且在setter方法中进行reatin和release，很明显是很浪费的，幸亏我们有@property。
  
- 我们已经知道，@property自动帮我们生成setter/getter方法和下划线开头的成员变量，那么是不是只需要重写setter方法呢？
  
  事实上，我们甚至不需要重写setter方法（这里说的是在没有其他需求的情况下），我们只需要这样写：
  
  ``` objective-c
  @property(retain) Dog *dog;
  ```
  
  那么编译器就会为我们生成相应的setter/getter方法和下划线开头的成员变量，并且在setter方法里为我们设置好retain和release问题，相当于已经默认为我们实现：
  
  ``` objective-c
  - (void)setDog:(Dog *)dog {
  	if (_dog != dog) {
      	[_dog release];
          _dog = [dog retain];
      }
  }
  
  - (Dog *)dog {
  	return _dog;
  }
  ```
  
  __注意，在类的dealloc方法中仍然要我们自己来release相应的对象。__
  
- 如果是这样写：
  
  ``` objective-c
  @property(assign) int age;
  ```
  
  表示用正常的方式生成setter和getter，不会处理retain和release问题，@property默认就为assign。
  
- 所以，如果是对象类型的属性，那么需要用retain；如果是基本类型，那么需要用assign。（NSString以后会说）
  
  > retain ： release旧值，retain新值（用于OC对象）
  > 
  > assign ： 直接赋值，不做任何内存管理(默认，用于非OC对象类型)
  > 
  > copy ： release旧值，copy新值（一般用于NSString *）
  > 
  > readwrite ：同时生成set方法和get方法（默认）
  > 
  > readonly ：只会生成get方法
  > 
  > atomic ：性能低（默认） 
  > 
  > nonatomic ：性能高
  > 
  > setter ： 设置set方法的名称，一定有个冒号:
  > 
  > getter ： 设置get方法的名称
  
- 补充：
  
  前面提到过，通常一个指针变为野指针之后，为了防止访问错误，我们通常将指针设置为nil，以下面为例：
  
  ``` objective-c
  - (void)dealloc {
      NSLog(@"%s", __func__);
      [_dog release]; // 此时person将要销毁，那么表示也不再用_dog了，所以_dog所指向的对象引用计数为0，_dog变为野指针了。
    	_dog = nil; 此时设置_dog为nil为防止访问野指针
      [super dealloc];
  }
  ```
  
  其实，上面的写法可以换成下面：
  
  ``` objective-c
  - (void)dealloc {
      NSLog(@"%s", __func__);
  	self.dog = nil;
      [super dealloc];
  }
  ```
  
  我们分析一下。
  
  self.dog = nil这行代码，本质上调用的是dog这个属性的setter方法：
  
  ``` objective-c
  - (void)setDog:(Dog *)dog {
  	if (_dog != dog) {
      	[_dog release];
          _dog = [dog retain];
      }
  }
  ```
  
  在原来\_dog是有值的，所以_dog != nil，所以进入if语句。
  
  在if中，首先执行[\_dog release]给\_dog指向对象引用计数-1，此时传入的参数dog即为nil，那么给nil发送retain消息得到的结果仍是nil，然后_dog = nil。所以self.dog = nil也就相当于执行了：
  
  ``` objective-c
  [_dog release];
  _dog = nil;
  ```
  
  这样一来代码更加简洁。
  
  ​