- 一个类遵守一个protocol，那么相当于在类里有了这个protocol的方法声明，而方法的实现需要我们自己来写。
  
- 一个类如果遵守一个protocol，那么说明这个类拥有了这个protocol的方法声明，所以这个类的子类同样会继承这些方法声明。例如，所有的类都继承自NSObject类，而NSObject类遵循NSObject协议，所以所有的类都相当于有NSObject协议里声明的方法。注意，这是是有方法的声明但是是没有实现的。
  
- 继承和实现协议的区别：
  
  - 继承之后默认就有实现, 而实现protocol只有声明没有实现
  - 相同类型的类可以使用继承, 但是不同类型的类只能使用protocol
  - protocol可以用于存储方法的声明, 可以将多个类中共同的方法抽取出来, 以后让这些类遵守协议即可
  
- protocol使用注意：
  
  - protocol用来声明方法(__不能声明成员变量__),不能写实现。
    
  - 只要父类遵守了某个协议,那么子类也遵守。
    
    ``` objective-c
    // SportProtocol.h文件
    @protocol SportProtocol <NSObject>
    - (void)playFootball;
    - (void)playBasketball;
    @end
    
    // Student.h文件
    #import "SportProtocol.h"
    @interface Student : NSObject <SportProtocol>
    @end
    
    // GoodStudent.h文件 这个类从Student类继承
    @interface GoodStudent : Student
    @end
    
    // GoodStudent.m文件
    @implementation GoodStudent
    - (void)playFootball
    {
        NSLog(@"%s", __func__);
    }
    - (void)playBasketball
    {
        NSLog(@"%s", __func__);
    }
    @end
    ```
    
  - OC不能继承多个类(单继承)但是能够遵守多个协议。
    
  - 协议可以遵守协议,一个协议遵守了另一个协议,就可以拥有另一份协议中的方法声明。
    
  - 我们知道有一个叫做NSObject的类，也有一个NSOject的协议。实际上NSObject类遵守NSObject协议，NSObject协议里面有一些有用的方法，比如__description__，__retain__，__release__等，又因为所有类都从NSObject类继承，所以所有类都有NSObject协议里的方法声明，这也是为什么我们在创建自定义的类（比如Person）的时候，可以直接实现description等方法，这是因为Person类的基类NSObject遵循NSObject协议，而NSObject协议里面声明了description等方法。
    
  - 前面说过协议是可以遵循协议的，所以建议每个新的协议都要遵守NSObject协议，虽然不这样做也没有错，但是这样可以为我们提供一些方便的方法。
  
- protocol类型限制
  
  有的时候我们希望我们的类的某个对象属于，必须具备某些行为（这意味着必须要实现某个协议），那么通常是以下面的方式进行protocol类型限制：
  
  > 数据类型<协议名称> 变量名
  
  代码的形式：
  
  ``` objective-c
  id<MyProtocol> obj = [[Person alloc] init]; // 如果没有遵守协议则会报警告
  
  @property (nonatomic, weak) id<MyProtocol> obj; // protocol类型限制
  ```
  
- 代理设计模式：
  
  - 代理设计模式的场合:
    
    - 当对象A发生了一些行为,想告知对象B(让对象B成为对象A的代理对象)
    - 对象B想监听对象A的一些行为(让对象B成为对象A的代理对象)
    - 当对象A无法处理某些行为的时候,想让对象B帮忙处理(让对象B成为对象A的代理对象)
    
  - 代理设计模式示例
    
    > 有一个婴儿，当婴儿饿的时候希望有一个保姆能喂他吃饭，当婴儿困的时候希望有一个保姆能哄他睡觉。
    
    ``` objective-c
    // main.m
    #import <Foundation/Foundation.h>
    #import "Baby.h"
    #import "Nanny.h"
    
    int main(int argc, const char * argv[]) {
        @autoreleasepool {
            Nanny *nanny = [[Nanny alloc] init];
            
            Baby *baby = [[Baby alloc] init];
            baby.hungryValue = 5;
            baby.sleepyValue = 5;
            baby.delegate = nanny;
            
            [baby babyHungry];
            [baby babySleepy];
        }
        return 0;
    }
    
    // Baby.h
    #import <Foundation/Foundation.h>
    
    @class Baby;
    
    @protocol BabyDelegate <NSObject>
    
    - (void)babyNeedsFoodWithbaby: (Baby *)baby;
    - (void)babyNeedsSleepWithBaby: (Baby *)baby;
    
    @end
    
    @interface Baby : NSObject
    
    @property (nonatomic, weak) id<BabyDelegate> delegate;
    @property (nonatomic, assign) int hungryValue;
    @property (nonatomic, assign) int sleepyValue;
    
    - (void)babyHungry;
    - (void)babySleepy;
    
    @end
    
    // Baby.m
    #import "Baby.h"
      
    @implementation Baby
    
    - (void)babyHungry {
        NSLog(@"婴儿饿了"); // 接下来给代理对象发送消息
        if ([self.delegate respondsToSelector:@selector(babyNeedsFoodWithbaby:)]) {
            [self.delegate babyNeedsFoodWithbaby:self];
        }
    }
    
    - (void)babySleepy {
        NSLog(@"婴儿困了"); // 接下来给代理对象发送消息
        if ([self.delegate respondsToSelector:@selector(babyNeedsSleepWithBaby:)]) {
            [self.delegate babyNeedsSleepWithBaby:self];
        }
    }
    
    @end
      
    // Nanny.h
    #import <Foundation/Foundation.h>
    #import "Baby.h"
    
    @interface Nanny : NSObject <BabyDelegate>
    
    @end
      
    // Nanny.m
    #import "Nanny.h"
    
    @implementation Nanny
    
    - (void)babyNeedsFoodWithbaby:(Baby *)baby {
        NSLog(@"给婴儿喂饭");
        baby.hungryValue -= 1;
    }
    
    - (void)babyNeedsSleepWithBaby:(Baby *)baby {
        NSLog(@"哄婴儿睡觉");
        baby.sleepyValue += 1;
    }
    
    @end
    ```
    
  - 上面一个例子的大体思路是：
    
    在Baby类的.h文件声明一个BabyDelegate，并且Baby有一个名叫delegate的属性，数据类型为id因为delegate的数据类型是不确定的，并且在这里用到了protocol类型限制，这里限制delegate必须要遵守Baby声明的协议，这样就能保证Baby类的代理能够满足Baby类的需求。然后在Nanny类遵循BabyDelegate协议，并且实现相应的代理方法。Baby类有两个方法，一个是baby饿了，一个是baby困了。当baby饿了的时候，需要给其代理发送消息做出相应的反应，在这里baby的代理变成了nanny，也就是说当baby饿得时候，要给其代理nanny发送之前baby协议中声明的对应的方法。这里要注意，虽然我们保证delegate遵守BabyDelegate协议，但是delegate所属的类（这里是Nanny类）可能并没有实现相应的代理方法，所以在发送消息之前要检查一下代理是否实现相应的方法了，这在代理设计模式中是经常用的。在main中设置好代理，并给baby发送不同的消息，现在baby会根据不同的方法给自己的代理发送不同的消息以处理不同的情况。这就是代理模式的简单应用。
    
  - 这里还有几点需要注意：
    
    - 一般情况下，当前协议属于谁，我们就将协议定义到谁的头文件中，而不是单独创建一个SomeProtocol.h文件。
    - 协议的名称一般以它属于的那个类的类名开头，后面跟上protocol或delegate。
    - 协议中的方法名称一半以协议的名称protocol之前的作为开头。比如在这个例子中，协议名为BabyDelegate，那么方法的名称就以baby开头。
    - 一般情况下协议中的方法会将触发该协议的对象传递出去(这里是Baby对象)。比如这里的代理方法都有一个Baby *类型的参数。
    - 一般情况下一个类中的代理属性名称叫做 delegate。
    - 当某一个类要称为另外一个类的代理的时候，一般情况下，在.h中用__@protocol 协议名称;__  告诉当前类这是一个协议；在.m中用\#import导入声明protocol的.h文件。(在这个例子中，我是直接在.h中用import导入的声明protocol的.h文件，而没有用@protocol，是因为用@protocol来声明编译器会有警告。)
    
  - 代理设计模式能让我们的程序更灵活，比如以我们刚才的代码为例子，如果不使用代理设计模式，而是用一般的方法：
    
    在Baby类中可能首先声明一个@property(nonatomic, strong) Nanny *nanny；然后在Nanny中要声明和实现处理Baby的方法，然后调用baby的方法的时候调用nanny的方法来处理。这样看起来是可以的，但是一旦需求变更，我们可能不再用一个nanny来照顾婴儿，而是改用一个student。那么此时，你要修改Baby类中的属性，将其变为student，并且在student的类中要实现nanny声明和实现的方法，然后在在调用baby类的方法的时候也要将以前调用nanny方法改为调用student方法；如果需求又变，那么又要改很多东西。
    
    但是代理设计模式则简洁不少。我们将婴儿的需求方法抽取成一个协议，然后将处理婴儿的人变得抽象（delegate），任何遵守了婴儿协议的人都可以成为婴儿的delegate。这样一来，当你哪天想要将nanny变为student，Baby这个类中的代码是一点也不需要更改的，它依旧是向自己的代理发送消息，它不用关心自己的代理是谁，它只关心只要有人实现我的协议，能给我喂饭哄我睡觉，那我就OK。所以说，需求变更我们只需让新的类实现Baby协议，并且将baby的delegate变为新的类的实例，那么就没有问题了，这样做明显要比前面说的更好。
  
  ​