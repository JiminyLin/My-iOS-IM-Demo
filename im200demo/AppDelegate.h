//
//  AppDelegate.h
//  im200demo
//
//  Created by LinGuangzhen on 15/10/26.
//  Copyright © 2015年 LinGuangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
//@interface AppDelegate : UIResponder <UIApplicationDelegate>
@interface AppDelegate : NSObject<UIApplicationDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) UIWindow *window;


@end

