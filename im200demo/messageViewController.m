//
//  messageViewController.m
//  im200demo
//
//  Created by LinGuangzhen on 15/10/28.
//  Copyright © 2015年 LinGuangzhen. All rights reserved.
//

#import "messageViewController.h"
#import <JMessage/JMessage.h>

@interface messageViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(strong,nonatomic)    UITextView *textview;
@property (strong,nonatomic) JMSGUser *otherJMSGUser;
@end
NSString *user1,*user2,*contentText,*curTime;
NSInteger sendTimes;
@implementation messageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [JMSGUser userInfoArrayWithUsernameArray:userArray completionHandler:^(id resultObject, NSError *error) {
        if (error ==nil) {
            NSLog(@"---获取用户 %@ 、%@的用户信息成功！，result：%@",user1,user2,resultObject);
            
            NSString *getUserInfo = [NSString stringWithFormat:@"%@",resultObject];
            [_textview setText:getUserInfo];
            
            _otherJMSGUser  = resultObject[0];
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
            
            [JMSGMessage sendSingleTextMessage:sendContent toUser:user1];

        }
        else{
            NSLog(@"------------与 %@的会话创建失败！error ： %@ ,Result: %@",user1,error,resultObject );

        }
    }];
    

}

- (IBAction)clickRepeatSendText:(id)sender {
    self.sendTimeTF.enabled =YES;
    NSString *sendTimesString = self.sendTimeTF.text;
    sendTimes = [sendTimesString integerValue];
    
    [JMSGConversation createSingleConversationWithUsername:user1 completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"------------与 %@的会话创建成功！",user1 );
            NSString *sendContent = [NSString stringWithFormat:@"%@:%@ - %@",user1,contentText,curTime];
            NSLog(@"-----------------sendContent:%@",sendContent);
            
            for (int i = 1; i<=sendTimes; i++) {
                [self initUserContent];
                [self curTimeValue];
                NSString *sendContent = [NSString stringWithFormat:@"%@:--%d--%@,%@",user1,i,contentText,curTime];
                NSLog(@"-----------------sendContent:%@",sendContent);
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
    
    [JMSGMessage sendSingleImageMessage:picData toUser:user1];
   }

- (IBAction)clickSendImag:(id)sender {
    
    UIImagePickerController *imgController = [[UIImagePickerController alloc]init];
    imgController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgController.delegate = self;
    [self presentViewController:imgController animated:YES completion:NULL];
    
    return;
    

}
- (IBAction)clickSendVoice:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
