//
//  JMSGMsgViewController.m
//  im213demo
//
//  Created by LinGuangzhen on 16/7/5.
//  Copyright © 2016年 LinGuangzhen. All rights reserved.
//

#import "JMSGMsgViewController.h"
#import <JMessage/JMessage.h>
#import <CFNetwork/CFNetwork.h>
#import "XHVoiceRecordHelper.h"
#import <CoreLocation/CoreLocation.h>

@interface JMSGMsgViewController ()<JMessageDelegate,CLLocationManagerDelegate>
{
    NSString * userText;
    NSString * groupIdText;
    NSString * appkeyText;
    NSString * _curTimeV;
    NSString * jmsgAlertText;
    NSString *FileUrlString;
    NSString * text;
    NSString* filePath;
    NSString*receiverFilePath;
    NSString *sendFileName ;


    
    NSString *fileDownloadPath;

    int localtionCase;
    int fileCase;
    
    NSNumber *longitude;
    NSNumber *latitude;
    
    NSURL *fileUrl;
    
    NSData *sendNSData;
    NSData *receiverNSData;
    
    int voiceCase;
    int  imageCase;
}
- (IBAction)clickSendStrideSingleFileMsg:(id)sender;
- (IBAction)clickSendSingleFileMsg:(id)sender;
- (IBAction)clickSendSingleLocalMsg:(id)sender;
- (IBAction)clickSendStrideSingleLocalMsg:(id)sender;

- (IBAction)clickSendGroupFileMsg:(id)sender;
- (IBAction)clickSendGroupLocalMsg:(id)sender;

- (IBAction)clickSendSingleFileMsgByContent:(id)sender;
- (IBAction)clickSendSingleLocalMsgByContent:(id)sender;

- (IBAction)clickSendGroupFileMsgByContent:(id)sender;
- (IBAction)clickSendGroupLocalMsgByContent:(id)sender;

- (IBAction)clickGetFile:(id)sender;


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
    
    //注册LocationManager
    _currentLoaction = [[CLLocationManager alloc] init];
    _currentLoaction.delegate = self;
#ifdef __IPHONE_8_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [_currentLoaction requestAlwaysAuthorization];
        NSLog(@"地理位置服务－－[UIDevice currentDevice].systemVersion floatValue] >= 8.0");
        
    }
#endif
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"您的设备的［设置］－［隐私］－［定位］已开启");
        [_currentLoaction startUpdatingLocation];//开始更新地理位置信息
    }
    else{
        NSLog(@"您的设备的［设置］－［隐私］－［定位］尚未开启");
    }
    
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
            NSString *fromName = [NSString stringWithFormat:@"%@单聊发图的fromName",userText];
            [_jmsgJMessage setFromName:fromName];
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
            
            NSString *fromName = [NSString stringWithFormat:@"%@群聊发图的fromName",userText];
            [_jmsgJMessage setFromName:fromName];
            
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
    
    NSString *fromName = [NSString stringWithFormat:@"%@单聊发文本的fromName",userText];
    [_jmsgJMessage setFromName:fromName];
    
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
    
    NSString *fromName = [NSString stringWithFormat:@"%@单聊发custom的fromName",userText];
    [_jmsgJMessage setFromName:fromName];
    
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

    NSString * text = [NSString stringWithFormat:@"clickSendContentTextForGroup至［Group:%@］,时间：%@", groupIdText,_curTimeV];
    
//    JMSGTextContent * textContentGroup = [[JMSGTextContent alloc] initWithText:nil];//参数nil异常处理
        JMSGTextContent * textContentGroup = [[JMSGTextContent alloc] initWithText:text];
    [textContentGroup addStringExtra:@"clickSendContentTextForGroup value" forKey:@"clickSendContentTextForGroup-string key"];

   _jmsgJMessage =  [JMSGMessage createGroupMessageWithContent:textContentGroup groupId:groupIdText  ];
    
//    _jmsgJMessage =  [JMSGMessage createGroupMessageWithContent:textContentGroup groupId:groupIdText  ];//参数nil异常测试
    NSString *fromName = [NSString stringWithFormat:@"发%@群聊文本的fromName",groupIdText];
    [_jmsgJMessage setFromName:fromName];
    
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
    
    NSString * text = [NSString stringWithFormat:@"-clickSendImageContentForGroup至［群:%@］,时间：%@", groupIdText,_curTimeV];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:text,@"567890",nil];
    
    JMSGCustomContent * customContenGroup = [[JMSGCustomContent alloc] initWithCustomDictionary:dictionary];
    [customContenGroup addStringExtra:@"-clickSendImageContentForGroup value" forKey:@"clickSendImageContentForGroup-string key"];
    
    _jmsgJMessage =  [JMSGMessage createGroupMessageWithContent:customContenGroup groupId:groupIdText];
    NSString *fromName = [NSString stringWithFormat:@"发%@群聊custom的fromName",groupIdText];
    [_jmsgJMessage setFromName:fromName];
    
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
    [self.fileUrlTF resignFirstResponder];
    [self.appkeyTF resignFirstResponder];
    
}
-(void )initTF{
    self.userTF.enabled = YES;
    userText = _userTF.text;
    if([userText  isEqual:@"nil"]){
        userText =nil;
    }
    
    self.fileUrlTF.enabled = YES;
    FileUrlString = self.fileUrlTF.text;
    fileUrl=[NSURL URLWithString:FileUrlString];
    
    
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
    

    
    if(message.contentType == kJMSGContentTypeFile){
        [(JMSGFileContent * )message.content fileData:^(NSData *data, NSString *objectId, NSError *error) {
            if (error) {
                NSLog(@"----获取文件内容失败，error：%@",error);
                return ;
            }
            receiverNSData = data;
            if ([sendNSData isEqual:receiverNSData] ) {
                NSLog(@"---这是自己发给自己的文件消息！");
                self.fileImageTF.image = [UIImage imageWithData:receiverNSData];
                
                NSString *fileName ;
                //指定图片存放的沙盒路径：documents文件夹中
                NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                
                //文件管理器
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
                [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];

                //判断下载文件类型，star
                if (receiverNSData.length<2) {
                    NSLog(@"---收到的文件消息，附件不是文件！");
                }
                
                int char1 = 0 ,char2 =0 ; //必须这样初始化
                
                [receiverNSData getBytes:&char1 range:NSMakeRange(0, 1)];
                
                [receiverNSData getBytes:&char2 range:NSMakeRange(1, 1)];
                
                NSLog(@"----收到消息nsdata二进制前两位的值：%d%d",char1,char2);
                
                NSString *fileNumStr =  [NSString stringWithFormat:@"%i%i",char1,char2];
                int fileNumInt = [fileNumStr intValue];
                
                //开始根据nsdata的二进制的前两位数值 判断类型
                switch (fileNumInt) {
                    case 255216:
                        NSLog(@"---收到的文件消息类型是：jpg");
                        fileName = @"/RecMedia.jpg";
                        break;
                        
                    case 13780:
                        NSLog(@"---收到的文件消息类型是：png");
                        fileName = @"/RecMedia.png";
                        break;
                        
                    case 8075:
                        NSLog(@"---收到的文件消息类型是：zip");
                        fileName = @"/RecMedia.zip";
                        break;
                    case 102100:
                        NSLog(@"---收到的文件消息类型是：txt");
                        fileName = @"/RecMedia.txt";
                        break;
                    default:
                        NSLog(@"---收到的文件消息其他类型：%@",fileNumStr);
                        break;
                }
                
                //判断下载文件类型，end

                            [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:fileName] contents:receiverNSData attributes:nil];
                
                //得到选择后沙盒中图片的完整路径
                receiverFilePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  fileName];

            }
            
        }];
        
    }
    
    if(message.contentType == kJMSGContentTypeLocation){
        JMSGLocationContent *localContent =  (JMSGLocationContent *) message.content;
        NSLog(@"----收到地理位置消息！\n详细地址：%@,\n经度：%@,\n纬度:%@，\n缩放比例：%@",localContent.address,localContent.latitude,localContent.longitude,localContent.scale);

        
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


-(void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event{
    JMSGNotificationEvent *nEvent = event;
    NSLog(@"---------SendMsg--onReceiveNotificationEvent收到 通知事件");
    
    //    if ([event isKindOfClass:[JMSGFriendNotificationEvent class]]) {
    //        JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
    //        [friendEvent getReason];
    //    }
    
    switch (nEvent.eventType) {
        case  kJMSGEventNotificationFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------SendMsg--onReceiveNotificationEvent收到 好友邀请相关 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
            
        }
            break;
            
        case  kJMSGEventNotificationReceiveFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------SendMsg--onReceiveNotificationEvent收到 好友邀请 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
        }
            break;
            
        case  kJMSGEventNotificationAcceptedFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------SendMsg--onReceiveNotificationEvent收到 同意添加好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);        }
            break;
            
        case  kJMSGEventNotificationDeclinedFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------SendMsg--onReceiveNotificationEvent收到 拒绝好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
        }
            break;
            
        case  kJMSGEventNotificationDeletedFriend:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            NSLog(@"---------SendMsg--onReceiveNotificationEvent收到 删除好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
            
        }
            
            break;
            
        case  kJMSGEventNotificationLoginKicked:
            NSLog(@"---------SendMsg--onReceiveNotificationEvent收到 多设备登陆被t 通知事件，描述：%@",nEvent.eventDescription);
            break;
        case  kJMSGEventNotificationServerAlterPassword:
            NSLog(@"---------SendMsg--onReceiveNotificationEvent收到 非客户端修改密码被t 通知事件，描述：%@",nEvent.eventDescription);
            break;
        case  kJMSGEventNotificationUserLoginStatusUnexpected:
            NSLog(@"---------SendMsg--onReceiveNotificationEvent收到 Juid变更导致下线的 事件，描述：%@",nEvent.eventDescription);
            break;
        case  kJMSGEventNotificationReceiveServerFriendUpdate:
            NSLog(@"---------SendMsg--onReceiveNotificationEvent收到 服务端变更好友相关 事件，描述：%@",nEvent.eventDescription);
            break;
        default:
            NSLog(@"---------SendMsg--onReceiveNotificationEvent收到 未知事件类型，描述：%@",nEvent.eventDescription);
            break;
    }
}
//220b90及之前的220获取好友事件的方法
//-(void)onFriendChanged:(JMSGFriendEventContent *)event{
//   JMSGFriendEventContent * msgJMSGFriendEventContent = event;
//    NSLog(@"----消息测试---onFriendChanged:%@\n",event);
//    NSLog(@"----消息测试---onFriendChanged:{\n好友通知事件类型:%ld,\n获取事件发生的理由:%@,\n事件发送者的username:%@,\n获取事件发送者user:%@",msgJMSGFriendEventContent.eventType,[msgJMSGFriendEventContent getReason],[msgJMSGFriendEventContent getFromUsername],[msgJMSGFriendEventContent getFromUser]);
//    
//}

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
//                  [JMSGMessage sendSingleVoiceMessage:nil voiceDuration:nil toUser:userText]; //nil异常测试

                  [JMSGMessage sendSingleVoiceMessage:voicePathNSData voiceDuration:voiceDurationNSNumber toUser:userText];
                NSLog(@"----- voiceCase:%d,  \n  [JMSGMessage sendSingleVoiceMessage:voicePathNSData voiceDuration:voiceDurationNSNumber toUser:userText]",voiceCase);

            }
                break;
            case 2:{
                [self initTF];
                
//                [JMSGMessage sendSingleVoiceMessage:nil voiceDuration:nil toUser:userText appKey:appkeyText];//nil异常测试

                [JMSGMessage sendSingleVoiceMessage:voicePathNSData voiceDuration:voiceDurationNSNumber toUser:userText appKey:appkeyText];
                
  NSLog(@"-----voiceCase:%d,  \n [JMSGMessage sendSingleVoiceMessage:voicePathNSData voiceDuration:voiceDurationNSNumber toUser:userText appKey:appkeyText];",voiceCase);
            }
                break;
            case 3:
            {                [self initTF];

//                [JMSGMessage sendGroupVoiceMessage:nil voiceDuration:nil toGroup:groupIdText];//参数nil的异常测试
                [JMSGMessage sendGroupVoiceMessage:voicePathNSData voiceDuration:voiceDurationNSNumber toGroup:groupIdText];
                NSLog(@"-----voiceCase:%d,/n[JMSGMessage sendGroupVoiceMessage:voicePathNSData voiceDuration:voiceDurationNSNumber",voiceCase);

            }
                break;
                
            case 4:
            {
                [self initTF];
                [self curTimeValue];

                NSString * singleContent = [NSString stringWithFormat:@"发送语音至［user:%@］,时间：%@", userText,_curTimeV];
                
//                  JMSGVoiceContent *sVoiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:nil voiceDuration:nil];//参数为nil的异常测试
                
                JMSGVoiceContent *sVoiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:voicePathNSData voiceDuration:voiceDurationNSNumber];
                
                [sVoiceContent addStringExtra:singleContent  forKey:@"send voice"];
                JMSGMessage * singleContentMessage =    [JMSGMessage createSingleMessageWithContent:sVoiceContent username:userText];
                
                NSString *fromName = [NSString stringWithFormat:@"给%@发单聊语音的fromName",groupIdText];
                [singleContentMessage setFromName:fromName];
                
                [JMSGMessage sendMessage:singleContentMessage];
                NSLog(@"-----voiceCase:%d,\n createSingleMessageWithContent- JMSGVoiceContent!",voiceCase);


            }
                break;
            case 5:
            {
                [self initTF];
                [self curTimeValue];

                NSString * groupContent = [NSString stringWithFormat:@"发送语音至［user:%@］,时间：%@", userText,_curTimeV];
//                 JMSGVoiceContent *gVoiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:nil voiceDuration:nil];//参数nil的异常测试
                
                JMSGVoiceContent *gVoiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:voicePathNSData voiceDuration:voiceDurationNSNumber];
                
                [gVoiceContent addStringExtra:groupContent  forKey:@"send voice"];
                JMSGMessage * groupContentMessage =    [JMSGMessage createGroupMessageWithContent:gVoiceContent groupId:groupIdText];
                NSString *fromName = [NSString stringWithFormat:@"给%@发群聊语音的fromName",groupIdText];
                [groupContentMessage setFromName:fromName];
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
- (IBAction)clickSendSingleFileMsg:(id)sender {
     [self initTF];
   [ self curTimeValue];
    
    fileCase = 1;

    [self handleFile];
    NSLog(@"----clickSendSingleFileMsg");
    
    }

- (IBAction)clickSendStrideSingleFileMsg:(id)sender {
    [self initTF];
    [ self curTimeValue];
    fileCase = 2;

    [self handleFile];
    
    NSString * text = [NSString stringWithFormat:@"clickSendStrideSingleFileMsg至［user:%@］,时间：%@", userText,_curTimeV];

    NSLog(@"----clickSendStrideSingleFileMsg");

    
}

- (IBAction)clickSendSingleLocalMsg:(id)sender {
    NSLog(@"---clickSendSingleLocalMsg");//,data:%@",data);

    [_currentLoaction startUpdatingLocation];//开始更新地理位置信息
//    NSLog(@"latitude纬度:%@",latitude);
//    NSLog(@"longitude纬度:%@",longitude);
    [self initTF];
    [ self curTimeValue];
    text = [NSString stringWithFormat:@"clickSendSingleLocalMsg至［user:%@］,时间：%@", userText,_curTimeV];
    localtionCase = 1;

   
}

- (IBAction)clickSendStrideSingleLocalMsg:(id)sender {
    [_currentLoaction startUpdatingLocation];//开始更新地理位置信息
    NSString * text = [NSString stringWithFormat:@"clickSendStrideSingleLocalMsg至［user:%@］,时间：%@", userText,_curTimeV];

    [self initTF];
    [ self curTimeValue];
    NSLog(@"---clickSendStrideSingleLocalMsg");//,data:%@",data);
    localtionCase = 2;

}

- (IBAction)clickSendGroupFileMsg:(id)sender {
    [self initTF];
    [ self curTimeValue];
    
    fileCase = 3;
    
    [self handleFile];
    NSString * text = [NSString stringWithFormat:@"clickSendGroupFileMsg至［Group:%@］,时间：%@", groupIdText,_curTimeV];

    NSLog(@"----clickSendGroupFileMsg");
}

- (IBAction)clickSendGroupLocalMsg:(id)sender {
    [_currentLoaction startUpdatingLocation];//开始更新地理位置信息

    [self initTF];
    [ self curTimeValue];
    NSString * text = [NSString stringWithFormat:@"clickSendGroupLocalMsg至［Group:%@］,时间：%@", groupIdText,_curTimeV];
    localtionCase = 3;

    NSLog(@"---clickSendGroupLocalMsg");//,data:%@",data);
    
}

- (IBAction)clickSendSingleFileMsgByContent:(id)sender {
    [self initTF];
    [self curTimeValue];
    fileCase = 4;
    [self handleFile];
    NSString * text = [NSString stringWithFormat:@"clickSendSingleFileMsgByContent至［user:%@］,时间：%@", userText,_curTimeV];
    
    //    JMSGTextContent * textContentGroup = [[JMSGTextContent alloc] initWithText:nil];//参数nil异常处理
    JMSGFileContent * fileContentSingle = [[JMSGFileContent alloc] initWithFileData:sendNSData fileName:text];
    [fileContentSingle addStringExtra:@"clickSendSingleFileMsgByContent value" forKey:@"clickSendSingleFileMsgByContent-string key"];
    _jmsgJMessage = [JMSGMessage createSingleMessageWithContent:fileContentSingle username:userText];
    
    NSString *fromName = [NSString stringWithFormat:@"发%@单聊文件的fromName",userText];
    [_jmsgJMessage setFromName:fromName];
    
//    _jmsgJMessage =  [JMSGMessage createGroupMessageWithContent:fileContentSingle groupId:groupIdText  ];
    
    NSLog(@"－－－－－－－－clickSendSingleFileMsgByContent:%@",text);

}

- (IBAction)clickSendSingleLocalMsgByContent:(id)sender {
    [_currentLoaction startUpdatingLocation];//开始更新地理位置信息

    [self initTF];
    [self curTimeValue];

    NSString * text = [NSString stringWithFormat:@"clickSendSingleLocalMsgByContent至［Group:%@］,时间：%@", userText,_curTimeV];
    
    //    JMSGTextContent * textContentGroup = [[JMSGTextContent alloc] initWithText:nil];//参数nil异常处理
    JMSGLocationContent * localtionContentSingle =  [[JMSGLocationContent alloc  ]initWithLatitude:latitude longitude:longitude scale:@1 address:text];
    [localtionContentSingle addStringExtra:@"clickSendSingleLocalMsgByContent value" forKey:@"clickSendSingleLocalMsgByContent-string key"];
    
    _jmsgJMessage =  [JMSGMessage createSingleMessageWithContent:localtionContentSingle username:userText  ];
    
    NSString *fromName = [NSString stringWithFormat:@"发%@单聊location的fromName",userText];
    [_jmsgJMessage setFromName:fromName];
    
    localtionCase = 4;

    NSLog(@"－－－－－－－－clickSendSingleLocalMsgByContent:%@",text);

}

- (IBAction)clickSendGroupFileMsgByContent:(id)sender {
    
    [self initTF];
    [self curTimeValue];
    [self handleFile];
    fileCase = 5;

    NSString * text = [NSString stringWithFormat:@"clickSendGroupFileMsgByContent至［Group:%@］,时间：%@", userText,_curTimeV];
    
    JMSGFileContent *fileContentGroup =  [[JMSGFileContent alloc]initWithFileData:sendNSData fileName:text];
    [fileContentGroup addStringExtra:@"clickSendGroupFileMsgByContent value" forKey:@"clickSendGroupFileMsgByContent-string key"];
    
    _jmsgJMessage =  [JMSGMessage createGroupMessageWithContent:fileContentGroup groupId:groupIdText  ];
    
    NSString *fromName = [NSString stringWithFormat:@"发%@群聊文件的fromName",groupIdText];
    [_jmsgJMessage setFromName:fromName];
    
    
    NSLog(@"－－－－－－－－clickSendGroupFileMsgByContent:%@",text);

    
}

- (IBAction)clickSendGroupLocalMsgByContent:(id)sender {
    
    [_currentLoaction startUpdatingLocation];//开始更新地理位置信息

    [self initTF];
    [self curTimeValue];
    [self handleFile];
    
    NSString * text = [NSString stringWithFormat:@"clickSendGroupLocalMsgByContent至［Group:%@］,时间：%@", userText,_curTimeV];
    
    JMSGLocationContent *loaclContentGroup =  [[JMSGLocationContent alloc]initWithLatitude:latitude longitude:longitude scale:@1 address:text];
    [loaclContentGroup addStringExtra:@"clickSendGroupLocalMsgByContent value" forKey:@"clickSendGroupLocalMsgByContent-string key"];
    
    _jmsgJMessage =  [JMSGMessage createGroupMessageWithContent:loaclContentGroup groupId:groupIdText  ];
    localtionCase = 5;
    
    NSString *fromName = [NSString stringWithFormat:@"发%@群聊location的fromName",groupIdText];
    [_jmsgJMessage setFromName:fromName];

    NSLog(@"－－－－－－－－clickSendGroupLocalMsgByContent:%@",text);

}

- (IBAction)clickGetFile:(id)sender {
    //获取要收到的文件的文件大小
    NSFileManager  *fileMananger = [NSFileManager defaultManager];

    if ([fileMananger fileExistsAtPath:receiverFilePath]) {
        NSDictionary *dic = [fileMananger attributesOfItemAtPath:receiverFilePath error:nil];
        NSLog(@"----收到的文件大小：%lld", [dic[@"NSFileSize"] longLongValue]);
        return;
        //  return [[fileMananger attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    NSLog(@"----出错了！收到的文件不存在！");
}


-(void)handleFile{
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:fileUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"----文件下载失败？");
            return ;
        }
        
        sendNSData = data;
    
        //判断下载文件类型，star
        if (sendNSData.length<2) {
            NSLog(@"---准备发送的文件消息，附件不是文件！");
        }
        
        int char1 = 0 ,char2 =0 ; //必须这样初始化
        
        [sendNSData getBytes:&char1 range:NSMakeRange(0, 1)];
        
        [sendNSData getBytes:&char2 range:NSMakeRange(1, 1)];
        
        NSLog(@"----nsdata的二进制的前两位数值:%d%d",char1,char2);
        
        NSString *sendFileNumStr =  [NSString stringWithFormat:@"%i%i",char1,char2];
        int sendFileNumInt = [sendFileNumStr intValue];
        
        //开始根据nsdata的二进制的前两位数值 判断类型
        switch (sendFileNumInt) {
            case 255216:
                NSLog(@"---准备发送的文件消息类型是：jpg");
                sendFileName = @"/RecMedia.jpg";
                break;
                
            case 13780:
                NSLog(@"---准备发送的文件消息类型是：png");
                sendFileName = @"/RecMedia.png";
                break;
                
            case 8075:
                NSLog(@"---准备发送的文件消息类型是：zip");
                sendFileName = @"/RecMedia.zip";
                break;
            case 102100:
                NSLog(@"---收到的文件消息类型是：txt");
                sendFileName = @"/RecMedia.txt";
                break;
            default:
                NSLog(@"---准备发送的文件消息其他类型：%@",sendFileNumStr);
                break;
        }
        
        //判断下载文件类型，end
        //图片保存的路径
        //指定图片存放的沙盒路径：documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:sendFileName] contents:sendNSData attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath, sendFileName];
        
        //获取要发送文件的文件大小
        if ([fileManager fileExistsAtPath:filePath]) {
            NSDictionary *dic = [fileManager attributesOfItemAtPath:filePath error:nil];
            NSLog(@"----将发送的文件大小：%lld", [dic[@"NSFileSize"] longLongValue]);
        }
        else{
            NSLog(@"----出错了！要发送的文件不存在！");

        }
        
        switch (fileCase) {
            case 1:
                [JMSGMessage sendSingleFileMessage:sendNSData fileName: _curTimeV toUser:userText];
                
                break;
            case 2:
                [JMSGMessage sendSingleFileMessage:sendNSData fileName:text toUser:userText appKey:appkeyText];
                
                break;
            case 3:
                [JMSGMessage sendGroupFileMessage:sendNSData fileName:text toGroup:groupIdText];
                
                break;
            case 4:
                [JMSGMessage sendMessage:_jmsgJMessage];
                
                break;
            case 5:
                [JMSGMessage sendMessage:_jmsgJMessage];
                
                break;
            default:
                NSLog(@"---正常来说，不会进这里！！");
                break;
        }

        
    }];
    
  
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取经纬度
    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    NSLog(@"经度:%f",newLocation.coordinate.longitude);
    latitude = [NSNumber numberWithDouble:newLocation.coordinate.latitude];
    

    longitude = [NSNumber numberWithDouble:newLocation.coordinate.longitude];


    // 停止位置更新
    [manager stopUpdatingLocation];
    NSLog(@"latitude纬度:%@",latitude);
        NSLog(@"longitude纬度:%@",longitude);
    
    switch (localtionCase) {
        case 1:{
            [JMSGMessage sendSingleLocationMessage:latitude longitude:longitude scale:@1 address:text toUser:userText];
        }
            break;
        case 2:
        {
                [JMSGMessage sendSingleLocationMessage:latitude longitude:longitude scale:@1 address:text toUser:userText appKey:appkeyText];
        }
             break;
        case 3:
        {
                [JMSGMessage sendGroupLocationMessage:latitude longitude:longitude scale:@1 address:text toGroup:groupIdText];
        }
            break;
        case 4:
        {
             [JMSGMessage sendMessage:_jmsgJMessage];
        }
            break;
        case 5:
        {
             [JMSGMessage sendMessage:_jmsgJMessage];
        }
            break;
        default:
            break;
    }
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}
@end
