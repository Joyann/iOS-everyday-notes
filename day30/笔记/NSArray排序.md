- Foundation自带类排序
  
  ``` objective-c
  NSArray *arr = @[@(1), @(9), @(5), @(2)];
  NSArray *newArr = [arr sortedArrayUsingSelector:@selector(compare:)];
  ```
  
- 自定义类排序
  
  ``` objective-c
  NSArray *arr = @[p1, p2, p3, p4, p5];
  //    默认按照升序排序
  NSArray *newArr = [arr sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(Person *obj1, Person *obj2) {
      return obj1.age > obj2.age;
  }];
  NSLog(@"%@", newArr);
  ```
  
  ​