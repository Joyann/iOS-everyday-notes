> 现在我们有一个UIView，和一个button，当点击button的时候，我们希望能在这个view上以九宫格的形式添加它的子view。

这里主要是记录一下实现的思路，以后类似的问题都可以这样思考。

![](http://cl.ly/image/360t150K3Q3J/%E4%B9%9D%E5%AE%AB%E6%A0%BC%E5%9B%BE.png)

如图，我们首先要计算的应该是__horizalSpacing__和__verticalSpacing__，因为拿到它们才可以计算坐标值。

很明显这个容器view的大小是固定的，每一个子view的大小也是固定的，所以可以拿到horizalSpacing和verticalSpacing的值，并且是通过动态计算，因为这样才能保证，当容器view或者子view的大小改变时，计算出的间距仍然是等大的。

这里首先要定义需要用到的常量：

``` objective-c
#define ITEM_WIDTH 80.0
#define ITEM_HEIGHT 80.0
#define COLS_COUNT 3
#define ROWS_COUNT 3
```

当点击button的时候，会触发addItemView的方法，就在这个方法里面计算水平和垂直间距：

``` objective-c
- (IBAction)addItemView 
{
	CGFloat horizalSpacing = (self.bigView.bounds.size.width - COLS_COUNT * ITEM_WIDTH) / (COLS_COUNT - 1);
    CGFloat verticalSpacing = (self.bigView.bounds.size.height - ROWS_COUNT * ITEM_HEIGHT) / (ROWS_COUNT - 1);
}
```

以horizalSpacing为例：

首先拿到容器view的总宽度：self.bigView.bounds.size.width

因为一行有三个item，每个item的宽度已知，所以可以计算出三个item占据的宽度：COLS_COUNT * ITEM_WIDTH

用总宽度减去三个item占据的宽度，剩下的空间就是总间距。

因为每一行有三个item，那么就会产生两个间距。同理，一行有n个item，那么就会产生n-1个间距。

有了总间距，知道了共有多少个间距，那么每个间距占据多少就可以求出来，所以求出了horizalSpacing。

verticalSpacing同理。

有了水平和垂直item间的间距，我们就可以计算item的坐标：

``` objective-c
第一个item: X1 = (ITEM_WIDTH + horizalSpacing) * 0, Y1 = 0
第二个item: X2 = (ITEM_WIDTH + horizalSpacing) * 1, Y1 = 0
第三个item: X3 = (ITEM_WIDTH + horizalSpacing) * 2, Y1 = 0

第四个item: X1 = (ITEM_WIDTH + horizalSpacing) * 0, Y2 = (ITEM_HEIGHT + verticalSpacing) * 1
第五个item: X2 = (ITEM_WIDTH + horizalSpacing) * 1, Y2 = (ITEM_HEIGHT + verticalSpacing) * 1
第六个item: X3 = (ITEM_WIDTH + horizalSpacing) * 2, Y2 = (ITEM_HEIGHT + verticalSpacing) * 1

...
```

可以看到，x和y坐标都是有规律的：

x坐标是通过

``` objective-c
 (ITEM_WIDTH + horizalSpacing) * index // 这里的index就是图中item的编号
```

但是当到第四个item的时候，又需要重复新一轮的index的值。

``` objective-c
0 % 3 = 0, 1 % 3 = 1, 2 % 3 = 2
3 % 3 = 0, 4 % 3 = 1, 5 % 3 = 2
6 % 3 = 0, 7 % 3 = 1, 8 % 3 = 2
```

可以看到，是和上面进行的模运算是一个规律，所以我们就可以将代码写成这样来计算x的值：

``` objective-c
- (IBAction)addItemView 
{
  	NSUInteger index = self.bigView.subviews.count; // 新增
  
	CGFloat horizalSpacing = (self.bigView.bounds.size.width - COLS_COUNT * ITEM_WIDTH) / (COLS_COUNT - 1);
    CGFloat verticalSpacing = (self.bigView.bounds.size.height - ROWS_COUNT * ITEM_HEIGHT) / (ROWS_COUNT - 1);
  
  	CGFloat x = (ITEM_WIDTH + horizalSpacing) * (index % COLS_COUNT); // 新增
}
```

在这里计算index并没有采用单独定义一个计数器，每次点击后计数器加1这种方式，而是通过计算容器view的子view的个数。很明显，第一次点击前index = 0。（之后会定义view然后加到bigView中，这时bigView的子view就会+1了。）

同理，y值可以采用同样的方法计算，不过要注意并非是进行取模计算，而是通过除法。（看一下每个item的序号并且和规律对应上，就会发现是用除法。）

``` objective-c
- (IBAction)addItemView 
{
  	NSUInteger index = self.bigView.subviews.count;
  
	CGFloat horizalSpacing = (self.bigView.bounds.size.width - COLS_COUNT * ITEM_WIDTH) / (COLS_COUNT - 1);
    CGFloat verticalSpacing = (self.bigView.bounds.size.height - ROWS_COUNT * ITEM_HEIGHT) / (ROWS_COUNT - 1);
  
  	CGFloat x = (ITEM_WIDTH + horizalSpacing) * (index % COLS_COUNT);
    CGFloat y = (ITEM_HEIGHT + verticalSpacing) * (index / COLS_COUNT); // 新增
}
```

拿到每次view的坐标，并且已知大小，就可以完成了。

``` objective-c
- (IBAction)addItemView 
{
  	NSUInteger index = self.bigView.subviews.count;
  
	CGFloat horizalSpacing = (self.bigView.bounds.size.width - COLS_COUNT * ITEM_WIDTH) / (COLS_COUNT - 1);
    CGFloat verticalSpacing = (self.bigView.bounds.size.height - ROWS_COUNT * ITEM_HEIGHT) / (ROWS_COUNT - 1);
  
  	CGFloat x = (ITEM_WIDTH + horizalSpacing) * (index % COLS_COUNT);
    CGFloat y = (ITEM_HEIGHT + verticalSpacing) * (index / COLS_COUNT);
    
    UIView *item = [[UIView alloc] initWithFrame:CGRectMake(x, y, ITEM_WIDTH, ITEM_HEIGHT)]; // 新增
    item.backgroundColor = [UIColor redColor];  // 新增
    [self.bigView addSubview:item];  // 新增
}
```

不仅仅是九宫格，无论改变item的大小还是bigView的大小，或者改变每一行每一列的item个数，都可以很好的计算出每个item合适的大小和位置。