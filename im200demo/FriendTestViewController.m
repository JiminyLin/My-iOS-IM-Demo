//
//  FriendViewController.m
//  im213qptXCTest
//
//  Created by LinGuangzhen on 9/5/16.
//  Copyright © 2016 LinGuangzhen. All rights reserved.
//

#import "FriendTestViewController.h"
#import <JMessage/JMessage.h>

@interface FriendTestViewController ()<JMessageDelegate>
{
    NSString *appkey;
    NSString *reason;
    NSString *_curTimeV;
    NSString *userName;
    NSString *noteName;
    NSString *noteMsg;
    NSString *friendAlertText;
    
    NSArray *friendList;

     NSArray *userList;
    NSArray *jMSGUserList;

    
}

- (IBAction)clickAddFriend:(id)sender;
- (IBAction)clickDelFriend:(id)sender;
- (IBAction)clickGetFriendList:(id)sender;
- (IBAction)clickAgreeAddFriendRequest:(id)sender;
- (IBAction)clickRejectFriendRequest:(id)sender;
- (IBAction)clickGetFriendStatus:(id)sender;
- (IBAction)clickGetFriendNoteName:(id)sender;
- (IBAction)clickSetFriendNoteName:(id)sender;
- (IBAction)clickSetFriendNoteMsg:(id)sender;


@property (strong ,nonatomic )JMSGMessage * friendJMessage;
@property (strong ,nonatomic )JMSGUser * friendJMSGUser;
@property (strong ,nonatomic )JMSGUser  *friendUser;
//@property (strong ,nonatomic )JMSGFriendEventContent *friendJMSGFriendEventContent;

@end

@implementation FriendTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //页面跳转
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< 全平台" style:UIBarButtonItemStylePlain target:self action:@selector(morePage)];
    
    
    NSLog(@"-------进入了FriendViewController 页面！");
    //隐藏键盘，star
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    //隐藏键盘，end
    
}

//页面跳转
-(void)morePage{
    [self.navigationController  popViewControllerAnimated:YES];
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
    
    [self.userTV resignFirstResponder];
    [self.noteMsgTV resignFirstResponder];
    [self.noteNameTV resignFirstResponder];
    [self.appkeyTV resignFirstResponder];
    [self.reasionTV resignFirstResponder];
    
}
-(void )initTv{
    self.userTV.enabled = YES;
    userName = self.userTV.text;
    
    userList = [[NSArray alloc] initWithObjects:
                userName,nil];
    
    self.noteNameTV.enabled = YES;
    noteName = self.noteNameTV.text;
    
    
    self.noteMsgTV.enabled = YES;
    noteMsg= self.noteMsgTV.text;
    
    self.reasionTV.enabled = YES;
    reason= self.reasionTV.text;
    
    self.appkeyTV.enabled = YES;
    appkey= self.appkeyTV.text;
    
}

-(void)curTimeValue{
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式:
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy年MM月dd日 HH小时mm分ss秒"];
    _curTimeV = [df stringFromDate:currentDate];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickAddFriend:(id)sender {
    [self initTv];
    [self curTimeValue];
[JMSGFriendManager sendInvitationRequestWithUsername:userName appKey:appkey reason:reason completionHandler:^(id resultObject, NSError *error) {
    if (error ) {
        NSLog(@"----发起添加好友[appkey:%@，用户:%@]失败，error:%@",appkey,userName,error);
        return ;
    }
    NSLog(@"----发起添加好友[appkey:%@，用户:%@]成功，resultObject:%@",appkey,userName,resultObject);
    
} ];
}

- (IBAction)clickDelFriend:(id)sender {
    [self initTv];
    [self curTimeValue];
    
    [JMSGFriendManager removeFriendWithUsername:userName appKey:appkey completionHandler:^(id resultObject, NSError *error) {
        if (error ) {
            NSLog(@"----删除好友[appkey:%@，用户:%@]失败，error:%@",appkey,userName,error);
            return ;
        }
        NSLog(@"----删除好友[appkey:%@，用户:%@]成功，resultObject:%@",appkey,userName,resultObject);
    }];
}

- (IBAction)clickGetFriendList:(id)sender {
    [self initTv];
    [self curTimeValue];
    
    JMSGUser *userTest = nil;
   
    NSLog(@"----user对象为nil，nikename:%@",userTest.nickname) ;
    [JMSGFriendManager getFriendList:^(id resultObject, NSError *error) {
            if (error ) {
                NSString *getFriendListError = [NSString stringWithFormat:@"----获取好友list 失败，error:%@",error];
                NSLog(@"----获取好友list 失败，error:%@",error);
                return ;
            }
            NSLog(@"----获取好友list 成功，resultObject:%@",resultObject);

     
    }];
}

- (IBAction)clickAgreeAddFriendRequest:(id)sender {
    [self initTv];
    [self curTimeValue];
    NSLog(@"----准备--同意[appkey:%@，用户:%@]的好友请求",appkey,userName);

    [JMSGFriendManager acceptInvitationWithUsername:userName appKey:appkey completionHandler:^(id resultObject, NSError *error) {
            if (error ) {
            NSLog(@"----同意[appkey:%@，用户:%@]的好友请求失败，error:%@",appkey,userName,error);
            return ;
        }
        NSLog(@"----同意[appkey:%@，用户:%@]的好友请求成功，resultObject:%@",appkey,userName,resultObject);

    }];
    
}

- (IBAction)clickRejectFriendRequest:(id)sender {
    [self initTv];
    [self curTimeValue];
    NSLog(@"----准备--拒绝[appkey:%@，用户:%@]的好友请求",appkey,userName);

   [ JMSGFriendManager rejectInvitationWithUsername:userName appKey:appkey reason:reason completionHandler:^(id resultObject, NSError *error) {
                if (error ) {
            NSLog(@"----拒绝[appkey:%@，用户:%@]的好友请求失败，error:%@",appkey,userName,error);
            return ;
        }
        NSLog(@"----拒绝[appkey:%@，用户:%@]的好友请求成功，resultObject:%@",appkey,userName,resultObject);
        
    }];

}

- (IBAction)clickGetFriendStatus:(id)sender {
    [self initTv];
    [self curTimeValue];
    NSLog(@"----准备开始获取用户信息，用于获取用户好友状态。");
      [JMSGUser  userInfoArrayWithUsernameArray:userList appKey:appkey completionHandler:^(id resultObject, NSError *error) {
          if (error ) {
              NSLog(@"----准备获取[appkey:%@，用户:%@]的好友状态，用户信息获取失败，error:%@",appkey,userName,error);
              return ;
          }

          jMSGUserList = resultObject;
         _friendUser = jMSGUserList[0];
          NSLog(@"----准备获取[appkey:%@，用户:%@]的好友状态，用户信息获取成功，\n resultObject:%@,\n好友状态为:%d",appkey,userName,resultObject,_friendUser.isFriend);
          
      }];
    
    NSLog(@"---_friendUser:%@",_friendUser);
        if (_friendUser.isFriend) {
            NSLog(@"是朋友！－－－：%d",_friendUser.isFriend);
        }
        else{
            NSLog(@"不是朋友！－－－：%d",_friendUser.isFriend);
        }
    _friendUser =  nil;
}

- (IBAction)clickGetFriendNoteName:(id)sender {
    [self initTv];
    [self curTimeValue];
    
    [JMSGUser  userInfoArrayWithUsernameArray:userList appKey:appkey completionHandler:^(id resultObject, NSError *error) {
        if (error ) {
            NSLog(@"----准备获取[appkey:%@，用户:%@]的好友备注名与备注信息，用户信息获取失败，error:%@",appkey,userName,error);
            return ;
        }
        
        jMSGUserList = resultObject;
        _friendJMSGUser = jMSGUserList[0];
        
        NSLog(@"----准备获取[appkey:%@，用户:%@]的 备注名与备注信息，用户信息获取成功，\nresultObject:%@,\n好友备注名为:%@，\n备注信息:%@ ",appkey,userName,resultObject,_friendJMSGUser.noteName,_friendJMSGUser.noteText);
       
        
    }];
    
}

- (IBAction)clickSetFriendNoteName:(id)sender {
    [self initTv];
    [self curTimeValue];
    [JMSGUser  userInfoArrayWithUsernameArray:userList appKey:appkey completionHandler:^(id resultObject, NSError *error) {
        if (error ) {
            NSLog(@"----准备设置[appkey:%@，用户:%@]的好友备注名，用户信息获取失败，error:%@",appkey,userName,error);
            return ;
        }
        
        jMSGUserList = resultObject;
        _friendJMSGUser = jMSGUserList[0];
        
        NSLog(@"----准备设置[appkey:%@，用户:%@]的 备注名，用户信息获取成功，\nresultObject:%@",appkey,userName,resultObject);
        [_friendJMSGUser updateNoteName:noteName completionHandler:^(id resultObject, NSError *error) {
            if (error ) {
                NSLog(@"----更新[appkey:%@，用户:%@]的备注名失败，error:%@",appkey,userName,error);
                return ;
            }
            NSLog(@"----更新[appkey:%@，用户:%@]的备注名成功，resultObject:%@",appkey,userName,resultObject);

        }];
        
    }];

    
}

- (IBAction)clickSetFriendNoteMsg:(id)sender {
    [self initTv];
    [self curTimeValue];
    
    [JMSGUser  userInfoArrayWithUsernameArray:userList appKey:appkey completionHandler:^(id resultObject, NSError *error) {
        if (error ) {
            NSLog(@"----准备设置[appkey:%@，用户:%@]的好友备注信息，用户信息获取失败，error:%@",appkey,userName,error);
            return ;
        }
        jMSGUserList = resultObject;
        _friendJMSGUser = jMSGUserList[0];
        NSLog(@"----准备设置[appkey:%@，用户:%@]的 备注信息，用户信息获取成功，\nresultObject:%@",appkey,userName,resultObject);
        [_friendJMSGUser updateNoteText:noteMsg completionHandler:^(id resultObject, NSError *error) {
            if (error ) {
                NSLog(@"----更新[appkey:%@，用户:%@]的备注信息失败，error:%@",appkey,userName,error);
                return ;
            }
            NSLog(@"----更新[appkey:%@，用户:%@]的备注信息成功，resultObject:%@",appkey,userName,resultObject);
            
        }];
        
    }];
    

}



-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    if (error !=nil) {
        NSLog(@"－－－\n 好友管理onReceiveMessage，收到消息异常:%@",error);
        friendAlertText = [NSString stringWithFormat:@"收到消息，异常！\n%@",error];
        [self showAlert:friendAlertText ];
        
        return;
    }
    //展示默认事件信息
    //    if (message.contentType == kJMSGContentTypeEventNotification) {
    //        NSString *showText = [((JMSGEventContent *)message.content) showEventNotification];
    //        [self showAlert:showText];
    //        NSLog(@"－－－:%@",showText);
    //
    //    }
    _friendJMessage = message;
    
    NSLog(@"－－－\n 好友管理--onReceiveMessage，成功收到消息！_disJMessage:%@",_friendJMessage);
    //
    //    //自定义事件代码
    if(_friendJMessage.contentType == 5){
        JMSGEventContent *eventContent = (JMSGEventContent *)_friendJMessage.content;
        //获取发起事件的用户名
        NSString *fromUsername = [eventContent getEventFromUsername];
        //获取事件作用对象用户名列表
        NSArray *toUsernameList = [eventContent getEventToUsernameList];
        
        //根据事件类型，定制相应描述（以事件类型: 添加新成员为例子）
        long eventType = eventContent.eventType;
        NSLog(@"------fromUsername:%@,\ntoUsernameList:%@",fromUsername,toUsernameList);
        
        
        switch(eventType)
        {
            case 8:
                friendAlertText  = [NSString stringWithFormat:@"[%@]创建了群，群成员有:%@",fromUsername,[toUsernameList componentsJoinedByString:@","]];
                [self showAlert:friendAlertText ];
                break;
                
            case 9:
                friendAlertText  = [NSString stringWithFormat:@"[%@]退出了群",fromUsername];
                [self showAlert:friendAlertText ];
                break;
                
            case 10:
                friendAlertText  = [NSString stringWithFormat:@"[%@ ]邀请了［%@］进群",fromUsername,[toUsernameList componentsJoinedByString:@","]];
                [self showAlert:friendAlertText ];
                break;
                
            case 11:
                friendAlertText  = [NSString stringWithFormat:@"[%@ ]把［%@］移出了群",fromUsername,[toUsernameList componentsJoinedByString:@","]];
                [self showAlert:friendAlertText ];
                break;
                
            case 12:
                friendAlertText  = [NSString stringWithFormat:@"[%@ ]更新了群信息",fromUsername];
                [self showAlert:friendAlertText ];
                break;
                
            default:
                friendAlertText  = [NSString stringWithFormat:@"未知群事件:%ld",eventType];
                [self showAlert:friendAlertText ];
                
        }
        return;
    }
    //
    friendAlertText  = [NSString stringWithFormat:@"收到消息！\n%@",message];
    [self showAlert:friendAlertText ];
    
    
}

-(void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event{
    JMSGNotificationEvent *nEvent = event;
    NSLog(@"---------friend--onReceiveNotificationEvent收到 通知事件");
    
    //    if ([event isKindOfClass:[JMSGFriendNotificationEvent class]]) {
    //        JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
    //        [friendEvent getReason];
    //    }
    
    switch (nEvent.eventType) {
        case  kJMSGEventNotificationFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------friend--onReceiveNotificationEvent收到 好友邀请相关 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
            
        }
            break;
            
        case  kJMSGEventNotificationReceiveFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------friend--onReceiveNotificationEvent收到 好友邀请 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
        }
            break;
            
        case  kJMSGEventNotificationAcceptedFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------friend--onReceiveNotificationEvent收到 同意添加好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);        }
            break;
            
        case  kJMSGEventNotificationDeclinedFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------friend--onReceiveNotificationEvent收到 拒绝好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
        }
            break;
            
        case  kJMSGEventNotificationDeletedFriend:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            NSLog(@"---------friend--onReceiveNotificationEvent收到 删除好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
            
        }
            
            break;
            
        case  kJMSGEventNotificationLoginKicked:
            NSLog(@"---------friend--onReceiveNotificationEvent收到 多设备登陆被t 通知事件，描述：%@",nEvent.eventDescription);
            break;
        case  kJMSGEventNotificationServerAlterPassword:
            NSLog(@"---------friend--onReceiveNotificationEvent收到 非客户端修改密码被t 通知事件，描述：%@",nEvent.eventDescription);
            break;
        case  kJMSGEventNotificationUserLoginStatusUnexpected:
            NSLog(@"---------friend--onReceiveNotificationEvent收到 Juid变更导致下线的 事件，描述：%@",nEvent.eventDescription);
            break;
        case  kJMSGEventNotificationReceiveServerFriendUpdate:
            NSLog(@"---------friend聊--onReceiveNotificationEvent收到 服务端变更好友相关 事件，描述：%@",nEvent.eventDescription);
            break;
        default:
            NSLog(@"---------friend--onReceiveNotificationEvent收到 未知事件类型，描述：%@",nEvent.eventDescription);
            break;
    }
}

-(void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    if (error !=nil) {
        NSLog(@"－－－\n 好友管理onSendMessageResponse，发送消息失败:%@",error);
        friendAlertText  = [NSString stringWithFormat:@"发送消息失败！\n%@",error];
        [self showAlert:friendAlertText ];
    }else {
        NSLog(@"－－－\n 好友管理onSendMessageResponse，发送消息成功！messge:%@",message);
        _friendJMessage = message;
        friendAlertText  = [NSString stringWithFormat:@"发送消息成功！\n%@",_friendJMessage.serverMessageId];
        [self showAlert:friendAlertText ];
    }
}

-(void)onReceiveMessageDownloadFailed:(JMSGMessage *)message{
    
    NSLog(@"-----好友管理 --onReceiveMessageDownloadFailed收到消息下载失败,----message:%@\n",message);
    friendAlertText  = [NSString stringWithFormat:@"收到消息下载失败！\n%@",message];
    [self showAlert:friendAlertText ];
    
}

-(void)onGroupInfoChanged:(JMSGGroup *)group{
    NSLog(@"----好友管理--onGroupInfoChanged:%@\n",group);
    
    
}

-(void)onConversationChanged:(JMSGConversation *)conversation{
    NSLog(@"---好友管理---onConversationChanged:%@\n",conversation);
}

-(void)onUnreadChanged:(NSUInteger)newCount{
    NSLog(@"----好友管理---onUnreadChanged:%lu\n",(unsigned long)newCount);
}

//220b90及之前的220获取好友事件的方法
//-(void)onFriendChanged:(JMSGFriendEventContent *)event{
//    _friendJMSGFriendEventContent = event;
//    NSLog(@"----好友管理---onFriendChanged:%@\n",event);
//    NSLog(@"----好友管理---onFriendChanged:{\n好友通知事件类型:%ld,\n获取事件发生的理由:%@,\n事件发送者的username:%@,\n获取事件发送者user:%@",_friendJMSGFriendEventContent.eventType,[_friendJMSGFriendEventContent getReason],[_friendJMSGFriendEventContent getFromUsername],[_friendJMSGFriendEventContent getFromUser]);
//
//}

-(void)onLoginUserKicked{
    NSLog(@"-----好友管理--onLoginUserKicked－－－\n --你被踢下线了！\n");
    friendAlertText  = [NSString stringWithFormat:@"此账号已在其他地方登陆，你已下线！"];
    [self showAlert:friendAlertText ];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"-------进入了好友页");
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
}
@end


