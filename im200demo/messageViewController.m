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
}

@property(strong,nonatomic)    UITextView *textview;
@property (strong,nonatomic) JMSGUser *otherJMSGUser;
@property (strong ,nonatomic )JMSGMessage *myJMSGMessage;
@property (strong,nonatomic)JMSGCustomContent *myJMSGCustomContent;
@property (strong ,nonatomic )JMSGConversation * myJMSGConversation;
@property (strong,nonatomic)  JMSGAbstractContent *myAbstractContent ;
@end
NSString *user1,*user2,*contentText,*curTime;
NSInteger sendTimes;
@implementation messageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"-------进入了 单聊 界面");

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
    [JMessage removeAllDelegates];

    [JMessage addDelegate:self withConversation:nil];
    
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
            Boolean isEqualToUser=  [ myInfo isEqualToUser:_otherJMSGUser];
            NSLog(@"----isEqualToUser:%d",isEqualToUser);
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
- (IBAction)clickSendText:(id)sender {
    [self initUserContent];
    [self curTimeValue];

    [JMSGConversation createSingleConversationWithUsername:user1 completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"------------与 %@的会话创建成功！",user1 );
            NSString *sendContent = [NSString stringWithFormat:@"%@:%@ - %@",user1,contentText,curTime];
            NSLog(@"-----------------sendContent:%@",sendContent);
            _myJMSGConversation = resultObject;
            [JMessage removeAllDelegates];
            [JMessage addDelegate:self withConversation:_myJMSGConversation];
            
            [JMSGMessage sendSingleTextMessage:sendContent toUser:user1];//调用发送单聊文本接口发消息

        }
        else{
            NSLog(@"------------与 %@的会话创建失败！error ： %@ ,Result: %@",user1,error,resultObject );

        }
    }];
    

}
- (IBAction)clickSendCustomMSG:(id)sender {
    [self initUserContent];
         NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:nil ,nil];
    
//    JMSGCustomContent *customContent = [[JMSGCustomContent alloc] initWithCustomDictionary:dictionary];
    JMSGCustomContent *customContent = [[JMSGCustomContent alloc] initWithCustomDictionary:@{@"custom key":@"custom value"}];
//
   [JMSGConversation createSingleConversationWithUsername:user1 completionHandler:^(id resultObject, NSError *error) {
       if (error !=nil) {
           NSLog(@"----发custom msg 创建会话失败！");
                 }
       _myJMSGConversation = resultObject;
       
       [JMessage removeAllDelegates];
       [JMessage addDelegate:self withConversation:_myJMSGConversation];
       NSLog(@"-----发送文本按钮这里添加了delegate");
       [_myAbstractContent addStringExtra:@"  JMSGAbstractContent *AbstractContent values" forKey:@"  JMSGAbstractContent *AbstractContent -key"];

       JMSGMessage *cutMessage = [_myJMSGConversation createMessageWithContent:customContent];
//       [customContent addObjectValue:nil forKey:nil];
         [customContent addObjectValue:@"custom key1" forKey:@"custom value 1"];
//       [customContent addStringExtra:@"EXTRAS V" forKey:@"EXTRAS KEY"];
              [customContent addStringExtra:nil forKey:nil];

       [_myJMSGConversation sendMessage:cutMessage];
       NSLog(@"------发送的custom：%@",cutMessage);

   }];
 }


- (IBAction)clickRepeatSendText:(id)sender {
    [self initUserContent];
    self.sendTimeTF.enabled =YES;
    NSString *sendTimesString = self.sendTimeTF.text;
    sendTimes = [sendTimesString integerValue];
    
    [JMSGConversation createSingleConversationWithUsername:user1 completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"------------与 %@的会话创建成功！",user1 );
            NSString *sendContent = [NSString stringWithFormat:@"%@:%@ - %@",user1,contentText,curTime];
            NSLog(@"-----------------sendContent:%@",sendContent);
            _myJMSGConversation = resultObject;
            for (int i = 1; i<=sendTimes; i++) {
                [self initUserContent];//初始化本页面的文本框
                [self curTimeValue];//获取一下当前时间
                NSString *sendContent = [NSString stringWithFormat:@"%@:--%d--%@,%@",user1,i,contentText,curTime];//把用户输入的内容和当前时间合成最终发送的内容
                NSLog(@"-----------------sendContent:%@",sendContent);
                [JMessage removeAllDelegates];

                [JMessage addDelegate:self withConversation:_myJMSGConversation];
                NSLog(@"-----循环发送按钮这里添加了delegate");

                [JMSGMessage sendSingleTextMessage:sendContent toUser:user1];
                
            }
        }
        else{
            NSLog(@"------------与 %@的会话创建失败！error ： %@ ,Result: %@",user1,error,resultObject );
        }
    }];

}

//调用相册
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self initUserContent];
    //先把图片转成NSData（注意图片的格式）
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *picData = UIImagePNGRepresentation(image);;
    [self dismissViewControllerAnimated:YES completion:nil];
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:_myJMSGConversation];
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

-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    if (error!=nil) {
        NSLog(@"---single--onReceiveMessage error is %@",error);
    }
    _message = message;
    NSLog(@"----single---onReceiveMessage :%@",message);
    NSString *onReceiveMessage = [NSString stringWithFormat:@"收到im消息：%@",message];
    [_textview setText:onReceiveMessage];

}

-(void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    if (error!=nil) {
        NSLog(@"---single--onReceiveMessage error is %@",error);
    }
    _message = message;
    NSLog(@"---single----im onSendMessageResponse :%@",message);
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
    NSLog(@"-----single--onConversationChanged:%@",conversation);
    singleMessage = [NSString stringWithFormat:@"%@",conversation];
    [_textview setText:singleMessage];
    NSLog(@"-----single--onConversationChanged:%@",singleMessage);

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
