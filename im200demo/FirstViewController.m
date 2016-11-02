//
//  FirstViewController.m
//  im200demo
//
//  Created by LinGuangzhen on 15/10/26.
//  Copyright © 2015年 LinGuangzhen. All rights reserved.
//

#import "FirstViewController.h"
#import <JMessage/JMessage.h>
    NSString* filePath;
@interface FirstViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,JMessageDelegate>
@property (nonatomic ,retain)JMSGUser *myJMSGUser;
@property (nonatomic ,retain)JMSGMessage *myJMSGMessage;
//@property (strong ,nonatomic )JMSGFriendEventContent *firstJMSGFriendEventContent;


@end

@implementation FirstViewController
NSString *theUserName,*theUserPassword,*allResult,*avatarPath;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self ObserveAllNotifications];
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
    NSLog(@"-------进入了home界面:FirstViewController");

    //隐藏键盘，star
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    //隐藏键盘，end
    // Do any additional setup after loading the view, typically from a nib.
}
//指定要隐藏键盘的控件
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.allResultTV resignFirstResponder];
    [self.signatureTF resignFirstResponder];
    [self.userName resignFirstResponder];
    [self.userPassword resignFirstResponder];
    [self.nikenameTF resignFirstResponder];
    [self.regionTF resignFirstResponder];
    [self.birthdayTF resignFirstResponder];
    [self.signatureTF resignFirstResponder];
    
}

-(void)ObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
       [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    
}

- (void)networkDidSetup:(NSNotification *)notification {
//    NSLog(@"－已连接");
    [self.connectionStatus setText:@"JPush 已连接"];
}

- (void)networkDidClose:(NSNotification *)notification {
//    NSLog(@"－未连接");
    [self.connectionStatus setText:@"JPush 未连接"];

}

- (void)networkDidRegister:(NSNotification *)notification {
//    NSLog(@"%@", [notification userInfo]);
    
//    NSLog(@"－已注册");
    [self.connectionStatus setText:@"JPush 已注册"];

}
- (void)networkDidLogin:(NSNotification *)notification {
    
    NSString * loginText =[ NSString stringWithFormat:@"－JPush 已登录！rid: %@",[JPUSHService registrationID]];
    [self.connectionStatus setText:loginText];
    
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

- (IBAction)clickGetAllDisturbStatus:(id)sender {
   NSLog(@"----当前登陆用户的全局防打扰状态：%d",[JMessage isSetGlobalNoDisturb]) ;
    allResult = [NSString stringWithFormat:@"－-获取当前登陆用户的全局防打扰状态：%d",[JMessage isSetGlobalNoDisturb]];
    [self showAlert:allResult];

}

- (IBAction)clickGetAllDisturbList:(id)sender {
    
    [JMessage noDisturbList:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"－-clickGetAllDisturbList--获取当前登陆用户的免打扰列表失败：%@",error);
            allResult = [NSString stringWithFormat:@"－-clickGetAllDisturbList--获取当前登陆用户的全局防打扰列表失败：%@",error];
            [self.allResultTV setText:allResult];
            [self showAlert:allResult];

            return ;
        }
        NSLog(@"－-clickGetAllDisturbList--获取当前登陆用户的全局防打扰列表成功：%@",resultObject);
        allResult = [NSString stringWithFormat:@"－-clickGetAllDisturbList--获取当前登陆用户的免打扰列表：%@",resultObject];
        [self showAlert:allResult];

        //此接口不可再主线程操作ui
//        allResult = [NSString stringWithFormat:@"－-clickGetAllDisturbList--获取当前登陆用户的全局防打扰列表成功：%@",resultObject];
//        [self.allResultTV setText:allResult];

        
    }];
}

- (IBAction)clickCloseAllMsgDisturb:(id)sender {
        [JMessage setIsGlobalNoDisturb:NO handler:^(id resultObject, NSError *error) {
    
        if (error != nil) {
            
            NSLog(@"－-clickCloseAllMsgDisturb--关闭当前登陆用户的全局防打扰失败：%@",error);
            
            allResult = [NSString stringWithFormat:@"关闭当前登陆用户的全局防打扰失败：%@",error];
            [self.allResultTV setText:allResult];
            [self showAlert:allResult];

            return ;
        }
        
        NSLog(@"－-clickCloseAllMsgDisturb--关闭当前登陆用户的全局防打扰成功：%@",resultObject);
        
        allResult = [NSString stringWithFormat:@"关闭当前登陆用户的全局防打扰成功：%@",resultObject];
        [self.allResultTV setText:allResult];
            [self showAlert:allResult];

    }];
    
}
- (IBAction)clickOpenAllMsgDisturb:(id)sender {
    
    [JMessage setIsGlobalNoDisturb:YES handler:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"－-clickCloseAllMsgDisturb-- 开启 当前登陆用户的全局防打扰失败：%@",error);
            allResult = [NSString stringWithFormat:@"开启 当前登陆用户的全局防打扰失败：%@",error];
            [self.allResultTV setText:allResult];
            [self showAlert:allResult];

            return ;
        }
        NSLog(@"－-clickCloseAllMsgDisturb--开启 当前登陆用户的全局防打扰成功：%@",resultObject);
        
        allResult = [NSString stringWithFormat:@"开启 当前登陆用户的全局防打扰成功：%@",resultObject];
        [self.allResultTV setText:allResult];
        [self showAlert:allResult];

    }];
    
}


- (IBAction)clickReg1000User:(id)sender {
    self.userName.enabled =YES;
    NSString *userNameStr= self.userName.text;
    self.userPassword.enabled =YES;
    NSString* userPasswordStr = self.userPassword.text;
    int starMember =   [userNameStr intValue];
    int toMemberNun = [userPasswordStr intValue];
    int curMemberNum = 0;
    int addMemberCount = starMember +toMemberNun ;
    
    self.nikenameTF.enabled = YES;
    NSString * strName = _nikenameTF.text;
    NSString * kongzifuchuan = @"";
    
     NSMutableArray *AddMemberArray=[NSMutableArray arrayWithCapacity:1001];
    NSLog(@"----AddMenberArray Count:%d",toMemberNun+starMember);
    if ([theUserName isEqualToString:kongzifuchuan ] | [strName isEqualToString:kongzifuchuan] | [theUserPassword isEqualToString:kongzifuchuan])
    {
        [self showAlert:@"请填写在user和密码文本框输入一个整形！\n昵称输入字符串！"];
        return;
    }
    for (starMember; starMember<= addMemberCount; starMember++) {
        
        [AddMemberArray addObject:[NSString stringWithFormat:@"%@%d",strName,starMember]];
        

        NSString* regUserV = [AddMemberArray objectAtIndex:curMemberNum];
        ++curMemberNum;

        
        [JMSGUser registerWithUsername:regUserV password:regUserV completionHandler:^(id resultObject, NSError *error) {
            if (error ==nil) {
                NSLog(@"-------注册用户：%@ ,成功！",regUserV);
                allResult = [NSString stringWithFormat:@"循环注册用户：%@，成功！",regUserV];
                [self.allResultTV setText:allResult];
                [self showAlert:allResult];

                
            }
            else{
              NSString *  showAlertAllResult = [NSString stringWithFormat:@"循环注册用户失败！error：%@",error];
                allResult =   [NSString stringWithFormat:@"循环注册用户:%@，失败！error：%@",regUserV, error];


                [self.allResultTV setText:allResult];
                NSLog(@"-------注册用户：%@ ,失败！原因：%@",regUserV,error);
                [self showAlert:showAlertAllResult];

            }
        }];


    }
    
    NSLog(@"---添加%d个用户到群",curMemberNum);

}

-(void)regUser{
    
    self.userName.enabled =YES;
    NSString *theUserName= self.userName.text;
    
    self.userPassword.enabled = YES;
    NSString *theUserPassword = self.userPassword.text;
    
    [JMSGUser registerWithUsername:theUserName password:theUserPassword completionHandler:^(id resultObject, NSError *error) {
        if (error ==nil) {
            NSLog(@"-------注册用户：%@ ,成功！",theUserName);
            allResult = [NSString stringWithFormat:@"注册用户：%@，成功！",theUserName];
            [self.allResultTV setText:allResult];
            [self showAlert:allResult];
            
        }
        else{
            allResult = [NSString stringWithFormat:@"注册用户:%@，失败！error：%@，result：%@",theUserName, error,resultObject];
            [self.allResultTV setText:allResult];
            NSLog(@"-------注册用户：%@ ,失败！原因：%@",theUserName,error);
            [self showAlert:allResult];
            
        }
    }];
    
}

- (IBAction)clickRegUser:(id)sender {
//    [self userNameAndPassword];
    [self regUser];
  }
-(void )LoginUser{
    self.userName.enabled =YES;
    NSString *theUserName= self.userName.text;
    
    self.userPassword.enabled = YES;
    NSString *theUserPassword = self.userPassword.text;
    NSLog(@"-------登录");
    [JMSGUser loginWithUsername:theUserName password:theUserPassword completionHandler:^(id resultObject, NSError *error) {
        if (error ==nil) {
            NSLog(@"-------登录用户：%@ ,成功！",theUserName);
            allResult = [NSString stringWithFormat:@"登录用户：%@，成功！",theUserName];
            [self.allResultTV setText:allResult];
            [self showAlert:allResult];
            
            _myJMSGUser = resultObject;//把登录后返回的内容赋给这个实例化的JMSGUser对象
            
            self.showDisplayName.enabled = YES;
            NSString *displayName = _myJMSGUser.displayName ;
            NSLog(@"---displayName:%@",displayName);
            [self.showDisplayName setText:displayName];
            
            
            
            //通过这个这个实例化的JMSGUser对象去获取当前登录用户的头像的缩略图
            [_myJMSGUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
                if (error == nil) {
                    NSLog(@"------获取我的大图成功！");//－－－data:%@--objectId:%@",data,objectId);
                    self.showAvatarImage.image = [UIImage imageWithData:data];//把获取缩略图的方法得到的data赋值到image view展示
                }
                else{
                    NSLog(@"------获取我的大图失败！－－－error：%@",error);
                    
                }
            }];
            
            //           Boolean isEqualToUser=  [_myJMSGUser isEqualToUser:_myJMSGUser];
            //            NSLog(@"----isEqualToUser:%d",isEqualToUser);
            //通过这个这个实例化的JMSGUser对象去获取当前登录用户的头像的大图
            //            [_myJMSGUser largeAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
            //                if (error == nil) {
            //                    NSLog(@"------获取我的大图成功！－－－result:%@",resultObject);
            //                    self.showAvatarImage.image = [UIImage imageWithData:data];
            //                }
            //                else{
            //                    NSLog(@"------获取我的大图失败！－－－error：%@，－－－result：%@",error,resultObject);
            //
            //                }
            //            }];
            
        }
        else{
            allResult = [NSString stringWithFormat:@"登录用户:%@，失败！－－－error：%@，－－－result：%@",theUserName, error,resultObject];
            [self.allResultTV setText:allResult];
            NSLog(@"-------登录用户：%@ ,失败！－－－error：%@，－－－result：%@",theUserName, error,resultObject);
            [self showAlert:allResult];
            
        }
        
    }];
}
- (IBAction)clickLogin:(id)sender {
//    [self regUser];
//
//
//    [self LoginUser];
//    [JMSGConversation createSingleConversationWithUsername:theUserName completionHandler:^(id resultObject, NSError *error) {
//        if (error != nil) {
//            NSLog(@"---clickLogin-createSingleConversationWithUsername fail:%@",error);
//            return ;
//        
//        }
//        NSLog(@"---clickLogin-createSingleConversationWithUsername pass");
//
//    }];
//    [self regUser];
//    [self LoginUser];
    [self LoginUser];

}
- (IBAction)clickLogout:(id)sender {
    NSLog(@"---set badge");
    [JPUSHService setBadge:0];
     [JMSGUser logout:^(id resultObject, NSError *error) {
        if (error ==nil) {
            NSLog(@"-------注销用户：%@ ,成功！",theUserName);
            allResult = [NSString stringWithFormat:@"注销用户成功！"];
            [self.allResultTV setText:allResult];
            self.showAvatarImage.image = [UIImage imageWithData:nil];
            [self showAlert:allResult];

            
        }
        else{
            allResult = [NSString stringWithFormat:@"注销用户:%@，失败！error：%@，result：%@",theUserName, error,resultObject];
            [self.allResultTV setText:allResult];
            NSLog(@"-------注销用户：%@ ,失败！原因：%@",theUserName,error);
            [self showAlert:allResult];

            
        }
    }];
}
- (IBAction)clickUpdateMyInfo:(id)sender {
    [self updateGender];
    [self updateNikename];
    [self updateRegion];
    [self updateSignature];
    [self updateBirthday];
    
 
}
//更新昵称
-(void)updateNikename{
    self.nikenameTF.enabled=YES;
    NSString *nikenameText = self.nikenameTF.text;
    [JMSGUser updateMyInfoWithParameter:nikenameText userFieldType:kJMSGUserFieldsNickname completionHandler:^(id resultObject, NSError *error) {
        if (error ==nil) {
            NSLog(@"－－－设置昵称“%@” 成功！",nikenameText);
        }
        else{
            NSLog(@"－－－设置昵称“%@” 失败！error：%@,resulet:%@",nikenameText,error,resultObject);
        }

    }];
}
//更新性别
-(void)updateGender{
    NSNumber *genderValue;
    if (self.genderSwitch.isOn) {
        genderValue = [NSNumber numberWithInt:1];
    }
    else{
        genderValue = [NSNumber numberWithInt:0];

    }
    
    [JMSGUser updateMyInfoWithParameter:genderValue userFieldType:kJMSGUserFieldsGender completionHandler:^(id resultObject, NSError *error) {
        if (error==nil) {
            NSLog(@"－－－设置性别“%@” 成功！",genderValue );
        }
        else{
            NSLog(@"－－－设置性别“%@” 失败！error：%@,resulet:%@",genderValue,error,resultObject);
        }
    }];
}
//更新生日
// 1999-10-22
-(void)updateBirthday{
    self.birthdayTF.enabled=YES;
    NSString *birthdayText = self.birthdayTF.text;//从文本框得到NSString类型的年月日
    //定义data 格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *dateCheck = [dateFormatter dateFromString:birthdayText];//把NSString格式的年月日转换成规定格式的NSDate

    NSNumber *birthday = @([dateCheck timeIntervalSince1970]);//得到输入日期的时间戳
    [JMSGUser updateMyInfoWithParameter:birthday userFieldType:kJMSGUserFieldsBirthday completionHandler:^(id resultObject, NSError *error) {
        if (error==nil) {
            NSLog(@"－－－设置生日“%@” 成功！",birthdayText);
        }
        else{
            NSLog(@"－－－设置生日“%@” 失败！error：%@,resulet:%@",birthdayText,error,resultObject);
        }

    }];
    
}
//更新区域
-(void)updateRegion{
    self.regionTF.enabled=YES;
    NSString *regionText= self.regionTF.text;
    [JMSGUser updateMyInfoWithParameter:regionText userFieldType:kJMSGUserFieldsRegion completionHandler:^(id resultObject, NSError *error) {
        if (error==nil) {
            NSLog(@"－－－设置区域“%@” 成功！",regionText);
        }
        else{
            NSLog(@"－－－设置区域 “%@” 失败！error：%@,resulet:%@",regionText,error,resultObject);
        }

    }];
}
//更新签名
-(void)updateSignature{
    self.signatureTF.enabled=YES;
    NSString *signatureText= self.signatureTF.text;
    [JMSGUser updateMyInfoWithParameter:signatureText userFieldType:kJMSGUserFieldsSignature completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"－－－设置签名“%@” 成功！",signatureText);
        }
        else{
            NSLog(@"－－－设置签名“%@” 失败！error：%@,resulet:%@",signatureText,error,resultObject);

        }
    }];
}
//触发更新头像
- (IBAction)clickUpdateAvatar:(id)sender {
    UIImagePickerController *imgController = [[UIImagePickerController alloc]init];
    imgController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgController.delegate = self;
    [self presentViewController:imgController animated:YES completion:NULL];
    
    return;
}
//调用相册
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //先把图片转成NSData（注意图片的格式）
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *data = UIImagePNGRepresentation(image);;
    [self dismissViewControllerAnimated:YES completion:nil];
    //图片保存的路径
    //指定图片存放的沙盒路径：documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
    
    //关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];

    [JMSGUser updateMyInfoWithParameter:data userFieldType:5 completionHandler:^(id resultObject, NSError *error) {
        if (error ==nil) {
            NSLog(@"-----更新头像成功！");
            allResult = [NSString stringWithFormat:@"更新头像:%@，成功！\nresult：%@",theUserName, resultObject];
            [self.allResultTV setText:allResult];
            [self showAlert:allResult];

//            [self.showAvatarImage addSubview:image];
            self.showAvatarImage.image = [UIImage imageNamed:filePath];
//            self.showAvatarImage.image = [UIImage imageWithData:nil];
            
        }
        else{
            allResult = [NSString stringWithFormat:@"更新头像:%@，失败！error：%@",theUserName, error];
            [self.allResultTV setText:allResult];
            NSLog(@"-------更新头像：失败！error：%@，result：%@",error);
            [self showAlert:allResult];

        }
    }];

}

- (IBAction)clickGetMyInfo:(id)sender {

    
    _myJMSGUser = [JMSGUser myInfo];
//    NSLog(@"-------clickGetMyInfo－get my info 的 appkey：%@",_myJMSGUser.appKey);
    allResult = [NSString stringWithFormat:@"－-我的个人信息：%@",_myJMSGUser];
    NSLog(@"------clickGetMyInfo－我的个人信息:%@",allResult) ;
    


  NSLog(@"------clickGetMyInfo－我的头像:%@", [JMSGUser myInfo].avatar) ;
    [self.allResultTV setText:allResult];
    
    NSLog(@"----clickGetMyInfo－－当前登陆的用户的displayName：%@",[_myJMSGUser displayName]);
    [_myJMSGUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        if (error == nil) {
            self.showAvatarImage.image = [UIImage imageWithData:data];//把获取缩略图的方法得到的data赋值到image view展示
            NSLog(@"------获取我的大图成功！－－－data：%@,objectId:%@",error,objectId);

        }
        else{
            NSLog(@"------获取我的大图失败！－－－error：%@",error);
            
        }
    }];
    
  
}

- (IBAction)clickGetMyGroupList:(id)sender {
    NSLog(@"------开始获取我的群列表!");

    [JMSGGroup myGroupArray:^(id resultObject, NSError *error) {
        if(error == nil){
            NSLog(@"------成功获取我的群列表！群列表如下：%@",resultObject);
            dispatch_async(dispatch_get_main_queue(),^{
                allResult = [NSString stringWithFormat:@"－-我的群列表：%@",resultObject];
                [self.allResultTV setText:allResult];
               

            });
           

        }
        else{
            NSLog(@"------获取我的群列表失败！----error：%@",error);
            allResult = [NSString stringWithFormat:@"－-我的群列表失败：%@",error];

            [self showAlert:allResult];

        }

    }];
}

//callback
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
- (IBAction)clickGetAllConversation:(id)sender {
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"-------当前登录用户会话获取出错！error:%@ ,resultObject:%@",error,resultObject);
            return ;
        }
        NSString *myAllConversation = [NSString stringWithFormat:@"%@",resultObject];
        [self.allResultTV setText:myAllConversation];
        NSLog(@"--------当前用户的会话列表如下：%@",myAllConversation);
    }];
}


-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    if (error !=nil) {
        NSLog(@"－－－\n 主页--onReceiveMessage，收到消息异常：%@",error);
        
        return;
    }
    //展示默认事件信息
    //    if (message.contentType == kJMSGContentTypeEventNotification) {
    //        NSString *showText = [((JMSGEventContent *)message.content) showEventNotification];
    //        [self showAlert:showText];
    //    }
    NSLog(@"--－－－－发送者对象：%@,\n用户名是：%@",message.fromUser,message.fromUser.username);
    
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
        
        switch(eventContent.eventType)
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
    
    NSLog(@"－－－\n主页-onReceiveMessage，收到消息成功！messge：%@",message);
    
    
}

-(void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    if (error !=nil) {
        allResult = [NSString stringWithFormat:@"发送消息失败：%@",error];
        [self showAlert:allResult];
//        NSLog(@"------home-onSendMessageResponse发消息失败！！from appkey(%@),targetAppkey(%@),--error：%@,---message:%@",_myJMSGMessage.fromAppKey,_myJMSGMessage.targetAppKey,error,message);
        
    }else {
        _myJMSGMessage = message;
        allResult = [NSString stringWithFormat:@"发送消息成功：%@",message];
        [self showAlert:allResult];

//        NSLog(@"------home-onSendMessageResponse发消息成功！！！\nfrom appkey(%@),\ntargetAppkey(%@),\n--error：%@,\n---message:%@",_myJMSGMessage.fromAppKey,_myJMSGMessage.targetAppKey,error,_myJMSGMessage);

    }
}

-(void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event{
    JMSGNotificationEvent *nEvent = event;
    JMSGFriendNotificationEvent * friendEvent ;
    NSLog(@"---------home--onReceiveNotificationEvent收到 通知事件");
    
//    if ([event isKindOfClass:[JMSGFriendNotificationEvent class]]) {
//        JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
//        [friendEvent getReason];
//    }
    
    switch (nEvent.eventType) {
        case  kJMSGEventNotificationFriendInvitation:
        {
            friendEvent = (JMSGFriendNotificationEvent *)event;

            NSLog(@"---------home--onReceiveNotificationEvent收到 好友邀请相关 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
          
        }
            break;
            
        case  kJMSGEventNotificationReceiveFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------home--onReceiveNotificationEvent收到 好友邀请 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
        }
            break;
            
        case  kJMSGEventNotificationAcceptedFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;

            NSLog(@"---------home--onReceiveNotificationEvent收到 同意添加好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);        }
            break;
            
        case  kJMSGEventNotificationDeclinedFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;

            NSLog(@"---------home--onReceiveNotificationEvent收到 拒绝好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
        }
            break;
            
        case  kJMSGEventNotificationDeletedFriend:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            NSLog(@"---------home--onReceiveNotificationEvent收到 删除好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);

        }
            
            break;
            
        case  kJMSGEventNotificationLoginKicked:
            NSLog(@"---------home--onReceiveNotificationEvent收到 多设备登陆被t 通知事件，描述：%@",nEvent.eventDescription);
            break;
        case  kJMSGEventNotificationServerAlterPassword:
            NSLog(@"---------home--onReceiveNotificationEvent收到 非客户端修改密码被t 通知事件，描述：%@",nEvent.eventDescription);
            break;
        case  kJMSGEventNotificationUserLoginStatusUnexpected:
            NSLog(@"---------home--onReceiveNotificationEvent收到 Juid变更导致下线的 事件，描述：%@",nEvent.eventDescription);
            break;
        default:
            NSLog(@"---------home--onReceiveNotificationEvent收到 未知事件类型，描述：%@",nEvent.eventDescription);
            break;
    }
    
    nEvent  = nil ;
    friendEvent = nil;
}

-(void)onReceiveMessageDownloadFailed:(JMSGMessage *)message{
    
    NSLog(@"-----home--onReceiveMessageDownloadFailed收到消息下载失败,----message:%@",message);
}

-(void)onGroupInfoChanged:(JMSGGroup *)group{
    NSLog(@"----home---onGroupInfoChanged:%@",group);
}

-(void)onConversationChanged:(JMSGConversation *)conversation{
    NSLog(@"---home----onConversationChanged:%@",conversation);
}

-(void)onUnreadChanged:(NSUInteger)newCount{
    NSLog(@"----home---onUnreadChanged:%ld",newCount);
    
}

-(void)onLoginUserKicked{
    NSLog(@"-----home--onLoginUserKicked");
    [self showAlert:@"-----home--onLoginUserKicked，被踢下线！"];

}


//220b90及之前的220获取好友事件的方法
//-(void)onFriendChanged:(JMSGFriendEventContent *)event{
//    JMSGFriendEventContent * disturbJMSGFriendEventContent = event;
//    NSLog(@"----home页面测试---onFriendChanged:%@\n",event);
//    NSLog(@"----home页面测试---onFriendChanged:{\n好友通知事件类型:%ld,\n获取事件发生的理由:%@,\n事件发送者的username:%@,\n获取事件发送者user:%@",disturbJMSGFriendEventContent.eventType,[disturbJMSGFriendEventContent getReason],[disturbJMSGFriendEventContent getFromUsername],[disturbJMSGFriendEventContent getFromUser]);
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"-------进入了主页:FirstViewController");
      [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
}
@end
