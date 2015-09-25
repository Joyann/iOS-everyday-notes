- 使用
  
  ``` objective-c
  NSDate *date = [NSDate date];
  ```
  
  可以创建一个NSDate对象，但是获得的对象是__零时区的时间__，而我们处于东八区，所以上面的date获得的时间是我们现在的时间-8。
  
- 获取当前时区的时间（较复杂的方法）
  
  ``` objective-c
  // 零时区的时间
  NSDate *date = [NSDate date];
  // 获取当前时区
  NSTimeZone *zone = [NSTimeZone systemTimeZone];
  // 获取当前时区到指定时区相隔多少秒
  NSInteger seconds = [zone secondsFromGMTForDate:date];
  // 获取当前时区的时间
  date = [date dateByAddingTimeInterval:seconds];
  NSLog(@"%@", date);
  ```
  
- 时间格式化（NSDate —> NSString）
  
  ``` objective-c
  // 零时区的时间
  NSDate *date = [NSDate date];
  // 创建时间格式化对象
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  // 设置格式化的格式
  formatter.dateFormat = @"yyyy年MM月dd日 HH时mm分ss秒";
  // 将时间转换成相应格式的字符串
  NSString *dateString = [formatter stringFromDate:date];
  NSLog(@"%@", dateString);
  ```
  
  注意：
  
  - 打印的日期就是当前我们所在时区的日期，也就是说DateFormatter自动帮我们转换成当前时区的时间，不需要我们自己计算。
    
  - 时间所对应的格式：
    
    > yyyy 代表年
    > 
    > MM  代表月
    > 
    > dd    代表日
    > 
    > HH    代表24小时制
    > 
    > hh    代表12小时制
    > 
    > mm  代表分
    > 
    > ss      代表秒
  
- NSString —> NSDate
  
  ``` objective-c
  NSString *dateString = @"2015/9/12 10:49:43 +0000";
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss Z";
  NSDate *date = [formatter dateFromString:dateString];
  NSLog(@"%@", date);
  ```
  
  注意：dateFormer中的格式必须要与时间字符串的格式一致（包括时区），否则可能转换失败。
  
  ------
  
- NSCalendar
  
  利用NSCalendar和NSDate，我们可以得到一个时间中的年/月/日/时/分/秒。
  
  ``` objective-c
  NSDate *date = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
  NSDateComponents *dateComponents = [calendar components:unit fromDate:date];
  NSLog(@"%ld年 %ld月 %ld日", dateComponents.year, dateComponents.month, dateComponents.day);
  ```
  
  注意：如果想要在dateComponents里面成功访问year/month/day这样的属性，那么在unit里面一定要写上，否则得到的dateComponents是不会有对应的属性的。
  
- __比较两个时间__
  
  ``` objective-c
  // 第一个时间
  NSString *dateString = @"2015/9/12 2:49:43 +0000";
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss Z";
  NSDate *date1 = [formatter dateFromString:dateString];
  
  // 第二个时间
  NSDate *date2 = [NSDate date];
  
  // 用NSCalendar比较两个时间
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSCalendarUnit unit = NSCalendarUnitYear   |
                        NSCalendarUnitMonth  |
                        NSCalendarUnitDay    |
                        NSCalendarUnitHour   |
                        NSCalendarUnitMinute |
                        NSCalendarUnitSecond ;
  
  NSDateComponents *dateComponents = [calendar components:unit fromDate:date1 toDate:date2 options:0];
  
  NSLog(@"相差： %ld年 %ld月 %ld日 %ld时 %ld分 %ld秒", dateComponents.year, dateComponents.month, dateComponents.day, dateComponents.hour, dateComponents.minute, dateComponents.second);
  ```
  
  ​