- 判断路径是否存在
  
  ``` objective-c
  NSFileManager *manager = [NSFileManager defaultManager];
  BOOL flag = [manager fileExistsAtPath:@"/Usrs/Joyann/Desktop/hello/hello.txt"]; // 可以判断文件，也可以判断文件夹
  ```
  
- 判断文件是否存在并且判断是否是文件夹
  
  ``` objective-c
  // 该方法的返回值是说明 传入的路径对应的文件/文件夹是否存在
  // 第二个参数是用于保存 判断结果的，如果是目录，那么会赋值为YES，如果不是，会赋值为NO。
  BOOL dir = NO;
  flag = [manager fileExistsAtPath:@"/Usrs/Joyann/Desktop/hello/hello.txt" isDirectory:&dir];
  NSLog(@"flag = %i, dir = %i", flag, dir);
  // 如果传入的路径既存在，又是一个目录，那么会输出两个1；如果传入的目录存在，但是不是一个目录而是一个文件（就是我们上面的这个例子），那么会输出1和0。
  ```
  
- 获取文件/文件夹的属性
  
  ``` objective-c
  NSDictionary *attributes = [manager attributesOfItemAtPath:@"/Usrs/Joyann/Desktop/hello/hello.txt" error:nil];
  NSLog(@"%@", attributes);
  ```
  
- 获取文件夹中所有文件
  
  ``` objective-c
  // 注意，这个方法只能获取当前文件夹下的所有文件，但是不能获取子文件夹下面的文件。
  NSArray *result = [manager contentsOfDirectoryAtPath:@"/Usrs/Joyann/Desktop/hello" error:nil];
  NSLog(@"%@", result);
  
  // 所以可以用下面两个方法来获取所有的文件(包括子文件夹下面的)
  // 可以用下面的方法来获得所有的文件，并且可以用attributesOfItemAtPath...这个方法获得文件大小，这样就可以计算一个文件夹的总大小。
  result = [manager subpathsAtPath:@"/Usrs/Joyann/Desktop/hello"];
  result = [manager subpathsOfDirectoryAtPath:@"/Usrs/Joyann/Desktop/hello" error:nil];
  NSLog(@"%@", result);
  ```
  
- 创建文件夹
  
  ``` objective-c
  // withIntermediateDirectories:如果指定的文件夹中有一些文件不存在，是否自动创建不存在的文件夹
  // attributes: 指定创建出来的文件夹的属性
  // 如果原来没有hello这个文件夹，那么经过这行代码，就会自动创建一个hello文件夹。
  // 如果路径改为：/Usrs/Joyann/Desktop/Hello/hello，而原本就没有Hello，那么如果withIntermediateDirectories:为YES，那么会自动创建Hello/hello；如果为NO，那么则不会自动创建。
  // 注意：这个方法只能用于创建文件夹，不能用于创建文件。
  [manager createDirectoryAtPath:@"/Usrs/Joyann/Desktop/hello" withIntermediateDirectories:YES attributes:nil error:nil];
  ```
  
- 创建文件
  
  ``` objective-c
  // contents: 文件中的内容
  // attributes: 文件的属性
  // 注意：这个方法只能用于创建文件，不能用于创建文件夹。
  NSString *contents = @"hello world";
  NSData *contentsData = [contents dataUsingEncoding:NSUTF8StringEncoding];
  [manager createFileAtPath:@"/Usrs/Joyann/Desktop/hello/hello.txt" contents:contentsData attributes:nil];
  ```
  
  ​