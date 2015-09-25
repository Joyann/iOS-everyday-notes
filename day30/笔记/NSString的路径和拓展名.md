- __- (BOOL)isAbsolutePath;__
  
  是否为绝对路径。（其实就是判断是否以/开头）
  
- __- (NSString *)lastPathComponent;__
  
  获得最后一个目录。（其实就是截取最后一个/后面的内容）
  
- __- (NSString *)stringByDeletingLastPathComponent;__
  
  删除最后一个目录。（其实就是删除最后一个/和之后的内容）
  
- __- (NSString *)stringByAppendingPathComponent:(NSString *)str;__
  
  在路径的后面拼接一个目录 (也可以使用stringByAppendingString:或者stringByAppendingFormat:拼接字符串内容)
  
  其实就是在最后面加上/和要拼接得内容。
  
  注意这个方法比较聪明，如果你传入的字符串在最后有/，那么则不给加；如果没有，则自动给加上。
  
- __- (NSString *)pathExtension;__
  
  其实就是从最后面开始截取.之后的内容。
  
- __- (NSString *)stringByDeletingPathExtension;__
  
  删除尾部的拓展名。（其实就是删除从最后面开始.之后的内容）
  
- __- (NSString )stringByAppendingPathExtension:(NSString )str;__
  
  在尾部添加一个拓展名。（其实就是在最后面拼接上.和指定的内容）