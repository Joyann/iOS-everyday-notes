- ARC的注意点
  
  - ARC是编译器特性，而不是运行时特性
  - ARC不是其它语言中的垃圾回收。
  - 当ARC开启时，编译器将自动在代码合适的地方插入retain，release和autorelease，相当于编译器帮我们完成了需要我们手动添加的这些。
  
- ARC的优点
  
  - 消除了手动管理内存的烦琐，基本上能够避免内存泄露。
  - 有时还能更加快速，因为编译器还可以执行某些优化。
  
- ARC的判断原则
  
  ​    只要还有一个强指针变量指向对象，对象就会保持在内存中
  
- ARC机制下有几个明显的标志：
  
  - 不允许调用对象的 release，retain方法
  - 不允许调用 autorelease方法
  - 再重写父类的dealloc方法时,不能再调用 [super dealloc];
  
- 强指针：
  
  - 默认所有指针变量都是强指针
    
  - 被__strong修饰的指针
    
    ``` objective-c
     Person *p1 = [[Person alloc] init];
     __strong  Person *p2 = [[Person alloc] init]; 
     // p1,p2都是强指针
    ```
  
- 弱指针：
  
  - 被__weak修饰的指针
    
    ``` objective-c
    __weak  Person *p = [[Person alloc] init];
    ```
  
- ARC下单对象内存管理
  
  - 局部变量释放对象随之被释放
    
    ``` objective-c
    int main(int argc, const char * argv[]) {
       @autoreleasepool {
            Person *p = [[Person alloc] init];
        } // 执行到这一行局部变量p释放
        // 由于没有强指针指向对象, 所以对象也释放
        return 0;
    }
    ```
    
  - 清空指针对象随之被释放
    
    ``` objective-c
    int main(int argc, const char * argv[]) {
       @autoreleasepool {
            Person *p = [[Person alloc] init];
            p = nil; // 执行到这一行, 由于没有强指针指向对象, 所以对象被释放
        }
        return 0;
    }
    ```
    
  - 不要使用弱指针保存新创建的对象
    
    ``` objective-c
    int main(int argc, const char * argv[]) {
       @autoreleasepool {
            // p是弱指针, 对象会被立即释放
            __weak Person *p1 = [[Person alloc] init];
        }
        return 0;
    }
    ```
  
- ARC下多对象内存管理
  
  - ARC和MRC一样, 想拥有某个对象必须用强指针保存对象, 但是__不需要在dealloc方法中release__。
    
    ``` objective-c
    @interface Person : NSObject
    
    // MRC写法
    @property (nonatomic, retain) Dog *dog1;
    
    // ARC写法
    @property (nonatomic, strong) Dog *dog2;
    
    @end
    ```
  
- ARC下循环引用问题
  
  ARC和MRC一样, 如果A拥有B, B也拥有A, 那么必须一方使用弱指针
  
  ``` objective-c
  @interface Person : NSObject
  
  //@property (nonatomic, retain) Dog *dog;
  @property (nonatomic, strong) Dog *dog;
  
  @end
  
  @interface Dog : NSObject
  
  // 错误写法, 循环引用会导致内存泄露
  //@property (nonatomic, strong) Person *owner;
  
  // 正确写法, 但如果保存对象建议使用weak
  //@property (nonatomic, assign) Person *owner;
  @property (nonatomic, weak) Person *owner;
  @end
  ```
  
- ARC下@property参数
  
  - strong : 用于OC对象, 相当于MRC中的retain
  - weak : 用于OC对象, 相当于MRC中的assign
  - assign : 用于基本数据类型, 跟MRC中的assign一样
  
- ARC和MRC兼容和转换
  
  - ARC模式下如何兼容非ARC的类（比如项目是ARC的，但是需要用到MRC的文件，不修改ARC，而是兼容MRC）
    - Builds Phases -> Compile Sources
    - 在里面找到MRC的.m文件，在__compiler Flags__双击，弹出输入框：
      - 转变为非ARC  __-fno-objc-arc__
      - 转变为ARC的 __-f-objc-arc (不常用)__
  - 如何将MRC项目转换为ARC
    - Edit -> Convert -> To Objective-C ARC … (并不是所有的项目都可以转换成功)
  
- 总结：
  
  - ARC和MRC主要区别在于我们不用再担心要给对象发送release消息，因为在ARC的模式下，一个对象如果没有强指针指向它，那么它就会被释放。
    
    ``` objective-c
    Person *person = [[Person alloc] init];
    ```
    
    这一行代码在ARC下就无需我们后续的手动release，因为当person出去自己的作用域，person将被释放，那么如果没有其他强指针指向这个对象，这个对象也随即被释放。这和MRC是不同的，因为如果在MRC下，person被释放，那么这个对象的引用计数依然是1，所以会造成内存泄露，所以在MRC下，在person被释放之前，应该给person发送release消息，这样person会找到这个Person实例对其引用计数-1。如果person被释放，那么就已经没有人可以访问到Person的实例了，很明显这样会造成内存泄露。
    
    所以ARC相比于MRC，重要的改变是将__引用计数是否为0来决定对象的去留__改为__是否有强指针指向对象来决定对象的去留__，所以ARC并不需要我们担心对象会一直待在内存中，因为随着指针的释放（可能是超过作用域被自动释放，或者被设置为了nil），那么在最后可能总有一个时刻没有强指针指向对象，对象就会被释放；而MRC如果你不主动在指针释放前release，那么就再也没有机会了，会造成内存泄露。
    
  - ARC中的类的对象属性需要用strong来修饰，如果是强引用循环，则需要将一方的属性改为assign或weak，但是推荐使用weak，因为assign更多是修饰基本类型的属性。
    
  - 如果一个类的某个属性是对象，那么我们用strong来修饰这个属性是因为我们想要让我们的类对这个对象有一个强指针的指向，这样能保证至少有一个强指针指向引用的对象，这样在这个类想要使用引用对象的时候，能够保证引用的对象不会被释放。在MRC中是同样的道理，不过用的是retain修饰符并且需要在类的dealloc方法中对引用的对象release；而ARC用strong，Xcode帮我们完成一切，所以也不需要我们在dealloc中进行更多操作。(strong和retain修饰符相当于都是Xcode帮我们在setter方法中对对象内存进行正确的处理，strong要更彻底因为不用我们在dealloc中再release；strong属于ARC，retain属于MRC。而ARC中的weak相当于MRC中的assign，更多的用于强引用循环。ARC中的assign和MRC中的assign是一样的，就是生成普通的setter方法并不会有更多的内存管理。不过在ARC中，一般用weak来修饰弱指针以解决强引用循环的问题，而assign就是用来修饰基础类型的)。
    
  - 内存管理这方面，我的第一反应是应该想起指针和类的实例在内存中的图。
    
    （左边是栈，里面有Person *person这样的指针。右边是堆，里面有[[Person alloc] init]出来的对象。person指向这个对象，默认person是强类型指针，所以Person的实例不会被释放。如果又有一个Dog类，情景与上面是一样的。那么如果Person类中有一个Dog *dog属性（nonatomic, strong），并且给这个dog赋值Dog的实例，那么Dog的这个实例则有两个强类型的，一个来自原来的dog强类型指针（在栈中），一个来自Person的dog属性（在Person中），所以如果将在栈中的指针赋值为nil，那么此时Dog实例也不会被释放，因为还有一个来自Person的强指针指向它 ...）
    
  - 要明白一点：
    
    ``` objective-c
    Person *person = [[Person alloc] init];
    ```
    
    这行代码里，person在栈里面，它的内存实际上是不需要我们管的，因为随着作用域的结束或者其他原因，person会被自动收回；但是[[Person alloc] init]出来的这个对象是需要我们管理内存的，因为它在堆里面，系统并不会自动收回它。MRC的时候我们要通过person给它release，所以要保证person在被收回前对其进行操作，否则就再也访问不到对象，造成内存泄露；但是在ARC模式下，对象的内存实际上也不需要我们管了，因为编译器会自动根据是否有强指针指向对象来判断需不需要收回对象，而这些强指针如person会被自动收回，所以相当于对象也会被自动收回。（这里指一般情况，不包括强引用循环等情况）
    
    ​