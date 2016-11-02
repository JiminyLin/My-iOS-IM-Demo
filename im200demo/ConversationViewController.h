//
//  ConversationViewController.h
//  im200demo
//
//  Created by LinGuangzhen on 15/11/6.
//  Copyright © 2015年 LinGuangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ConversationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *covUser;
@property (weak, nonatomic) IBOutlet UITextField *covGroupID;
@property (weak, nonatomic) IBOutlet UITextField *covJMsgID;
@property (weak, nonatomic) IBOutlet UITextField *covOffSet;
@property (weak, nonatomic) IBOutlet UITextField *covLimit;
@property (weak, nonatomic) IBOutlet UILabel *covUnreadCountLB;
@property(nonatomic, strong) CLLocationManager *currentLoaction;

@end
