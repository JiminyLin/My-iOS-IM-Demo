//
//  ChangePasswordViewController.m
//  im200demo
//
//  Created by LinGuangzhen on 15/11/2.
//  Copyright © 2015年 LinGuangzhen. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import <JMessage/JMessage.h>

@interface ChangePasswordViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,JMessageDelegate>
@property (strong ,nonatomic )JMSGMessage * changePwJMessage;
@property  (strong ,nonatomic)JMSGConversation *changePwConversation;
@property  (strong ,nonatomic)JMSGUser *changePwJMSGUser;


@end

@implementation ChangePasswordViewController
NSString *curTimeChangePassword;

NSString *StrideAppMessage = nil;
NSString * user1Str = nil;
NSString * user2Str= nil;
NSString * targetAppkeyStr = nil;

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

-(void)curTimeValue{
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy年MM月dd日 HH小时mm分ss秒"];
    curTimeChangePassword = [df stringFromDate:currentDate];
    
    //    NSLog(@"系统当前时间为：%@",curTime);
}

//指定要隐藏键盘的控件
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.oldPassword resignFirstResponder];
    [self.newsPassword resignFirstResponder];
    [self.TF_targetAppkey resignFirstResponder];
    [self.TF_user1 resignFirstResponder];
    [self.TF_user2 resignFirstResponder];
    [self.msgidV resignFirstResponder];
    [self.TV_resultShow resignFirstResponder];
}


- (IBAction)clickCreateStrideAppConversation:(id)sender {
    self.TF_user1.enabled = YES;
    user1Str = self.TF_user1.text;
    self.TF_targetAppkey.enabled = YES;
    targetAppkeyStr = self.TF_targetAppkey.text;
    
    
    [JMSGConversation createSingleConversationWithUsername:user1Str     appKey:targetAppkeyStr completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSString *createStrideAppConv= [NSString stringWithFormat:@"创建于appkey（%@）用户（%@）的会话成功！\n{\n resultObject：%@,\nerror: %@}",targetAppkeyStr,user1Str,resultObject,error];
            self.TV_resultShow.text = createStrideAppConv;
            
            NSLog(@"---------change password page ---创建于appkey（%@）用户（%@）的会话成功！\n{\n resultObject：%@,\nerror: %@\n}",targetAppkeyStr,user1Str,resultObject,error);
            _changePwConversation = resultObject;
           
            
        }
        else{
            NSLog(@"---------change password page ---创建于appkey（%@）用户（%@）的会话失败！resultObject：%@,error: %@\n",targetAppkeyStr,user1Str,resultObject,error);
            NSString *createStrideAppConv= [NSString stringWithFormat:@"创建于appkey（%@）用户（%@）的会话失败！resultObject：%@,error: %@",targetAppkeyStr,user1Str,resultObject,error];
            self.TV_resultShow.text = createStrideAppConv;
            
            
        }
        
    }];

}

- (IBAction)clickGetStrideAppUserInfo:(id)sender {
    self.TF_user1.enabled = YES;
    self.TF_user2.enabled = YES;
    
     targetAppkeyStr = self.TF_targetAppkey.text;
     user1Str = self.TF_user1.text;
    user2Str = self.TF_user2.text;
    NSArray * userArray;
        userArray  = [[NSArray alloc] initWithObjects:
                      user1Str,user2Str,nil];

    
    
    [JMSGUser userInfoArrayWithUsernameArray: userArray appKey:targetAppkeyStr completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            
            NSString *getStrideAppUsersInfo= [NSString stringWithFormat:@"userInfoArrayWithUsernameArray 成功: appkey(%@),user1(%@)、user2(%@)的个人信息如下：%@",targetAppkeyStr,user1Str,user2Str,resultObject];
            self.TV_resultShow.text = getStrideAppUsersInfo;
            
            NSLog(@"----ChangePassword－－userInfoArrayWithUsernameArray 成功: appkey(%@),user1(%@)、user2(%@)的个人信息如下：%@\n",targetAppkeyStr,user1Str,user2Str,resultObject);
            
            NSArray *usersArrayResultObject = resultObject;
           long int userArrayCount = [usersArrayResultObject count];
            for (int i = 0 ; i< userArrayCount; i ++) {
                NSLog(@"----clickGetStrideAppUserInfouserArrayCount:%ld",userArrayCount);
                _changePwJMSGUser = usersArrayResultObject[i];
                NSString *userInfoAppkey = _changePwJMSGUser.appKey;
                NSString * userInfoUserName = _changePwJMSGUser.username;
                NSLog(@"-----userInfoArrayWithUsernameArray---appkey(%@)用户（%@）所属appkey:%@\n",targetAppkeyStr,userInfoUserName, userInfoAppkey);
            }
          
        }
        else{
              NSLog(@"----ChangePassword－－userInfoArrayWithUsernameArray 失败: appkey(%@),user1(%@)、user2(%@)的个人信息获取失败，error：%@，resultObject:%@\n",targetAppkeyStr,user1Str,user2Str,error,resultObject);
            NSString *getStrideAppUsersInfo= [NSString stringWithFormat:@"uuserInfoArrayWithUsernameArray 失败: appkey(%@),user1(%@)、user2(%@)的个人信息获取失败，error：%@，resultObject:%@\n",targetAppkeyStr,user1Str,user2Str,error,resultObject];
            self.TV_resultShow.text = getStrideAppUsersInfo;
        }
    }];
<<<<<<< HEAD
}

- (IBAction)clickSendStrideAppTextMsg:(id)sender {
    [self curTimeValue];
//    NSString *sendContent = [NSString stringWithFormat:@"%@- %@,appkey:%@\n",user1Str,curTimeChangePassword,targetAppkeyStr];
    //
    NSString *convText= [NSString stringWithFormat:@"要发送跨应用的文本内容。%@",curTimeChangePassword];
    JMSGTextContent * convTextContent = [[JMSGTextContent alloc] initWithText:convText];
    [convTextContent addStringExtra:@"cov-Text-string value" forKey:@"cov-Text-string key"];
    _changePwJMessage = [_changePwConversation createMessageWithContent:convTextContent];
    [_changePwConversation sendMessage:_changePwJMessage];

//              [_changePwConversation sendTextMessage:sendContent];
    NSLog(@"----_changePwConversation:%@",_changePwConversation);
//           NSLog(@"----修改密码页面，给Appkey(%@)的用户(%@)发送文本消息:%@\n",targetAppkeyStr,user1Str,sendContent);
    
}

//调用相册
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self curTimeValue];
    

    //先把图片转成NSData（注意图片的格式）
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *picData = UIImagePNGRepresentation(image);;
    [self dismissViewControllerAnimated:YES completion:nil];
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
    NSLog(@"-----发送图片页面添加了delegate");
    
    [_changePwConversation sendImageMessage:picData];
//    [JMSGMessage sendSingleImageMessage:picData toUser:user1Str];//调用单聊发图接口发送从相册里面选择的图片
}
- (IBAction)clickSendStrideAppImageMsg:(id)sender {
    //打开显示相册控件
    UIImagePickerController *imgController = [[UIImagePickerController alloc]init];
    imgController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgController.delegate = self;
    [self presentViewController:imgController animated:YES completion:NULL];
    
    return;
}
- (IBAction)clickSendStrideAppCustom:(id)sender {
    [self curTimeValue];
    NSDictionary *dictionary  = @{@"d":@"g",@"y66":@"sfjhdsjh"};
//     NSDictionary *dictionary  = [[NSDictionary alloc] initWithObjectsAndKeys:@"",nil,nil];
    
    JMSGCustomContent *strideAppCustomContent = [[JMSGCustomContent alloc] initWithCustomDictionary:dictionary];
        NSString *sendCustomContent = [NSString stringWithFormat:@"%@- %@,to appkey:%@\n",user1Str,curTimeChangePassword,targetAppkeyStr];
    JMSGMessage *cutMessage = [_changePwConversation createMessageWithContent:strideAppCustomContent];
    [strideAppCustomContent setContentText:sendCustomContent];
    [strideAppCustomContent addObjectValue:@"custom key1" forKey:@"custom value 1"];
    [strideAppCustomContent addStringExtra:@"addStringExtra for value1" forKey:@"addStringExtra for key 1"];

    [_changePwConversation sendMessage:cutMessage];

}

- (IBAction)clickDelStrideAppConversation:(id)sender {
    self.TF_user1.enabled = YES;
    user1Str = self.TF_user1.text;
    self.TF_targetAppkey.enabled = YES;
    targetAppkeyStr = self.TF_targetAppkey.text;
    
    [JMSGConversation deleteSingleConversationWithUsername:user1Str appKey:targetAppkeyStr];
    NSLog(@"----删除appkey（%@）下用户（%@）的会话\n",targetAppkeyStr,user1Str);
}

- (IBAction)clickGetStrideAppUserConversation:(id)sender {
    
    self.TF_user1.enabled = YES;
    user1Str = self.TF_user1.text;
    self.TF_targetAppkey.enabled = YES;
    targetAppkeyStr = self.TF_targetAppkey.text;
_changePwConversation = [JMSGConversation singleConversationWithUsername:user1Str appKey:targetAppkeyStr];
    
    
    NSLog(@"----change password page，获取跨应用Appkey(%@)下用户（%@）的会话：%@\n",targetAppkeyStr,user1Str,_changePwConversation);
}

=======
}

- (IBAction)clickSendStrideAppTextMsg:(id)sender {
    [self curTimeValue];
//    NSString *sendContent = [NSString stringWithFormat:@"%@- %@,appkey:%@\n",user1Str,curTimeChangePassword,targetAppkeyStr];
    //
    NSString *convText= [NSString stringWithFormat:@"要发送跨应用的文本内容。%@",curTimeChangePassword];
    JMSGTextContent * convTextContent = [[JMSGTextContent alloc] initWithText:convText];
    [convTextContent addStringExtra:@"cov-Text-string value" forKey:@"cov-Text-string key"];
    _changePwJMessage = [_changePwConversation createMessageWithContent:convTextContent];
    [_changePwConversation sendMessage:_changePwJMessage];

//              [_changePwConversation sendTextMessage:sendContent];
    NSLog(@"----_changePwConversation:%@",_changePwConversation);
//           NSLog(@"----修改密码页面，给Appkey(%@)的用户(%@)发送文本消息:%@\n",targetAppkeyStr,user1Str,sendContent);
    
}

//调用相册
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self curTimeValue];
    

    //先把图片转成NSData（注意图片的格式）
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *picData = UIImagePNGRepresentation(image);;
    [self dismissViewControllerAnimated:YES completion:nil];
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
    NSLog(@"-----发送图片页面添加了delegate");
    
    [_changePwConversation sendImageMessage:picData];
//    [JMSGMessage sendSingleImageMessage:picData toUser:user1Str];//调用单聊发图接口发送从相册里面选择的图片
}
- (IBAction)clickSendStrideAppImageMsg:(id)sender {
    //打开显示相册控件
    UIImagePickerController *imgController = [[UIImagePickerController alloc]init];
    imgController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgController.delegate = self;
    [self presentViewController:imgController animated:YES completion:NULL];
    
    return;
}
- (IBAction)clickSendStrideAppCustom:(id)sender {
    [self curTimeValue];
    NSDictionary *dictionary  = @{@"d":@"g",@"y66":@"sfjhdsjh"};
//     NSDictionary *dictionary  = [[NSDictionary alloc] initWithObjectsAndKeys:@"",nil,nil];
    
    JMSGCustomContent *strideAppCustomContent = [[JMSGCustomContent alloc] initWithCustomDictionary:dictionary];
        NSString *sendCustomContent = [NSString stringWithFormat:@"%@- %@,to appkey:%@\n",user1Str,curTimeChangePassword,targetAppkeyStr];
    JMSGMessage *cutMessage = [_changePwConversation createMessageWithContent:strideAppCustomContent];
    [strideAppCustomContent setContentText:sendCustomContent];
    [strideAppCustomContent addObjectValue:@"custom key1" forKey:@"custom value 1"];
    [strideAppCustomContent addStringExtra:@"addStringExtra for value1" forKey:@"addStringExtra for key 1"];

    [_changePwConversation sendMessage:cutMessage];

}

- (IBAction)clickDelStrideAppConversation:(id)sender {
    self.TF_user1.enabled = YES;
    user1Str = self.TF_user1.text;
    self.TF_targetAppkey.enabled = YES;
    targetAppkeyStr = self.TF_targetAppkey.text;
    
    [JMSGConversation deleteSingleConversationWithUsername:user1Str appKey:targetAppkeyStr];
    NSLog(@"----删除appkey（%@）下用户（%@）的会话\n",targetAppkeyStr,user1Str);
}

- (IBAction)clickGetStrideAppUserConversation:(id)sender {
    
    self.TF_user1.enabled = YES;
    user1Str = self.TF_user1.text;
    self.TF_targetAppkey.enabled = YES;
    targetAppkeyStr = self.TF_targetAppkey.text;
_changePwConversation = [JMSGConversation singleConversationWithUsername:user1Str appKey:targetAppkeyStr];
    
    
    NSLog(@"----change password page，获取跨应用Appkey(%@)下用户（%@）的会话：%@\n",targetAppkeyStr,user1Str,_changePwConversation);
}

>>>>>>> 74e9421649647b162dda870da3e7c6b8d672ebc2
- (IBAction)clickChangePassword:(id)sender {
    self.oldPassword.enabled =YES;
    NSString *oldPsw = self.oldPassword.text;
    
    self.newsPassword.enabled =YES;
    NSString *newsPsw = self.newsPassword.text;
    
    [JMSGUser  updateMyPasswordWithNewPassword:newsPsw oldPassword:oldPsw completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"-----修改密码成功！－－旧密码：%@，－－新密码：%@\n",oldPsw,newsPsw);
        }
        else{
            NSLog(@"-----修改密码失败！－－旧密码：%@，－－新密码：%@，－－error：%@，－－result：%@\n",oldPsw,newsPsw,error,resultObject);

        }
        
    }];
    
}


- (IBAction)clickClearTV:(id)sender {
    self.TV_resultShow.text = @"98f67476b10c3bf6690559a9\n228a71eadccde93549bbf5c4\n8a06e1d67fd00b0423ffff6d";
}
- (IBAction)cilckDelStrideAppConvAllMSG:(id)sender {
    if (_changePwConversation !=nil) {
        NSString * convInfo = [NSString stringWithFormat:@"[当前会话：%@]",_changePwConversation];
        
        NSLog(@"------Change Password即将删除会话：%@",convInfo);
        [_changePwConversation deleteAllMessages];
        
          }
    else{
        NSLog(@"------Change Password会话对象为空，放弃删除跨应用会话动作！");

    }

}

- (IBAction)clickGetSomeMsgidContent:(id)sender {
    self.msgidV.enabled = YES;
    NSString * msgidText = self.msgidV.text;
    NSLog(@"------_changePwConversation的msgid（%@）的内容：%@",msgidText, [_changePwConversation messageWithMessageId:msgidText]);
    
}

- (IBAction)clickGetStrideAppConvLastMSG:(id)sender {
    if (_changePwConversation !=nil) {
        
        NSLog(@"------Change Password即将获取会话最后一条消息：%@",   [_changePwConversation latestMessage]);
    }
    else{
        NSLog(@"------Change Password会话对象为空，放弃获取会话最新一条消息动作！");
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cilckGetStrideAppConvAllMSG:(id)sender {
    
    NSString * convInfo = [NSString stringWithFormat:@"%@",_changePwConversation];
    
    NSLog(@"------cilckGetStrideAppConvAllMSG当前会话是：%@",convInfo);
    if (_changePwConversation !=nil) {
        
        [_changePwConversation allMessages:^(id resultObject, NSError *error) {
            if (error == nil) {
               NSString * covShow = [NSString stringWithFormat:@"－－－cilckGetStrideAppConvAllMSG成功获取到当前会话的所有消息：%@",resultObject];
                self.TV_resultShow.text =covShow;
                NSLog(@"%@",covShow);
            }
            else {
               NSString * covShowError = [NSString stringWithFormat:@"－－－cilckGetStrideAppConvAllMSG获取到当前会话的所有消息失败！－－error：%@，－－result：%@",error,resultObject];
                self.TV_resultShow.text =covShowError;
                NSLog(@"%@",covShowError);
                
            }
        }];
        
    }
    else{
        NSLog(@"---covConversation is nil!!!不去获取当前会话的全部消息");
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/
-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    if (error !=nil) {
        NSLog(@"------ChangePasswordViewController－ -onReceiveMessage收到消息,--error：%@,---message:%@\n",error,message);
        StrideAppMessage = [NSString stringWithFormat:@" 收到消息: %@，error%@\n",message,error];
        self.TV_resultShow.text =  StrideAppMessage;

<<<<<<< HEAD
        
=======
        return;
>>>>>>> 74e9421649647b162dda870da3e7c6b8d672ebc2
    }else{
        NSLog(@"--------[message toJsonString]:%@",[message toJsonString]) ;

        StrideAppMessage = [NSString stringWithFormat:@" 收到消息: %@\n",message];
        self.TV_resultShow.text =  StrideAppMessage;
        _changePwJMessage =  message;
<<<<<<< HEAD

        NSLog(@"--ChangePasswordViewController---onReceiveMessage收到消息：%@\n",message);
        
        NSLog(@"---ChangePasswordViewController---_myJMSGMessage.contentType: %ld, _myJMSGMessage.content:%@\n",(long)_changePwJMessage.contentType,_changePwJMessage.content) ;
        
        
//        NSLog(@"--ChangePasswordViewController---onReceiveMessage收到消息：%@\n",[_changePwJMessage ]);

//        NSLog(@"---ChangePasswordViewController--判断本消息的fromAppKey(%@)是否为当前集成使用的appkey：%d,",_changePwJMessage.fromAppKey,[JMessage isMainAppKey:_changePwJMessage.fromAppKey]);

    }
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
//    if(message.ty == kJMSGEventNotificationReceiveFriendInvitation){
    
//    }

    if(message.contentType == kJMSGContentTypeLocation){
        JMSGLocationContent *localContent =  (JMSGLocationContent *) message.content;
        NSLog(@"----收到地理位置消息！\n详细地址：%@,\n经度：%@,\n纬度:%@，\n缩放比例：%@",localContent.address,localContent.latitude,localContent.longitude,localContent.scale);
        
    }
    
    NSLog(@"－－－\n ChangePasswordViewController-onReceiveMessage，收到消息成功！messge：%@",message);
    
    }

=======

        NSLog(@"--ChangePasswordViewController---onReceiveMessage收到消息：%@\n",message);
        
        NSLog(@"---ChangePasswordViewController---_myJMSGMessage.contentType: %ld, _myJMSGMessage.content:%@\n",(long)_changePwJMessage.contentType,_changePwJMessage.content) ;
        
        
//        NSLog(@"--ChangePasswordViewController---onReceiveMessage收到消息：%@\n",[_changePwJMessage ]);

//        NSLog(@"---ChangePasswordViewController--判断本消息的fromAppKey(%@)是否为当前集成使用的appkey：%d,",_changePwJMessage.fromAppKey,[JMessage isMainAppKey:_changePwJMessage.fromAppKey]);

    }
    }

>>>>>>> 74e9421649647b162dda870da3e7c6b8d672ebc2
-(void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    if (error !=nil) {
//        NSLog(@"------ChangePasswordViewController-onSendMessageResponse发消息失败！！from appkey(%@),targetAppkey(%@),--error：%@,---message:%@\n",_changePwJMessage.fromAppKey,_changePwJMessage.targetAppKey,error,message);
        StrideAppMessage = [NSString stringWithFormat:@" onSendMessageResponse消息: %@,error:%@",message,error];
        self.TV_resultShow.text =  StrideAppMessage;
        
    }else {
        _changePwJMessage = message;
//        
        NSLog(@"------ChangePasswordViewController-onSendMessageResponse发消息成功！！！\nfrom appkey(%@),\ntargetAppkey(%@),\n--error：%@,\n---message:%@\n",_changePwJMessage.fromAppKey,_changePwJMessage.targetAppKey,error,_changePwJMessage);
//        StrideAppMessage = [NSString stringWithFormat:@" onSendMessageResponse消息: %@",_changePwJMessage];
        self.TV_resultShow.text =  StrideAppMessage;
        
    }
}

<<<<<<< HEAD


-(void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event{
    JMSGNotificationEvent *nEvent = event;
    NSLog(@"---------change Password--onReceiveNotificationEvent收到 通知事件");
    
    //    if ([event isKindOfClass:[JMSGFriendNotificationEvent class]]) {
    //        JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
    //        [friendEvent getReason];
    //    }
    
    switch (nEvent.eventType) {
        case  kJMSGEventNotificationFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------change Password--onReceiveNotificationEvent收到 好友邀请相关 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
            
        }
            break;
            
        case  kJMSGEventNotificationReceiveFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------change Password--onReceiveNotificationEvent收到 好友邀请 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
        }
            break;
            
        case  kJMSGEventNotificationAcceptedFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------change Password--onReceiveNotificationEvent收到 同意添加好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);        }
            break;
            
        case  kJMSGEventNotificationDeclinedFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------change Password--onReceiveNotificationEvent收到 拒绝好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
        }
            break;
            
        case  kJMSGEventNotificationDeletedFriend:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            NSLog(@"---------change Password--onReceiveNotificationEvent收到 删除好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
            
        }
            
            break;
            
        case  kJMSGEventNotificationLoginKicked:
            NSLog(@"---------change Password--onReceiveNotificationEvent收到 多设备登陆被t 通知事件，描述：%@",nEvent.eventDescription);
            break;
        case  kJMSGEventNotificationServerAlterPassword:
            NSLog(@"---------change Password--onReceiveNotificationEvent收到 非客户端修改密码被t 通知事件，描述：%@",nEvent.eventDescription);
            break;
        case  kJMSGEventNotificationUserLoginStatusUnexpected:
            NSLog(@"---------change Password--onReceiveNotificationEvent收到 Juid变更导致下线的 事件，描述：%@",nEvent.eventDescription);
            break;
        default:
            NSLog(@"---------change Password--onReceiveNotificationEvent收到 未知事件类型，描述：%@",nEvent.eventDescription);
            break;
    }
}

=======
>>>>>>> 74e9421649647b162dda870da3e7c6b8d672ebc2
-(void)onReceiveMessageDownloadFailed:(JMSGMessage *)message{
    
    NSLog(@"-----ChangePasswordViewController--onReceiveMessageDownloadFailed收到消息下载失败,----message:%@\n",message);
    StrideAppMessage = [NSString stringWithFormat:@" onReceiveMessageDownloadFailed消息: %@",message];
    self.TV_resultShow.text =  StrideAppMessage;
}

-(void)onGroupInfoChanged:(JMSGGroup *)group{
    NSLog(@"----ChangePasswordViewController---onGroupInfoChanged:%@\n",group);
    StrideAppMessage = [NSString stringWithFormat:@" onReceiveMessageDownloadFailed消息: %@",group];
    self.TV_resultShow.text =  StrideAppMessage;

}

-(void)onConversationChanged:(JMSGConversation *)conversation{
    NSLog(@"---ChangePasswordViewController----onConversationChanged:%@\n",conversation);
    StrideAppMessage = [NSString stringWithFormat:@" 收到onConversationChanged: %@",conversation];
    self.TV_resultShow.text =  StrideAppMessage;
}

-(void)onUnreadChanged:(NSUInteger)newCount{
    NSLog(@"----ChangePasswordViewController---onUnreadChanged:%lu\n",(unsigned long)newCount);
    
    StrideAppMessage = [NSString stringWithFormat:@" 收到onConversationChanged: %ld",newCount];
    self.TV_resultShow.text =  StrideAppMessage;
    
}

-(void)onLoginUserKicked{
    NSLog(@"-----ChangePasswordViewController--onLoginUserKicked－－－--你被踢下线了！\n");
    StrideAppMessage = [NSString stringWithFormat:@" --onLoginUserKicked-你被踢下线了！"];
    self.TV_resultShow.text =  StrideAppMessage;
}

<<<<<<< HEAD

//220b90及之前的版本接收好友相关事件的方法
//-(void)onFriendChanged:(JMSGFriendEventContent *)event{
//    JMSGFriendNotificationEvent * disturbJMSGFriendEventContent = event;
//    NSLog(@"----ChangePasswordViewController页面测试---onFriendChanged:%@\n",event);
//    NSLog(@"----ChangePasswordViewController页面测试---onFriendChanged:{\n好友通知事件类型:%ld,\n获取事件发生的理由:%@,\n事件发送者的username:%@,\n获取事件发送者user:%@",disturbJMSGFriendEventContent.eventType,[disturbJMSGFriendEventContent getReason],[disturbJMSGFriendEventContent getFromUsername],[disturbJMSGFriendEventContent getFromUser]);
//    
//}

=======
>>>>>>> 74e9421649647b162dda870da3e7c6b8d672ebc2
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"-------进入了消息页:ChangePassWordViewController");
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
}
@end
