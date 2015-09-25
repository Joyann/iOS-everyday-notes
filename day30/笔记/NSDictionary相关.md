- 常用方法：
  
  ``` objective-c
  + (instancetype)dictionary;
  + (instancetype)dictionaryWithObject:(id)object forKey:(id <NSCopying>)key;
  + (instancetype)dictionaryWithObjectsAndKeys:(id)firstObject, ...;
  + (id)dictionaryWithContentsOfFile:(NSString *)path;
  + (id)dictionaryWithContentsOfURL:(NSURL *)url;
  ```
  
  > 可以看到，NSDictionary的读写和NSString,NSArray都类似，都是...WithContentsOfFile/URL这种形式。
  
- 字典是无序的。
  
- 字典的遍历：
  
  1. 快速遍历
     
     ``` objective-c
     NSDictionary *dict = @{@"name":@"joyann", @"phone":@"12345678", @"address":@"SY"};
     for (NSString *key in dict) {
         NSLog(@"key = %@, value = %@", key, dict[key]);
     }
     ```
     
  2. Block遍历（更加方便，推荐）
     
     ``` objective-c
     [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
         NSLog(@"key = %@, value = %@", key, obj);
     }];
     ```
  
- 注意：
  
  - NSDictionary是不可变的，即你只能进行”查”，但是无法进行”增”，”删”，”改”。
  
  
  - 和NSMutableArray一样，NSMutableDictionary不能使用@{}来创建。（这样相当于子类指针指向父类对象，是不对的）
    
  - 如果给__NSDictionary__初始化的时候，有相同的key，那么在字典中会只有出现的第一个key和其对应的value；剩下的和其相同的key对应的value会被省略。
    
    初始化之后，这个字典就不可再修改，如果试图修改key对应的value，那么编译器会报错。
    
    如果给__NSMutableDictionary__初始化的时候，有相同的key，那么后面的key所对应的value会覆盖前面的，这与NSDictionary是相反的。
    
    初始化之后，可变字典可以被修改，使用下面这种方式：
    
    ``` objective-c
    dic[@"name"] = @"Joyann"; // dic为可变字典
    ```
    
    如果在dic中__有__"name"这个key，那么“Joyann"将会替代原来的key所对应的value；
    
    如果在dic中__没有__"name”这个key，那么这个可变字典将会把name-Joyann这个键值对加进去。