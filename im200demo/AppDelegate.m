//
//  AppDelegate.m
//  im200demo
//
//  Created by LinGuangzhen on 15/10/26.
//  Copyright © 2015年 LinGuangzhen. All rights reserved.
//

#import "AppDelegate.h"
#import <JMessage/JMessage.h>
#import <AdSupport/AdSupport.h>
<<<<<<< HEAD
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

=======
>>>>>>> 74e9421649647b162dda870da3e7c6b8d672ebc2


@interface AppDelegate () <JMessageDelegate>
@property (strong,nonatomic) JMSGUser *myJMSGUser;
@property(strong,nonatomic)JMSGConversation * myJMSGConversation;
<<<<<<< HEAD
@property (nonatomic, strong) UNUserNotificationCenter *center;
=======

>>>>>>> 74e9421649647b162dda870da3e7c6b8d672ebc2

@end

@implementation AppDelegate

NSArray *_delegateCovList;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString * appkey = @"";
<<<<<<< HEAD
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"--------IDFA:%@",advertisingId);
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
    //apple注册apns新方法！
    _center = [UNUserNotificationCenter currentNotificationCenter];
    [_center requestAuthorizationWithOptions:(UNAuthorizationOptionSound|UNAuthorizationOptionAlert|UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }];
        _center.delegate = self;

    }
=======

    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
  
>>>>>>> 74e9421649647b162dda870da3e7c6b8d672ebc2
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
        
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
<<<<<<< HEAD
    [JPUSHService setupWithOption:launchOptions appKey:appkey
                          channel:@"lingz im 213channel"
                 apsForProduction:NO
            advertisingIdentifier:advertisingId];
    
//    [JMSGUser loginWithUsername:@"qpt12" password:@"qpt12" completionHandler:^(id resultObject, NSError *error) {
//        if (error ==nil) {
//            NSLog(@"-------登录用户成功！");
//        }else{
//            NSLog(@"-------登录用户失败！%@",error);
//        }
//        
//        //通过这个这个实例化的JMSGUser对象去获取当前登录用户的头像的缩略图
//    }];
    
        [JMessage addDelegate:self  withConversation:nil];
        [JMessage setupJMessage:launchOptions appKey:appkey channel:@"lingz im 213channel" apsForProduction:YES category:nil];//98f67476b10c3bf6690559a9 228a71eadccde93549bbf5c4 8a06e1d67fd00b0423ffff6d 4f7aef34fb361292c566a1cd




    
//    [JMessage  setIsGlobalNoDisturb:YES handler:^(id resultObject, NSError *error) {
=======
    
//    [JPUSHService setupWithOption:launchOptions appKey:appkey
//                          channel:@"im 213channel"
//                 apsForProduction:NO
//            advertisingIdentifier:advertisingId];
    [JMessage addDelegate:self  withConversation:nil];

    [JMessage setupJMessage:launchOptions appKey:appkey channel:@"im 213channel" apsForProduction:YES category:nil];///    [JMessage  setIsGlobalNoDisturb:YES handler:^(id resultObject, NSError *error) {
>>>>>>> 74e9421649647b162dda870da3e7c6b8d672ebc2
//        if (error != nil){
//            NSLog(@"------set setIsGlobalNoDisturb:YES  fail:%@ ",error);
//            return ;
//        }
//        NSLog(@"-------set setIsGlobalNoDisturb:YES  pass ");
//        
//    }
//     ];
    if(application.applicationState == UIApplicationStateInactive) {}
//    [JMessage setLogOFF ];
    [JPUSHService crashLogON];
//      [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [self registerNotificationCenter];
    [JPUSHService setDebugMode];

    return YES;
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}


- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

- (void)registerNotificationCenter {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];

    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(receivePushMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];

<<<<<<< HEAD
}


- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"－已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"－未连接");
    [self showAlert:@"JPush长连接 未连接！"];
=======
>>>>>>> 74e9421649647b162dda870da3e7c6b8d672ebc2
    
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    
    NSLog(@"－已注册");
    
}
- (void)networkDidLogin:(NSNotification *)notification {
    
    NSLog(@"－已登录");
    NSLog(@"－get RegistrationID: %@",[JPUSHService registrationID]);
    NSString * loginText =[ NSString stringWithFormat:@"－JPush 已登录！rid: %@",[JPUSHService registrationID]];
    [self showAlert:loginText];

}

- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"－已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"－未连接");
    [self showAlert:@"JPush长连接 未连接！"];
    
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    
    NSLog(@"－已注册");
    
}
- (void)networkDidLogin:(NSNotification *)notification {
    
    NSLog(@"－已登录");
    NSLog(@"－get RegistrationID: %@",[JPUSHService registrationID]);
    NSString * loginText =[ NSString stringWithFormat:@"－JPush 已登录！rid: %@",[JPUSHService registrationID]];
    [self showAlert:loginText];

}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"----TOken:%@",deviceToken);
}
//- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    NSDictionary *userInfo = [notification userInfo];
//    NSLog(@"---自定义消息：%@",userInfo);
//}

- (void)receivePushMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *currentContent = [NSString
                                stringWithFormat:
                                @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
                                [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                               dateStyle:NSDateFormatterNoStyle
                                                               timeStyle:NSDateFormatterMediumStyle],
                                title, content, extra];
    NSLog(@"-----自定义消息-----%@", userInfo);

    [JPUSHService handleRemoteNotification:userInfo];

}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required - 处理收到的通知
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"---iOS6后收到通知：%@",userInfo);

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"--- >＝iOS7系统后收到通知：%@",userInfo);
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        if (error != nil) {
<<<<<<< HEAD
            NSLog(@"\n－－applicationWillResignActive当前登录用户所有会话获取出错！\n error:%@ ,resultObject:%@",error,resultObject);
=======
            NSLog(@"\n－－applicationWillResignActive当前登录用户会话获取出错！\n error:%@ ,resultObject:%@",error,resultObject);
>>>>>>> 74e9421649647b162dda870da3e7c6b8d672ebc2
            return ;
        }
        int AllCovUnReadCount = 0;
        _delegateCovList = resultObject;
        for (int i =0; i< _delegateCovList.count; i++) {
            _myJMSGConversation = _delegateCovList[i];
<<<<<<< HEAD
            
            JMSGMessage *convLatestMessage  = _myJMSGConversation.latestMessage;
            
            if(convLatestMessage.contentType == kJMSGContentTypeEventNotification){
                JMSGEventContent *eventContent = (JMSGEventContent *)convLatestMessage.content;
                //获取发起事件的用户名
                NSString *fromUsername = [eventContent getEventFromUsername];
                //获取事件作用对象用户名列表
                NSArray *toUsernameList = [eventContent getEventToUsernameList];
                
                //根据事件类型，定制相应描述（以事件类型: 添加新成员为例子）
                long eventType = eventContent.eventType;
                NSLog(@"－－第 %d个会话－\n eventType:%ld,\nfromUsername：%@,\ntoUsernameList:%@",i,eventType,fromUsername,toUsernameList);
                
                switch(eventType)
                {
                    case 8:
                        NSLog(@"--%@", [NSString stringWithFormat:@"[%@]创建了群，群成员有:%@",fromUsername,[toUsernameList componentsJoinedByString:@","]]);
                        
                        break;
                        
                    case 9:
                        NSLog(@"--%@", [NSString stringWithFormat:@"[%@]退出了群",fromUsername]);
                        
                        break;
                        
                    case 10:
                        NSLog(@"--%@",[NSString stringWithFormat:@"[%@ ]邀请了［%@］进群",fromUsername,[toUsernameList componentsJoinedByString:@","]]);
                        
                        break;
                        
                    case 11:
                        NSLog(@"--%@", [NSString stringWithFormat:@"[%@ ]把［%@］移出了群",fromUsername,[toUsernameList componentsJoinedByString:@","]]);
                        
                        break;
                        
                    case 12:
                        NSLog(@"--%@", [NSString stringWithFormat:@"[%@ ]更新了群信息",fromUsername]);
                        
                        break;
                        
                    default:
                        NSLog(@"--%@", [NSString stringWithFormat:@"未知群事件：%ld",eventType]);
                        
                }
                return;
            }

            
            int covUnreadCount = [_myJMSGConversation.unreadCount intValue];
            NSLog(@"---------delegateCovList[%d],{\n未读数：%d，具体：\n:%@\n}",i,covUnreadCount,_myJMSGConversation);
            NSLog(@"---------delegateCovList[%d],{\n最新一条消息:%@\n}",i,_myJMSGConversation.latestMessage);

=======
            int covUnreadCount = [_myJMSGConversation.unreadCount intValue];
            NSLog(@"---------delegateCovList[%d],{\n未读数：%d，具体：\n:%@\n}",i,covUnreadCount,_myJMSGConversation);
            
>>>>>>> 74e9421649647b162dda870da3e7c6b8d672ebc2
            AllCovUnReadCount = AllCovUnReadCount + covUnreadCount ;
            
        }
        [JPUSHService setBadge:AllCovUnReadCount];
        
        NSLog(@"-------所有会话的未读数共\n：%d",AllCovUnReadCount);
        [application setApplicationIconBadgeNumber:AllCovUnReadCount];
        
    }];
    
    NSLog(@"－－－－－－－－－－applicationWillResignActive");
//    int badge =10;
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge-1];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    [JPUSHService setBadge:0];
    
    NSLog(@"－－－－－－－－－－applicationDidEnterBackground");

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"－－－－－－－－－－applicationWillEnterForeground");

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"－－－－－－－－－－applicationDidBecomeActive");
    
//    UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories: nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
//    NSLog(@"--clickGetMyInfo--再次注册apns！");

    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"－－－－－－－－－－applicationWillTerminate");

}

@end
