//
//  ChangePasswordViewController.h
//  im200demo
//
//  Created by LinGuangzhen on 15/11/2.
//  Copyright © 2015年 LinGuangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *newsPassword;
@property (weak, nonatomic) IBOutlet UITextField *TF_user1;
@property (weak, nonatomic) IBOutlet UITextField *TF_user2;
@property (weak, nonatomic) IBOutlet UITextField *msgidV;

@property (weak, nonatomic) IBOutlet UITextField *TF_targetAppkey;
@property (weak, nonatomic) IBOutlet UITextView *TV_resultShow;

@end
