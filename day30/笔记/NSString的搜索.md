- __- (BOOL)hasPrefix:(NSString *)aString;__
  
  是否以aString开头。
  
- __- (BOOL)hasSuffix:(NSString *)aString;__
  
  是否以aString结尾。
  
- __- (NSRange)rangeOfString:(NSString *)aString;__
  
  - NSRange是一个结构体，由__location__和__length__组成。
  - 如果不包含aString，那么__location为NSNotFound，length为0__。
  
  
  - NSRange的创建
    
    方式一：
    
    ``` objective-c
    NSRange range;
    range.location = 7;
    range.length = 3;
    ```
    
    方式二：
    
    ``` objective-c
    NSRange range = {7, 3};
    或者
    NSRange range = {.location = 7,.length = 3};
    ```
    
    方式三：
    
    ``` objective-c
    NSRange range = NSMakeRange(7, 3);
    ```
    
    开发中推荐使用__NSMakeRange函数__。