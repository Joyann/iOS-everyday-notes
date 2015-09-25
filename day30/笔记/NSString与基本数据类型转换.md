- __- (unichar)characterAtIndex:(NSUInteger)index;__
  
  返回index位置对应的字符。
  
- NSString转为基本数据类型：
  
  - __- (double)doubleValue;__
  - __- (float)floatValue;__
  - __- (int)intValue;__
  
- NSString转为C语言中的字符串：
  
  - __- (char *)UTF8String;__
    
    ``` objective-c
    NSString *str = @"abc";
    const char *cStr = [str UTF8String];
    NSLog(@"cStr = %s", cStr);
    ```
  
- C语言字符串转为NSString:
  
  - __-(NSString *)stringWithUTF8String:(char *)cStr__
    
    ``` objective-c
    char *cStr = "abc";
    NSString *str = [NSString stringWithUTF8String:cStr];
    NSLog(@"str = %@", str);
    ```
    
    ​