# iOS UICollectionView 第二版(一)

- UICollectionViewController与UITableViewController非常相似，都需要实现数据源方法，其中UICollectionViewController与其相对应的是：			
  
  `(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;`​
  
  `-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;`
  
  `- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath`
  
  其中第一个返回多少个section，第二个返回section对应多少个item，第三个返回每个item具体是什么。数据源和代理的设置与UITableViewController一样。
  
- 在用UICollectionViewController的时候，可以用xib，代码以及Storyboard三种方式实现（与UITableViewController一样）。
  
- 在使用代码实现的时候，可以在application:didFinishLaunchingWithOptions:方法中按以下思路来实现：
  
  ``` objective-c
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[JYCollectionViewController alloc] initWithCollectionViewLayout:flowLayout]];
  
    self.window.rootViewController = navigationController;
  
    self.window.backgroundColor = [UIColor whiteColor];
  
    [self.window makeKeyAndVisible];
  
    return YES;
  ```

	以上代码通过手写代码的方式创建一个UINavigationController并将其设置成self.window的rootVC，通过__UICollectionViewFlowLayout__来创建一个collectionVC(JYCollectionViewController)。注意此时的flowLayout相当于是默认设置，我们将在后面修改它的值。

- 如果不想用上面的手动写代码的方法，最方便的方法是使用Storyboard来拖进一个UICollectionViewController，实现它的数据源和代理等方法就可以直接使用了。
  
- 如果想用xib的方法，可以在创建JYCollectionViewController的时候使用以下方法：
  
     ` [[JYCollectionViewController alloc] initWithNibName:@"YourXibName" bundle:nil];`
  
- 使用代码创建和xib,Storyboard这种可视界面创建有什么区别呢？个人理解是当你看到一个VC是以initWithFrame这种方式创建(在此例是用initWithCollectionViewLayout)，说明是以手写代码的方式创建的，那说明里面的控件，包括控件的大小，样式等东西都可能需要你在initWithFrame方法中用代码写出来。当你看到用initWithNibName这种形式创建，说明是用xib方式创建，你可以直接在可视界面设置好其属性，直接用IBOutlet来操作。
  
- 无论在使用UITableViewController和UICollectionViewController的时候都不可避免的需要自定义cell（item）。如果使用Storyboard的方式可以直接在Storyboard中设置其identifier，并且拖入想要的控件设置其属性，直接使用非常方便。如果使用代码的方式创建cell（item），需要在controller里面进行注册：
  
  `[self.collectionView registerClass:[JYCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];  //默认使用[UICollectionViewCell class]`
  
  ​

  	可以看到registerClass表示的是注册用手写代码的方式创建的cell，并给其设置identifier。此后JYCollectionViewCell会调用- (id)initWithFrame:(CGRect)frame方法，我们需要在这个方法中设置这个cell，比如增加控件，设置各种属性等：	

``` objective-c
self = [super initWithFrame:frame];
if (self) {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 10, 10)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.imageView];
}
return self;
```

	此时在controller里面，我们就可以重用这个cell了。

	我们还有第三种方式创建cell（item），就是用xib的方式。我们可以在创建JYCollectionViewCell的时候的同时选中创建相应的xib文件，也可以不创建，如果不创建，那么需要新建一个空的xib文件，拖入cell，设置完需要显示的样子之后与JYCollectionViewCell这个类关联，就可以达到和第一种方式相同的效果。当我们有了JYCollectionViewCell想对应的xib文件，我们同样需要在controller里面对其进行注册，注意和手写代码创建cell时的方法的区别：

 `[self.collectionView registerNib:[UINib nibWithNibName:@"YourNibName" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];`

因为此时我们使用的是xib方式，那么需要找到我们的xib文件，所以变成了以上代码的样子。此后我们的cell不再像刚才一样调用initWithFrame方法了，而会调用__awakeFromNib__方法，我们可以在这个方法中进行想要的操作。同样的，通过IBOutlet方式给cell类设置属性，便可以正常使用这个自定义的cell了。

- 在cell的类中，因为要不断的重用，需要实现__prepareForReuse__方法。
  
  ``` objective-c
  [super prepareForReuse];
  self.image = nil;
  self.backgroundColor = [UIColor whiteColor];
  ```
  
- 如果在将collectionView设置成允许多选：
  
  ``` 
  [self.collectionView allowsMultipleSelection];
  ```
  
  并且想要当用户点击cell的时候有变化，可以在cell类中重写__-(void)setHighlighted:(BOOL)highlighted__方法：
  
  ``` 
  [super setHighlighted:highlighted];
  if (highlighted) {
      self.imageView.alpha = 0.5f;
  } else {
      self.imageView.alpha = 1.0f;
  }
  ```
  
  在这里是当用户点击cell的时候（Highlight状态），imageView的alpha变成0.5，松开手指的时候变回1.0。因为cell在实时监控是否是highlight状态，所以无论何时松开手指都会自动变回1.0。
  
- 上面提到，在最开始手写代码创建JYCollectionViewController的时候需要用到一个UICollectionViewFlowLayout，那时我们用的是默认的，现在我们可以在controller里面重新设置flowLayout的值。
  
  ``` 
  UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
  flowLayout.itemSize = CGSizeMake(100, 100);
  flowLayout.minimumLineSpacing = 10;
  flowLayout.minimumInteritemSpacing = 10;
  flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
  ```
  
  首先将flowLayout”拿”出来，设置各种属性，就可以成功修改我们collectionView的样子了。（可以在viewDidLoad中修改）
  
- UICollectionView进行多个数据的插入，删除等操作：
  
  ``` objective-c
  [self.collectionView performBatchUpdates:^{
      NSDate *date = [NSDate date];
      [self.datesArray insertObject:date atIndex:0];
      [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
  } completion:nil];
  ```
  
  可以看到我们在block中首先修改数据，然后给collectionView加入数据，模式与UITableView是一样的。
  
  同样也可以用和UITableView相同的刷新方式：
  
  `[self.collectionView reloadData]`
  
- 补充：
  
  - 在iOS中，用户点击图标进入程序，在暂留的启动界面，程序被加载到内存，进入程序后app变成__active__状态，当用户点击Home键，程序进入__background__状态，app会有10s时间来保存数据或者处理一些任务，当任务完成程序会进入__suspended__状态，在这个状态app仍然在内存中但不会执行任何代码，如果在suspended状态用户点回app，那么程序会回到用户上一次点击Home键程序退出的页面。当内存很少时，系统会kill掉suspended状态的app或者当用户手动kill掉app时，程序最终变成__terminated__状态。当有电话进来（或者用户接受到一个类似于日历的alert，打开multitasking tray）时，app会变成__inactive__状态，app仍在运行，但是不在界面的最前端。
  
  
  - 设置时间格式：
    
    `[self.dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"h:mm:ss a" options:0 locale:[NSLocale currentLocale]]];`
    
    显示的是类似于__8:45:07 AM__。
  
- 一共三个简单例子，具体的看代码。