- 并不是所有的对象都可以发送__copy和mutableCopy__消息，只有一些系统的类（如NSString,NSArray,NSDictionary等）才可以。如果是自定义的类，我们可以通过遵守NSCopying和NSMutableCopying，并实现相应的方法，来实现copy和mutableCopy。
- 深拷贝和浅拷贝
  - 深拷贝的意思是会生成新的对象；而浅拷贝的意思是只拷贝指针，并不会生成新的对象。


- 拷贝的整体原则就是：
  
  __拷贝出的新的和旧的两个互不影响。当修改旧值时，新值不会被改变；当修改新值时，旧值不会被改变。__
  
- 发送copy消息会得到一个不可变对象；发送mutableCopy消息会得到一个可变对象。
  
- 以NSMutableArray为例：
  
  如果使用[NSMutableArray copy]，那么首先可以确定，得到的是一个不可变对象，也就是NSArray。因为原值是NSMutableArray类型，而要求得到的类型是NSArray类型，所以要产生新值才能满足，所以是深拷贝。
  
  如果使用[NSMutableArray mutableCopy]，可以首先确定得到的是一个可变对象，也就是NSMutableArray。如果不产生新对象，而是一个指针指向原来的对象，那么修改旧值，代表新值也会改变（因为两个是同一个值）；修改新址，代表旧址也会改变，显然违反拷贝的原则，所以要产生新的NSMutableArray对象，所以是深拷贝。
  
- 以NSArray为例：
  
  如果使用[NSArray copy]，那么可以确定得到的是一个不可变对象，也就是NSArray。而原值的类型是NSArray类型，说明是不可修改的，而新值是NSArray同样说明是不可修改的，这样是满足拷贝的要求的，因为旧值就不允许修改，而新值也不允许修改，那么copy操作时就可以直接产生一个指针指向原来的对象而不必产生新的对象。所以这是__浅拷贝__。
  
  如果使用[NSArray mutableCopy]，那么得到一个可变对象，很明显原来是NSArray类型现在却是NSMutableArray，只有产生新值才能满足，所以是深拷贝。
  
- 总结：
  
  1. 给一个__不可变对象__（例如NSArray，NSString，NSDictionary...）发送__copy__消息，那么即使不产生新的对象，也能满足拷贝的要求，所以这样就是__浅拷贝__。
  2. 给一个__不可变对象__（例如NSArray，NSString，NSDictionary...）发送__mutableCopy__消息，那么一定要产生新对象才能满足要求（原来是不可变的，现在要得到一个可变的，只能产生新的），所以这样就是__深拷贝__。
  3. 给一个__可变对象__（例如NSMutableArray，NSMutableString，NSMutableDictionary...）发送__copy__消息，那么一定要产生新对象才能满足要求（原来是可变的，现在要得到一个不可变的，只能产生新的），所以这样就是__深拷贝__。
  4. 给一个__可变对象__（例如NSMutableArray，NSMutableString，NSMutableDictionary...）发送__mutableCopy__消息，那么一定要产生新对象才能满足（如果不产生，那么新值和旧值都是可变的，那么可能会相互影响），所以这样就是__深拷贝__。
  
- 补充：
  
  - 如果使用NSString *str = @“hello"这种方式创建字符串，那么是放在常量区的。
    
  - 如果使用initWith...或者类工厂方法来创建字符串，那么是放在堆区的。
    
  - 但是，如果在MAC OS X下查看一个字符串的retainCount(用Command Line Toll创建的项目)，那么会发现其retainCount是一个非常大的数字，那么说明在MAC OS X下，无论是用字符串的初始化方法/类工厂方法还是直接使用@“”来创建，这个字符串都没有在堆区里面。
    
  - 如果想要正常查看一个字符串的引用计数器值，那么需要创建iOS的项目。这样一来，使用@"”那么字符串在常量区；使用初始化方法/类工厂方法，那么字符串在堆区。
    
    ​
  
- 浅拷贝的内存管理：
  
  以NSString为例。如果对NSString使用了copy，那么是浅拷贝，并不会生成新的对象，所以这时，原来的字符串的引用计数器会进行一次加1（发送一条retain消息），因为又有一个新的指针指向这个对象了。
  
  ``` objective-c
  - (void)viewDidLoad {
  	[super viewDidLoad];
      
      NSString *str = [[NSString alloc] initWithFormat:@"hello"]; // 此时引用计数为1。注意，这里使用的是initWith...而不是类工厂方法，如果是类工厂方法，那么在创建这个对象的适合系统已经发送autorelease消息，后面是不需要release的。
    	NSString *str1 = [str copy]; // 并未产生新对象，而是对原来对象发送retain消息，引用计数变为2
        
  	[str release]; 
    	[str release]; // 因为引用计数为2，所以需要再次release
  }
  ```
  
- 深拷贝的内存管理：
  
  以NSString为例。如果对NSString使用mutableCopy，那么是深拷贝，会生成新的对象，所以这时，原来对象的retainCount不变，而新的对象的retainCount为1。
  
  ``` objective-c
  - (void)viewDidLoad {
  	[super viewDidLoad];
      
      NSString *str = [[NSString alloc] initWithFormat:@"hello"]; // 原来的对象retainCount为1。
      NSMutableString *strM = [str mutableCopy]; // 此时产生新对象，原来对象的retainCount不变，新对象为1。
    
    	[str release]; // 释放原来对象
    	[strM release]; // 释放新对象
  }
  ```
  
  ​