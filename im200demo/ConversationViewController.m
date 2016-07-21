//
//  ConversationViewController.m
//  im200demo
//
//  Created by LinGuangzhen on 15/11/6.
//  Copyright © 2015年 LinGuangzhen. All rights reserved.
//

#import "ConversationViewController.h"
#import <JMessage/JMessage.h>

@interface ConversationViewController ()<JMessageDelegate>
{
    
    NSString *_curTimeV;
    NSString *_covUserNameV;
    NSString *_covGroupIdV;
    NSString *_covJMsgIdV;
    NSString *_covShow;
    NSString *_covUnReadCount;
    NSNumber *_covUnreadCount_value;
    
    NSArray *_covList;
    
}
@property(strong,nonatomic)    UITextView *covAllShowTV;

@property (strong ,nonatomic )JMSGMessage * covJMessage;
@property  (strong ,nonatomic)JMSGConversation *covConversation;
@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"-------进入了Conversation 页面！");
    //隐藏键盘，star
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    //隐藏键盘，end
    _covAllShowTV = [[UITextView alloc] initWithFrame: CGRectMake(0, 255, 360, 140) ];
    _covAllShowTV.backgroundColor = [UIColor blueColor ];
    [self.view addSubview:_covAllShowTV];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< 全平台" style:UIBarButtonItemStylePlain target:self action:@selector(morePage)];


}

-(void)morePage{
    [self.navigationController  popViewControllerAnimated:YES];
}
//指定要隐藏键盘的控件
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
 
    [self.covAllShowTV resignFirstResponder];
    [self.covGroupID resignFirstResponder];
    [self.covJMsgID resignFirstResponder];
    [self.covLimit resignFirstResponder];
    [self.covOffSet resignFirstResponder];
    [self.covUser resignFirstResponder];
}
-(void )initTv{
    self.covUser.enabled = YES;
    _covUserNameV = self.covUser.text;
    NSLog(@"---_covUserNameV:%@" , _covUserNameV);
    
    self.covGroupID.enabled = YES;
    _covGroupIdV = self.covGroupID.text;
    NSLog(@"---covGroupIDV :%@" , _covGroupID);

    
    self.covJMsgID.enabled = YES;
    _covJMsgIdV = self.covJMsgID.text;
    
    
}
-(void)curTimeValue{
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy年MM月dd日 HH小时mm分ss秒"];
    _curTimeV = [df stringFromDate:currentDate];
    
}

-(void)getCovByUserName{
    NSLog(@"---getCovByUserName");

    [self initTv];
    _covConversation = [JMSGConversation singleConversationWithUsername: _covUserNameV];

    NSString *st= [NSString stringWithFormat:@"%@",_covConversation];
    NSLog(@"-----获取(%@)的会话：%@", _covUserNameV,st);
//    _covConversation = [JMSGConversation singleConversationWithUsername: _covUserNameV];
//    
//    _covUnreadCount_value = _covConversation.unreadCount;
//    NSLog(@"－－－获取与%@ 的会话：\n%@,\n--未读数:%@",_covUserNameV, st,_covUnreadCount_value);
}
- (IBAction)clickSearchCovByUser:(id)sender {
    [self getCovByUserName];
}

-(void)createSingleCovByUser{
    NSLog(@"---createSingleCovByUser");
    [self initTv];
    [JMSGConversation createSingleConversationWithUsername:_covUserNameV completionHandler:^(id resultObject, NSError *error) {
        if (error != nil) {
//            [self getLastMsg];
                       NSLog(@"--------创建与 %@  的会话失败！－－error：%@,---Result:%@",_covUserNameV,error,resultObject);
            _covShow = [NSString stringWithFormat:@"--------创建与 %@  的会话失败，－－error：%@,---Result:%@",_covUserNameV,error,resultObject];
            [_covAllShowTV setText:_covShow];
            
        }
        else{
            NSLog(@"--------创建与 %@  的会话成功！---Result:%@",_covUserNameV,resultObject);

            _covConversation = resultObject;
            [JMessage removeAllDelegates];
            [JMessage addDelegate:self withConversation:nil];
            
             _covShow = [NSString stringWithFormat:@"--------创建与 %@  的会话成功！---Result:%@",_covUserNameV,resultObject];
            [_covAllShowTV setText:_covShow];
            
        }
    }];

}
- (IBAction)clickCreateSingleCovByUser:(id)sender {
    [self createSingleCovByUser];
    }

- (IBAction)clickDelCovByUser:(id)sender {
    NSLog(@"---clickDelCovByUser");

    [self initTv];
    [JMSGConversation deleteSingleConversationWithUsername:_covUserNameV];
    NSLog(@"------删除与［%@］的会话",_covUserNameV);
    
}

-(void)getCovByGid{
    [self initTv];
    _covConversation = [JMSGConversation groupConversationWithGroupId:_covGroupIdV];
    NSLog(@"－－－获取群［%@］的会话：%@",_covGroupIdV, _covConversation);

}
- (IBAction)clickGetCovByGroupID:(id)sender {
    NSLog(@"---clickGetCovByGroupID");

    [self getCovByGid];
}

- (IBAction)clickCreateCovByGroupID:(id)sender {
    NSLog(@"---clickCreateCovByGroupID");

        [self initTv];
    [JMSGConversation createGroupConversationWithGroupId:_covGroupIdV completionHandler:^(id resultObject, NSError *error) {
        if (error != nil) {
            
            
            [JMessage removeAllDelegates];
            [JMessage addDelegate:self withConversation:nil];
            _covShow = [NSString stringWithFormat:@"－－－－创建群ID［%@］的会话,失败！－－－－error：%@,－－－result：%@",_covGroupIdV,error,resultObject];
            [_covAllShowTV setText:_covShow];
            NSLog(@"%@",_covShow);
        }
        else{
            _covConversation = resultObject;

            _covShow = [NSString stringWithFormat:@"－－－－创建群ID［%@］的会话，成功！--Result: %@",_covGroupIdV,resultObject];
            [_covAllShowTV setText:_covShow];
            NSLog(@"%@",_covShow);
        }
    }];
}
- (IBAction)clickDelCovByGroupID:(id)sender {
    NSLog(@"---clickDelCovByGroupID");

        [self initTv];
    [JMSGConversation deleteGroupConversationWithGroupId:_covGroupIdV];
    NSLog(@"------删除群［%@］的会话",_covGroupIdV);

}
- (IBAction)clickGetMessageByMSGID:(id)sender {
    NSLog(@"---clickGetMessageByMSGID");

    [self initTv];

    _covShow = [NSString stringWithFormat:@"－－－获取 %@ 会话中某msgid的内容：%@",_covUserNameV, [_covConversation messageWithMessageId:_covJMsgIdV]];

    [_covAllShowTV setText:_covShow];
    NSLog(@"%@",_covShow);
}
- (IBAction)clickClearUnreadCount:(id)sender {
    if(_covConversation){
    [_covConversation clearUnreadCount];
        NSLog(@"－－－重置了未读数");
        return;
    }
    NSLog(@"－－－尚未创建会话，无法重置未读数");

}

-(void) getSomeBodyCov:(NSString*)userNameOrGroupId{
    NSLog(@"---getSomeBodyCov");

    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"-------获取会话列表失败，error：%@,--result:%@", error , resultObject);
            return ;
        }
        
        if (error ==nil) {
            NSLog(@"－－－－成功获取所有会话列表：%@",resultObject);
            _covList = resultObject;
            NSLog(@"----[_covList count ] %ld",(unsigned long)[_covList count ] );
            if ( [_covList count ] > 0) {
                for (int i = 0; i< [_covList count]; i++) {
              
                    JMSGConversation *cov =_covList[i];
                    id target = cov.target;
                    if ([target isKindOfClass:[JMSGUser class]] ) {
                        JMSGUser *user = target;
                        if ([user.username isEqualToString:userNameOrGroupId]) {
                            NSLog(@"－－user－会话［%d］属于［%@］的会话！", i,userNameOrGroupId);

                            _covConversation = _covList[i];
                            [self messageArrayFromNewestWithOffset];

                            
                        } else {
                            NSLog(@"－－user－会话［%d］不属于［%@］的会话！", i,userNameOrGroupId);
                        }

                        
                    } else if ([target isKindOfClass:[JMSGGroup class]]) {
                        JMSGGroup *group = target;

                        NSLog(@"---group.gid :%@，－userNameOrGroupId：%@", group.gid, userNameOrGroupId);
                        if ([(NSString *)group.gid isEqualToString:userNameOrGroupId]) {
                            NSLog(@"if it is come in");
                            NSLog(@"－－－会话［%d］属于［%@］的会话！",i,userNameOrGroupId);

                            _covConversation = _covList[i];
                            [self messageArrayFromNewestWithOffset];

                            
                        } else {
                            NSLog(@"－－－会话［%d］不属于［%@］的会话！",i,userNameOrGroupId);
                        }
                    }
                    
                    
                    
                }
                
            }  else{
                NSLog(@"－－－当前用户 没有任何会话！！放弃获取会话最后一个记录的动作！");
            }
            
        } else{
            NSLog(@"－－－当前用户的所有会话失败！");
        }
    }];
}


-(void)messageArrayFromNewestWithOffset{

    self.covOffSet.enabled = YES;
    NSString * offSetNsstring = self.covOffSet.text ;
    int offSetInt = [offSetNsstring intValue];
    NSNumber *offSetNsnuber = [[NSNumber alloc] initWithInt:offSetInt];
    
    self.covLimit.enabled = YES;
    NSString *limitNsstring = self.covLimit.text;
    int limitInt = [limitNsstring intValue];
    NSNumber *limitNsnuber = [[NSNumber alloc] initWithInt:limitInt];
    NSLog(@"-------messageArrayFromNewestWithOffset-,从%@开始的 %@ 条记录如下：%@",offSetNsnuber,limitNsnuber,[_covConversation messageArrayFromNewestWithOffset:offSetNsnuber limit:limitNsnuber]);
}
- (IBAction)clickSearchSomeMessage:(id)sender {
    NSLog(@"---clickSearchSomeMessage");

    [self initTv];

    [self getSomeBodyCov:_covUserNameV];

 }
- (IBAction)clickGetAllMSG:(id)sender {
    NSLog(@"---clickGetAllMSG");

    NSString * convInfo = [NSString stringWithFormat:@"%@",_covConversation];

    NSLog(@"------clickGetAllMSG当前会话：%@",convInfo);
    if (_covConversation !=nil) {
  
    [_covConversation allMessages:^(id resultObject, NSError *error) {
        if (error == nil) {
            _covShow = [NSString stringWithFormat:@"－－clickGetAllMSG－成功获取到当前会话的所有消息：%@",resultObject];
            [_covAllShowTV setText:_covShow];
            NSLog(@"%@",_covShow);
        }
        else {
            _covShow = [NSString stringWithFormat:@"－－－clickGetAllMSG获取到当前会话的所有消息失败！－－error：%@，－－result：%@",error,resultObject];
            [_covAllShowTV setText:_covShow];
            NSLog(@"%@",_covShow);

        }
    }];
        
    }
    else{
        NSLog(@"---covConversation is nil!!!不去获取当前会话的全部消息");
    }
}
- (IBAction)clickDelAllMsg:(id)sender {
//    NSLog(@"--当前会话：%@",_covConversation);
    [_covConversation deleteAllMessages];
    
    NSLog(@"－－－－删除[%@]会话的所有消息！",_covConversation.target);
}
- (IBAction)clickGetLastMSG:(id)sender {

    NSLog(@"----clickGetLastMSG: %@"  ,  [_covConversation latestMessage]);
    NSLog(@"----clickGetLastMSGlatestMessageContentText: %@"  ,  _covConversation.latestMessageContentText);

//    NSLog(@"\n－－－准备开始获取当前会话的最后一个消息！");
//    [self initTv];
//    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
//        if (error != nil) {
//            NSLog(@"-------获取会话列表失败，error：%@,--result:%@", error , resultObject);
//            return ;
//        }
//        NSLog(@"－－－－成功获取所有会话列表：%@",resultObject);
//        _covList = resultObject;
//        NSLog(@"----[_covList count ] %ld",[_covList count ] );
//        int a =0;
//        if ( [_covList count ] > 0) {
//            for (int i = 0; i< [_covList count]; i++) {
//                
//                JMSGConversation *cov =_covList[i];
//                id target = cov.target;
//                if ([target isKindOfClass:[JMSGUser class]] ) {
//                    JMSGUser *user = target;
//                    if ([user.username isEqualToString:_covUserNameV]) {
//                        NSLog(@"－－－－user－单聊会话［%d］：%@ 属于［%@］的会话！", i , user.username , _covUserNameV);
//                        
//                        _covConversation = _covList[i];
//                        _covShow = [NSString stringWithFormat:@"---->用户［%@］会话的最后一个消息记录是：%@,\n此消息的文本内容：%@" , _covUserNameV ,  [_covConversation latestMessage] , [_covConversation latestMessageContentText]];
//                        NSLog(@"%@",_covShow);
//                        [_covAllShowTV setText:_covShow];
//                        
//                    } else {
////                        NSLog(@"－－user－会话［%d］:( %@ )不属于［%@］的会话！", i ,user.username , _covUserNameV);
//                        a = a + 1;
//                    }
//                    
//                    
//                } else if ([target isKindOfClass:[JMSGGroup class]]) {
//                    JMSGGroup *group = target;
//                    
////                    NSLog(@"---group.gid :%@，－userNameOrGroupId：%@", group.gid, _covUserNameV);
//                    if ([(NSString *)group.gid isEqualToString:_covUserNameV]) {
////                        NSLog(@"if it is come in");
//                        NSLog(@"  >>二级信息打印：群会话［%d］:( %@) 属于［%@］的会话！", i , group.gid , _covUserNameV);
//                        
//                        _covConversation = _covList[i];
//                        _covShow = [NSString stringWithFormat:@"---->群会话［%@］的最后一个消息记录是：\n%@,\n文本内容是：\n%@" , _covUserNameV ,  [_covConversation latestMessage] , [_covConversation latestMessageContentText]];
//                        NSLog(@"%@",_covShow);
////                        [_covAllShowTV setText:_covShow];
//
//                    } else {
////                        NSLog(@"#####会话［%d］: (%@ )不属于［%@］的会话！",i , group.gid ,_covUserNameV);
//                        a = a+1;
//
//                    }
//                }
//                if (a == [_covList count ]) {
//                    NSLog(@"－－－当前用户没用与用户[%@]的聊天会话,放弃获取最后一条消息的动作！",_covUserNameV);
//                }
//            }
//
//        }  else{
//            NSLog(@"－－－当前用户 没有任何会话！！放弃获取会话最后一个记录的动作！");
//        }
//        
//    }];
    
}
-(void)getLastMsg{
    NSLog(@"－－getLastMsg－－当前会话的最后一条消息如下：%@", [_covConversation latestMessage]);
    
    NSLog(@"－－getLastMsg－－当前会话的最后一条消息文本：%@",[_covConversation latestMessageContentText]);
}
- (IBAction)clickRefreshMsgFromServer:(id)sender {
    NSLog(@"---clickRefreshMsgFromServer");

    [_covConversation refreshTargetInfoFromServer:^(id resultObject, NSError *error) {
        if (error == nil) {
            _covShow = [NSString stringWithFormat:@"－－－成功从服务器拉取会话信息：%@",resultObject];
            [_covAllShowTV setText:_covShow];
            NSLog(@"%@",_covShow);
        }
        else {
            _covShow = [NSString stringWithFormat:@"－－－从服务器拉取会话信息失败！－－error：%@，－－result：%@",error,resultObject];
            [_covAllShowTV setText:_covShow];
            NSLog(@"%@",_covShow);
        }
    }];

}


-(void)sendCovText{
       [self initTv];
    
    [self curTimeValue];
    NSLog(@"---sendCovText");

    if (_covConversation == nil) {
        NSLog(@"----conv 发送文本消息，发现会话尚未创建，请先创建会话！");
        return;
    }
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
    NSString *convText= [NSString stringWithFormat:@"会话页面要发送的文本内容.%@",_curTimeV];
    JMSGTextContent * convTextContent = [[JMSGTextContent alloc] initWithText:convText];
    [convTextContent addStringExtra:@"cov-Text-string value" forKey:@"cov-Text-string key"];
    [convTextContent addNumberExtra:[[NSNumber alloc]initWithInt:1 ] forKey:@"cov Text nsnumber key"];

    _covJMessage = [_covConversation createMessageWithContent:convTextContent ];
    [_covJMessage setFromName:@"covText发送者"];
    [_covConversation sendMessage:_covJMessage];


    NSLog(@"------conversation 页面，sendCovText，发送了文本消息:%@",convText);

}
- (IBAction)clicksendText:(id)sender {
      [self sendCovText];
 }
- (IBAction)clickSendImageMSG:(id)sender {
    NSLog(@"---clickSendImageMSG");

    //打开显示相册控件
    UIImagePickerController *imgController = [[UIImagePickerController alloc]init];
    imgController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgController.delegate = self;
    [self presentViewController:imgController animated:YES completion:NULL];
    
    return;
    
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self initTv];
    //先把图片转成NSData（注意图片的格式）
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *picData = UIImagePNGRepresentation(image);;
    [self dismissViewControllerAnimated:YES completion:nil];
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
    NSLog(@"-----发送图片页面添加了delegate");
    [self initTv];
    [self getCovByUserName];
    if(_covConversation == nil){
        NSLog(@"----------cov-准备发送图片消息，但是发现没有［%@］ 的会话，开始创建此会话！",_covUserNameV);
        [self initTv];
        [JMSGConversation createSingleConversationWithUsername:_covUserNameV completionHandler:^(id resultObject, NSError *error) {
            if (error != nil) {
                
                //            [self getLastMsg];
                NSLog(@"--------创建与 %@  的会话失败！－－error：%@,---Result:%@",_covUserNameV,error,resultObject);
                _covShow = [NSString stringWithFormat:@"--------创建与 %@  的会话失败，－－error：%@,---Result:%@",_covUserNameV,error,resultObject];
                [_covAllShowTV setText:_covShow];
                return ;
            }
            
            
                NSLog(@"--------创建与 %@  的会话成功！---Result:%@",_covUserNameV,resultObject);
                _covConversation = resultObject;
            _covShow = [NSString stringWithFormat:@"--------创建与 %@  的会话成功！---Result:%@",_covUserNameV,resultObject];
            [self sendImageMsg:picData];
            return;
                      }];
    }
    [self sendImageMsg:picData];

}

-(void)sendImageMsg:(NSData *)imagePath{
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
    [_covAllShowTV setText:_covShow];
    JMSGImageContent * convSendImage = [[JMSGImageContent alloc] initWithImageData:imagePath];
    
    [convSendImage addStringExtra:@"cov-image-string value" forKey:@"cov-image-string key"];
    [convSendImage addNumberExtra:[[NSNumber alloc]initWithInt:1 ] forKey:@"cov image nsnumber key"];
//    convSendImage addObserver:<#(nonnull NSObject *)#> forKeyPath:<#(nonnull NSString *)#> options:<#(NSKeyValueObservingOptions)#> context:<#(nullable void *)#>
    [_covConversation createMessageAsyncWithImageContent:convSendImage completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"-------ConversationViewController  sendImageMsg 发送消息 －－error： %@ ,-－－result：%@",error,resultObject);
            _covJMessage= resultObject;
            
            [_covConversation sendMessage: _covJMessage];
            
        }
        else {
            NSLog(@"-------conversation sendImageMsg 发送消息异常！ －－error： %@ ,-－－result：%@",error,resultObject);
            return ;
        }
        
    }];
}


-(void)onConversationChanged:(JMSGConversation *)conversation{
    _covConversation = conversation;
    NSLog(@"----cov--onConversationChanged,--target:%@,--title:%@", conversation.target,conversation.title);
    
    NSLog(@"------cov--onConversationChanged:%@",conversation);
    _covShow = [NSString stringWithFormat:@"------cov--onConversationChanged:%@",conversation];
    [_covAllShowTV setText:_covShow];
    
    
}

-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    if (error==nil) {
        _covJMessage = message;
        NSLog(@"-－－ConversationViewController－－收到的消息是否属于当前会话：%d,－－cov:%@",  [_covConversation isMessageForThisConversation:_covJMessage],_covConversation);
        
        NSLog(@"------ConversationViewController--onReceiveMessage,--message:%@,\n－－收到的消息id:%@",_covJMessage,_covJMessage.msgId);
        
        _covShow = [NSString stringWithFormat:@"------cov--onReceiveMessage,--message:%@,－－error:%@",_covJMessage,error];
        [_covAllShowTV setText:_covShow];
        
//        NSLog(@"-----ConversationViewController--onReceiveMessage: 收到消息的targetAppkey（%@）,fromAppkey（%@）\n",_covJMessage.targetAppKey,_covJMessage.fromAppKey) ;
//        JMSGEventContent *myJMSGEvenContent ;
        
//        NSLog(@"-----判断本消息的fromAppKey(%@)是否为当前集成使用的appkey：%d,",_covJMessage.fromAppKey,[JMessage isMainAppKey:_covJMessage.fromAppKey]) ;

    }
    else{
        NSLog(@"－－ConversationViewController－onReceiveMessage,收到消息的时候报错了，error:%@ ",error);
    }
}

-(void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    _covJMessage = message;
    NSLog(@"------ConversationViewController--onSendMessageResponse,--message:%@,－－error:%@",message,error);
    _covShow = [NSString stringWithFormat:@"%@,－－error:%@",_covJMessage,error];
    [_covAllShowTV setText:_covShow];
}

-(void)onUnreadChanged:(NSUInteger)newCount{
    NSLog(@"－－ConversationViewController－未读数改变：%ld",(unsigned long)newCount);
    _covUnReadCount = [NSString stringWithFormat:@"-----未读数：%ld",newCount];
    self.covUnreadCountLB.enabled =YES;
    [self.covUnreadCountLB setText:_covUnReadCount];
}
- (IBAction)clickClearTV:(id)sender {
    self.covAllShowTV.text = @"--";
    //测试代码，发送custom
//    NSDictionary *dictionary  = [[NSDictionary alloc] initWithObjectsAndKeys:@"",nil,nil];
//    
//    JMSGCustomContent *strideAppCustomContent = [[JMSGCustomContent alloc] initWithCustomDictionary:dictionary];
//    NSString *sendCustomContent = [NSString stringWithFormat:@"%@-%@\n",_covUserNameV,_curTimeV];
//    JMSGMessage *cutMessage = [_covConversation createMessageWithContent:strideAppCustomContent];
//    [strideAppCustomContent setContentText:sendCustomContent];
//    [strideAppCustomContent addObjectValue:@"custom key1" forKey:@"custom value 1"];
//    
//    [_covConversation sendMessage:cutMessage];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"-------进入了会话:ConversationViewController");
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
}

@end
