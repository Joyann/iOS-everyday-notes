//
//  AppDelegate.m
//  CollectionView-SelectedHighlight
//
//  Created by joyann on 15/8/14.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "AppDelegate.h"
#import "JYCollectionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[JYCollectionViewController alloc] initWithCollectionViewLayout:flowLayout]];
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
