//
//  JMSGMsgViewController.h
//  im213demo
//
//  Created by LinGuangzhen on 16/7/5.
//  Copyright © 2016年 LinGuangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface JMSGMsgViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userTF;
@property (weak, nonatomic) IBOutlet UITextField *groupIdTF;
@property (weak, nonatomic) IBOutlet UITextField *appkeyTF;
@property (weak, nonatomic) IBOutlet UITextField *fileUrlTF;
@property (weak, nonatomic) IBOutlet UIImageView *fileImageTF;
@property(nonatomic, strong) CLLocationManager *currentLoaction;
@end
