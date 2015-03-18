//
//  AppDelegate.h
//  FBFun
//
//  Created by MACBOOK-MUM on 14/03/15.
//  Copyright (c) 2015 MACBOOK-MUM. All rights reserved.
//

#import "FBFunViewController.h"
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {

     FBFunViewController *objFBFunViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) FBFunViewController *objFBFunViewController;
@property (nonatomic, retain) UINavigationController *objNavigationController;
@end

