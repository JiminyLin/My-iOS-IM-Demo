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
@interface FirstViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic ,retain)JMSGUser *myJMSGUser;

@end

@implementation FirstViewController
NSString *theUserName,*theUserPassword,*allResult,*avatarPath;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self unObserveAllNotifications];
    
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

-(void)unObserveAllNotifications {
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
    NSLog(@"已连接");
    [self.connectionStatus setText:@"JPush 已连接"];
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"未连接");
    [self.connectionStatus setText:@"JPush 未连接"];

}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    
    NSLog(@"已注册");
    [self.connectionStatus setText:@"JPush 已注册"];

}

- (void)networkDidLogin:(NSNotification *)notification {
    
    NSLog(@"已登录");
    NSLog(@"get RegistrationID: %@",[JPUSHService registrationID]);
    NSString * loginText =[ NSString stringWithFormat:@"JPush 已登录！rid: %@",[JPUSHService registrationID]];
    [self.connectionStatus setText:loginText];

}



- (IBAction)clickRegUser:(id)sender {
//    [self userNameAndPassword];
    
    self.userName.enabled =YES;
    NSString *theUserName= self.userName.text;
    
    self.userPassword.enabled = YES;
    NSString *theUserPassword = self.userPassword.text;

    [JMSGUser registerWithUsername:theUserName password:theUserPassword completionHandler:^(id resultObject, NSError *error) {
        if (error ==nil) {
            NSLog(@"-------注册用户：%@ ,成功！",theUserName);
            allResult = [NSString stringWithFormat:@"注册用户：%@，成功！",theUserName];
            [self.allResultTV setText:allResult];

        }
        else{
            allResult = [NSString stringWithFormat:@"注册用户:%@，失败！error：%@，result：%@",theUserName, error,resultObject];
            [self.allResultTV setText:allResult];
            NSLog(@"-------注册用户：%@ ,失败！原因：%@",theUserName,error);

        }
    }];
    
}
- (IBAction)clickLogin:(id)sender {
    
    self.userName.enabled =YES;
    NSString *theUserName= self.userName.text;
    
    self.userPassword.enabled = YES;
    NSString *theUserPassword = self.userPassword.text;
    
    [JMSGUser loginWithUsername:theUserName password:theUserPassword completionHandler:^(id resultObject, NSError *error) {
        if (error ==nil) {
            NSLog(@"-------登录用户：%@ ,成功！",theUserName);
            allResult = [NSString stringWithFormat:@"登录用户：%@，成功！",theUserName];
            [self.allResultTV setText:allResult];
            
            _myJMSGUser = resultObject;
            
            [_myJMSGUser largeAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
                if (error == nil) {
                    NSLog(@"------获取我的大图成功！－－－result:%@",resultObject);
                    self.showAvatarImage.image = [UIImage imageWithData:data];
                }
                else{
                    NSLog(@"------获取我的大图失败！－－－error：%@，－－－result：%@",error,resultObject);
                    
                }
            }];

        }
        else{
            allResult = [NSString stringWithFormat:@"登录用户:%@，失败！error：%@，result：%@",theUserName, error,resultObject];
            [self.allResultTV setText:allResult];
            NSLog(@"-------登录用户：%@ ,失败！原因：%@",theUserName,error);
            
        }

    }];
}
- (IBAction)clickLogout:(id)sender {
    
     [JMSGUser logout:^(id resultObject, NSError *error) {
        if (error ==nil) {
            NSLog(@"-------注销用户：%@ ,成功！",theUserName);
            allResult = [NSString stringWithFormat:@"注销用户成功！"];
            [self.allResultTV setText:allResult];
            self.showAvatarImage.image = [UIImage imageWithData:nil];

            
        }
        else{
            allResult = [NSString stringWithFormat:@"注销用户:%@，失败！error：%@，result：%@",theUserName, error,resultObject];
            [self.allResultTV setText:allResult];
            NSLog(@"-------注销用户：%@ ,失败！原因：%@",theUserName,error);
           
            
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
    
    
//    NSString *genderText= self.genderTF.text;
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
-(void)updateBirthday{
    self.birthdayTF.enabled=YES;
    NSNumber *birthdayText = self.birthdayTF.text;
    [JMSGUser updateMyInfoWithParameter:birthdayText userFieldType:kJMSGUserFieldsBirthday completionHandler:^(id resultObject, NSError *error) {
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
            NSLog(@"－－－设置签名“%@” 失败！error：%@,resulet:%@",regionText,error,resultObject);
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
    //这里将图片放在沙盒的documents文件夹中
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
            allResult = [NSString stringWithFormat:@"更新头像:%@，成功！error：%@，result：%@",theUserName, error,resultObject];            [self.allResultTV setText:allResult];
            
//            [self.showAvatarImage addSubview:image];
            self.showAvatarImage.image = [UIImage imageNamed:filePath];
//            self.showAvatarImage.image = [UIImage imageWithData:nil];
            
        }
        else{
            allResult = [NSString stringWithFormat:@"更新头像:%@，失败！error：%@，result：%@",theUserName, error,resultObject];
            [self.allResultTV setText:allResult];
            NSLog(@"-------更新头像：失败！error：%@，result：%@",error,resultObject);
        }
    }];

}

- (IBAction)clickGetMyInfo:(id)sender {
    allResult = [NSString stringWithFormat:@"－-我的个人信息：%@",[JMSGUser myInfo]];
  NSLog(@"------toux:%@", [JMSGUser myInfo].avatar) ;
    [self.allResultTV setText:allResult];
    
  
}

- (IBAction)clickGetMyGroupList:(id)sender {
    [JMSGGroup myGroupArray:^(id resultObject, NSError *error) {
        if(error == nil){
            NSLog(@"------成功获取我的群列表！群列表如下：%@",resultObject);
            dispatch_async(dispatch_get_main_queue(),^{
                allResult = [NSString stringWithFormat:@"－-我的群列表：%@",resultObject];
                [self.allResultTV setText:allResult];
            });
           

        }
        else{
            NSLog(@"------获取我的群列表失败！----error：%@---result:%@,",error,resultObject);
        }

    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
