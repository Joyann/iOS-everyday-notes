//
//  ViewController.m
//  AllViewCar
//
//  Created by joyann on 15/8/11.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i <= 36; i++) {
        NSString *imageName = [NSString stringWithFormat:@"img_360car_black_%02d.jpg", i];
        [images addObject:[UIImage imageNamed:imageName]];
    }
    self.imageView.animationImages = images;
    self.imageView.animationDuration = 2.0;
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
}

@end
