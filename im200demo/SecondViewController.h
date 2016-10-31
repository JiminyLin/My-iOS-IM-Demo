//
//  SecondViewController.h
//  im200demo
//
//  Created by LinGuangzhen on 15/10/26.
//  Copyright © 2015年 LinGuangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *groupNameTF;
@property (weak, nonatomic) IBOutlet UITextField *groupID_TF;
@property (weak, nonatomic) IBOutlet UITextField *groupMemberTF;
@property (weak, nonatomic) IBOutlet UITextField *groupMsgContentTF;
@property (weak, nonatomic) IBOutlet UITextField *sendGroupMsgTimesTF;

@property (weak, nonatomic) IBOutlet UITextField *groupDecTF;

@property (weak, nonatomic) IBOutlet UILabel *groupDisplayNameLb;

@end

