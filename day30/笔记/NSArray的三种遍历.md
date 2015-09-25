- NSArray的下标遍历
  
  ``` objective-c
  NSArray *arr = @[p1, p2, p3, p4, p5];
  for (int i = 0; i < arr.count; ++i) {
      Person *p = arr[i];
      [p say];
  }
  ```
  
- NSArray的快速遍历
  
  ``` objective-c
  NSArray *arr = @[p1, p2, p3, p4, p5];
  for (Person *p in arr) {
      [p say];
  }
  ```
  
- NSArray使用block进行遍历
  
  ``` objective-c
  [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    	NSLog(@"obj = %@, idx = %lu", obj, idx);
    	Person *p = obj;
    	[p say];
  }];
  ```
  
  ​