//
//  SecondViewController.m
//  im200demo
//
//  Created by LinGuangzhen on 15/10/26.
//  Copyright © 2015年 LinGuangzhen. All rights reserved.
//

#import "SecondViewController.h"
#import <JMessage/JMessage.h>


@interface SecondViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
//    JMSGGroup *_myGroup;
    int sendGroupMsgTimesInt ;
    NSString *groupNameText,*groupIDTextStr,*groupMember2Text,*groupMemberText,*sendGroupMSGText,*groupDescText,*sendGroupMsgTimesStr,*curTime;

//    NSArray* memberArray;
    
    
}
@property (nonatomic, retain)JMSGGroup *myGroup;
@property (nonatomic,retain)NSArray* memberArray;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏键盘，star
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    //隐藏键盘，end
}

//指定要隐藏键盘的控件
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.sendGroupMsgTimesTF resignFirstResponder];
    [self.groupID_TF resignFirstResponder];
    [self.groupMemberTF resignFirstResponder];
    [self.groupMsgContentTF resignFirstResponder];
    [self.groupNameTF resignFirstResponder];
}
-(void)initTF{
    self.groupNameTF.enabled=YES;
    groupNameText = self.groupNameTF.text;

    self.groupID_TF.enabled = YES;
    groupIDTextStr= self.groupID_TF.text;
    
    self.groupMemberTF.enabled =YES;
    groupMemberText = self.groupMemberTF.text;
    
    self.groupMember2TF.enabled =YES;
    groupMember2Text = self.groupMember2TF.text;
    
    _memberArray = [[NSArray alloc] initWithObjects:
                            groupMemberText,groupMember2Text,nil];
    
    self.groupMsgContentTF.enabled = YES;
    sendGroupMSGText = self.groupMsgContentTF.text;
    
    self.groupDecTF.enabled=YES;
    groupDescText = self.groupDecTF.text;
    
    self.sendGroupMsgTimesTF.enabled = YES;
    sendGroupMsgTimesStr = self.sendGroupMsgTimesTF.text;
    sendGroupMsgTimesInt = [sendGroupMsgTimesStr intValue];
}
-(void)curTimeValue{
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy年MM月dd日 HH小时mm分ss秒"];
    curTime = [df stringFromDate:currentDate];
    
    //    NSLog(@"系统当前时间为：%@",curTime);
}
- (IBAction)clickCreateGroup:(id)sender {
    [self initTF];
    
             [JMSGGroup createGroupWithName:groupNameText desc:groupDescText memberArray:_memberArray completionHandler:^(id resultObject, NSError *error) {
                if (error == nil) {
                    _myGroup = resultObject;

                    NSLog(@"-----成功创建群:%@ ,群描述：%@，群成员：%@！群id：%@",groupNameText,groupDescText,_memberArray,_myGroup.gid);
                    
                }
                else{
                    NSLog(@"-----创建群：%@ 失败！---error ：%@,---Result: %@",groupNameText,error,resultObject);
                }
            }];

   
    
}
- (IBAction)clickUpdateGroupInfo:(id)sender {
    [self initTF];
    [JMSGGroup updateGroupInfoWithGroupId:groupIDTextStr name:groupNameText desc:groupDescText completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"-----成功更新群:%@ 的信息!更新的群描述：%@！",groupNameText,groupDescText);
        }
        else{
            NSLog(@"-----更新群:%@ 的信息 失败!更新的群描述：%@！---error：%@,----result: %@",groupNameText,groupDescText,error,resultObject);
        }
    }];
  }
- (IBAction)clickGetGroupInfo:(id)sender {
    [self getGroupInfo];
  
}
-(void)getGroupInfo{
    [self initTF];
    [JMSGGroup groupInfoWithGroupId:groupIDTextStr completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"-----成功 获取群:%@ 的信息!群信息如下：%@",groupIDTextStr,resultObject);
            _myGroup = resultObject;
        }
        else{
            NSLog(@"-----获取 群:%@ 的信息 失败!error：%@,result: %@",groupIDTextStr,error,resultObject);
        }
        
    }];
}
- (IBAction)clickGetGroupMember:(id)sender {
    [self getGroupInfo];
    NSLog(@"--------获取群 %@ 成员成功，成员有：%@",_myGroup.gid,_myGroup.memberArray) ;
}
- (IBAction)clickAddGroupMember:(id)sender {
    [self initTF];
    
    __weak SecondViewController *weakSelf = self;
    [_myGroup addMembersWithUsernameArray:weakSelf.memberArray completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
//            NSLog(@"------给群 ％@ 添加群成员：%@",self.myGroup.gid, memberArray);
            NSLog(@"---------给群 %@ 添加群成员成功！成员：%@",weakSelf.myGroup.gid, weakSelf.memberArray);
        }
        else{
            NSLog(@"------给群 %@ 添加群成员失败！成员：%@，-- error: %@ ,---result: %@",weakSelf.myGroup.gid,weakSelf.memberArray,error,resultObject);
            
        }
    }];
    
}

- (IBAction)clickDelGroupMember:(id)sender {
    [self initTF];
    [self getGroupInfo];

    [_myGroup removeMembersWithUsernameArray:_memberArray completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"------给群 %@ 删除群成功！成员：%@",_myGroup.gid,_memberArray);
        }
        else{
            NSLog(@"------给群 %@ 删除群成员：%@，-- error: %@ ,---result: %@",_myGroup.gid,_memberArray,error,resultObject);

        }
    }];
    
}
- (IBAction)clickExitGroup:(id)sender {

    [self initTF];
    [self getGroupInfo];

    [_myGroup exit:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"------退出群 %@ ",_myGroup.gid);
        }
        else{
            NSLog(@"------退出群 %@ ，-- error: %@ ,---result: %@",_myGroup.gid,error,resultObject);
        }
    }];
}

- (IBAction)clickSendGroupTextMsg:(id)sender {
    sendGroupMsgTimesInt = 1;
    [self initTF];

    [JMSGConversation createGroupConversationWithGroupId:groupIDTextStr completionHandler:^(id resultObject, NSError *error) {
        [self initTF];
        if (error == nil) {
            NSLog(@"------------与 %@的会话创建成功！",groupIDTextStr );

            for (int i =1; i<=sendGroupMsgTimesInt; i++) {
                [self curTimeValue];
                NSString *sendContent = [NSString stringWithFormat:@"%@:－－%d－－%@ - %@",groupIDTextStr,i,sendGroupMSGText,curTime];
                NSLog(@"-----------------sendContent:%@",sendContent);
                
                [JMSGMessage sendGroupTextMessage:sendContent toGroup:groupIDTextStr  ];
            }
        
        }
        else{
            NSLog(@"------------与 %@的会话创建失败！error ： %@ ,Result: %@",groupIDTextStr,error,resultObject );
           
        }
    
    }];

}


//调用相册
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    sendGroupMsgTimesInt =1;
    //先把图片转成NSData（注意图片的格式）
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *picData = UIImagePNGRepresentation(image);;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self initTF];

    [JMSGConversation createGroupConversationWithGroupId:groupIDTextStr completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            [self initTF];
            NSLog(@"------------与 %@的会话创建成功！",groupIDTextStr );

            for (int i =1; i<=sendGroupMsgTimesInt; i++) {
                [self curTimeValue];
                NSString *sendContent = [NSString stringWithFormat:@"%@: －－%d－－%@ - %@",groupIDTextStr,i,sendGroupMSGText,curTime];
                NSLog(@"-----------------sendContent:%@",sendContent);
                [JMSGMessage sendGroupImageMessage:picData toGroup:groupIDTextStr];            }
            
        }
        else{
            NSLog(@"------------与 %@的会话创建失败！error ： %@ ,Result: %@",groupIDTextStr,error,resultObject );

        }
        
    }];

}

- (IBAction)clickSendGroupImageMsg:(id)sender {
    UIImagePickerController *imgController = [[UIImagePickerController alloc]init];
    imgController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgController.delegate = self;
    [self presentViewController:imgController animated:YES completion:NULL];
    return;
}
- (IBAction)clickSendGroupVoice:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
