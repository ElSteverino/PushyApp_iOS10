//
//  ViewController.m
//  PushyApp_iOS10
//
//  Created by quattro on 4/25/17.
//  Copyright © 2017 Coursera Networking and Security in iOS Applications. All rights reserved.
//

#import "ViewController.h"
@import UserNotifications;
@import UserNotificationsUI;


@interface ViewController ()

- (void) createNotificationForCategory:(NSString*) categoryID withDelay:(int) secondsInTheFuture;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)scheduleFirstNotificationAction:(id)sender {
    
    [self createNotificationForCategory:@"UniqueCategoryID_1" withDelay: 5];
    
}

- (IBAction)scheduleSecondNotificationAction:(id)sender {
    
    [self createNotificationForCategory:@"UniqueCategoryID_2" withDelay: 5];
    
}


- (void) createNotificationForCategory:(NSString*) categoryID withDelay:(int) secondsInTheFuture {

    /*
     Creating a notification in UserNotificationCenter starts with creating the content of the notification
     using UNMutableNotificationContent. 
     
        .title      - The notification title that will appear in the notification center
        .subtitle   - The notification subtitle that will appear in the notification center
        .body       - The body of the notification that will appear in the notification center
        .badge      - The NSNumber to display on the App's icon
        .sound      - The sound to play with the notification, defaultSound is the user defined sound
        .categoryIdentifier - The identifier of the app-defined category object
     
     Other properties exist, check documentation for more details
     
     */
    
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"Notification Title"                 arguments:nil];
    content.subtitle = [NSString localizedUserNotificationStringForKey:@"Notification Subtitle"           arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:@"Notification body notification body" arguments:nil];
    content.badge = [NSNumber numberWithInteger:31415];
    content.sound = [UNNotificationSound defaultSound];
    content.categoryIdentifier = categoryID;
    
    
    /* 
    
     Once the content has been created, we define the trigger for the notifictaion. Notifications can be triggered several 
     different ways:
     
     UNTimeIntervalNotificationTrigger - Delivery of a local notification after the specified amount of time.
     UNCalendarNotificationTrigger - Delivery of a notification at the specified date and time.
     UNLocationNotificationTrigger - Delivery of a notification when the user reaches the specified geo-location.
     UNPushNotificationTrigger - Indicates that a delivered notification was sent using the Apple Push Notification Service.
     
     NOTE: UNPushNotificationTrigger is Apple's way to do remote notifications so 3rd party solutions such as Parse
     and Firebase are no longer needed.
     
     */

    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger    triggerWithTimeInterval:secondsInTheFuture    repeats:NO];
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"PushyApp_iOS10"    content:content    trigger:trigger];
    
    
    /* 
     
     The final step is to add the notification to the current UNUserNotificationCenter queue. 
     The completion handler gives us an opportunity to deal with errors when adding notifications to the queue.
     
     */
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"PushyApp_iOS10: UNUserNotificationCenter ERROR - %@", error);
            
        }
        
    }];
}

@end
