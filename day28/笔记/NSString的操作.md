- Foundation框架常见错误：
  
  在查看Foundation的类的声明的时候，如果不小心修改文件，那么可能会报错：
  
  > ’NSString.h’ has been modified ...
  
  解决方案很简单，只需要删除Xcode的缓存即可：
  
  ``` objective-c
  缓存路径是/Users/用户名/Library/Developer/Xcode/DerivedData(默认情况下, 这是一个隐藏文件夹)
  
  显示隐藏文件 : defaults write com.apple.finder AppleShowAllFiles –bool true
  隐藏隐藏文件 : defaults write com.apple.finder AppleShowAllFiles –bool false
  (输入指令后, 一定要重新启动Finder)
  ```
  
- NSString创建方式
  
  - 最直接的方式(常量字符串)
    
    常量区中的字符串只要内容一致, 不会重复创建
    
    ``` objective-c
    NSString *str1 = @"hello";
    NSString *str2 = @"hello";
    NSLog(@"str1 = %p, str3 = %p", str1, str2);
    输出地址一致
    ```
    
    注意，str1和str2存在栈空间，虽然str1和str2各自指向”hello”字符串，但是这种常量字符串”hello”字符串是存储在常量区的，并且只有一个”hello”字符串，因为str1和str2指向的字符串的内容相同，在常量区中只会创建一个。
    
  - 格式化的方式
    
    堆区中得字符串哪怕内容一致, 也会重复创建
    
    ``` objective-c
    NSString *str3 = [NSString stringWithFormat:@"hello"];
    NSString *str4 = [NSString stringWithFormat:@"hello"];
    NSLog(@"str2 = %p, str4 = %p", str2, str4);
    输出地址不一样
    ```
  
- 利用NSString来读写字符串
  
  1. 直接读文件中的字符
     
     ``` objective-c
     // 用来保存错误信息
     NSError *error = nil;
     
     // 读取文件内容
     NSString *str = [NSString stringWithContentsOfFile:@"/Users/Joyann/Desktop/hello.txt" encoding:NSUTF8StringEncoding error:&error];
     
     // 如果有错误信息
     if (error) {
         NSLog(@"读取失败, 错误原因是:%@", [error localizedDescription]);
     } else { // 如果没有错误信息
         NSLog(@"读取成功, 文件内容是:\n%@", str);
     }
     ```
     
  2. 直接写入文件中，注意重复写入会覆盖掉之前的内容
     
     ``` objective-c
     NSString *str = @"hello";
     BOOL flag = [str writeToFile:@"/Users/Joyann/Desktop/hello.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
     // atomically如果传入NO，即使没有将所有的字符都成功写入，那么也会创建文件；传入YES保证文件的完整性
     if (flag == 1)
     {
         NSLog(@"写入成功");
     }
     ```
  
- 利用URL来读写字符串
  
  > 基本URL包含 协议、主机域名（服务器名称\IP地址）、路径
  > 
  > 可以简单认为: URL == 协议头://主机域名/路径
  > 
  > 常见的URL协议头(URL类型)：
  > 
  > - __http://__ 和__https://__  超文本传输协议资源, 网络资源
  > - __ftp://__ 文件传输协议
  > - __file://__ 本地电脑的文件
  
  1. URL的创建：
     
     - 传入完整的字符串创建
       
       ``` objective-c
       NSURL *url = [NSURL URLWithString:@"file:///Users/Joyann/Desktop/str.txt"];
       ```
       
     - 通过文件路径创建(默认就是file协议的)
       
       ``` objective-c
       NSURL *url = [NSURL fileURLWithPath:@"/Users/Joyann/Desktop/str.txt"];
       ```
       
     - 注意上面两个方法，第一个URLWithString要求明确的在字符串中写出协议头是什么，而fileURLWithPath则默认是file://的，所以在字符串中不要再写。另外，在第一个方法中的字符串file:///Users...，这里面的第三个/是不可以忽略的。
     
  2. 利用URL从文件中读取内容
     
     ``` objective-c
     // 用来保存错误信息
     NSError *error = nil;
     
     // 创建URL路径
     //    NSString *path = @"file://192.168.1.100/Users/Joyann/Desktop/hello.txt";
     
     //  本机可以省略主机域名
     //    NSString *path = @"file:///Users/Joyann/Desktop/hello.txt";
         NSURL *url = [NSURL URLWithString:path];
     
     //  利用fileURLWithPath方法创建出来的URL默认协议头为file://
     NSURL *url = [NSURL fileURLWithPath:@"/Users/Joyann/Desktop/hello.txt"];
     
     // 读取文件内容
     NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
     
     // 如果有错误信息
     if (error) {
         NSLog(@"读取失败, 错误原因是:%@", [error localizedDescription]);
     } else { // 如果没有错误信息
         NSLog(@"读取成功, 文件内容是:\n%@", str);
     }
     ```
     
  3. 利用URL写入文件：
     
     ``` objective-c
     NSString *str = @"hello";
     [str writeToURL:[NSURL fileURLWithPath:@"/Users/Joyann/Desktop/hello.txt"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
     ```
     
  4. 对于路径中有中文的处理：
     
     - 一般来说如果访问本地文件建议使用fileURLWithString:这个方法，因为它不仅是默认帮我们加上file://，而且它处理好路径中的中文，将中文转换成百分比形式；而URLWithString:则不会有这种操作，这意味着用URLWithString:将找不到正确路径。
       
     - 如果你不得不要使用URLWithString（因为fileURLWithString:只能给本地的路径使用，那么如果我们想要访问的是一个网址，比如www.baidu.com这，那么就只能只用URLWithString了。），那么需要在构造URL之前，要给字符串进行百分号转换：
       
       ``` objective-c
       path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
       ```
       
       这样就会将路径中的中文进行百分号转换，然后再用URLWithString:来构造URL。
  
- 总结NSString的读写操作：
  
  总体来说分为两种：
  
  - 直接利用NSString来进行读写操作
    
    - 读操作利用__stringWithContentsOfFile__开头的这个NSString的方法进行，这个方法将文件中的内容以字符串的方式返回。注意，这个方法接受的参数是一个表示__绝对路径__的NSString。
      
    - 写操作利用__writeToFile__开头的这个NSString的方法进行，这个方法返回一个BOOL值代表是否成功写入。注意，这个方法接受的参数也是一个表示__绝对路径__的NSString。
      
    - 所以可以知道，在方法中用到__File__的，都是代表利用表示绝对路径的NSString来进行读写操作的，并且这代表只能读写本地的文件，如果想要读取网页，那么需要利用URL来进行。
      
      ​
    
  - 利用URL来进行读写操作
    
    - 不同于直接利用NSString，利用URL首先要构建URL，这又分为两种：
      
      - 利用NSURL的__URLWithString__开头的方法来创建
      - 利用NSURL的__fileURLWithPath__开头的方法来创建
      - 这两个方法的不同在于，第一个方法在传入NSString参数的时候，需要我们明确写出__协议头+主机域名+路径__，比如@"file:///Users/Joyann/Desktop/hello.txt”；而第二个方法，默认是file://的，所以我们并不写file://这个协议头，比如@"/Users/Joyann/Desktop/hello.txt”。fileURLWithPath默认是file://的，这带来了方便和不足：
        - 我们在访问本地文件时，不用写file://这个协议头，这是方便
        - 另外，fileURLWithPath可以帮我们处理路径中的中文问题
        - 但是，这意味着fileURLWithPath只能构建访问本地文件的URL，如果需要构建访问网络的URL，那么还是需要使用URLWithString方法。
      - 注意，如果是用URLWithString来创建URL，那么如果参数是包含中文的字符串，那么需要对这个字符串进行百分号转换。所以如果需求是既要进行网络请求（不是本地请求）又有中文，那么需要先对路径进行百分号转换（stringByAddingPercentEscapesUsingEncoding这个方法），案后用URLWthString将转换后的参数传进去，然后得到URL，再进行后续操作。
      
    - 现在我们有了URL，那么URL进行读写操作：
      
      - 读操作利用__stringWithContentsOfURL__开头的这个NSString方法进行，这个方法将文件中的内容以字符串的方式返回。注意，这个方法接受的参数是一个NSURL。
        
      - 写操作利用__writeToURL__开头的这个NSString的方法进行，这个方法返回一个BOOL值代表是否成功写入。注意，这个方法接受的参数也是一个NSURL。
        
        ​