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
    int i;
    NSString *groupNameText,*groupIDTextStr,*groupMember2Text,*groupMemberText,*sendGroupMSGText,*groupDescText,*sendGroupMsgTimesStr,*curTime;
    NSString *messageDelegate;
    
    NSString * alertText;
    NSData *picData;
//    NSArray* memberArray;
    
    
}
@property (nonatomic, retain)JMSGGroup *myGroup;
@property (nonatomic,retain)NSArray* memberArray;
@property(nonatomic,retain)JMSGConversation * groupConversation;
@property(strong,nonatomic)    UITextView *covAllShowTV;
@property (strong,nonatomic)JMSGMessage *groupJMSGMessage;
@property (strong,nonatomic)JMSGImageContent *groupJMSGImageContent;
@property (nonatomic, strong) JMSGMessage * message;
@property (nonatomic, strong) NSTimer * timer;


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
    
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    //隐藏键盘，end
    _covAllShowTV = [[UITextView alloc] initWithFrame: CGRectMake(0, 260, 320, 140) ];
    [self.view addSubview:_covAllShowTV];

}

//指定要隐藏键盘的控件
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.sendGroupMsgTimesTF resignFirstResponder];
    [self.groupID_TF resignFirstResponder];
    [self.groupMemberTF resignFirstResponder];
    [self.groupMsgContentTF resignFirstResponder];
    [self.groupNameTF resignFirstResponder];
    [self.groupDecTF resignFirstResponder];
}
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}


- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:2.5f
                                     target:self
     
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

-(void)initTF{
    self.groupNameTF.enabled=YES;
    groupNameText = self.groupNameTF.text;

    self.groupID_TF.enabled = YES;
    groupIDTextStr= self.groupID_TF.text;
    
    self.groupMemberTF.enabled =YES;
    groupMemberText = self.groupMemberTF.text;
    

    
    _memberArray = [[NSArray alloc] initWithObjects:
                            groupMemberText,nil];
    
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

- (IBAction)clickGetGroupIsNoDisturb:(id)sender {
    
    Boolean  isNoDisturb_V =  _myGroup.isNoDisturb;
    
    NSLog(@"---防打扰状态：%d",isNoDisturb_V);

    if (isNoDisturb_V) {
        NSLog(@"------当前群防打扰状态：开启");
        [self showAlert:@"当前群防打扰状态：开启"];
        
        return;
    }
    NSLog(@"------当前群防打扰状态：关闭");
    [self showAlert:@"当前群防打扰状态：关闭"];


}
- (IBAction)clickOpenGroupDisturb:(id)sender {
    if (_myGroup == nil) {
        NSLog(@"----尚未获取到Group对象，放弃获取某群防打扰状态！");
        [self showAlert:@"----尚未获取到Group对象，放弃获取某群防打扰状态！"];

        return;
    }
    
    NSLog(@"------当前群对象是：%@",_myGroup);

    
    [_myGroup setIsNoDisturb:YES handler:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"------群防打扰开启失败：%@",error);
            [self showAlert:@"----尚未获取到Group对象，放弃获取某群防打扰状态！"];

            return ;
        }
        NSLog(@"------群防打扰开启成功：%@",resultObject);
        [self showAlert:@"----------群防打扰开启成功！"];


    }];
}
- (IBAction)clickCloseGroupDisturb:(id)sender {
    if (_myGroup == nil) {
        NSLog(@"----尚未获取到Group对象，放弃获取某群防打扰状态！");
        return;
    }
    NSLog(@"------当前群对象是：%@",_myGroup);

    [_myGroup setIsNoDisturb:NO handler:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"------群防打扰关闭失败：%@",error);
            alertText = [NSString stringWithFormat:@"------群防打扰关闭失败：%@",error];
            [self showAlert:alertText];

            return ;
        }
        NSLog(@"------群防打扰关闭成功：%@",resultObject);
         alertText = [NSString stringWithFormat:@"------群防打扰关闭成功：%@",resultObject];
        [self showAlert:alertText];

        
    }];
}

- (IBAction)clickCreateGroup:(id)sender {
    [self initTF];
    NSLog(@"-----开始创建群:%@ ",groupNameText);

             [JMSGGroup createGroupWithName:groupNameText desc:groupDescText memberArray:nil completionHandler:^(id resultObject, NSError *error) {
                if (error == nil) {
                    _myGroup = resultObject;
                    alertText = [NSString stringWithFormat:@"------创建群成功：%@",resultObject];
                    [self showAlert:alertText];
                    _covAllShowTV.text = alertText;

                    NSLog(@"-----成功创建群:%@ ,群描述：%@，群成员：%@！群id：%@,--resultObject: %@ ",groupNameText,groupDescText,_memberArray,_myGroup.gid,resultObject);
                    
                }
                else{
                    NSLog(@"-----创建群：%@ 失败！---error ：%@",groupNameText,error);
                    alertText = [NSString stringWithFormat:@"-----创建群：%@ 失败！---error ：%@",groupNameText,error];
                    [self showAlert:alertText];
                    _covAllShowTV.text = alertText;

                }
            }];

    
}
- (IBAction)clickUpdateGroupInfo:(id)sender {
    [self initTF];
    [JMSGGroup updateGroupInfoWithGroupId:groupIDTextStr name:groupNameText desc:groupDescText completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"-----clickUpdateGroupInfo-成功更新群:%@ 的信息!更新的群描述：%@！",groupNameText,groupDescText);
            alertText = [NSString stringWithFormat:@"-----成功更新群:%@ 的信息!更新的群描述：%@！",groupNameText,groupDescText];
            [self showAlert:alertText];
        }
        else{
            NSLog(@"-----clickUpdateGroupInfo-更新群:%@ 的信息 失败!更新的群描述：%@！---error：%@",groupNameText,groupDescText,error);
            alertText = [NSString stringWithFormat:@"更新群:%@ 的信息 失败!更新的群描述：%@！---error：%@",groupNameText,groupDescText,error];
            [self showAlert:alertText];
        }
    }];
  }
- (IBAction)clickGetGroupInfo:(id)sender {
    [self initTF];
    [JMSGGroup groupInfoWithGroupId:groupIDTextStr completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"-----clickGetGroupInfo-成功获取群:%@ 的信息 ! 群信息如下：%@",groupIDTextStr,resultObject);
            _myGroup = resultObject;
          NSString * groupDispalyNameText =   [_myGroup displayName];
            self.groupDisplayNameLb.enabled = YES;
            [self.groupDisplayNameLb setText:groupDispalyNameText];
            
            alertText = [NSString stringWithFormat:@"成功获取群:%@ 的信息 ! 群信息如下：%@",groupIDTextStr,resultObject];
            [self showAlert:alertText];
        }
        else{
            NSLog(@"-----clickGetGroupInfo-获取 群:%@ 的信息 失败!error：%@",groupIDTextStr,error);
            
            alertText = [NSString stringWithFormat:@"获取 群:%@ 的信息 失败!error：%@",groupIDTextStr,error];
            [self showAlert:alertText];
        }
    }];
  
}

- (IBAction)clickGetGroupMember:(id)sender {
    [self initTF];
    NSLog(@"----准备获取群 %@ 成员，开始获取当前群的群信息！",groupIDTextStr);
 [JMSGGroup groupInfoWithGroupId:groupIDTextStr completionHandler:^(id resultObject, NSError *error) {
    if (error == nil) {
        if (_myGroup) {
            _myGroup = resultObject;
            NSLog(@"--clickGetGroupMember-_myGroup.memberArray:%@",_myGroup.memberArray);
            alertText = [NSString stringWithFormat:@"成功获取群成员,成员总数：%lu",(unsigned long)(_myGroup.memberArray).count];
            [self showAlert:alertText];
            return;
            
        }
        else{
            NSLog(@"---_myGroup对象为空！");
            [self showAlert:@"---_myGroup对象为空！"];

        }
        [self showAlert:@"---获取群成员 失败，具体看日志！！"];


    }
}];
  }

- (IBAction)click1000Menber:(id)sender {
    NSLog(@"----click1000Menber ");

    sendGroupMsgTimesInt = 1;
    [self initTF];
    NSMutableArray *AddMenberArray=[NSMutableArray arrayWithCapacity:2000];
    for (int i=1; i <= sendGroupMsgTimesInt; i++) {
        int j = i;
        [AddMenberArray addObject:[NSString stringWithFormat:@"R_qpts_%d",j--]];

    }
    NSLog(@"----AddMenberArray Count:%d",sendGroupMsgTimesInt);
    

    [_myGroup addMembersWithUsernameArray:AddMenberArray completionHandler:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"---群聊页面批量添加群成员，失败：%@",error);
            alertText = [NSString stringWithFormat:@"---批量加群用户失败！%@",error];
            [self showAlert:alertText];
            return ;
        }
        NSLog(@"---群聊页面批量添加群成员，成功：%@",resultObject);
        [self showAlert:@"---批量添加群成员，成功，具体看日志！！"];


    }];
//    [JMSGGroup createGroupWithName:groupNameText desc:groupDescText memberArray:AddMenberArray completionHandler:^(id resultObject, NSError *error) {
//        if (error == nil) {
//            _myGroup = resultObject;
//            NSLog(@"---------新建群成功！{\n群id：%@,\n群成员：%@\n}",_myGroup.gid , _myGroup.memberArray);
//        }
//        else{
//            NSLog(@"-------新建群失败？添加群成员失败？成员：%@，-- error: %@ ,---result: %@",AddMenberArray,error,resultObject);
//            
//        }
//
//    }];
    
}

- (IBAction)clickAddGroupMember:(id)sender {
    [self initTF];
    NSLog(@"-----准备为群［id：%@，name：%@］  添加成员",_myGroup.gid ,_myGroup.name);
    __weak SecondViewController *weakSelf = self;
    [self initTF];
    if (_myGroup == nil) {
        NSLog(@"------准备添加群用户，但是当前群对象不存在！");
        [self showAlert:@"---准备添加群用户，但是当前群对象不存在！！"];

        return;
    }
    
    //得到——myGroup实例的值，开始添加群用户列表到某群
                [_myGroup addMembersWithUsernameArray:weakSelf.memberArray completionHandler:^(id resultObject, NSError *error) {
                    if (error == nil) {
                        NSLog(@"---------给群 %@ 添加群成员成功！成员：%@",weakSelf.myGroup.gid, weakSelf.memberArray);
                        [self showAlert:@"---添加群成员成功！"];

                    }
                    else{
                        NSLog(@"------给群 %@ 添加群成员失败！成员：%@，-- error: %@ ,---result: %@",weakSelf.myGroup.gid,weakSelf.memberArray,error,resultObject);
                        alertText = [NSString stringWithFormat:@"---加群用户失败！%@",error];
                        [self showAlert:alertText];
                    }
                }];
    
}


- (IBAction)clickDelGroupMember:(id)sender {
    [self initTF];
    
    if (_myGroup == nil) {
        NSLog(@"------准备删除群用户，但是当前群对象不存在！");
        [self showAlert:@"---准备删除群用户，但是当前群对象不存在！！"];
        
        return;
    }
    
    NSLog(@"----clickDelGroupMember");
            [_myGroup removeMembersWithUsernameArray:_memberArray completionHandler:^(id resultObject, NSError *error) {
                if (error == nil) {
                    NSLog(@"------给群 %@ 删除群成功！成员：%@",_myGroup.gid,_memberArray);
                    [self showAlert:@"---删除群用户成功！"];

                }
                else{
                    NSLog(@"------给群 %@ 删除群成员：%@ 失败！，-- error: %@ ,---result: %@",_myGroup.gid,_memberArray,error,resultObject);
                    alertText = [NSString stringWithFormat:@"---删除群用户失败！%@",error];
                    [self showAlert:alertText];

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
                    [self showAlert:@"---退群成功！"];

                }
                else{
                    NSLog(@"------退出群 %@ 失败，-- error: %@ ",_myGroup.gid,error);
                    alertText = [NSString stringWithFormat:@"---退群用户失败！%@",error];
                    [self showAlert:alertText];
                }
            }];
        }
        else{
            NSLog(@"-----获取 群:%@ 的信息 失败!error：%@",groupIDTextStr,error);
            alertText = [NSString stringWithFormat:@"---获取群信息失败！%@",error];
            [self showAlert:alertText];
        }
    }];
  
}
- (void)setSendGroupMsg{
    [self curTimeValue];
    [self initTF];
    
    NSString *sendContent = [NSString stringWithFormat:@"%@:---group--%d---%@ - %@",groupIDTextStr,i,sendGroupMSGText,curTime];
    NSLog(@"-----------------sendContent:%@",sendContent);
    
    JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:sendContent];
    
    [textContent addStringExtra:@"fsdakljfsk-ljklfjd-klf" forKey:@"statusId"];
    //                [textContent addStringExtra:@"http://image.7gyou.com/status/2016" forKey:@"statusImg"];
    // 不关注会话的情况
    JMSGMessage *message = [JMSGMessage createGroupMessageWithContent:textContent groupId:groupIDTextStr  ];
    NSLog(@"------------clickSendGroupTextMsg-----message:%@",message);
    
    [JMSGMessage sendMessage:message];
    //                [JMSGMessage sendGroupTextMessage:sendContent toGroup:groupIDTextStr  ];
    
    if (sendGroupMsgTimesInt  == i) {
        [_timer invalidate];
        _timer = nil;
        i =  0;
        return;
    }
    
    i = i+1;

}

- (IBAction)clickSendGroupTextMsg:(id)sender {
    i = 1;
            [JMessage removeAllDelegates];
            [JMessage addDelegate:self withConversation:nil];

  _timer =   [NSTimer scheduledTimerWithTimeInterval:1.5//单位秒
                                     target:self
                                   selector:@selector(setSendGroupMsg)
                                   userInfo:nil
                                    repeats:YES ];      //循环发送可以用这种方法， 这不会阻塞线程的， 更加符合实际情况
    
}

-(void)sendGroupImage{
    
    [JMSGConversation createGroupConversationWithGroupId:groupIDTextStr completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            [self initTF];
            NSLog(@"------------与 %@的会话创建成功！",groupIDTextStr );
            _groupConversation = resultObject;
            
            
            [self curTimeValue];
            NSString *sendContent = [NSString stringWithFormat:@"%@: －－%d－－%@ - %@",groupIDTextStr,i,sendGroupMSGText,curTime];
            NSLog(@"-----------------send group Image to：%@",sendContent);
            [JMSGMessage sendGroupImageMessage:picData toGroup:groupIDTextStr];
            
            
            _groupJMSGImageContent.uploadHandler = ^(float percent, NSString *msgID){
                
                NSString *percentS =  [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
                NSLog(@"----------------send group image progress : %@", percentS);
            };
        }
        
        else{
            NSLog(@"------------与 %@的会话创建失败！error ： %@ ,Result: %@",groupIDTextStr,error,resultObject );
            
        }
        
    }];

    if (sendGroupMsgTimesInt == i) {
        [_timer invalidate];
        _timer = nil;
        i = 0;
        return;
    }
    i++;
}
//调用相册
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    //先把图片转成NSData（注意图片的格式）
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    picData = UIImagePNGRepresentation(image);;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self initTF];
    
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
    NSLog(@"------removeAllDelegates，addDelegate：nil");
  
    _timer =   [NSTimer scheduledTimerWithTimeInterval:1.5//单位秒
                                                target:self
                                              selector:@selector(sendGroupImage)
                                              userInfo:nil
                                               repeats:YES ];      //循环发送可以用这种方法， 这不会阻塞线程的， 更加符合实际情况
    

    
}

- (IBAction)clickSendGroupImageMsg:(id)sender {
    i = 1;
    UIImagePickerController *imgController = [[UIImagePickerController alloc]init];
    imgController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgController.delegate = self;
    [self presentViewController:imgController animated:YES completion:NULL];
    
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
    
    
    return;
}

- (IBAction)clickSendGroupVoice:(id)sender {
}

- (IBAction)clickDelConversation:(id)sender {
    [self initTF];
    [JMSGConversation deleteGroupConversationWithGroupId:groupIDTextStr];
    NSString * clickDelConversation = [NSString stringWithFormat:@"----删除群ID为 %@ 的会话",groupIDTextStr];

    NSLog(@"%@",clickDelConversation);
    [_covAllShowTV setText:clickDelConversation];


}
- (IBAction)clickGetSomeGidGroupConversation:(id)sender {
    [self initTF];
   NSString * getConversationForGid = [NSString stringWithFormat:@"%@", [JMSGConversation groupConversationWithGroupId:groupIDTextStr]];
    NSLog(@"------获取群 %@ 的会话:%@",groupIDTextStr,getConversationForGid);

    [self showAlert:getConversationForGid];
    
}


-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    if (error !=nil) {
        NSLog(@"－－－\n 群聊--onReceiveMessage，收到消息异常：%@",error);
        
        return;
    }
    //展示默认事件信息
    //    if (message.contentType == kJMSGContentTypeEventNotification) {
    //        NSString *showText = [((JMSGEventContent *)message.content) showEventNotification];
    //        [self showAlert:showText];
    //    }
    
    //自定义事件代码
    if(message.contentType == kJMSGContentTypeEventNotification){
        JMSGEventContent *eventContent = (JMSGEventContent *)message.content;
        //获取发起事件的用户名
        NSString *fromUsername = [eventContent getEventFromUsername];
        //获取事件作用对象用户名列表
        NSArray *toUsernameList = [eventContent getEventToUsernameList];
        
        //根据事件类型，定制相应描述（以事件类型: 添加新成员为例子）
        long eventType = eventContent.eventType;
        NSLog(@"－－－\n eventType:%ld,\nfromUsername：%@,\ntoUsernameList:%@",eventType,fromUsername,toUsernameList);
        
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
    
    if(message.contentType == kJMSGContentTypeFile){
        [(JMSGFileContent * )message.content fileData:^(NSData *data, NSString *objectId, NSError *error) {
            if (error) {
                NSLog(@"----获取文件内容失败，error：%@",error);
                return ;
            }
            
            NSLog(@"---objectid：%@！",objectId);
            
        }];
        
    }
    
    if(message.contentType == kJMSGContentTypeLocation){
        JMSGLocationContent *localContent =  (JMSGLocationContent *) message.content;
        NSLog(@"----收到地理位置消息！\n详细地址：%@,\n经度：%@,\n纬度:%@，\n缩放比例：%@",localContent.address,localContent.latitude,localContent.longitude,localContent.scale);
        
    }
    
    NSLog(@"－－－\n群聊-onReceiveMessage，收到消息成功！messge：%@",message);
    
    
}


-(void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event{
    JMSGNotificationEvent *nEvent = event;
    NSLog(@"---------Group--onReceiveNotificationEvent收到 通知事件");
    
    //    if ([event isKindOfClass:[JMSGFriendNotificationEvent class]]) {
    //        JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
    //        [friendEvent getReason];
    //    }
    
    switch (nEvent.eventType) {
        case  kJMSGEventNotificationFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------Group--onReceiveNotificationEvent收到 好友邀请相关 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
            
        }
            break;
            
        case  kJMSGEventNotificationReceiveFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------Group--onReceiveNotificationEvent收到 好友邀请 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
        }
            break;
            
        case  kJMSGEventNotificationAcceptedFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------Group--onReceiveNotificationEvent收到 同意添加好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);        }
            break;
            
        case  kJMSGEventNotificationDeclinedFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------Group--onReceiveNotificationEvent收到 拒绝好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
        }
            break;
            
        case  kJMSGEventNotificationDeletedFriend:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            NSLog(@"---------Group--onReceiveNotificationEvent收到 删除好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
            
        }
            
            break;
            
        case  kJMSGEventNotificationLoginKicked:
            NSLog(@"---------Group--onReceiveNotificationEvent收到 多设备登陆被t 通知事件，描述：%@",nEvent.eventDescription);
            break;
        case  kJMSGEventNotificationServerAlterPassword:
            NSLog(@"---------Group--onReceiveNotificationEvent收到 非客户端修改密码被t 通知事件，描述：%@",nEvent.eventDescription);
            break;
        case  kJMSGEventNotificationUserLoginStatusUnexpected:
            NSLog(@"---------Group--onReceiveNotificationEvent收到 Juid变更导致下线的 事件，描述：%@",nEvent.eventDescription);
            break;
        default:
            NSLog(@"---------Group--onReceiveNotificationEvent收到 未知事件类型，描述：%@",nEvent.eventDescription);
            break;
    }
}
-(void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    if (error !=nil) {
        NSLog(@"------grounp---onSendMessageResponse发群消息,--error：\n%@,\n---message:%@",error,message);
        NSString * onSendMessageResponse = [NSString stringWithFormat:@"------grounp--onSendMessageResponse:%@",message];
        [_covAllShowTV setText:onSendMessageResponse];
        return;

    }
    NSLog(@"-----grounp--onSendMessageResponse发送群消息：%@",message);
    NSString * onSendMessageResponse = [NSString stringWithFormat:@"------grounp--onSendMessageResponse:%@",message];
    [_covAllShowTV setText:onSendMessageResponse];

}

-(void)onReceiveMessageDownloadFailed:(JMSGMessage *)message{
  
        NSLog(@"-------grounp--onReceiveMessageDownloadFailed收到群消息下载失败,----message:%@",message);
    
    NSString * recMessgeDownloadFailed = [NSString stringWithFormat:@"------grounp--onReceiveMessageDownloadFailed:%@",message];
    [_covAllShowTV setText:recMessgeDownloadFailed];

}

-(void)onGroupInfoChanged:(JMSGGroup *)group{
    NSLog(@"-------onGroupInfoChanged:\n%@",group);
    NSString * onGroupInfoChanged = [NSString stringWithFormat:@"------grounp--onGroupInfoChanged:\n%@",group];
    [_covAllShowTV setText:onGroupInfoChanged];
}

-(void)onConversationChanged:(JMSGConversation *)conversation{
    NSLog(@"-------onConversationChanged:\n%@",conversation);
    NSString * onConversationChanged = [NSString stringWithFormat:@"------grounp--onConversationChanged:\n%@",conversation];
    [_covAllShowTV setText:onConversationChanged];
}

-(void)onUnreadChanged:(NSUInteger)newCount{
    NSLog(@"-------onUnreadChanged:%ld",newCount);

}

-(void)onLoginUserKicked{
    NSLog(@"-------onLoginUserKicked");
}

//220b90及之前的220获取好友事件的方法

//-(void)onFriendChanged:(JMSGFriendEventContent *)event{
//    JMSGFriendEventContent * disturbJMSGFriendEventContent = event;
//    NSLog(@"----群聊页面测试---onFriendChanged:%@\n",event);
//    NSLog(@"----群聊页面测试---onFriendChanged:{\n好友通知事件类型:%ld,\n获取事件发生的理由:%@,\n事件发送者的username:%@,\n获取事件发送者user:%@",disturbJMSGFriendEventContent.eventType,[disturbJMSGFriendEventContent getReason],[disturbJMSGFriendEventContent getFromUsername],[disturbJMSGFriendEventContent getFromUser]);
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"-------进入了群聊界面:SecondViewController");
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
}

@end
