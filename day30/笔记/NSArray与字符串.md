- 把数组元素链接成字符串
  
  - __- (NSString )componentsJoinedByString:(NSString )separator;__
    
    这是NSArray的方法, 用separator作拼接符将数组元素拼接成一个字符串。
    
    ``` objective-c
    NSArray *arr = @[@"hello", @"world", @"joy", @"ann"];
    NSString *res = [arr componentsJoinedByString:@"*"];
    NSLog(@"res = %@", res);
    
    输出结果：hello*world*joy*ann
    ```
  
- 字符串分割方法
  
  - __- (NSArray )componentsSeparatedByString:(NSString )separator;__
    
    这是NSString的方法,将字符串用separator作为分隔符切割成数组元素。
    
    ``` objective-c
    NSString *str = @"this-is-a-book";
    NSArray *arr = [str componentsSeparatedByString:@"-"];
    NSLog(@"%@", arr);
    
    输出结果:
    (
        this,
        is,
        a,
        book
    )
    ```
    
    ​