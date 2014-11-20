//
//  AppDelegate.h
//  XMPP_For_iPhone
//
//  Created by xu lingyi on 11/18/14.
//  Copyright (c) 2014 xuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyXMPP;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MyXMPP *myXMPP;

@end

