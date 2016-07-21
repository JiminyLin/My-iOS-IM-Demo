//
//  JMSGMsgViewController.m
//  im213demo
//
//  Created by LinGuangzhen on 16/7/5.
//  Copyright © 2016年 LinGuangzhen. All rights reserved.
//

#import "JMSGMsgViewController.h"
#import <JMessage/JMessage.h>
#import "XHVoiceRecordHelper.h"


@interface JMSGMsgViewController ()<JMessageDelegate>
{
    NSString * userText;
    NSString * groupIdText;
    NSString * appkeyText;
    NSString * _curTimeV;
    NSString * jmsgAlertText;
    
    int voiceCase;
    int  imageCase;
}
@property (weak, nonatomic) IBOutlet UIButton *voiceBtnForSingleShortcut;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtnForStrideAppSingleShortcut;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtnForStrideAppGroupShortcut;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtnForGroupContent;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtnForSingleContent;
@property (nonatomic, strong) XHVoiceRecordHelper *voiceRecordHelper;

@property (strong ,nonatomic )JMSGMessage * jmsgJMessage;
@property (strong ,nonatomic )JMSGGroup * jmsgJMSGGroup;
@property (strong ,nonatomic )JMSGUser * jmsgJMSGUser;
@end

@implementation JMSGMsgViewController

- (XHVoiceRecordHelper *)voiceRecordHelper
{
    if (_voiceRecordHelper == nil) {
        _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
    }
    return _voiceRecordHelper;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.voiceBtnForSingleShortcut addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.voiceBtnForSingleShortcut addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    [self.voiceBtnForStrideAppSingleShortcut addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.voiceBtnForStrideAppSingleShortcut addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    [self.voiceBtnForStrideAppGroupShortcut addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.voiceBtnForStrideAppGroupShortcut addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    [self.voiceBtnForGroupContent addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.voiceBtnForGroupContent addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    [self.voiceBtnForSingleContent addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.voiceBtnForSingleContent addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< 全平台" style:UIBarButtonItemStylePlain target:self action:@selector(morePage)];
    // Do any additional setup after loading the view.
    //隐藏键盘，star
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    //隐藏键盘，end

}
-(void)morePage{
    [self.navigationController  popViewControllerAnimated:YES];
}
- (IBAction)clickSendTextForSingle:(id)sender {
    [self initTF];
    [self curTimeValue];
    
    NSString * text = [NSString stringWithFormat:@"clickSendTextForSingle至［user:%@］,时间：%@", userText,_curTimeV];
    
    [JMSGMessage sendSingleTextMessage:text toUser:userText];
//    [JMSGMessage sendSingleTextMessage:nil toUser:userText];//参数nil异常测试

    NSLog(@"－－－－－－－－clickSendTextForSingle：%@",text);
}


- (IBAction)clickSendStrideAppTextForSingle:(id)sender {
       [self initTF];
        [self curTimeValue];
    
    NSString * text = [NSString stringWithFormat:@"clickSendStrideAppTextForSingle至［appkey:%@,user:%@］,时间：%@", userText,appkeyText,_curTimeV];
    
//    [JMSGMessage sendSingleTextMessage:nil toUser:userText appKey:appkeyText];//参数nil异常测试
    [JMSGMessage sendSingleTextMessage:text toUser:userText appKey:appkeyText];
    NSLog(@"－－－－－－－－clickSendStrideAppTextForSingle:%@",text);

}

- (IBAction)clickSendImageForSingle:(id)sender {
    [self initTF];
    [self curTimeValue];
    imageCase = 1;
    
    NSLog(@"－－－－－－－－clickSendImageForSingle，imageCase =1");
    //打开显示相册控件
    UIImagePickerController *imgController = [[UIImagePickerController alloc]init];
    imgController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgController.delegate = self;
    [self presentViewController:imgController animated:YES completion:NULL];
    
    return;

}

- (IBAction)clickSendStrideAppImageForSingle:(id)sender {
    [self initTF];
    [self curTimeValue];
    imageCase = 2;
    
    NSLog(@"－－－－－－－－clickSendImageForSingle，imageCase = 2");
    //打开显示相册控件
    UIImagePickerController *imgController = [[UIImagePickerController alloc]init];
    imgController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgController.delegate = self;
    [self presentViewController:imgController animated:YES completion:NULL];
    
    return;
}
- (IBAction)clickSendVoiceForSingle:(id)sender {
    NSLog(@"－－－－－－－－clickSendVoiceForSingle,voiceCase = 1");
    voiceCase = 1;
}

- (IBAction)clickSendStrideAppVoiceForSingle:(id)sender {
    NSLog(@"－－－－－－－－clickSendStrideAppVoiceForSingle,voiceCase = 2");
    voiceCase = 2;

}




- (IBAction)clickSendTextForGroup:(id)sender {
       [self initTF];
        [self curTimeValue];

    NSString * text = [NSString stringWithFormat:@"clickSendTextForGroup至［group:%@］,时间：%@", groupIdText,_curTimeV];
    [JMSGMessage sendGroupTextMessage:text toGroup:groupIdText];
    
//        [JMSGMessage sendGroupTextMessage:nil toGroup:groupIdText];//参数nil异常处理
    NSLog(@"－－－－－－－－clickSendTextForGroup:%@",text);

}

- (IBAction)clickSendImageForGroup:(id)sender {
    [self initTF];
    [self curTimeValue];
    imageCase = 3;
    
    NSLog(@"－－－－－－－－clickSendImageForGroup，imageCase = 3");
    //打开显示相册控件
    UIImagePickerController *imgController = [[UIImagePickerController alloc]init];
    imgController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgController.delegate = self;
    [self presentViewController:imgController animated:YES completion:NULL];
    
    return;
}


///调用相册
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //先把图片转成NSData（注意图片的格式）
    
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *picData = UIImagePNGRepresentation(image);;
    [self dismissViewControllerAnimated:YES completion:nil];
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
    NSLog(@"-----发送图片页面添加了delegate");
    switch (imageCase) {
        case 1:
            [JMSGMessage sendSingleImageMessage:picData toUser:userText];//调用单聊发图接口发送从相册里面选择的图片
//            [JMSGMessage sendSingleImageMessage:nil toUser:userText];//参数nil的异常测试
            break;
        case 2:
            [JMSGMessage sendSingleImageMessage:picData toUser:userText appKey:appkeyText];//调用单聊跨应用发图接口发送从相册里面选择的图片
            
//            [JMSGMessage sendSingleImageMessage:nil toUser:userText appKey:appkeyText];//参数nil的异常测试
            break;
            
        case 3:
            [JMSGMessage sendGroupImageMessage:picData toGroup:groupIdText];
//            [JMSGMessage sendGroupImageMessage:nil toGroup:groupIdText];//参数nil的异常测试


            break;
        case 4:
        {
            NSNumber * contentImageNSNuber = [[NSNumber alloc] initWithInt:4444];
            
            NSString * text = [NSString stringWithFormat:@"clickSendImageContentForSingle至［user:%@］,时间：%@", userText,_curTimeV];
            
            JMSGImageContent * imageContenSingle = [[JMSGImageContent alloc] initWithImageData:picData];

//            JMSGImageContent * imageContenSingle = [[JMSGImageContent alloc] initWithImageData:nil];//参数nil的异常测试
            [imageContenSingle addStringExtra:text forKey:@"clickSendContentImageForSingle key"];
            [imageContenSingle addStringExtra:@"https://www.jiguang.cn" forKey:@"url key"];

            [imageContenSingle addNumberExtra:contentImageNSNuber forKey:@"addNumberExtra key"];
          _jmsgJMessage =    [JMSGMessage createSingleMessageWithContent:imageContenSingle username:userText];
            [JMSGMessage sendMessage:_jmsgJMessage];

        }
             break;
            
        case   5:
        {
            NSNumber * contentImageNSNuber = [[NSNumber alloc] initWithInt:6666];
            
            NSString * text = [NSString stringWithFormat:@"clickSendImageContentForGroup至［Group:%@］,时间：%@", groupIdText,_curTimeV];
            
            JMSGImageContent * imageContenSingle = [[JMSGImageContent alloc] initWithImageData:picData];
            
//            JMSGImageContent * imageContenSingle = [[JMSGImageContent alloc] initWithImageData:nil];//参数nil的异常测试


            [imageContenSingle addStringExtra:text forKey:@""];
            [imageContenSingle addStringExtra:@"https://www.jiguang.cn" forKey:@"url key"];

            [imageContenSingle addNumberExtra:contentImageNSNuber forKey:@"clickSendImageContentForGroup-addNumberExtra key"];
        _jmsgJMessage =    [JMSGMessage createSingleMessageWithContent:imageContenSingle username:userText];
            [JMSGMessage sendMessage:_jmsgJMessage];

        }
            break;
        default:
            NSLog(@"  －－－－发送快捷发生图片消息异常！");
            break;
    }
    
    
}

- (IBAction)clickSendVoiceForGroup:(id)sender {
    NSLog(@"－－－－－－－－clickSendVoiceContentForSingle,voiceCase = 3");
    voiceCase = 3;
}


- (IBAction)clickSendContentTextForSingle:(id)sender {
    [self initTF];
    [self curTimeValue];
    NSNumber *textNsnuber = [[NSNumber alloc] initWithInt:01];

    NSString * text = [NSString stringWithFormat:@"clickSendContentTextForSingle至［user:%@］,时间：%@", userText,_curTimeV];
    
//    JMSGTextContent * textContenSingle = [[JMSGTextContent alloc] initWithText:nil];//参数nil的异常测试

    
    JMSGTextContent * textContenSingle = [[JMSGTextContent alloc] initWithText:text];
    
    [textContenSingle addStringExtra:@"cov-Text-string value" forKey:@"cov-Text-string key"];
    [textContenSingle addNumberExtra:textNsnuber forKey:@"addNumberExtra key"];
  _jmsgJMessage =  [JMSGMessage createSingleMessageWithContent:textContenSingle username:userText];
    
    [JMSGMessage sendMessage:_jmsgJMessage];
    NSLog(@"－－－－－－－－clickSendContentTextForSingle:%@",text);

    
}

- (IBAction)clickSendContentImageForSingle:(id)sender {
    [self initTF];
    [self curTimeValue];
    imageCase = 4;
    
    NSLog(@"－－－－－－－－clickSendImageContentForSingle－imageCase = 4");
    //打开显示相册控件
    UIImagePickerController *imgController = [[UIImagePickerController alloc]init];
    imgController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgController.delegate = self;
    [self presentViewController:imgController animated:YES completion:NULL];
    
    return;
}
- (IBAction)clickSendCustomContentForSingle:(id)sender {
    [self initTF];
    [self curTimeValue];
    
    NSString * text = [NSString stringWithFormat:@"clickSendCustomContentForSingle至［user:%@］,时间：%@", userText,_curTimeV];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:text,@"567890",nil];

//    JMSGCustomContent * customContenSingle = [[JMSGCustomContent alloc] initWithCustomDictionary:nil];//参数nil测试
    
    JMSGCustomContent * customContenSingle = [[JMSGCustomContent alloc] initWithCustomDictionary:dictionary];

    [customContenSingle addStringExtra:@"clickSendCustomContentForSingle value" forKey:@"clickSendCustomContentForSingle-string key"];
   _jmsgJMessage =  [JMSGMessage createSingleMessageWithContent:customContenSingle username:userText];
    
    [JMSGMessage sendMessage:_jmsgJMessage];
    NSLog(@"－－－－－－－－clickSendCustomContentForSingle:%@",text);


}
- (IBAction)clickSendVoiceContentForSingle:(id)sender {
 
    NSLog(@"－－－－－－－－clickSendVoiceContentForSingle,voiceCase = 4");
    voiceCase = 4;
}



- (IBAction)clickSendContentTextForGroup:(id)sender {
    [self initTF];
    [self curTimeValue];

    NSString * text = [NSString stringWithFormat:@"clickSendContentTextForGroup至［Group:%@］,时间：%@", userText,_curTimeV];
    
//    JMSGTextContent * textContentGroup = [[JMSGTextContent alloc] initWithText:nil];//参数nil异常处理
        JMSGTextContent * textContentGroup = [[JMSGTextContent alloc] initWithText:text];
    [textContentGroup addStringExtra:@"clickSendContentTextForGroup value" forKey:@"clickSendContentTextForGroup-string key"];

   _jmsgJMessage =  [JMSGMessage createGroupMessageWithContent:textContentGroup groupId:groupIdText  ];
    
//    _jmsgJMessage =  [JMSGMessage createGroupMessageWithContent:textContentGroup groupId:groupIdText  ];//参数nil异常测试

    
    [JMSGMessage sendMessage:_jmsgJMessage];
    NSLog(@"－－－－－－－－clickSendContentTextForGroup:%@",text);


}

- (IBAction)clickSendImageContentForGroup:(id)sender {
    [self initTF];
    [self curTimeValue];
    imageCase = 5;
    
    NSLog(@"－－－－－－－－clickSendImageContentForGroup， imageCase = 6");
    //打开显示相册控件
    UIImagePickerController *imgController = [[UIImagePickerController alloc]init];
    imgController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgController.delegate = self;
    [self presentViewController:imgController animated:YES completion:NULL];
}
- (IBAction)clickSendCustomContentForGroup:(id)sender {
    [ self initTF];
    [self curTimeValue];
    
    NSString * text = [NSString stringWithFormat:@"-clickSendImageContentForGroup至［user:%@］,时间：%@", userText,_curTimeV];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:text,@"567890",nil];
    
    JMSGCustomContent * customContenGroup = [[JMSGCustomContent alloc] initWithCustomDictionary:dictionary];
    [customContenGroup addStringExtra:@"-clickSendImageContentForGroup value" forKey:@"clickSendImageContentForGroup-string key"];
    _jmsgJMessage =  [JMSGMessage createGroupMessageWithContent:customContenGroup groupId:groupIdText];
    [JMSGMessage sendMessage:_jmsgJMessage];
    
    NSLog(@"－－－－－－－－clickSendCustomContentForGroup:%@",text);


}

- (IBAction)clickSendVoiceContentForGroup:(id)sender {
    NSLog(@"－－－－－－－－clickSendVoiceContentForGroup,voiceCase = 5");
    voiceCase = 5;
}


//指定要隐藏键盘的控件
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.userTF resignFirstResponder];
    [self.groupIdTF resignFirstResponder];
    
    [self.appkeyTF resignFirstResponder];
    
}
-(void )initTF{
    self.userTF.enabled = YES;
    userText = _userTF.text;
    if([userText  isEqual:@"nil"]){
        userText =nil;
    }
    
    self.groupIdTF.enabled = YES;
    groupIdText = _groupIdTF.text;
    if([groupIdText  isEqual:@"nil"]){
        groupIdText =nil;
    }
    
    self.appkeyTF.enabled = YES;
    appkeyText = _appkeyTF.text;
    if([appkeyText  isEqual:@"nil"]){
        appkeyText =nil;
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"-------进入了JMSGMsgViewController");
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
}
-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    if (error !=nil) {
        NSLog(@"－－－\n msg--onReceiveMessage，收到消息异常：%@",error);
        jmsgAlertText = [NSString stringWithFormat:@"收到消息，异常！\n%@",error];
        [self showAlert:jmsgAlertText];
        return;
    }
    //展示默认事件信息
    //    if (message.contentType == kJMSGContentTypeEventNotification) {
    //        NSString *showText = [((JMSGEventContent *)message.content) showEventNotification];
    //        [self showAlert:showText];
    //    }
    
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
                jmsgAlertText = [NSString stringWithFormat:@"[%@]创建了群，群成员有:%@",fromUsername,[toUsernameList componentsJoinedByString:@","]];
                [self showAlert:jmsgAlertText];
                break;
                
            case 9:
                jmsgAlertText = [NSString stringWithFormat:@"[%@]退出了群",fromUsername];
                [self showAlert:jmsgAlertText];
                break;
                
            case 10:
                jmsgAlertText = [NSString stringWithFormat:@"[%@ ]邀请了［%@］进群",fromUsername,[toUsernameList componentsJoinedByString:@","]];
                [self showAlert:jmsgAlertText];
                break;
                
            case 11:
                jmsgAlertText = [NSString stringWithFormat:@"[%@ ]把［%@］移出了群",fromUsername,[toUsernameList componentsJoinedByString:@","]];
                [self showAlert:jmsgAlertText];
                break;
                
            case 12:
                jmsgAlertText = [NSString stringWithFormat:@"[%@ ]更新了群信息",fromUsername];
                [self showAlert:jmsgAlertText];
                break;
                
            default:
                jmsgAlertText = [NSString stringWithFormat:@"未知群事件：%ld",eventType];
                [self showAlert:jmsgAlertText];
                
        }
        return;
    }
    
    NSLog(@"－－－\n 快速发送消息onReceiveMessage，收到消息成功！messge：%@",message);
    jmsgAlertText = [NSString stringWithFormat:@"收到消息！\n%@",message];
    [self showAlert:jmsgAlertText];
    
    
}

-(void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    if (error !=nil) {
        NSLog(@"－－－\n 快速发送消息onSendMessageResponse，发送消息失败：%@",error);
        jmsgAlertText = [NSString stringWithFormat:@"发送消息失败！\n%@",error];
        [self showAlert:jmsgAlertText];
    }else {
        NSLog(@"－－－\n 快速发送消息onSendMessageResponse，发送消息成功！messge：%@",message);
        _jmsgJMessage = message;
        jmsgAlertText = [NSString stringWithFormat:@"发送消息成功！\n%@",_jmsgJMessage.serverMessageId];
        [self showAlert:jmsgAlertText];
    }
}

-(void)onReceiveMessageDownloadFailed:(JMSGMessage *)message{
    
    NSLog(@"-----快速发送消息 --onReceiveMessageDownloadFailed收到消息下载失败,----message:%@\n",message);
    jmsgAlertText = [NSString stringWithFormat:@"收到消息下载失败！\n%@",message];
    [self showAlert:jmsgAlertText];
    
}

-(void)onGroupInfoChanged:(JMSGGroup *)group{
    NSLog(@"----快速发送消息--onGroupInfoChanged:%@\n",group);
    
    
}

-(void)onConversationChanged:(JMSGConversation *)conversation{
    NSLog(@"---快速发送消息---onConversationChanged:%@\n",conversation);
}

-(void)onUnreadChanged:(NSUInteger)newCount{
    NSLog(@"----快速发送消息---onUnreadChanged:%lu\n",(unsigned long)newCount);
}

-(void)onLoginUserKicked{
    NSLog(@"-----快速发送消息--onLoginUserKicked－－－\n --你被踢下线了！\n");
    jmsgAlertText = [NSString stringWithFormat:@"此账号已在其他地方登陆，你已下线！"];
    [self showAlert:jmsgAlertText];
    
}


//发送语音复用方法：

- (void)holdDownButtonTouchDown
{
    [self curTimeValue];
    NSLog(@"－－－－录音开始时间：%@",_curTimeV);
    [self.voiceRecordHelper startRecordingWithPath:[self getRecorderPath] StartRecorderCompletion:^{
        
    }];
}

- (void)holdDownButtonTouchUpInside
{
    [self curTimeValue];
    NSLog(@"－－－－录音结束时间：%@",_curTimeV);
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
        [self sendMessageWithVoice:self.voiceRecordHelper.recordPath voiceDuration:self.voiceRecordHelper.recordDuration];
    }];
}

- (void)sendMessageWithVoice:(NSString *)voicePath
               voiceDuration:(NSString*)voiceDuration
{
    NSData * voicePathNSData =[NSData dataWithContentsOfFile:voicePath] ;
    NSNumber * voiceDurationNSNumber = [NSNumber numberWithInteger:[voiceDuration integerValue]];
    NSLog(@"－－－－－－－－－VoiceCase:%d,voicePath：%@, voiceDuration：%@", voiceCase,voicePath, voiceDuration);
//        [JMSGMessage sendSingleVoiceMessage:voicePathNSData voiceDuration:voiceDurationNSNumber toUser:userText];

//    for (int i =1; i <= 5; i++) {
        switch (voiceCase) {
            case 1:
            {
                [self initTF];
                  [JMSGMessage sendSingleVoiceMessage:nil voiceDuration:nil toUser:userText]; //nil异常测试

//                  [JMSGMessage sendSingleVoiceMessage:voicePathNSData voiceDuration:voiceDurationNSNumber toUser:userText];
                NSLog(@"----- voiceCase:%d,  \n  [JMSGMessage sendSingleVoiceMessage:voicePathNSData voiceDuration:voiceDurationNSNumber toUser:userText]",voiceCase);

            }
                break;
            case 2:{
                [self initTF];
                
                [JMSGMessage sendSingleVoiceMessage:nil voiceDuration:nil toUser:userText appKey:appkeyText];//nil异常测试

//                [JMSGMessage sendSingleVoiceMessage:voicePathNSData voiceDuration:voiceDurationNSNumber toUser:userText appKey:appkeyText];
                
  NSLog(@"-----voiceCase:%d,  \n [JMSGMessage sendSingleVoiceMessage:voicePathNSData voiceDuration:voiceDurationNSNumber toUser:userText appKey:appkeyText];",voiceCase);
            }
                break;
            case 3:
            {                [self initTF];

                [JMSGMessage sendGroupVoiceMessage:nil voiceDuration:nil
                                           toGroup:groupIdText];//参数nil的异常测试
//                [JMSGMessage sendGroupVoiceMessage:voicePathNSData voiceDuration:voiceDurationNSNumber
//                                           toGroup:groupIdText];
                NSLog(@"-----voiceCase:%d,/n[JMSGMessage sendGroupVoiceMessage:voicePathNSData voiceDuration:voiceDurationNSNumber",voiceCase);

            }
                break;
                
            case 4:
            {
                [self initTF];
                [self curTimeValue];

                NSString * singleContent = [NSString stringWithFormat:@"发送语音至［user:%@］,时间：%@", userText,_curTimeV];
                  JMSGVoiceContent *sVoiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:nil voiceDuration:nil];//参数为nil的异常测试
                
//                JMSGVoiceContent *sVoiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:voicePathNSData voiceDuration:voiceDurationNSNumber];
                
                [sVoiceContent addStringExtra:singleContent  forKey:@"send voice"];
                JMSGMessage * singleContentMessage =    [JMSGMessage createSingleMessageWithContent:sVoiceContent username:userText];
                [JMSGMessage sendMessage:singleContentMessage];
                NSLog(@"-----voiceCase:%d,\n createSingleMessageWithContent- JMSGVoiceContent!",voiceCase);


            }
                break;
            case 5:
            {
                [self initTF];
                [self curTimeValue];

                NSString * groupContent = [NSString stringWithFormat:@"发送语音至［user:%@］,时间：%@", userText,_curTimeV];
                 JMSGVoiceContent *gVoiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:nil voiceDuration:nil];//参数nil的异常测试
                
//                JMSGVoiceContent *gVoiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:voicePathNSData voiceDuration:voiceDurationNSNumber];
                
                [gVoiceContent addStringExtra:groupContent  forKey:@"send voice"];
                JMSGMessage * groupContentMessage =    [JMSGMessage createGroupMessageWithContent:gVoiceContent groupId:groupIdText];
                [JMSGMessage sendMessage:groupContentMessage];
                NSLog(@"-----createGroupMessageWithContent －－JMSGVoiceContent!");

            }
                break;
            default:
                NSLog(@"-----default!");
                break;
        }
//         sleep(2);
//    }
    
      }

- (NSString *)getRecorderPath {
    NSString *recorderPath = nil;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MMMM-dd";
    recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
    dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.ilbc", [dateFormatter stringFromDate:now]];
    return recorderPath;
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
