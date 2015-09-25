- __- (NSString )stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement;__
  
  用replacement替换target。
  
  ``` objective-c
  NSString *newStr = [str stringByReplacingOccurrencesOfString:@"*" withString:@"/"];
  ```
  
- __- (NSString )stringByTrimmingCharactersInSet:(NSCharacterSet *)set;__
  
  根据传入的set来去掉首尾的字符串。
  
  ``` objective-c
  NSString *str =  @"   http://baidu.com/img   ";
  NSString *newStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  
  NSString *str = @"http://baidu.com/img***"
  NSString *newStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"*"]];
  ```
  
  这里看到NSCharacterSet *可以确定set是一个对象。然后在文档里可以查到这个类的初始化方法以得到满足要求的对象。