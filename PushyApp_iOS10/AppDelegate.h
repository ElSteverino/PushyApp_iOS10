//
//  AppDelegate.h
//  PushyApp_iOS10
//
//  Created by quattro on 4/25/17.
//  Copyright © 2017 Coursera Networking and Security in iOS Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

