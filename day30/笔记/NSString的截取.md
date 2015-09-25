- __- (NSString *)substringFromIndex:(NSUInteger)from;__
  
  从指定位置from开始(包括指定位置的字符)到尾部。
  
  ``` objective-c
  NSString *str = @"<head>hello</head>";
  str = [str substringFromIndex:7];
  NSLog(@"str = %@", str);
  
  输出：hello</head>
  ```
  
- __- (NSString *)substringToIndex:(NSUInteger)to;__
  
  从字符串的开头一直截取到指定的位置to，__但不包括该位置的字符。__
  
  ``` objective-c
  NSString *str = @"<head>joy</head>";
  str = [str substringToIndex:10];
  NSLog(@"str = %@", str);
  
  输出：<head>joy
  ```
  
- __- (NSString *)substringWithRange:(NSRange)range;__
  
  按照所给出的NSRange从字符串中截取子串。
  
  ``` objective-c
  NSString *str = @"<head>joy</head>";
  NSRange range;
  /*
  range.location = 6;
  range.length = 3;
  */
  range.location = [str rangeOfString:@">"].location + 1;
  range.length = [str rangeOfString:@"</"].location - range.location;
  NSString *res = [str substringWithRange:range];
  NSLog(@"res = %@", res);
  
  输出：joy
  ```
  
- 记得在做字符串截取的时候不要进行硬编码，传入的location和length应该能满足需求变更。