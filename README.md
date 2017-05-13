This is an iOS 10 version of the Week 3 demo app presented by DJP3 in the Coursera course Networking and Security in iOS Applications.

Notifications have changed between when the course was filmed and now (iOS 10), this is my implementation of DJP3's PushyApp which has been updated for iOS 10 using the new User Notification Framework.  I have tried to document the code to explain how I understand the new system works. 

To get started, first the UserNotification and UserNotificationUI frameworks need to be added to the project and imported into theViewController.m and AppDelegate.m files. 

In iOS 10, the methods application:didReceiveLocalNotification: and application:handleActionWithIdentifier:forLocalNotification:completionHandler: have been depreciated and are no longer used. DJP3's example uses the method application:didReceiveLocalNotification: to handle notifications received while in the foreground and the method application:didFinishLaunchingWithOptions: to check the UIApplicationLaunchOptionsLocalNotificationKey to see if the App moved to the foreground as a result of a notification. This is depreciated in iOS 10.  

Instead, notifications are handled by implementing the UNUserNotificationCenterDelegate protocol with two call backs.

userNotificationCenter:willPresentNotification:withCompletionHandler: handles notifications received while the App is in the foreground.
 
userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: handles notifications received while the App is in the background. 

To handle the scenario where a notification has been delivered and the user opens the App from the home screen, the app checks if there have been delivered notifications that are still in the notification center. The App does that when it switches to the foreground using the applicationDidBecomeActive: method in AppDelegate.m

This demonstration implements Action Notifications for two different UNNotificationCategory categories.  The first UI button schedules a notification 15 seconds in the future for UniqueCategoryID_1 with two notification actions, the second button does the same for UniqueCategoryID_2 with four notification actions. When the notifications arrive in the notification center, the user can swipe down to reveal the actions.  

Notification actions are handled by the userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: method. The specific notification action is found in the response.actionIdentifier property.  In some cases the App may need to know the categoryIdentifier of the notification being responded to, that information is found in the property response.notification.request.content.categoryIdentifier (although, there may be a better way to get a notification's categoryIdentifier, not sure). 

Apple has an excellent WWDC 2016 video that covers the new notification system.

https://developer.apple.com/videos/play/wwdc2016/707/
https://developer.apple.com/reference/usernotifications/unusernotificationcenter

Cheers,
Steve
