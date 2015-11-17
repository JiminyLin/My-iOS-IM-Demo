//
//  ChangePasswordViewController.m
//  im200demo
//
//  Created by LinGuangzhen on 15/11/2.
//  Copyright © 2015年 LinGuangzhen. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import <JMessage/JMessage.h>

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad]; //隐藏键盘，star
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    //隐藏键盘，end
}

//指定要隐藏键盘的控件
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.oldPassword resignFirstResponder];
    [self.newsPassword resignFirstResponder];
}
- (IBAction)clickChangePassword:(id)sender {
    self.oldPassword.enabled =YES;
    NSString *oldPsw = self.oldPassword.text;
    
    self.newsPassword.enabled =YES;
    NSString *newsPsw = self.newsPassword.text;
    
    [JMSGUser  updateMyPasswordWithNewPassword:newsPsw oldPassword:oldPsw completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"-----修改密码成功！－－旧密码：%@，－－新密码：%@",oldPsw,newsPsw);
        }
        else{
            NSLog(@"-----修改密码失败！－－旧密码：%@，－－新密码：%@，－－error：%@，－－result：%@",oldPsw,newsPsw,error,resultObject);

        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
