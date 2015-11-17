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
    
    NSArray *_covList;
    
}
@property(strong,nonatomic)    UITextView *covAllShowTV;

@property (strong ,nonatomic )JMSGMessage * covJMessage;
@property  (strong ,nonatomic)JMSGConversation *covConversation;
@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏键盘，star
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    //隐藏键盘，end
    _covAllShowTV = [[UITextView alloc] initWithFrame: CGRectMake(0, 245, 320, 140) ];
    [self.view addSubview:_covAllShowTV];

    
    // Do any additional setup after loading the view, typically from a nib.
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
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
//    NSLog(@"---_covUserNameV:%@" , _covUserNameV);
    
    self.covGroupID.enabled = YES;
    _covGroupIdV = self.covGroupID.text;
    
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
    [self initTv];
    NSString *st= [NSString stringWithFormat:@"%@",[JMSGConversation singleConversationWithUsername: _covUserNameV]];
    _covConversation = [JMSGConversation singleConversationWithUsername: _covUserNameV];
    NSLog(@"－－－获取与%@ 的会话：%@",_covUserNameV, st);
}
- (IBAction)clickSearchCovByUser:(id)sender {
    [self getCovByUserName];
}

-(void)createSingleCovByUser{
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
    [self initTv];
    [JMSGConversation deleteSingleConversationWithUsername:_covUserNameV];
    NSLog(@"------删除与［%@］的会话",_covUserNameV);
    
}

-(void)getCovByGid{
    [self initTv];
    _covConversation = [JMSGConversation groupConversationWithGroupId:_covGroupIdV];
    NSLog(@"－－－获取群［%@］的会话：%@",_covGroupIdV, [JMSGConversation groupConversationWithGroupId:_covGroupIdV]);

}
- (IBAction)clickGetCovByGroupID:(id)sender {
    [self getCovByGid];
}

- (IBAction)clickCreateCovByGroupID:(id)sender {
        [self initTv];
    [JMSGConversation createGroupConversationWithGroupId:_covGroupIdV completionHandler:^(id resultObject, NSError *error) {
        if (error != nil) {
            _covConversation = resultObject;
            
            
            [JMessage removeAllDelegates];
            [JMessage addDelegate:self withConversation:nil];
            _covShow = [NSString stringWithFormat:@"－－－－创建群ID［%@］的会话,失败！－－－－error：%@,－－－result：%@",_covGroupIdV,error,resultObject];
            [_covAllShowTV setText:_covShow];
            NSLog(@"%@",_covShow);
        }
        else{
            _covShow = [NSString stringWithFormat:@"－－－－创建群ID［%@］的会话，成功！--Result: %@",_covGroupIdV,resultObject];
            [_covAllShowTV setText:_covShow];
            NSLog(@"%@",_covShow);
        }
    }];
}
- (IBAction)clickDelCovByGroupID:(id)sender {
        [self initTv];
    [JMSGConversation deleteGroupConversationWithGroupId:_covGroupIdV];
    NSLog(@"------删除群［%@］的会话",_covGroupIdV);

}
- (IBAction)clickGetMessageByMSGID:(id)sender {
    [self initTv];

    _covShow = [NSString stringWithFormat:@"－－－会话：%@－获取msgid： %@ 的消息：%@",_covConversation,_covJMessage.msgId,  [_covConversation messageWithMessageId:_covJMessage.msgId]];
    [_covAllShowTV setText:_covShow];
    NSLog(@"%@",_covShow);
    
}
- (IBAction)clickClearUnreadCount:(id)sender {
    [_covConversation clearUnreadCount];
    NSLog(@"－－－重置了未读数");
}

-(void) getSomeBodyCov:(NSString*)userNameOrGroupId{
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"-------获取会话列表失败，error：%@,--result:%@", error , resultObject);
            return ;
        }
        
        if (error ==nil) {
            NSLog(@"－－－－成功获取所有会话列表：%@",resultObject);
            _covList = resultObject;
            NSLog(@"----[_covList count ] %ld",[_covList count ] );
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
    [self initTv];

    [self getSomeBodyCov:_covUserNameV];

 }
- (IBAction)clickGetAllMSG:(id)sender {
    if (_covConversation !=nil) {
  
    [_covConversation allMessages:^(id resultObject, NSError *error) {
        if (error == nil) {
            _covShow = [NSString stringWithFormat:@"－－－成功获取到当前会话的所有消息：%@",resultObject];
            [_covAllShowTV setText:_covShow];
            NSLog(@"%@",_covShow);
        }
        else {
            _covShow = [NSString stringWithFormat:@"－－－获取到当前会话的所有消息失败！－－error：%@，－－result：%@",error,resultObject];
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
    [_covConversation deleteAllMessages];
    NSLog(@"－－－－删除当前会话的所有消息！");
}
- (IBAction)clickGetLastMSG:(id)sender {
    NSLog(@"\n－－－准备开始获取当前会话的最后一个消息！");
    [self initTv];
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"-------获取会话列表失败，error：%@,--result:%@", error , resultObject);
            return ;
        }
        NSLog(@"－－－－成功获取所有会话列表：%@",resultObject);
        _covList = resultObject;
        NSLog(@"----[_covList count ] %ld",[_covList count ] );
        int a =0;
        if ( [_covList count ] > 0) {
            for (int i = 0; i< [_covList count]; i++) {
                
                JMSGConversation *cov =_covList[i];
                id target = cov.target;
                if ([target isKindOfClass:[JMSGUser class]] ) {
                    JMSGUser *user = target;
                    if ([user.username isEqualToString:_covUserNameV]) {
                        NSLog(@"－－－－user－会话［%d］：%@ 属于［%@］的会话！", i , user.username , _covUserNameV);
                        
                        _covConversation = _covList[i];
                        _covShow = [NSString stringWithFormat:@"-------用户［%@］的最后一个消息记录是：%@,-文本内容是：%@" , _covUserNameV ,  [_covConversation latestMessage] , [_covConversation latestMessageContentText]];
                        NSLog(@"%@",_covShow);
//                        [_covAllShowTV setText:_covShow];
                        
                    } else {
                        NSLog(@"－－user－会话［%d］: %@ 不属于［%@］的会话！", i ,user.username , _covUserNameV);
                        a = a + 1;
                    }
                    
                    
                } else if ([target isKindOfClass:[JMSGGroup class]]) {
                    JMSGGroup *group = target;
                    
                    NSLog(@"---group.gid :%@，－userNameOrGroupId：%@", group.gid, _covUserNameV);
                    if ([(NSString *)group.gid isEqualToString:_covUserNameV]) {
                        NSLog(@"if it is come in");
                        NSLog(@"－－－会话［%d］: %@ 属于［%@］的会话！", i , group.gid , _covUserNameV);
                        
                        _covConversation = _covList[i];
                        _covShow = [NSString stringWithFormat:@"-------用户［%@］的最后一个消息记录是：%@,-文本内容是：%@" , _covUserNameV ,  [_covConversation latestMessage] , [_covConversation latestMessageContentText]];
                        NSLog(@"%@",_covShow);
//                        [_covAllShowTV setText:_covShow];

                    } else {
                        NSLog(@"－－－会话［%d］:%@ 不属于［%@］的会话！",i , group.gid ,_covUserNameV);
                        a = a+1;

                    }
                }
                if (a == [_covList count ]) {
                    NSLog(@"－－－当前用户不存在于用户[%@]的会话,放弃获取最后一条消息的动作！",_covUserNameV);
                }
            }

        }  else{
            NSLog(@"－－－当前用户 没有任何会话！！放弃获取会话最后一个记录的动作！");
        }
        
    }];
     
}
-(void)getLastMsg{
    NSLog(@"－－getLastMsg－－当前会话的最后一条消息如下：%@", [_covConversation latestMessage]);
    
    NSLog(@"－－getLastMsg－－当前会话的最后一条消息文本：%@",[_covConversation latestMessageContentText]);
}
- (IBAction)clickRefreshMsgFromServer:(id)sender {
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
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
    NSString *convText= [NSString stringWithFormat:@"会话页面要发送的文本内容.%@",_curTimeV];
    JMSGTextContent * convTextContent = [[JMSGTextContent alloc] initWithText:convText];
    [convTextContent addStringExtra:@"cov-Text-string value" forKey:@"cov-Text-string key"];
    [convTextContent addNumberExtra:[[NSNumber alloc]initWithInt:1 ] forKey:@"cov Text nsnumber key"];

    _covJMessage = [_covConversation createMessageWithContent:convTextContent ];
    [_covConversation sendMessage:_covJMessage];
    NSLog(@"------发送了文本消息:%@",convText);
    

}
- (IBAction)clicksendText:(id)sender {
    [self initTv];
    [self curTimeValue];
    [self getCovByUserName];
    if (_covConversation ==nil) {
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
              
                _covShow = [NSString stringWithFormat:@"--------创建与 %@  的会话成功！---Result:%@",_covUserNameV,resultObject];
                [_covAllShowTV setText:_covShow];
                [self sendCovText];
                return ;
            }
        }];
    }
    [self sendCovText];
 }
- (IBAction)clickSendImageMSG:(id)sender {
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
    [JMessage addDelegate:self withConversation:_covConversation];
    [_covAllShowTV setText:_covShow];
    JMSGImageContent * convSendImage = [[JMSGImageContent alloc] initWithImageData:imagePath];
    [convSendImage addStringExtra:@"cov-image-string value" forKey:@"cov-image-string key"];
    [convSendImage addNumberExtra:[[NSNumber alloc]initWithInt:1 ] forKey:@"cov image nsnumber key"];
//    convSendImage addObserver:<#(nonnull NSObject *)#> forKeyPath:<#(nonnull NSString *)#> options:<#(NSKeyValueObservingOptions)#> context:<#(nullable void *)#>
    [_covConversation createMessageAsyncWithImageContent:convSendImage completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"-------发送single msg 正常！ －－error： %@ ,-－－result：%@",error,resultObject);
            _covJMessage= resultObject;
            [_covConversation sendMessage: _covJMessage];
            
        }
        else {
            NSLog(@"-------发送single msg 异常！ －－error： %@ ,-－－result：%@",error,resultObject);
            return ;
        }
        
    }];
}


-(void)onConversationChanged:(JMSGConversation *)conversation{
    _covConversation = conversation;
    NSLog(@"----ov--onConversationChanged,--target:%@,--title:%@", conversation.target,conversation.title);
    
    NSLog(@"------cov--onConversationChanged:%@",conversation);
    _covShow = [NSString stringWithFormat:@"------cov--onConversationChanged:%@",conversation];
    [_covAllShowTV setText:_covShow];
    
    
}

-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    if (error==nil) {
        _covJMessage = message;
        NSLog(@"-－－－－收到的消息是否属于当前会话：%d,－－cov:%@",  [_covConversation isMessageForThisConversation:_covJMessage],_covConversation);
        
        NSLog(@"------cov--onReceiveMessage,--message:%@,\n－－收到的消息id:%@",_covJMessage,_covJMessage.msgId);
        
        _covShow = [NSString stringWithFormat:@"------cov--onReceiveMessage,--message:%@,－－error:%@",_covJMessage,error];
        [_covAllShowTV setText:_covShow];
    }
    else{
        NSLog(@"－－cov－onReceiveMessage,收到消息的时候报错了，error:%@ ",error);
    }
}

-(void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    _covJMessage = message;
    NSLog(@"------cov--onSendMessageResponse,--message:%@,－－error:%@",message,error);
    _covShow = [NSString stringWithFormat:@"%@,－－error:%@",_covJMessage,error];
    [_covAllShowTV setText:_covShow];
}

-(void)onUnreadChanged:(NSUInteger)newCount{
    NSLog(@"－－－未读数改变：%ld",newCount);
    _covUnReadCount = [NSString stringWithFormat:@"-----未读数：%ld",newCount];
    self.covUnreadCountLB.enabled =YES;
    [self.covUnreadCountLB setText:_covUnReadCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
