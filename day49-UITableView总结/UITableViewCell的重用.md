UITableViewCell如果在`tableView:cellForRowAtIndexPath:`方法中，像其他类一样，使用下面的方式创建：

``` objective-c
UITableViewCell *cell = [[UITableViewCell alloc] init];
cell.textLabel.text = @"hello";
...
```

这样虽然能正确显示，但是性能是有问题的。

苹果实际上是帮我们提高了性能了的。假设要显示200行数据，如果同时创建200个cell，那么无疑会非常消耗性能，并且并没有太大的意义——因为有些cell根本还没有显示出来。

所以在使用UITableView的时候，只有在__cell即将显示的时候才会调用`tableView:cellForRowAtIndexPath:`__方法，也就是说，如果有200行数据，那么只会创建我们可以看到的cell，而那些看不到的数据，则不会创建对应的cell。

比如在手机屏幕上可以同时显示5个cell（编号为0 - 4），那么当用户向上滑tableView的时候，第6个cell即将出现，而第1个cell还未消失，所以此时会创建6个UITableViewCell。当第7个cell出现，那么第1个cell就会完全从屏幕上消失，此时这个UITableViewCell的对象将被销毁，并且第7个cell被创建。以此类推，当有新的cell出现，那么就会创建一个新的cell，销毁消失的那个cell。

这样虽然不必同时创建200个cell，但是在不断地创建-销毁cell，性能上依然会有问题。

__苹果提供的更好的方法是将cell复用，而不是销毁。__

每次有新的cell出现的时候（也就是`tableView:cellForRowAtIndexPath:`方法执行的时候），不应该直接创建一个cell，而是应该去__缓冲池__中查找有没有可复用的cell，如果有，那么就重用这个cell；如果没有，则创建一个cell。这样无论数据是200行，2000行还是20000行，实际上创建的只是__屏幕可见的cell的个数__。

还是上面的例子，当第7个cell即将出现，第1个cell消失，此时并不会销毁第一个cell，而是将它放入__缓冲池__中等待复用。此时第7个cell会首先去缓冲池中寻找是否有可复用的cell，发现有（就是消失的第1个cell），那么就会拿来复用，而不是重新创建。这样一来，消失一个，下次就会重用这个，这样就可以保证创建最少数量的cell，仍然可以满足需求。

实现cell的重用可以采用下面的方法：

- 使用代码自己来创建新的cell：
  
  ``` objective-c
  - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
  {
      NSString * const cellIdentifier = @"CellIdentifier";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (!cell) {
  		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        	cell.backgroundColor = [UIColor greenColor];
      }
      cell.textLabel.text = @"hello";
      
      return cell;
  }
  ```
  
  这里有几点需要注意：
  
  - 当cell为nil，需要创建新的cell的时候，使用的是`initWithStyle:reuseIdentifier:`方法，而不是`init`方法，这样做是因为创建新的cell的时候需要绑定一个identifier，这样在重用的时候才能找到可重用的相同类型。如果使用`init`方法则没有绑定identifier，这样在重用的时候无法成功找到对应的可重用的cell。
    
  - 一般在`if(!cell)`中，也就是在新创建cell的时候，将一些只需要初始化一次的属性进行初始化，而不是在这个括号的外面。因为在括号外面会执行多次，而这些属性并不需要多次设置。同样，如果不同的cell需要设置不同属性或数据，那么需要在括号外执行，因为括号外面每次cell出现都会执行到，这样可以保证不用的cell对应不同的属性或数据。如果将本该设置不同cell对应不同属性的代码放在括号里面，在复用cell的时候不会重新覆盖这些数据，会出现不正确的结果，早晨数据冗余的问题。
    
    ​
  
- 另一种方法是自动创建新的cell：
  
  ``` objective-c
  NSString * const cellIdentifier = @"CellIdentifier";
  
  - (void)viewDidLoad 
  {
      [super viewDidLoad];
      
      [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
  }
  
  - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
  {
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
      cell.textLabel.text = @"hello";
      
      return cell;
  }
  ```
  
  首先需要注册class，意思就是告诉tableView，首先去__缓冲池__中找有没有可重用的cell，如果有，则拿过来重用；如果没有，那么根据之前注册的`UITableViewCell`这个类，来自动生成一个cell，并且给它绑定上重用identifier。
  
  这个方法省去了我们自己手动创建cell，但是也有不足：苹果提供给我们的cell的样式，除了默认的，我们都不能用了。
  
  第一种方法我们通过手动创建cell，使用`initWithStyle:reuseIdentifier:`可以传入不同的style来创建苹果为我们提供的cell，但是在第二种方法中无法实现了。
  
  第二种方法更多的时候用在我们自定义Cell。虽然无法使用更多的系统自带样式，但是我们首先可以注册自定义的cell的类（将UITableViewCell换成自定义的Cell），然后仍然首先去缓冲池中找有没有可重用cell，如果没有，则根据注册的cell来创建cell并绑定identifier。当然，在使用`dequeueReusableCellWithIdentifier:`的时候，返回的应该也是自定义的Cell类型。
  
- 注册的不仅可以是Class，还可以是nib，也就是说可以注册通过xib创建的cell，和上面的方法同理。
  
- 还可以直接通过Storyboard，设置好prototype cell的identifier，在`dequeueReusableCellWithIdentifier:`中就可以直接使用cell，既不用提前注册，也不用手动创建cell。