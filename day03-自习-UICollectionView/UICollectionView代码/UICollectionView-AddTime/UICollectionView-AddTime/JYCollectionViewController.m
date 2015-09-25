//
//  JYCollectionViewController.m
//  UICollectionView-AddTime
//
//  Created by joyann on 15/8/13.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "JYCollectionViewController.h"
#import "JYCollectionViewCell.h"

@interface JYCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *datesArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation JYCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datesArray = [[NSMutableArray alloc] init];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"h:mm:ss a" options:0 locale:[NSLocale currentLocale]]];
    
    [self.collectionView registerClass:[JYCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.itemSize = CGSizeMake(100, 100);
    
    
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDate)];
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
    self.navigationItem.title = @"Our Time Machine";
}

- (void)addDate {
    [self.collectionView performBatchUpdates:^{
        NSDate *date = [NSDate date];
        [self.datesArray insertObject:date atIndex:0];
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
    } completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYCollectionViewCell *cell = (JYCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDate *date = self.datesArray[indexPath.row];
    cell.text = [self.dateFormatter stringFromDate:date];
    
    return cell;
}


@end
