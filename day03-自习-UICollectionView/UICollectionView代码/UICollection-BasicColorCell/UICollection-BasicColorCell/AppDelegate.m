//
//  AppDelegate.m
//  UICollection-BasicColorCell
//
//  Created by on 15/8/13.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "AppDelegate.h"
#import "JYCollectionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    JYCollectionViewController *collectionVC = [[JYCollectionViewController alloc] initWithNibName:@"JYCollectionViewController" bundle:nil];
    
    self.window.rootViewController = collectionVC;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
