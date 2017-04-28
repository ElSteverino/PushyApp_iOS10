//
//  AppDelegate.m
//  PushyApp_iOS10
//
//  Created by quattro on 4/25/17.
//  Copyright © 2017 Coursera Networking and Security in iOS Applications. All rights reserved.
//

#import "AppDelegate.h"
@import UserNotifications;


@interface AppDelegate ()

-(void) requestPermissionToNotify;
-(void) displayAlertWithTitle:(NSString*) title message:(NSString*) message actionTitle:(NSString*) actionTitle;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    /*
     
     To receive notifications, our AppDelegate must conform to the UNUserNotificationCenterDelegate protocol.
     This must be done in application:willFinishLaunchingWithOptions:  OR  application:didFinishLaunchingWithOptions:
     
     The AppDelegate must also implement the two delegate handlers:
     
        userNotificationCenter:willPresentNotification:withCompletionHandler
     
     AND
     
        userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler
     
     */
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
 
    [self requestPermissionToNotify];

    return YES;
    
}


- (void) applicationDidBecomeActive:(UIApplication *)application {
    
    /*
     
     ApplicationDidBecomeActive is called when our app is brought to the foreground either from a stopped (non running)
     state or and background (idle) state.  This is where we check to see if any notifications were delivered while
     we were in a non-foreground state. This handles the case when we click on our App's icon while there
     are delivered notifications in the notification center.
     
     */
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        
        if ( requests.count ) {
            [self displayAlertWithTitle:@"Alert" message:@"Notification received,\nApp in background or stopped,\nLaunched from home or lock screen" actionTitle:@"OK"];
        }
    }];
    
    application.applicationIconBadgeNumber = 0;

}


- (void) requestPermissionToNotify {

    /*
     
     Anytime we need to reference the UserNotificationCenter, we must use currentNotificationCenter to get
     the singleton user notification center object for the app or app extension. We should never try to 
     create instances of the UNUserNotificationCenter class on our own.
     
     Apple recommends that requestAuthorizationWithOptions early in the App's lifecycle, which is why I am 
     doing this in the AppDelegate instead of the ViewController. 
     
     As a side note, some Apps request permission for notifications, the camera, GPS, etc, letting iOS do
     all the work. The iOS App HeartWatch does an exceptionally good job requesting permissions. It goes
     through a series of storyboards, each explaining the permission they are requesting and the reasons why.
     IMHO, from a user's perspective, this is much better than an App which leaves you wondering why it
     needs permission to use the microphone or GPS.
     
     */
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];

    /*
     
     We define Action Notifications for the UNUserNotificationCenter currentNotificationCenter with
     instances of UNNotificationAction.
     
     A UNNotificationAction object represents a task that your app can perform in response to a delivered 
     notification. You can define custom actions for each type of notification that your app supports. 
     The action object itself contains information about how to display that action onscreen. When the user 
     selects that action, the system forwards the action’s identifier string to your app so that you can 
     perform the corresponding task.
     
     Always create instances of this class using the actionWithIdentifier:title:options: method. After 
     creating action objects, associate them with a UNNotificationCategory object to define your app’s 
     notification types. A notification can display up to four actions onscreen at once, and in some 
     cases may display only two of those actions.
     
     A UNNotificationCategory object defines a type of notification that your executable can receive. 
     You use category objects to implement actionable notifications—that is, notifications that have 
     action buttons that the user can select in response to the notification. Each category object you 
     create stores the actions and other behaviors associated with a specific type of notification.
     
     You create category objects using the categoryWithIdentifier:actions:intentIdentifiers:options: method 
     and register them using the singleton UNUserNotificationCenter object early in your executable’s life 
     cycle. You can register as many category objects as you want.
     
     */
    
    
    UNNotificationAction *firstAction = [UNNotificationAction actionWithIdentifier:@"FirstNotificationActionID" title:@"First Action Title" options:UNNotificationActionOptionForeground];
    
    UNNotificationAction *secondAction = [UNNotificationAction actionWithIdentifier:@"SecondNotificationActionID" title:@"Second Action Title" options:UNNotificationActionOptionDestructive];
    
    UNNotificationCategory *category1 = [UNNotificationCategory categoryWithIdentifier:@"UniqueCategoryID_1"
                                                                               actions:@[firstAction, secondAction]
                                                                     intentIdentifiers:@[]
                                                                               options:UNNotificationCategoryOptionCustomDismissAction];
    
    [center setNotificationCategories:[NSSet setWithArray:@[category1]]];

    UNNotificationAction *kiloByteAction = [UNNotificationAction actionWithIdentifier:@"kiloByteActionID" title:@"Kilobytes" options:UNNotificationActionOptionForeground];
    
    UNNotificationAction *megaByteAction = [UNNotificationAction actionWithIdentifier:@"megaByteActionID" title:@"Megabytes" options:UNNotificationActionOptionForeground];
    
    UNNotificationAction *gigaByteAction = [UNNotificationAction actionWithIdentifier:@"gigaByteActionID" title:@"Gigabytes" options:UNNotificationActionOptionForeground];
    
    UNNotificationAction *actualAction = [UNNotificationAction actionWithIdentifier:@"actualActionID" title:@"Actual Size" options:UNNotificationActionOptionDestructive];
    
    UNNotificationCategory *category2 = [UNNotificationCategory categoryWithIdentifier:@"UniqueCategoryID_2"
                                                                               actions:@[kiloByteAction, megaByteAction, gigaByteAction, actualAction]
                                                                     intentIdentifiers:@[]
                                                                               options:UNNotificationCategoryOptionCustomDismissAction];
    
    [center setNotificationCategories:[NSSet setWithArray:@[category1, category2]]];

    
    /* 
     
     Request authorization to interact with the user when local and remote notifications arrive.
     
     If the local or remote notifications of your app or app extension interact with the user in any way, 
     you must call this method to request authorization for those interactions. The first time your app 
     ever calls the method, the system prompts the user to authorize the requested options. The user may 
     respond by granting or denying authorization, and the system stores the user’s response so that 
     subsequent calls to this method do not prompt the user again. The user may change the allowed 
     interactions at any time. Use the getNotificationSettingsWithCompletionHandler: method to determine 
     what your app is allowed to do.
     
     */
    
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge )
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              // Enable or disable features based on authorization.
                          }];
    
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {

    /*
     
     userNotificationCenter:willPresentNotification:withCompletionHandler
     
     This is a UNUserNotificationCenterDelegate callback to handle notifications being received while the
     the App is in the foreground.  The completion handler MUST be called with the desired notification 
     options. Options include:
     
     UNNotificationPresentationOptionNone   - Do not present a notification
     UNNotificationPresentationOptionSound  - Play the notification sound
     UNNotificationPresentationOptionAlert  - Display a visual notification on screen and add the the notification center
     UNNotificationPresentationOptionBadge  - Update the app icon's badge count (not needed for notifications in the foreground)
     
     */

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    completionHandler(UNNotificationPresentationOptionSound);
    [self displayAlertWithTitle:@"Alert" message:@"Notification received,\nApp in foreground" actionTitle:@"OK"];

}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {

    /*
     
     userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:
     
     Called to let your app know which action was selected by the user for a given notification for
     notifications received whil the App was NOT in the foreground.
     
     Use this method to perform the tasks associated with your app’s custom actions. When the user 
     responds to a notification, the system calls this method with the results. You use this method 
     to perform the task associated with that action, if at all. 
     
     The App may have multiple notification categories, that we may choose to handle individually. 
     For example, our App may notifiy the user that a new message has arrived, that notification may 
     have actions to 'Respond' or 'Delete'. The App may also send another type of notification to the 
     user reminding them of a task with actions to 'Complete', 'Ignore', or 'Snooze'
     
     For those actions, we can rely on the repsonse.actionIdentifier as the identifier can be made 
     unique across all actions.
     
     However, we may not always be able to rely on the actionIdentifier in all cases. When the user clicks 
     on a notification card, the response is either UNNotificationDefaultActionIdentifier or 
     UNNotificationDismissActionIdentifier. In this case, we need to check the unique categoryIdentifier
     to pair up the default or dismissed action to the intended notification.
     
     At the end of of the implementation, the completionHandler must be called to let the system know 
     that processing for the notification is complete.
 
     */
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSString *message;

    // Initialize the alert string based on the categoryIdentifier
    if ( [response.notification.request.content.categoryIdentifier isEqualToString:@"UniqueCategoryID_1"] ) {
        
        message = @"Notification received,\nApp in background or stopped,\nCategory 1, %@";
        
    } else if ( [response.notification.request.content.categoryIdentifier isEqualToString:@"UniqueCategoryID_2"] ) {
        
        message = @"Notification received,\nApp in background or stopped,\nCategory 2, %@";
        
    } else {
        
        message = @"Notification received,\nApp in background or stopped,\nUnknown Category, %@";
        
    }
    
    
    /*
     
     The exhaustive if statement to pair the response.actionIdentifier with the App's actions. 
     For demonstration purposes we simply display an Alert. In a real world sceniaro, this would 
     call methods to manipulate data, whatever.
     
     */
    
    if ( [response.actionIdentifier isEqualToString: UNNotificationDefaultActionIdentifier] ) {
        // Default action taken
        [self displayAlertWithTitle:@"Alert"
                            message:[NSString stringWithFormat:message, @"Default Action"]
                        actionTitle:@"OK"];
    } else if ( [response.actionIdentifier isEqualToString: UNNotificationDismissActionIdentifier] ) {
        // User dismissed the notification
        [self displayAlertWithTitle:@"Alert"
                            message:[NSString stringWithFormat:message, @"Dismissed Action"]
                        actionTitle:@"OK"];
    } else if ( [response.actionIdentifier isEqualToString: @"kiloByteActionID"] ) {
        [self displayAlertWithTitle:@"Alert"
                            message:[NSString stringWithFormat:message, @"Kilobyte Action"]
                        actionTitle:@"OK"];
    } else if ( [response.actionIdentifier isEqualToString: @"megaByteActionID"] ) {
        [self displayAlertWithTitle:@"Alert"
                            message:[NSString stringWithFormat:message, @"Megabyte Action"]
                        actionTitle:@"OK"];
    } else if ( [response.actionIdentifier isEqualToString: @"gigaByteActionID"] ) {
        [self displayAlertWithTitle:@"Alert"
                            message:[NSString stringWithFormat:message, @"Gigabyte Action"]
                        actionTitle:@"OK"];
    } else if ( [response.actionIdentifier isEqualToString: @"deleteActionID"] ) {
        [self displayAlertWithTitle:@"Alert"
                            message:[NSString stringWithFormat:message, @"Actual Size Action"]
                        actionTitle:@"OK"];
    } else if ( [response.actionIdentifier isEqualToString: @"FirstNotificationActionID"] ) {
        [self displayAlertWithTitle:@"Alert"
                            message:[NSString stringWithFormat:message, @"FirstNotificationActionID"]
                        actionTitle:@"OK"];
    } else if ( [response.actionIdentifier isEqualToString: @"SecondNotificationActionID"] ) {
        [self displayAlertWithTitle:@"Alert"
                            message:[NSString stringWithFormat:message, @"SecondNotificationActionID"]
                        actionTitle:@"OK"];
    } else {
        [self displayAlertWithTitle:@"Alert"
                            message:[NSString stringWithFormat:message, @"Undefined Action"]
                        actionTitle:@"OK"];
    }

    // The completionHandler must be called before the method ends
    completionHandler( );
    
}


-(void) displayAlertWithTitle:(NSString*) title message:(NSString*) message actionTitle:(NSString*) actionTitle {

    /*
    
     displayAlertWithTitle:(NSString*) title message:(NSString*) message actionTitle:(NSString*) actionTitle
    
     Simple helper method to display an alert on the main queue
     
    */
    
    UIApplication *application = [UIApplication sharedApplication];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionTitle
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil];

    [alertController addAction:alertAction];

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [application.keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        
    });
    
}


@end

