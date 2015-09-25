//
//  JYCollectionViewCell.m
//  CollectionView-SelectedHighlight
//
//  Created by joyann on 15/8/14.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "JYCollectionViewCell.h"

@interface JYCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation JYCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 10, 10)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.image = nil;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.imageView.alpha = 0.5f;
    } else {
        self.imageView.alpha = 1.0f;
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}


@end
