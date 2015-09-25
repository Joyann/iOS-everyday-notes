- __- (BOOL)isEqualToString:(NSString *)aString;__
  
  两个字符串的内容相同就返回YES, 否则返回NO。
  
- __- (NSComparisonResult)compare:(NSString *)string;__
  
  比较方法: 逐个字符地进行比较ASCII值，返回NSComparisonResult作为比较结果。
  
  > NSComparisonResult是一个枚举，有3个值:
  > 
  > 如果左侧 > 右侧,返回NSOrderedDescending,
  > 
  > 如果左侧 < 右侧,返回NSOrderedAscending,
  > 
  > 如果左侧 == 右侧返回NSOrderedSame
  
  ``` objective-c
  NSString *str1 = @"abc";
  NSString *str2 = @"abd";
  switch ([str1 compare:str2]) {
      case NSOrderedAscending:
          NSLog(@"后面一个字符串大于前面一个");
          break;
      case NSOrderedDescending:
          NSLog(@"后面一个字符串小于前面一个");
          break;
      case NSOrderedSame:
          NSLog(@"两个字符串一样");
          break;
  }
  输出结果: 后面一个字符串大于前面一个
  ```
  
- __- (NSComparisonResult) caseInsensitiveCompare:(NSString *)string;__
  
  忽略大小写进行比较，返回值类型与__compare:__一致。
  
  ``` objective-c
  NSString *str1 = @"abc";
  NSString *str2 = @"ABC";
  switch ([str1 caseInsensitiveCompare:str2]) {
      case NSOrderedAscending:
          NSLog(@"后面一个字符串大于前面一个");
          break;
      case NSOrderedDescending:
          NSLog(@"后面一个字符串小于前面一个");
          break;
      case NSOrderedSame:
          NSLog(@"两个字符串一样");
          break;
  }
  输出结果:两个字符串一样
  ```
  
  ​