- NSArray数据写入到文件中
  
  ``` objective-c
  NSArray *arr = @[@"hello", @"joy", @"ann"];
  BOOL flag = [arr writeToFile:@"/Users/Joyann/Desktop/joyann.plist" atomically:YES];
  NSLog(@"%i", flag);
  ```
  
- 从文件中读取数据到NSArray中
  
  ``` objective-c
  NSArray *newArr = [NSArray arrayWithContentsOfFile:@"/Users/Joyann/Desktop/joyann.plist"];
  NSLog(@"%@", newArr);
  ```
  
- plist文件本质上是XML文件，但是在Mac上保存成plist格式的文件，用Xcode打开更直观清晰。