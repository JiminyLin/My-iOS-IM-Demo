//
//  SecondViewController.m
//  im200demo
//
//  Created by LinGuangzhen on 15/10/26.
//  Copyright © 2015年 LinGuangzhen. All rights reserved.
//

#import "SecondViewController.h"
#import <JMessage/JMessage.h>


@interface SecondViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,JMessageDelegate>
{
//    JMSGGroup *_myGroup;
    int sendGroupMsgTimesInt ;
    NSString *groupNameText,*groupIDTextStr,*groupMember2Text,*groupMemberText,*sendGroupMSGText,*groupDescText,*sendGroupMsgTimesStr,*curTime;
    NSString *messageDelegate;

//    NSArray* memberArray;
    
    
}
@property (nonatomic, retain)JMSGGroup *myGroup;
@property (nonatomic,retain)NSArray* memberArray;
@property(nonatomic,retain)JMSGConversation * groupConversation;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"-------进入了群聊 界面");

    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];

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
    [self.groupMember2TF resignFirstResponder];
    [self.groupMsgContentTF resignFirstResponder];
    [self.groupNameTF resignFirstResponder];
    [self.groupDecTF resignFirstResponder];
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
    NSLog(@"-----开始创建群:%@ ",groupNameText);

             [JMSGGroup createGroupWithName:groupNameText desc:groupDescText memberArray:_memberArray completionHandler:^(id resultObject, NSError *error) {
                if (error == nil) {
                    _myGroup = resultObject;

                    NSLog(@"-----成功创建群:%@ ,群描述：%@，群成员：%@！群id：%@,--resultObject: %@ ",groupNameText,groupDescText,_memberArray,_myGroup.gid,resultObject);
                    
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
    [self initTF];
    NSLog(@"----准备获取群成员，开始获取当前群的群信息！");
    [JMSGGroup groupInfoWithGroupId:groupIDTextStr completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"-----成功 获取群:%@ 的信息!群信息如下：%@，－－开始获取群成员！",groupIDTextStr,resultObject);
            _myGroup = resultObject;
            NSLog(@"--------获取群 %@ 成员成功，成员有：%@",_myGroup.gid,_myGroup.memberArray) ;
        }
        else{
            NSLog(@"-----获取 群:%@ 的信息 失败!error：%@,result: %@,----放弃获取群成员操作",groupIDTextStr,error,resultObject);
        }
    }];

                  }

- (IBAction)clickAddGroupMember:(id)sender {
    [self initTF];
    NSLog(@"-----准备为群:%@  添加成员",groupNameText);
    __weak SecondViewController *weakSelf = self;
    [self initTF];
    [JMSGGroup groupInfoWithGroupId:groupIDTextStr completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"-----成功 获取群:%@ 的信息!群信息如下：%@，－－－准备添加群成员！",groupIDTextStr,resultObject);
            _myGroup = resultObject;
                //得到——myGroup实例的值，开始添加群用户列表到某群
                [_myGroup addMembersWithUsernameArray:weakSelf.memberArray completionHandler:^(id resultObject, NSError *error) {
                    if (error == nil) {
                        NSLog(@"---------给群 %@ 添加群成员成功！成员：%@",weakSelf.myGroup.gid, weakSelf.memberArray);
                    }
                    else{
                        NSLog(@"------给群 %@ 添加群成员失败！成员：%@，-- error: %@ ,---result: %@",weakSelf.myGroup.gid,weakSelf.memberArray,error,resultObject);
                        
                    }
                }];
        }
        else{
            NSLog(@"-----获取 群:%@ 的信息 失败!error：%@,result: %@,----myGroup为空，放弃添加群用户请求",groupIDTextStr,error,resultObject);
        }
        
    }];
    
    
}

- (IBAction)clickDelGroupMember:(id)sender {
    [self initTF];

    [JMSGGroup groupInfoWithGroupId:groupIDTextStr completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"-----成功 获取群:%@ 的信息!群信息如下：%@，－－准备删除群成员！",groupIDTextStr,resultObject);
            _myGroup = resultObject;
            
            [_myGroup removeMembersWithUsernameArray:_memberArray completionHandler:^(id resultObject, NSError *error) {
                if (error == nil) {
                    NSLog(@"------给群 %@ 删除群成功！成员：%@",_myGroup.gid,_memberArray);
                }
                else{
                    NSLog(@"------给群 %@ 删除群成员：%@，-- error: %@ ,---result: %@",_myGroup.gid,_memberArray,error,resultObject);
                    
                }
            }];

        }
        else{
            NSLog(@"-----获取 群:%@ 的信息 失败!error：%@,result: %@，－－－放弃删除删除群成员动作！",groupIDTextStr,error,resultObject);
        }
        
    }];


}
- (IBAction)clickExitGroup:(id)sender {
    [self initTF];
    [JMSGGroup groupInfoWithGroupId:groupIDTextStr completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"-----成功 获取群:%@ 的信息!群信息如下：%@，－－－准备退群！",groupIDTextStr,resultObject);
            _myGroup = resultObject;
            //获取到群实例值，准备调用退群接口
            [_myGroup exit:^(id resultObject, NSError *error) {
                if (error == nil) {
                    NSLog(@"------退出群 %@ ",_myGroup.gid);
                }
                else{
                    NSLog(@"------退出群 %@ ，-- error: %@ ,---result: %@，－－－放弃退群动作！",_myGroup.gid,error,resultObject);
                }
            }];
        }
        else{
            NSLog(@"-----获取 群:%@ 的信息 失败!error：%@,result: %@",groupIDTextStr,error,resultObject);
        }
    }];
  
}

- (IBAction)clickSendGroupTextMsg:(id)sender {
    [self initTF];

    [JMSGConversation createGroupConversationWithGroupId:groupIDTextStr completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"------------与 %@的会话创建成功！error:%@ , result: %@ ",groupIDTextStr , error, resultObject);
            _groupConversation = resultObject;
            
            [JMessage removeAllDelegates];
            [JMessage addDelegate:self withConversation:nil];
            sendGroupMsgTimesInt = 1;


            for (int i =1; i <= sendGroupMsgTimesInt ; i++) {
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
            _groupConversation = resultObject;
            [JMessage removeAllDelegates];
            [JMessage addDelegate:self withConversation:nil];
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
- (IBAction)clickDelConversation:(id)sender {
    [self initTF];
    [JMSGConversation deleteGroupConversationWithGroupId:groupIDTextStr];
    NSLog(@"----删除群ID为 %@ 的会话",groupIDTextStr);

}
- (IBAction)clickGetSomeGidGroupConversation:(id)sender {
    [self initTF];
   NSString * getConversationForGid = [NSString stringWithFormat:@"%@", [JMSGConversation groupConversationWithGroupId:groupIDTextStr]];
    NSLog(@"------获取群 %@ 的会话:%@",groupIDTextStr,getConversationForGid);
    
}

-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    if (error !=nil) {
        NSLog(@"-------onReceiveMessage收到群消息,--error：%@,---message:%@",error,message);
        messageDelegate = [NSString stringWithFormat:@"%@",message];
        
    }
    NSLog(@"-----onReceiveMessage收到群消息：%@",message);
}

-(void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    if (error !=nil) {
        NSLog(@"-------onSendMessageResponse发群消息,--error：%@,---message:%@",error,message);
    }
    NSLog(@"-----onSendMessageResponse发送群消息：%@",message);
}

-(void)onReceiveMessageDownloadFailed:(JMSGMessage *)message{
  
        NSLog(@"-------onReceiveMessageDownloadFailed收到群消息下载失败,----message:%@",message);
}

-(void)onGroupInfoChanged:(JMSGGroup *)group{
    NSLog(@"-------onGroupInfoChanged:%@",group);
}

-(void)onConversationChanged:(JMSGConversation *)conversation{
    NSLog(@"-------onConversationChanged:%@",conversation);
}

-(void)onUnreadChanged:(NSUInteger)newCount{
    NSLog(@"-------onUnreadChanged:%ld",newCount);

}

-(void)onLoginUserKicked{
    NSLog(@"-------onLoginUserKicked");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
