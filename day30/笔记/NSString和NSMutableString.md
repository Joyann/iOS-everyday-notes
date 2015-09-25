- 从前面的笔记可以知道，NSString的方法都会返回一个NSString对象，因为NSString不可变，所以只能产生新的对象。而NSMutableString很多方法是返回void的，因为它可以直接修改，不必创建新的对象。
  
- NSMutableString继承自NSString，所以也会将NSString中的方法继承下来。所以当用NSMutableString的时候应该注意返回值。虽然给NSMutableString用返回NSString *的方法并不会出错，但是会产生新的对象，比较浪费。
  
- NSMutableString在某些情况下更省内存，因为不必像NSString那样创建新对象。
  
- 下面的例子：
  
  ``` objective-c
  NSMutableString *strM = @"Hello world";
  ```
  
  这样做是会有警告的，因为@[]这种形式只能用于NSString，所以运行的话程序会崩溃。