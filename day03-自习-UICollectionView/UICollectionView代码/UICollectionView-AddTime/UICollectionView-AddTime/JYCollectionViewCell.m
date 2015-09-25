//
//  JYCollectionViewCell.m
//  UICollectionView-AddTime
//
//  Created by joyann on 15/8/13.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "JYCollectionViewCell.h"

@interface JYCollectionViewCell()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation JYCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont boldSystemFontOfSize:17];
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.text = @"";
}

- (void)setText:(NSString *)text {
    _text = text;
    
    self.textLabel.text = self.text;
}

@end
