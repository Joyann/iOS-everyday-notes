//
//  ViewController.m
//  MakeCallAndMessage
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
    
    NSURL *callUrl = [NSURL URLWithString:@"tel://10086"];
    [[UIApplication sharedApplication] openURL:callUrl];
    
    NSURL *messageURL = [NSURL URLWithString:@"sms://10086"];
    [[UIApplication sharedApplication] openURL:messageURL];
}

@end
