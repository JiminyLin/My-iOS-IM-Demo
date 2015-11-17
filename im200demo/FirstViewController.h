//
//  FirstViewController.h
//  im200demo
//
//  Created by LinGuangzhen on 15/10/26.
//  Copyright © 2015年 LinGuangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *connectionStatus;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (weak, nonatomic) IBOutlet UILabel *showDisplayName;
@property (weak, nonatomic) IBOutlet UITextView *allResultTV;

@property (weak, nonatomic) IBOutlet UITextField *nikenameTF;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTF;
@property (weak, nonatomic) IBOutlet UITextField *regionTF;
@property (weak, nonatomic) IBOutlet UITextField *signatureTF;
@property (weak, nonatomic) IBOutlet UISwitch *genderSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *showAvatarImage;

@end

