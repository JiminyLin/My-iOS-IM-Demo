//
//  messageViewController.m
//  im200demo
//
//  Created by LinGuangzhen on 15/10/28.
//  Copyright © 2015年 LinGuangzhen. All rights reserved.
//

#import "messageViewController.h"
#import <JMessage/JMessage.h>

@interface messageViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,JMessageDelegate>
{
    JMSGMessage * _message;
    NSString *singleMessage;
    NSString *  singlePageAlertText;
}

@property(strong,nonatomic)    UITextView *textview;
@property (strong,nonatomic) JMSGUser *otherJMSGUser;
@property (strong,nonatomic) JMSGUser *myJMSGUser;

@property (strong ,nonatomic )JMSGMessage *myJMSGMessage;
@property (strong,nonatomic)JMSGCustomContent *myJMSGCustomContent;
@property (strong ,nonatomic )JMSGConversation * myJMSGConversation;
@property (strong,nonatomic)  JMSGAbstractContent *myAbstractContent ;
@end
@implementation messageViewController
NSString *user1,*user2,*contentText,*curTime;
NSInteger sendTimes;
NSString *unReadCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"-------进入了 单聊 界面:messageViewController");
    
  
     //隐藏键盘，star
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    //隐藏键盘，end
    // Do any additional setup after loading the view, typically from a nib.
    _textview = [[UITextView alloc] initWithFrame: CGRectMake(0, 210, 320, 140) ];
    [self.view addSubview:_textview];
    _textview.backgroundColor = [UIColor grayColor];

    
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}


- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
     
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}
//指定要隐藏键盘的控件
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.userTF resignFirstResponder];
    [self.userTF2 resignFirstResponder];
    [self.contentTF resignFirstResponder];
    [self.sendTimeTF resignFirstResponder];
    [self.textview resignFirstResponder];
    
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

- (IBAction)clickGetUserDisturbStatus:(id)sender {
    if (_otherJMSGUser ==nil) {
        NSLog(@"----尚未获取到User对象，放弃获取某用户防打扰状态！");
        NSString *GetUserDisturbStatusFial = [NSString stringWithFormat:@"----尚未获取到User对象，放弃获取某用户防打扰状态！"];
        
        [_textview setText:GetUserDisturbStatusFial];

        return;
    }
    
    NSLog(@"---将获取用户%@防打扰状态：%d",_otherJMSGUser,_otherJMSGUser.isNoDisturb);
    NSString *GetUserDisturbStatusSucce= [NSString stringWithFormat:@"---将获取用户%@防打扰状态：%d",_otherJMSGUser,_otherJMSGUser.isNoDisturb];
    
    [_textview setText:GetUserDisturbStatusSucce];

    if (_otherJMSGUser.isNoDisturb) {
        NSLog(@"------用户对象：%@，\n防打扰状态为：开启",_otherJMSGUser);
        return;
    }
    NSLog(@"------用户对象：%@，\n防打扰状态为：关闭",_otherJMSGUser);

}
- (IBAction)clickOpenUserDisturb:(id)sender {
    if (_otherJMSGUser ==nil) {
        NSLog(@"----尚未获取到User对象，放弃获取某用户防打扰状态！");
        NSString *clickOpenUserDisturbFail = [NSString stringWithFormat:@"----尚未获取到User对象，放弃开启某用户防打扰状态！"];
        
        [_textview setText:clickOpenUserDisturbFail];

        
        return;
    }
    NSLog(@"------用户对象是：%@",_otherJMSGUser);

    [_otherJMSGUser setIsNoDisturb:YES handler:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"------用户防打扰开启失败：%@",error);
            return ;
        }
        NSLog(@"------用户打扰开启成功：%@",resultObject);
        
        NSString *setIsNoDisturb= [NSString stringWithFormat:@"---防打扰开启成功：%@",resultObject];
        
        [_textview setText:setIsNoDisturb];

    }];
}
- (IBAction)clickCloseUserDisturb:(id)sender {
    if (_otherJMSGUser ==nil) {
        NSLog(@"----尚未获取到User对象，放弃获取某用户防打扰状态！");
        return;
    }
    NSLog(@"------用户对象是：%@",_otherJMSGUser);
    
    [_otherJMSGUser setIsNoDisturb:NO handler:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"------用户防打扰关闭失败：%@",error);
            return ;
        }
        NSLog(@"------用户打扰关闭成功：%@",resultObject);
        
    }];

}

- (IBAction)clickGetUserInfo:(id)sender {
    self.userTF.enabled=YES;
    self.userTF.enabled =YES;
    user1 = self.userTF.text;
    user2 = self.userTF2.text;
    NSArray * userArray;
    NSString *nilString=@"";
    if (![user1 isEqualToString:nilString] && ![user2 isEqualToString:nilString]) {
        userArray  = [[NSArray alloc] initWithObjects:
                      user1,user2,nil];
    }
    else if ([user1 isEqualToString:nilString] && ![user2 isEqualToString:nilString]) {
        userArray  = [[NSArray alloc] initWithObjects:
                      user2,nil];
    }
    else if (![user1 isEqualToString:nilString] && [user2 isEqualToString:nilString]) {
        userArray  = [[NSArray alloc] initWithObjects:
                      user1,nil];
    }
    else{
        userArray  = [[NSArray alloc] initWithObjects:
                          @"",nil];
    }
    NSLog(@"-----要获取de 用户有：%@",userArray) ;

    JMSGUser *myInfo = [JMSGUser myInfo];
    
    [JMSGUser userInfoArrayWithUsernameArray:userArray completionHandler:^(id resultObject, NSError *error) {
        if (error ==nil) {
            NSLog(@"---获取用户 %@ 、%@的用户信息成功！，result：%@",user1,user2,resultObject);
            
            NSString *getUserInfo = [NSString stringWithFormat:@"%@",resultObject];
            [_textview setText:getUserInfo];
            
            _otherJMSGUser  = resultObject[0];
//            Boolean isEqualToUser=  [ myInfo isEqualToUser:_otherJMSGUser];
//            NSLog(@"----isEqualToUser:%d",isEqualToUser);
            [_otherJMSGUser largeAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
                if (error == nil) {
                    NSLog(@"----获取 %@ 的头像",userArray);
                    self.showImageIV.image = [UIImage imageWithData:data];

                }
            }];
        }
        else{
            NSLog(@"---获取用户 %@ 、%@的用户信息失败！，erro：%@,result：%@",user1,user2,error,resultObject);
        }
    }];
}

-(void)initUserContent{
    self.userTF.enabled =YES;
    user1 = self.userTF.text;
    
    self.contentTF.enabled =YES;
    contentText = self.contentTF.text;
    
   }
- (IBAction)clickSendKuaAppText:(id)sender {
    [self initUserContent];
    [self curTimeValue];
    NSString * kuaAppkey = @"98f67476b10c3bf6690559a9";
    NSString *sendContent = [NSString stringWithFormat:@"%@:%@ - %@",user1,contentText,curTime];
    [JMSGConversation  createSingleConversationWithUsername:user1 appKey:kuaAppkey completionHandler:^(id resultObject, NSError *error) {
        if (error ==nil) {
            NSLog(@"----跨应用appkey(%@),用户（%@）会话创建成功！error:%@, resultObject：%@", kuaAppkey,user1,error,resultObject);
            _myJMSGConversation = resultObject;
            [_myJMSGConversation sendTextMessage:sendContent];
        }
        else{
              NSLog(@"----跨应用appkey(%@),用户（%@）会话创建失败！error:%@, resultObject：%@", kuaAppkey,user1,error,resultObject);        }
    }];
//    [JMSGMessage sendSingleTextMessage:sendContent toUser:user1];//调用发送单聊文本接口发消息
    NSLog(@"------单聊页面，发送消息内容：%@",sendContent);
    

}


- (IBAction)clickSendText:(id)sender {
    [self initUserContent];
    [self curTimeValue];
 _myJMSGUser =  [JMSGUser myInfo];
    NSString *sendContent = [NSString stringWithFormat:@"本消息由[%@]发至[%@]:%@ - %@",[_myJMSGUser username],user1,contentText,curTime];
    _myJMSGConversation = [JMSGConversation singleConversationWithUsername:user1];
    [JMSGMessage sendSingleTextMessage:sendContent toUser:user1];//调用发送单聊文本接口发消息
    NSLog(@"------单聊页面， 发送文本消息，内容：%@",sendContent);


}
- (IBAction)clickSendCustomMSG:(id)sender {
    [self initUserContent];
    
//    JMSGCustomContent *customContent = [[JMSGCustomContent alloc] initWithCustomDictionary:@{@"custom key":@"custom value"}];

//   [JMSGConversation createSingleConversationWithUsername:user1 completionHandler:^(id resultObject, NSError *error) {
//       if (error !=nil) {
//           NSLog(@"----发custom msg 创建会话失败！");
//                 }
       NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"ssss",@"567890",nil];
       
       JMSGCustomContent *customContent = [[JMSGCustomContent alloc] initWithCustomDictionary:dictionary];
       [customContent addStringValue:@"hjs-hfsd" forKey:@"gfhjkl-4567s"];

//       _myJMSGConversation = resultObject;
    
       [JMessage removeAllDelegates];
       [JMessage addDelegate:self withConversation:nil];
       NSLog(@"-----发送文本按钮这里添加了delegate");

    
       NSLog(@"----当前登陆的用户的displayName：%@",[_myJMSGUser displayName]);
    
       [customContent setContentText:@"customText的内容！！！！clickSendCustomMSG－button"];
//       [customContent addObjectValue:nil forKey:nil];
         [customContent addObjectValue:@"custom key1" forKey:@"custom value 1"];
       [customContent addStringExtra:@"EViewXTRAS V" forKey:@"EXTRAS KEY"];
//              [customContent addStringExtra:nil forKey:nil];
//    JMSGMessage *cutMessage = [_myJMSGConversation createMessageWithContent:customContent];
    
       JMSGMessage *cutMessage = [JMSGMessage createSingleMessageWithContent:customContent username:user1];

       
       NSLog(@"-----单聊－clickSendCustomMSG-message:%@",cutMessage);

    [cutMessage setFromName:@"custom setFromName :"];
    _myJMSGUser = [JMSGUser myInfo];
       
       [JMSGMessage sendMessage:cutMessage];
//       [_myJMSGConversation sendMessage:cutMessage];
       NSLog(@"------发送的custom：%@",cutMessage);

//   }];
 }


- (IBAction)clickRepeatSendText:(id)sender {
    [self initUserContent];
    self.sendTimeTF.enabled =YES;
    NSString *sendTimesString = self.sendTimeTF.text;
    sendTimes = [sendTimesString integerValue];

            for (int i = 1; i<=sendTimes; i++) {
                [self initUserContent];//初始化本页面的文本框
                [self curTimeValue];//获取一下当前时间
                
                _myJMSGUser =  [JMSGUser myInfo];
                NSString *sendContent = [NSString stringWithFormat:@"本消息由[%@]发至[%@]:--%d--%@,%@",  [_myJMSGUser username],user1,i,contentText,curTime];//把用户输入的内容和
                
                
                
                [JMessage removeAllDelegates];
                [JMessage addDelegate:self withConversation:nil];
//                NSLog(@"-----循环发送按钮这里添加了delegate");
                NSLog(@"------单聊－RepeatSendText，发送消息：%@",sendContent);
                [JMSGMessage sendSingleTextMessage:sendContent toUser:user1];
                sleep(1.5);

            }

}

//调用相册
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self initUserContent];
    //先把图片转成NSData（注意图片的格式）
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *picData = UIImagePNGRepresentation(image);;
    [self dismissViewControllerAnimated:YES completion:nil];
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
    NSLog(@"-----发送图片页面添加了delegate");


    [JMSGMessage sendSingleImageMessage:picData toUser:user1];//调用单聊发图接口发送从相册里面选择的图片
   }

- (IBAction)clickSendImag:(id)sender {
    //打开显示相册控件
    UIImagePickerController *imgController = [[UIImagePickerController alloc]init];
    imgController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgController.delegate = self;
    [self presentViewController:imgController animated:YES completion:NULL];
    
    return;
    

}
- (IBAction)clickSendVoice:(id)sender {
}
- (IBAction)clickClearTV:(id)sender {
    [_textview setText:@"/"];


}
- (IBAction)clickDelSingleConversation:(id)sender {
    [self initUserContent];
    [ JMSGConversation deleteSingleConversationWithUsername:user1];
}
- (IBAction)clickAllMessage:(id)sender {
    [_myJMSGConversation allMessages:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"----single--获取此会话的消息失败～");
        }
        NSString *groupAllMessage = [NSString stringWithFormat:@"%@",resultObject];
        [_textview setText:groupAllMessage];
        NSLog(@"---single---获取到当前会话的所有消息如下：%@",groupAllMessage);
    }];
}
- (IBAction)clickClearReadCount:(id)sender {
    if (_myJMSGConversation) {
        [_myJMSGConversation clearUnreadCount];
        self.unReadCountTF.enabled = YES;
        self.unReadCountTF.text =[NSString stringWithFormat:@"未读数：%@", [_myJMSGConversation unreadCount]];
        NSLog(@"----－－－messageViewControlle--clickClearReadCount-当前会话的未读数：%@",  _myJMSGConversation.unreadCount);

    }
    else{
        NSLog(@"-clickClearReadCount:尚未获取到会话!");
        
    }
//    [_message updateFlag:@(1)];
//    NSLog(@"----－－－当前flag：%@",  _message.flag);


}

-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    if (error!=nil) {
        NSLog(@"---single--onReceiveMessage error is %@",error);
    }else{
        //自定义事件代码
        if(message.contentType == 5){
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
                    singlePageAlertText = [NSString stringWithFormat:@"[%@]创建了群，群成员有:%@",fromUsername,[toUsernameList componentsJoinedByString:@","]];
                    [self showAlert:singlePageAlertText];
                    break;
                    
                case 9:
                    singlePageAlertText = [NSString stringWithFormat:@"[%@]退出了群",fromUsername];
                    [self showAlert:singlePageAlertText];
                    break;
                    
                case 10:
                    singlePageAlertText = [NSString stringWithFormat:@"[%@ ]邀请了［%@］进群",fromUsername,[toUsernameList componentsJoinedByString:@","]];
                    [self showAlert:singlePageAlertText];
                    break;
                    
                case 11:
                    singlePageAlertText = [NSString stringWithFormat:@"[%@ ]把［%@］移出了群",fromUsername,[toUsernameList componentsJoinedByString:@","]];
                    [self showAlert:singlePageAlertText];
                    break;
                    
                case 12:
                    singlePageAlertText = [NSString stringWithFormat:@"[%@ ]更新了群信息",fromUsername];
                    [self showAlert:singlePageAlertText];
                    break;
                    
                default:
                    singlePageAlertText = [NSString stringWithFormat:@"未知群事件：%ld",eventType];
                    [self showAlert:singlePageAlertText];
                    
            }
            return;
        }

        
    _message = message;
        id MessageTarget = _message.target ;
        if ([MessageTarget isKindOfClass:[JMSGUser class]]) {
//            _myJMSGConversation=   [JMSGConversation singleConversationWithUsername:_message.fromUser.username appKey:_message.fromAppKey];
            
            NSString *onReceiveMessage = [NSString stringWithFormat:@"收到im消息：%@",message];
            [_textview setText:onReceiveMessage];
            unReadCount = [NSString stringWithFormat:@"未读数：%@",_myJMSGConversation.unreadCount];
            self.unReadCountTF.enabled=YES;
            self.unReadCountTF.text = unReadCount;
            NSLog(@"----single---1onReceiveMessage :%@",message);

            NSLog(@"----－－－2messageViewController-onReceiveMessage当前会话的未读数：%@",  _myJMSGConversation.unreadCount);
            //        NSLog(@"----messageViewController－－－收到的消息转成jsonString：%@",  [_message toJsonString]);
            
            //    NSLog(@"--－－messageViewController－－isEqualToMessage:%d",[_myJMSGMessage isEqualToMessage:message]);
            
            //    NSLog(@"-----messageViewController--onReceiveMessage: 收到消息的targetAppkey（%@）,fromAppkey（%@）\n",_message.targetAppKey,_message.fromAppKey) ;
            
//            NSLog(@"-----3messageViewController-判断本消息的fromAppKey(%@)是否为当前集成使用的appkey：%d\n",message.fromAppKey,[JMessage isMainAppKey:_message.fromAppKey]) ;
            return;
        }
        else  if ([MessageTarget isKindOfClass:[JMSGGroup class]]){
            JMSGGroup * group = MessageTarget;
            
            _myJMSGConversation=   [JMSGConversation groupConversationWithGroupId: group.gid];
            
            NSLog(@"----single---1onReceiveMessage :%@",message);
            NSString *onReceiveMessage = [NSString stringWithFormat:@"收到im消息：%@",message];
            [_textview setText:onReceiveMessage];
            unReadCount = [NSString stringWithFormat:@"未读数：%@",_myJMSGConversation.unreadCount];
            self.unReadCountTF.enabled=YES;
            self.unReadCountTF.text = unReadCount;
            NSLog(@"----－－－2messageViewController-onReceiveMessage当前会话的未读数：%@",  _myJMSGConversation.unreadCount);
            //        NSLog(@"----messageViewController－－－收到的消息转成jsonString：%@",  [_message toJsonString]);
            
            //    NSLog(@"--－－messageViewController－－isEqualToMessage:%d",[_myJMSGMessage isEqualToMessage:message]);
            
            //    NSLog(@"-----messageViewController--onReceiveMessage: 收到消息的targetAppkey（%@）,fromAppkey（%@）\n",_message.targetAppKey,_message.fromAppKey) ;
            
//            NSLog(@"-----3messageViewController-判断本消息的fromAppKey(%@)是否为当前集成使用的appkey：%d,\n",message.fromAppKey,[JMessage isMainAppKey:_message.fromAppKey]) ;
            return;

        }

        }
      
}

-(void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    if (error!=nil) {
        NSLog(@"---single--onSendMessageResponse error is %@，message：%@",error,message);
        return ;
    }
    _myJMSGMessage = message;
    NSLog(@"---single----im onSendMessageResponse 发送结果:%@",message);
    NSString *onSendMessageResponse = [NSString stringWithFormat:@"发送im消息：%@",message];

    [_textview setText:onSendMessageResponse];
}

-(void )onReceiveMessageDownloadFailed:(JMSGMessage *)message{
    _message = message;
    NSLog(@"---single----im onReceiveMessageDownloadFailed :%@",message);
    singleMessage = [NSString stringWithFormat:@"%@",_message];
    [_textview setText:singleMessage];
    NSLog(@"----single---onConversationChanged:%@",singleMessage);

}
-(void)onGroupInfoChanged:(JMSGGroup *)group{
    NSLog(@"-----single--onGroupInfoChanged:%@",group);
}
-(void)onConversationChanged:(JMSGConversation *)conversation{
    _myJMSGConversation = conversation;
    NSLog(@"-----single--onConversationChanged，conversation:%@",conversation);
    singleMessage = [NSString stringWithFormat:@"%@",conversation];
    [_textview setText:singleMessage];
    NSLog(@"-----single--onConversationChanged，singleMessage:%@",singleMessage);

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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"-------进入了消息页:messageViewController");
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
}

@end
