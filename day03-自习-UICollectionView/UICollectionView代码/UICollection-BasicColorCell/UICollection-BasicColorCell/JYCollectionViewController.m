//
//  JYCollectionViewController.m
//  CollectionView-ColorCellBasic
//
//  Created by joyann on 15/8/13.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "JYCollectionViewController.h"

@interface JYCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *colors;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation JYCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self getData];
}

- (void)getData {
    const NSInteger numberOfColors = 100;
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:numberOfColors];
    for (int i = 0; i < numberOfColors; i++) {
        UIColor *randomColor = [self getRandomColor];
        [tempArray addObject:randomColor];
    }
    self.colors = [NSArray arrayWithArray:tempArray];
}

- (UIColor *)getRandomColor {
    CGFloat red = (arc4random() % 255) / 255.0f;
    CGFloat blue = (arc4random() % 255) / 255.0f;
    CGFloat green = (arc4random() % 255) / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIColor *randomColor = self.colors[indexPath.row];
    cell.backgroundColor = randomColor;
    
    return cell;
}

@end
