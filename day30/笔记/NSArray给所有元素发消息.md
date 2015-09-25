- 让集合里面的所有元素都执行aSelector这个方法
  
  - __- (void)makeObjectsPerformSelector:(SEL)aSelector;__
  - __- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(id)argument;__
  - __注意: 如果数组中的对象没有这个方法会报错。__
  
  ``` objective-c
  [arr makeObjectsPerformSelector:@selector(say)];
  [arr makeObjectsPerformSelector:@selector(eat:) withObject:@"bread"];
  ```
  
  注意，只能支持一个参数的方法。