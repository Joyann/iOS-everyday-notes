//
//  ViewController.m
//  TouchTransitionAnimation
//
//  Created by joyann on 15/8/11.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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
    CATransition *transition = [CATransition animation];
    transition.duration = 2.0;
    transition.type = @"cube";
    transition.subtype = @"fromRight";
    
    [self.view.layer addAnimation:transition forKey:nil];
}

@end
