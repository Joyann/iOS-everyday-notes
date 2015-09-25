//
//  JYCollectionViewController.m
//  CollectionView-SelectedHighlight
//
//  Created by joyann on 15/8/14.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "JYCollectionViewController.h"
#import "JYCollectionViewCell.h"

@interface JYCollectionViewController () <UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *colors;

@end

@implementation JYCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[JYCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.delegate = self;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(100, 100);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    
    [self.collectionView allowsMultipleSelection];
    
    [self getData];
}

- (void)getData {
    const NSInteger imagesCount = 12;
    const NSInteger colorsCount = 10;
    NSMutableArray *tempImagesArray = [[NSMutableArray alloc] initWithCapacity:imagesCount];
    NSMutableArray *tempColorsArray = [[NSMutableArray alloc] initWithCapacity:colorsCount];
    for (int i = 0; i < imagesCount; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.png",i + 1]];
        [tempImagesArray addObject:image];
    }
    self.images = [NSArray arrayWithArray:tempImagesArray];
    for (int i = 0; i < colorsCount; i++) {
        UIColor *color = [self getRandomColor];
        [tempColorsArray addObject:color];
    }
    self.colors = [NSArray arrayWithArray:tempColorsArray];
}

- (UIColor *)getRandomColor {
    CGFloat red = (arc4random() % 255) / 255.0;
    CGFloat blue = (arc4random() % 255) / 255.0;
    CGFloat green = (arc4random() % 255) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.colors.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYCollectionViewCell *cell = (JYCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIColor *color = self.colors[indexPath.section];
    cell.backgroundColor = color;
    UIImage *image = self.images[indexPath.row];
    cell.image = image;
    return cell;
}


@end
