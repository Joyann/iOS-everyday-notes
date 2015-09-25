# UICollection View(二)

- __supplementary views__是__数据驱动（data-driven）__的，而__decoration views__则不是。

- supplementary views依赖于__UICollectionViewLayout__。iOS默认使用其子类__UICollectionViewFlowLayout__。

- UICollectionViewFlowLayout中有两个内建supplementary views：

  - headers
  - footers

- Remember：任何不是cell但是显示关于collection的data或者metadata的，应该是supplementary view。

- supplementary views与collection view cells类似：给collection view发送消息注册一个supplementary views的Class或UINib，之后不断重用supplementary views。这里需要注意的一点是，除此之外还需要我们提供__supplementary views的尺寸__。

- 在创建header view的自定义类的时候，需要从__UICollectionReusableView__继承。这个类提供和UICollectionViewCell一样的功能，但是相对来说更__轻量级__。

- supplementary views, out of the box, 不支持一些高级特性，比如: selection, highlighting等cell可以实现的特性。

- 下面是使用supplementary views的例子：

  ``` objective-c
  // 创建自定义的header view类，注意，继承自UICollectionReusableView，其他的和cell一样。
  // Header File
  @interface AFCollectionHeaderView : UICollectionReusableView

  @property (nonatomic, copy) NSString *text;

  @end

  // Implementation File
  @implementation AFCollectionHeaderView
  {
  	UILabel *textLabel;
  }

  - (id)initWithFrame:(CGRect)frame
  {
    if (!(self = [super initWithFrame:frame])) return nil;
    textLabel = [[UILabel alloc] initWithFrame:CGRectInset(
   CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)), 30,  10)];
    textLabel.backgroundColor = [UIColor clearColor]; textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont boldSystemFontOfSize:20]; textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleWidth; [self addSubview:textLabel];
    return self;
  }

  -(void)prepareForReuse
  {
    [super prepareForReuse];
    [self setText:@""];
  }

  -(void)setText:(NSString *)text
  {
    _text = [text copy];
    [textLabel setText:text];
  }

  @end
  ```

  现在我们已经有了自定义的supplementary views类，我们需要在controller里面对其注册，方式同样和cell类似，但是需要我们说明supplementary view的尺寸。在viewDidLoad方法里面：

  ``` objective-c
  // After we have set up the flow layout
  surveyFlowLayout.headerReferenceSize = CGSizeMake(60, 50);
  // After we have set up the collection view
  [surveyCollectionView registerClass:[AFCollectionHeaderView class]
  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
  ```

  可以看到，我们的header view是由UICollectionLayout来控制的，所以在设置好UICollectionViewFlowLayout(继承自UICollectionFlowLayout)后，需要设置其__headerReferenceSize__属性来说明supplementary view的大小。(UICollectionView和大小有关几乎都是用flow layout(layout)来控制(?))

  和cell类似，如果想要使用supplementary view并且进行复用，需要对其进行注册，在这个方法中我们说明了想要注册的view的类型是__UICollectionElementKindSectionHeader__，即section header类型，并且给其绑定一个reuse identifier。

  因为supplementary view可能有多种类型(除了UICollectionElementKindSectionHeader还有UICollectionElementKindSectionFooter，这是flow layout默认提供的，我们也可以自定义，在以后会提到)，而我们并不能从AFCollectionHeaderView的父类中推断出这是哪种类型，所以需要说明我们希望注册的是哪一种类型，即section header。

  __注意：一定不要忘记设置headerReferenceSize，否则会默认为0，那么supplementary view将不会显示出来。__

------

  现在我们已经注册好supplementary view，我们需要返回supplementary view。我们通过__UICollectionViewDelegate的collectionView:viewForSupplementaryElementOfKind: atIndexPath:方法来实现__。

  第二个参数是我们注册header view时候的kind(UICollectionElementKindSectionHeader)，因为目前为止我们只有一种类型的supplementary view，所以下面忽略了这个参数，但是如果你有多个类型，你需要处理返回正确的类型。

``` objective-c
  -(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
  {
  	//Provides a view for the headers in the collection view
  	AFCollectionHeaderView *headerView = (AFCollectionHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];

    if (indexPath.section == 0)
    {
    	//If this is the first header, display a prompt to the user [headerView
      setText:@"Tap on a photo to start the recommendationengine."];
    }else if (indexPath.section <= currentModelArrayIndex)
    {
    	//Otherwise, display a prompt using the selected photo from the previous section
      AFSelectionModel *selectionModel = selectionModelArray[indexPath.section - 1];
    	AFPhotoModel *selectedPhotoModel = [self photoModelForIndexPath:[NSIndexPath indexPathForItem:selectionModel.selectedPhotoModelIndex inSection:indexPath.section - 1]];
    	[headerView setText:[NSString stringWithFormat:@"Because you liked %@...", selectedPhotoModel.name]];
    }

    return headerView;
  }
```

  接下来就是正确地设置cell：

``` objective-c
  -(NSInteger)numberOfSectionsInCollectionView:(UICollectionView
  *)collectionView
  {
  	// Return the smallest of either our current model index plus one,
  	// or our total number of sections. This will show 1 section when we 	 // only want to display section zero, etc.
      // It will prevent us from returning 11 when we only have 10 sections.

  	return MIN(currentModelArrayIndex + 1, selectionModelArray.count);
  }


  -(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
  {
    	//Return the number of photos in the section model
    	return [[selectionModelArray[currentModelArrayIndex] photoModels] count];
  }


  -(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
  {
  	AFCollectionViewCell *cell = (AFCollectionViewCell *)[collectionView
  dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

  	//Configure the cell
  	[self configureCell:cell forIndexPath:indexPath];

  	return cell;
  }
```

  接下来就是创建自定义的UICollectionViewCell的子类，就不写了。主要是想记录如何创建和使用supplementary views。

- 和UITableViewDelegate类似，UICollectionViewDelegate也提供了很多的代理方法：

  ``` objective-c
  -(void)collectionView:(UICollectionView *)collectionView
  didSelectItemAtIndexPath:(NSIndexPath *)indexPath
  {
  	//No matter what, deselect that cell
  	[collectionView deselectItemAtIndexPath:indexPath animated:YES];

    	//当cell被点中所采取的操作
    	...
  }

  collectionView:shouldHighlightItemAtIndexPath:
  collectionView:shouldSelectItemAtIndexPath:
  collectionView:shouldDeselectItemAtIndexPath:
  ```

- Methods for Modifying Collection View Content:

  > insertSections:
  >
  > deleteSections:
  >
  > reloadSections:
  >
  > moveSection:toSection:
  >
  > insertItemsAtIndexPaths:
  >
  > deleteItemsAtIndexPaths:
  >
  > reloadItemsAtIndexPaths:
  >
  > moveItemAtIndexPath:toIndexPath:

- collection view 的 cell 的尺寸一般由 flow layout 来设置，但是这只能让所有的cell都是一样的尺寸，如果想要不同的cell有不同的尺寸呢？

  flow layout的delegate(__UICollectionViewDelegateFlowLayout__)的方法可以解决这个问题。

  ``` objective-c
  -(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
  {
  	...
  }
  ```

- 如果想要实现cell的copy/cut/paste功能

  在UICollectionViewDelegate方法中实现以下方法：

  ``` objective-c
  -(BOOL)collectionView:(UICollectionView *)collectionView
  shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
  {
  	return YES;    //  enable the copy/cut/paste menu for individual cells instead of for an entire collection view
  }
  ```

  上面这个方法让collection view知道我们支持menus，接下来collection view将询问它的delegate不同的action(copy/cut/paste)执行哪种不同的操作：

  ``` objective-c
  -(BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
  {
  	if ([NSStringFromSelector(action) isEqualToString:@"copy:"])
  	{
  		return YES;
  	}
  	return NO;
  }
  ```

  注意collection view首先会用到上面这个方法来确定哪种操作是可执行的，在这里我们将SEL类型的action转换成NSString：

  ```
  NSStringFromSelector(action)
  ```

  接下来，就是真正所执行的操作：

  ``` objective-c
  -(void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
  {
  	if ([NSStringFromSelector(action) isEqualToString:@"copy:"])
  	{
  		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
  		[pasteboard setString:[[self photoModelForIndexPath:indexPath] name]];
      }

  }
  ```

  注意拿到系统paste board的方法：

  ``` objective-c
  UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
  // 接着将值设置给pasteboard
  [pasteboard setString: "value"];
  ```



------
