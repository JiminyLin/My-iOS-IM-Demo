//
//  disturbAndBlackListViewController.m
//  im213demo
//
//  Created by LinGuangzhen on 16/6/28.
//  Copyright © 2016年 LinGuangzhen. All rights reserved.
//

#import "DisturbAndBlackListViewController.h"
#import <JMessage/JMessage.h>

@interface DisturbAndBlackListViewController ()<JMessageDelegate>
{
    
    NSString *_curTimeV;
    NSString *_disUser1V;
    NSString *_disUser2V;
    NSString *_disAppkeyV;

    NSString * _disStrUserV;
    NSString *_disGroupIdV;
    NSString * _disAlertText;
    NSString * kongzifuchuan ;

    
    NSArray *userList;
    
    
}
@property (strong ,nonatomic )JMSGMessage * disJMessage;
@property  (strong ,nonatomic)JMSGConversation *disConversation;
@property (strong ,nonatomic )JMSGGroup * disJMSGGroup;
@property (strong ,nonatomic )JMSGUser * disJMSGUser;


@end

@implementation DisturbAndBlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< 全平台" style:UIBarButtonItemStylePlain target:self action:@selector(morePage)];
    
    NSLog(@"-------进入了DisturbAndBlackListViewController 页面！");
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

//指定要隐藏键盘的控件
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.user1TF resignFirstResponder];
    [self.user2TF resignFirstResponder];

    [self.groupIdTF resignFirstResponder];

    [self.appkeyTF resignFirstResponder];

  [self.strUserTF resignFirstResponder];
}
-(void )initTv{
    self.user1TF.enabled = YES;
    _disUser1V = _user1TF.text;
    
    self.user2TF.enabled = YES;
    _disUser2V = _user2TF.text;
    
    userList = [[NSArray alloc] initWithObjects:
                    _disUser1V,nil];
    
    self.appkeyTF.enabled = YES;
    _disAppkeyV = _appkeyTF.text;
    
    self.groupIdTF.enabled = YES;
    _disGroupIdV = _groupIdTF.text;
    
    self.strUserTF.enabled = YES;
    _disStrUserV = _strUserTF.text;
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

- (IBAction)clickRegisterBatchUser:(id)sender {
    [self initTv];
    int starMember =   [_disUser1V intValue];
    int toMemberNun = [_disUser2V intValue];
    int curMemberNum = 0;
kongzifuchuan = @"";
    int addMemberCount = starMember +toMemberNun ;
    NSMutableArray *AddMemberArray=[NSMutableArray arrayWithCapacity:1000];
    NSLog(@"----AddMenberArray Count:%d",toMemberNun+starMember);
    if ([_disUser1V isEqualToString:kongzifuchuan] | [_disStrUserV isEqualToString:kongzifuchuan] | [_disStrUserV isEqualToString:kongzifuchuan]) {
        [self showAlert:@"请填写在user1、user2输入一个整形！strName输入一个字符串！"];
        return;
    }
        for (starMember; starMember<= addMemberCount; starMember++) {
            
            [AddMemberArray addObject:[NSString stringWithFormat:@"%@%d",_disStrUserV,starMember]];
            
            NSString * regiUserV = AddMemberArray[curMemberNum];

            ++curMemberNum;

        [JMSGUser registerWithUsername:regiUserV password:regiUserV completionHandler:^(id resultObject, NSError *error) {
            if (error ==nil) {
                NSLog(@"-------注册用户：%@ ,成功！",regiUserV);
                _disAlertText = [NSString stringWithFormat:@"循环注册用户：%@，成功！",regiUserV];
                [self showAlert:_disAlertText];
                
                
            }
            else{
                NSString *  showAlertAllResult = [NSString stringWithFormat:@"循环注册用户失败！error：%@",error];
                _disAlertText =   [NSString stringWithFormat:@"循环注册用户:%@，失败！error：%@",regiUserV, error];
               
                NSLog(@"-------注册用户：%@ ,失败！原因：%@",regiUserV,error);
                [self showAlert:showAlertAllResult];
            
            }
        }];
    }
    NSLog(@"---添加%d个用户到群",curMemberNum);
}

- (IBAction)clickGetGroupInfo:(id)sender {
        [self initTv];
    [JMSGGroup groupInfoWithGroupId:_disGroupIdV completionHandler:^(id resultObject, NSError *error) {
        if (error != nil) {
                    NSLog(@"－－－\n clickGetGroupInfo  获取群：%@失败：%@",_disGroupIdV,error);
            _disAlertText = [NSString stringWithFormat:@"－－－\n clickGetGroupInfo  获取群：%@失败：%@",_disGroupIdV,error];
            [self showAlert:_disAlertText];
            return ;
        }
        
        _disJMSGGroup = resultObject;
        NSArray * memberArrayV =  _disJMSGGroup.memberArray;
        long  memberCount = memberArrayV.count;

        NSLog(@"－－－\n  clickGetGroupInfo 获取群：%@成功：%@,\n群成员最大数：%@,\n群成员：%@,\n当前用户成员总数：%ld,\n群主是：%@，群主所在appkey：%@",_disGroupIdV,resultObject,_disJMSGGroup.maxMemberCount,_disJMSGGroup.memberArray,memberCount,_disJMSGGroup.owner,_disJMSGGroup.ownerAppKey);
  
        _disAlertText = [NSString stringWithFormat:@"－－－n  clickGetGroupInfo 获取群［%@］的群信息成功，\n群成员最大数：%@,\n当前用户成员总数：%ld,\nwoner:%@",_disGroupIdV,_disJMSGGroup.maxMemberCount, memberCount,_disJMSGGroup.owner];
        [self showAlert:_disAlertText];

    }];
}

- (IBAction)clickAddStrideAppGroupMember:(id)sender {
        [self initTv];
   if (_disJMSGGroup == nil) {
        NSLog(@"－－－\n clickAddStrideAppGroupMember,尚未实例化JMSGGroup，不做添加跨应用成员[%@]动作！",userList);
       _disAlertText = [NSString stringWithFormat:@"尚未实例化JMSGGroup，不做添加跨应用成员[%@]动作！",userList];
       [self showAlert:_disAlertText];
        return;
    }
//    NSLog(@"---当前群对象是：％@"，_disJMSGGroup.\);
    [_disJMSGGroup addMembersWithUsernameArray:userList appKey:_disAppkeyV completionHandler:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"－－－\n clickAddStrideAppGroupMember,加跨应用成员[appkey:%@,user:%@]失败:%@",_disAppkeyV,userList,error);
            
            _disAlertText = [NSString stringWithFormat:@"加跨应用成员[%@]失败:%@",userList,error];
            [self showAlert:_disAlertText];
            return ;
        }
        NSLog(@"－－－\n clickAddStrideAppGroupMember[%@],加跨应用成员成功:%@",userList,resultObject);
        
        _disAlertText = [NSString stringWithFormat:@"加跨应用成员[%@]成功:%@",userList,resultObject];
//        [self showAlert:_disAlertText];
        
    }];
    
}

- (IBAction)clickAddBatchStrideAppGroupMember:(id)sender {
    [self initTv];
    int starMember = [_disUser1V intValue];
    int maxMember = [_disUser2V intValue];
    int curMemberNum = 0;
    int memberCountNum = starMember + maxMember;
    kongzifuchuan = @"";

    
    NSMutableArray *AddMenberArray=[NSMutableArray arrayWithCapacity:1000];
    NSLog(@"----AddMenberArray Count:%d",maxMember+starMember);
    if ([_disUser1V isEqualToString:kongzifuchuan] | [_disStrUserV isEqualToString:kongzifuchuan] | [_disStrUserV isEqualToString:kongzifuchuan]) {
        [self showAlert:@"请填写在user1、user2输入一个整形！strName输入一个字符串！"];
        return;
    }
    for (starMember ; starMember<= memberCountNum; starMember++) {
      ++curMemberNum;
       
        [AddMenberArray addObject:[NSString stringWithFormat:@"%@%d",_disStrUserV,curMemberNum]];
      

    }
    
    NSLog(@"---添加%d个用户到群",curMemberNum);

    [_disJMSGGroup addMembersWithUsernameArray:AddMenberArray completionHandler:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"---群聊页面批量添加群成员，失败：%@",error);
            _disAlertText = [NSString stringWithFormat:@"---批量加群用户失败！%@",error];
            [self showAlert:_disAlertText];
            return ;
        }
        NSLog(@"---群聊页面批量添加群成员，成功：%@",resultObject);
        [self showAlert:@"---批量添加群成员，成功，具体看日志！！"];
    }];

}

- (IBAction)clickDelStrideAppGroupMember:(id)sender {
        [self initTv];
    if (_disJMSGGroup == nil) {
        NSLog(@"－－－\n clickDelStrideAppGroupMember,尚未实例化JMSGGroup，不做添加跨应用成员动作！");
        
        _disAlertText = [NSString stringWithFormat:@"尚未实例化JMSGGroup，不做添加跨应用成员动作！"];
        [self showAlert:_disAlertText];

        return;
    }
    
    [_disJMSGGroup removeMembersWithUsernameArray:userList appKey:_disAppkeyV completionHandler:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"－－－\n clickDelStrideAppGroupMember,删除跨应用成员[appkey:%@,user:%@]失败:%@",_disAppkeyV,_disUser1V,error);
            _disAlertText = [NSString stringWithFormat:@"删除跨应用成员失败:%@",error];
            [self showAlert:_disAlertText];
            return ;
        }
        NSLog(@"－－－\n clickDelStrideAppGroupMember[%@],删除跨应用成员成功:%@",userList,resultObject);\
        
        _disAlertText = [NSString stringWithFormat:@"删除跨应用成员[user:%@]成功:%@",userList,resultObject];
//        [self showAlert:_disAlertText];
    }];
}

- (IBAction)clickCreatStrideSingleConversation:(id)sender {
        [self initTv];
  [  JMSGConversation createSingleConversationWithUsername:_disUser1V appKey:_disAppkeyV completionHandler:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"－－－\n clickCreatStrideSingleConversation,创建跨应用单聊会话失败:%@",error);
            _disAlertText = [NSString stringWithFormat:@"clickCreatStrideSingleConversation,创建跨应用单聊会话失败:\n%@",error];
            [self showAlert:_disAlertText];
            return ;
        }
        NSLog(@"－－－\n clickCreatStrideSingleConversation,创建跨应用单聊会话成功:%@",resultObject);
      _disConversation = resultObject;
      
      _disAlertText = [NSString stringWithFormat:@"clickCreatStrideSingleConversation,创建跨应用单聊［appkey:%@,user:%@］会话成功:\n%@",_disAppkeyV,_disUser1V,resultObject];
      [self showAlert:_disAlertText];
      
    }];

}
- (IBAction)clickGetStrideSingleConversation:(id)sender {
    [self initTv];

  NSLog(@"－－－\n clickGetStrideSingleConversation,获取到key[%@]下用户［%@］的会话：%@",_disAppkeyV,_disUser1V,[JMSGConversation singleConversationWithUsername:_disUser1V appKey:_disAppkeyV])  ;
    
    _disConversation = [JMSGConversation singleConversationWithUsername:_disUser1V appKey:_disAppkeyV];
    
    _disAlertText = [NSString stringWithFormat:@"－－－\n clickGetStrideSingleConversation,获取到key[%@]下用户［%@］的会话：%@",_disAppkeyV,_disUser1V,[JMSGConversation singleConversationWithUsername:_disUser1V appKey:_disAppkeyV]];
    
    [self showAlert:_disAlertText];
}

- (IBAction)clickGetConversationAllMsg:(id)sender {
    [_disConversation allMessages:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"－－－\n clickGetConversationAllMsg,获取跨应用群聊会话所有消息失败:%@",error);
            
            _disAlertText = [NSString stringWithFormat:@"－－－\n clickGetConversationAllMsg,获取跨应用群聊会话所有消息失败:%@",error];
            
            [self showAlert:_disAlertText];
            return ;
        }
        NSLog(@"－－－\n clickCreatStrideSingleConversation,获取跨应用群聊会话所有消息成功:\n%@",resultObject);
        
        _disAlertText = [NSString stringWithFormat:@"－－－\n 获取跨应用群聊会话所有消息成功:\n%@",resultObject];
        [self showAlert:_disAlertText];
    }];
}

- (IBAction)clickCreatStrideGroupConversation:(id)sender {
        [self initTv];
    [JMSGConversation createGroupConversationWithGroupId:_disGroupIdV completionHandler:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"－－－\n clickCreatStrideGroupConversation,创建群聊会话[%@]失败:%@",_disGroupIdV,error);
           
            _disAlertText = [NSString stringWithFormat:@"－－－\n 创建群聊会话失败:%@",error];
            [self showAlert:_disAlertText];
            return ;
        }
        NSLog(@"－－－\n clickCreatStrideSingleConversation,创建跨应用群聊会话成功:%@",resultObject);
        _disConversation = resultObject;
        
        
        _disAlertText = [NSString stringWithFormat:@"－－－\n 创建 群聊会话 成功!"];
        [self showAlert:_disAlertText];
    }];
}

- (IBAction)clickGetStrideGroupConversation:(id)sender {
   NSLog(@"－－－\n －clickGetStrideGroupConversation,获取群[%@]信息：%@",_disGroupIdV,[JMSGConversation groupConversationWithGroupId:_disGroupIdV]) ;
        _disConversation = [JMSGConversation groupConversationWithGroupId:_disGroupIdV];
    _disAlertText = [NSString stringWithFormat:@"－－获取群聊会话:%@",_disConversation];
    [self showAlert:_disAlertText];
}

- (IBAction)clickDelStrideSingleConversation:(id)sender {
        [self initTv];
    [JMSGConversation deleteSingleConversationWithUsername:_disUser1V appKey:_disAppkeyV];
    NSLog(@"－－－\n clickDelStrideSingleConversation,删除与appkey:［%@］ 用户为：［%@］  的会话",_disAppkeyV,_disUser1V);
    
    _disAlertText = [NSString stringWithFormat:@"－－删除了［appkey:%@,user:%@］的单聊会话！",_disAppkeyV,_disUser1V];
    [self showAlert:_disAlertText];
    
}
- (IBAction)clickDelStrideGroupConversion:(id)sender {
        [self initTv];
    
    [JMSGConversation deleteGroupConversationWithGroupId:_disGroupIdV];
    NSLog(@"－－－\n clickDelStrideGroupConversion,删除群%@会话:",_disGroupIdV);
    _disAlertText = [NSString stringWithFormat:@"－－删除了［appkey:%@,GroupID:%@］的群聊会话！",_disAppkeyV,_disGroupIdV];
    [self showAlert:_disAlertText];

}

- (IBAction)clickDelStrideConversationMsg:(id)sender {
    
    [_disConversation deleteAllMessages];
    
    NSLog(@"－－－\n clickDelStrideGroupConversion,删除会话[%@]的所有消息",_disConversation);
    _disAlertText = [NSString stringWithFormat:@"－－删除了删除会话[%@]的所有消息",_disConversation];
    [self showAlert:_disAlertText];

}

- (IBAction)clickOpenStrideDisturb:(id)sender {
        [self initTv];
  [  JMSGUser userInfoArrayWithUsernameArray:userList appKey:_disAppkeyV completionHandler:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"－－－\n clickOpenStrideDisturb,获取用户信息失败～！！error:%@",error);
            _disAlertText = [NSString stringWithFormat:@"－－clickOpenStrideDisturb,获取用户信息失败～！！error:%@",error];
            [self showAlert:_disAlertText];

            return;
                   }
        NSLog(@"－－－\n clickOpenStrideDisturb,获取用户信息成功～！！resultObject:%@",resultObject);
        NSArray *usersArrayResultObject = resultObject;
                    _disJMSGUser = usersArrayResultObject[0];
      NSLog(@"－－－\n clickOpenStrideDisturb,即将开启对[%@]的免打扰",_disJMSGUser);
      

      [_disJMSGUser setIsNoDisturb:YES handler:^(id resultObject, NSError *error) {
          if (error != nil) {
              NSLog(@"－－－\n clickOpenStrideDisturb,开免打扰，失败～！！error:%@",error);
              _disAlertText = [NSString stringWithFormat:@"－－开免打扰，失败～！！error:%@",error];
              [self showAlert:_disAlertText];
              return;
          }
          NSLog(@"－－－\n clickOpenStrideDisturb,开免打扰，成功～！！结果:%@",resultObject);
          _disAlertText = [NSString stringWithFormat:@"－－开免［user:%@］打扰，成功～！！",_disJMSGUser];
          [self showAlert:_disAlertText];
     
      }];

    }];
}
- (IBAction)clickClosedStrideDisturb:(id)sender {
        [self initTv];
    [  JMSGUser userInfoArrayWithUsernameArray:userList appKey:_disAppkeyV completionHandler:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"－－－\n clickClosedStrideDisturb,获取用户[appkey:%@,user:%@]信息失败～！！error:%@",_disAppkeyV,_disUser1V,error);
            _disAlertText = [NSString stringWithFormat:@"－－clickClosedStrideDisturb,获取用户[appkey:%@,user:%@]信息失败～！！error:%@",_disAppkeyV,_disUser1V,error];
            [self showAlert:_disAlertText];
            return;
        }
        NSLog(@"－－－\n clickClosedStrideDisturb,获取用户信息成功～！！error:%@",resultObject);
        NSArray *usersArrayResultObject = resultObject;
        _disJMSGUser = usersArrayResultObject[0];
        NSLog(@"－－－\n clickOpenStrideDisturb,即将关闭对[%@]的免打扰",_disJMSGUser);
        
        [_disJMSGUser setIsNoDisturb:NO handler:^(id resultObject, NSError *error) {
            if (error != nil) {
                NSLog(@"－－－\n clickOpenStrideDisturb,关闭打扰，失败～！！error:%@",error);
                _disAlertText = [NSString stringWithFormat:@"－－clickClosedStrideDisturb,关闭用户[appkey:%@,user:%@]免打扰失败～！！error:%@",_disAppkeyV,_disUser1V,error];
                [self showAlert:_disAlertText];
                return;
            }
            NSLog(@"－－－\n clickOpenStrideDisturb,关闭打扰，成功～！！结果:%@",resultObject);
            _disAlertText = [NSString stringWithFormat:@"－－clickClosedStrideDisturb,关闭用户[appkey:%@,user:%@]免打扰成功～！！",_disAppkeyV,_disUser1V];
            [self showAlert:_disAlertText];
            
        }];
        
    }];

}
- (IBAction)clickGetStrideDisturbList:(id)sender {
    [self initTv];
    [JMessage noDisturbList:^(id resultObject, NSError *error) {
        if (error !=nil) {
            NSLog(@"－－－\n clickGetStrideDisturbList获取免打扰列表失败！error：%@",error);
            
            _disAlertText = [NSString stringWithFormat:@"－－clickGetStrideDisturbList,获取用户[appkey:%@,user:%@]免打扰列表失败～！！\n%@",_disAppkeyV,_disUser1V,error];
            [self showAlert:_disAlertText];
            return ;
        }
        
        NSLog(@"－－－\n clickGetStrideDisturbList获取免打扰列表成功！result：%@",resultObject);
        _disAlertText = [NSString stringWithFormat:@"－－clickGetStrideDisturbList,获取用户[appkey:%@,user:%@]免打扰列表成功～！！",_disAppkeyV,_disUser1V];
        [self showAlert:_disAlertText];
        
    }];
    

}
- (IBAction)clickGetStrideDisturbStatusForUser:(id)sender {
    
    [self initTv];
    [  JMSGUser userInfoArrayWithUsernameArray:userList appKey:_disAppkeyV completionHandler:^(id resultObject, NSError *error) {
        if (error != nil) {
            NSLog(@"－－－\n clickGetStrideDisturbStatusForUser,获取用户[appkey:%@,user:%@]信息失败～不去获取免打扰状态！！error:%@",_disAppkeyV,_disUser1V,error);
            _disAlertText = [NSString stringWithFormat:@"－－clickGetStrideDisturbStatusForUser,获取用户[appkey:%@,user:%@]信息失败～不去获取免打扰状态！！error:%@",_disAppkeyV,_disUser1V,error];
            [self showAlert:_disAlertText];
            return;
        }
        NSLog(@"－－－\n clickGetStrideDisturbStatusForUser,获取用户信息成功～！！result:%@",resultObject);
        NSArray *usersArrayResultObject = resultObject;
        _disJMSGUser = usersArrayResultObject[0];
        NSLog(@"－－－\n clickGetStrideDisturbStatusForUser,[appkey：%@，user：%@]的免打扰状态为：%d",_disAppkeyV,_disJMSGUser,_disJMSGUser.isNoDisturb);
        
        _disAlertText = [NSString stringWithFormat:@"－－clickGetStrideDisturbStatusForUser,[appkey：%@，user：%@]的免打扰状态为：%d",_disAppkeyV,_disJMSGUser,_disJMSGUser.isNoDisturb];
        [self showAlert:_disAlertText];
     
    }];
    
}

- (IBAction)clickOpenDisturbForGroup:(id)sender {
    [self initTv];
    if (_disJMSGGroup == nil) {
        NSLog(@"－－－\n clickOpenDisturbForGroup,尚未创建JMSGGroup实例对象，无法开启群免打扰状态");
        _disAlertText = [NSString stringWithFormat:@"尚未创建JMSGGroup实例对象，无法开启群免打扰状态"];
        [self showAlert:_disAlertText];
        return;
    }
    
[_disJMSGGroup setIsNoDisturb:YES handler:^(id resultObject, NSError *error) {
    if (error !=nil) {
        NSLog(@"－－－\n clickOpenDisturbForGroup 开启免打扰失败！error：%@",error);
        _disAlertText = [NSString stringWithFormat:@"开启免打扰失败！error：%@",error];
        [self showAlert:_disAlertText];
        return ;
    }
    
    NSLog(@"－－－\n clickOpenDisturbForGroup 开启免打扰成功！result：%@",resultObject);
    _disAlertText = [NSString stringWithFormat:@"开启免打扰成功！result：%@",resultObject];
    [self showAlert:_disAlertText];
    
}];

}
- (IBAction)clickClosedDisturbForGroup:(id)sender {
    if (_disJMSGGroup == nil) {
        NSLog(@"－－－\n clickClosedDisturbForGroup,尚未创建JMSGGroup实例对象，无法关闭群免打扰状态");
        _disAlertText = [NSString stringWithFormat:@"尚未创建JMSGGroup实例对象，无法关闭群免打扰状态"];
        [self showAlert:_disAlertText];
        return;
    }
    
    [_disJMSGGroup setIsNoDisturb:NO handler:^(id resultObject, NSError *error) {
        if (error !=nil) {
            NSLog(@"－－－\n clickClosedDisturbForGroup 关闭免打扰失败！error：%@",error);
            _disAlertText = [NSString stringWithFormat:@"关闭免打扰失败！error：%@",error];
            [self showAlert:_disAlertText];
            return ;
        }
        
        NSLog(@"－－－\n clickClosedDisturbForGroup 关闭免打扰成功！result：%@",resultObject);
        _disAlertText = [NSString stringWithFormat:@"关闭免打扰成功！result：%@",resultObject];
        [self showAlert:_disAlertText];
        
    }];


}

- (IBAction)clickGetDisturbStatusForGroup:(id)sender {
     [self initTv];
    if (_disJMSGGroup == nil) {
        NSLog(@"－－－\n clickGetDisturbStatusForGroup,尚未创建JMSGGroup实例对象，无法获取群免打扰状态");
        _disAlertText = [NSString stringWithFormat:@"clickGetDisturbStatusForGroup,尚未创建JMSGGroup实例对象，无法获取群免打扰状态"];
        [self showAlert:_disAlertText];
        return;
    }
    
    NSLog(@"－－－\n clickGetDisturbStatusForGroup,群[%@]免打扰状态：%d",_disJMSGGroup,   _disJMSGGroup.isNoDisturb);
    _disAlertText = [NSString stringWithFormat:@"群[%@]免打扰状态：%d",_disJMSGGroup,   _disJMSGGroup.isNoDisturb];
    [self showAlert:_disAlertText];
 
}

- (IBAction)clickOpenGlobalStrideDisturb:(id)sender {
        [self initTv];
    NSLog(@"------clickOpenGlobalStrideDisturb－我的个人信息:%@",[JMSGUser myInfo]) ;

    NSLog(@"－－－\n clickOpenGlobalStrideDisturb，开启当前登陆用户的全局免打扰");
    [JMessage setIsGlobalNoDisturb:YES handler:^(id resultObject, NSError *error) {
        if(error != nil ){
            NSLog(@"－－－\n clickOpenGlobalStrideDisturb,开启全局免打扰失败～！！error:%@",error);
            
            _disAlertText = [NSString stringWithFormat:@"获取全局免打扰失败～！！error:%@",error];
            [self showAlert:_disAlertText];

            return ;
        }
        NSLog(@"－－－\n clickOpenGlobalStrideDisturb,开启全局免打扰成功～！！result  :%@",resultObject);
        _disAlertText = [NSString stringWithFormat:@"获取全局免打扰成功！result：%@",resultObject];
        [self showAlert:_disAlertText];

    }];

}

- (IBAction)clickClosedGlobalStrideDisturb:(id)sender {
    [self initTv];
        NSLog(@"------clickClosedGlobalStrideDisturb－我的个人信息:%@",[JMSGUser myInfo]) ;
    NSLog(@"－－－\n clickClosedGlobalStrideDisturb，关闭当前登陆用户的全局免打扰");
    [JMessage setIsGlobalNoDisturb:NO handler:^(id resultObject, NSError *error) {
        if(error != nil ){
            NSLog(@"－－－\n clickClosedGlobalStrideDisturb,关闭全局免打扰失败～！！error:%@",error);
            _disAlertText = [NSString stringWithFormat:@"关闭全局免打扰失败～！！error:%@",error];
            [self showAlert:_disAlertText];
            return ;
        }
        NSLog(@"－－－\n clickClosedGlobalStrideDisturb,关闭全局免打扰成功～！！result  :%@",resultObject);
        _disAlertText = [NSString stringWithFormat:@"关闭全局免打扰成功～！！result  :%@",resultObject];
        [self showAlert:_disAlertText];
        
    }];
}
- (IBAction)clickGetGlobalStrideDisturbStatus:(id)sender {
        [self initTv];
    NSLog(@"－－－\n clickGetGlobalStrideDisturbStatus,当前登陆用户的全局免打扰状态为:%d",[JMessage isSetGlobalNoDisturb]);
    _disAlertText = [NSString stringWithFormat:@"当前登陆用户的全局免打扰状态为:%d",[JMessage isSetGlobalNoDisturb]];
    [self showAlert:_disAlertText];
}

- (IBAction)clickGetBlackList:(id)sender {
        [self initTv];
    [JMessage blackList:^(id resultObject, NSError *error) {
        if(error != nil ){
            NSLog(@"－－－\n clickGetBlackList,当前登陆用户的黑名单[%@]获取失败～！！error:%@",userList,error);
            _disAlertText = [NSString stringWithFormat:@"当前登陆用户的黑名单[%@]获取失败～！！error:%@",userList,error];
            [self showAlert:_disAlertText];
            return ;
        }
        NSLog(@"－－－\n clickGetBlackList,当前登陆用户的黑名单获取成功～！！result  :%@",resultObject);
        _disAlertText = [NSString stringWithFormat:@"当前登陆用户的黑名单获取成功～！！result  : %@",resultObject];
        [self showAlert:_disAlertText];
    }];
}
- (IBAction)clickAddBlackListMember:(id)sender {
        [self initTv];
    [JMSGUser addUsersToBlacklist:userList completionHandler:^(id resultObject, NSError *error) {
        if(error != nil ){
            NSLog(@"－－－\n clickAddBlackListMember,给当前登陆用户增加本应用用户到黑名单[%@]失败～！！error:%@",userList,error);
            _disAlertText = [NSString stringWithFormat:@"给当前登陆用户增加本应用用户到黑名单[%@]失败～！！error:%@",userList,error];
            [self showAlert:_disAlertText];
            return ;
        }
        NSLog(@"－－－\n clickAddBlackListMember,给当前登陆用户增加本应用用户到黑名单[%@]成功～！！result  :%@",userList,resultObject);
        
        _disAlertText = [NSString stringWithFormat:@"给当前登陆用户增加本应用用户到黑名单[%@]成功～！！result  :%@",userList,resultObject];
        [self showAlert:_disAlertText];
    }];
}
- (IBAction)clickDelBlackListMember:(id)sender {
        [self initTv];
    [JMSGUser delUsersFromBlacklist:userList completionHandler:^(id resultObject, NSError *error) {
        
        if(error != nil ){
            NSLog(@"－－－\n clickDelBlackListMember,给当前登陆用户 删除本应用用户的 黑名单［user:%@］失败～！！error:%@",userList,error);
            _disAlertText = [NSString stringWithFormat:@"给当前登陆用户 删除本应用用户的 黑名单［user:%@］失败～！！error:%@",userList,error];
            [self showAlert:_disAlertText];

            return ;
        }
        NSLog(@"－－－\n clickDelBlackListMember,给当前登陆用户 删除本应用用户黑名单[%@]成功～！！result  :%@",userList,resultObject);
        
        _disAlertText = [NSString stringWithFormat:@"给当前登陆用户 删除本应用用户的 黑名单［user:%@］成功～！！result  :%@",userList,resultObject];
        [self showAlert:_disAlertText];
    }];
}

- (IBAction)clickGetUserBlackStatus:(id)sender {
    [self initTv];
    [JMSGUser userInfoArrayWithUsernameArray:userList completionHandler:^(id resultObject, NSError *error) {
        if(error != nil ){
            NSLog(@"－－－\n clickGetUserBlackStatus,获取用户［user:%@］个人信息失败～！！error:%@",userList,error);
           
            _disAlertText = [NSString stringWithFormat:@"获取用户［user:%@］个人信息失败，放弃获取黑名单状态～！！error :%@",userList,error];
            [self showAlert:_disAlertText];
            return ;
        }
        NSLog(@"－－－\n clickGetUserBlackStatus,获取用户［user:%@］个人信息成功～！！result  :%@",userList,resultObject);
        NSArray *usersArrayResultObject = resultObject;
        _disJMSGUser = usersArrayResultObject[0];
        NSLog(@"－－－\n clickGetUserBlackStatus,获取用户［user:%@］黑名单状态～！！result  :%d",userList,_disJMSGUser.isInBlacklist);
     
        _disAlertText = [NSString stringWithFormat:@"获取用户［user:%@］黑名单状态～！！result  :%d",userList,_disJMSGUser.isInBlacklist];
        [self showAlert:_disAlertText];

    }];

   }

- (IBAction)clickGetStrideAppUserBlackStatus:(id)sender {
    [self initTv];
    [JMSGUser userInfoArrayWithUsernameArray:userList appKey:_disAppkeyV completionHandler:^(id resultObject, NSError *error) {
        if(error != nil ){
            NSLog(@"－－－\n clickGetStrideAppUserBlackStatus,获取用户［appkey:%@,user:%@］个人信息失败,放弃获取跨应用用户黑名单状态～！！error:%@",_disAppkeyV,userList,error);
           
            //获取用户信息失败，弹出提示
            _disAlertText = [NSString stringWithFormat:@"获取用户［appkey:%@,user:%@］个人信息失败,放弃获取跨应用用户黑名单状态～！！error:%@",_disAppkeyV,userList,error];
            [self showAlert:_disAlertText];
            return ;
        }
        NSLog(@"－－－\n clickGetStrideAppUserBlackStatus,获取用户［appkey:%@,user:%@］个人信息成功～！！result  :%@",_disAppkeyV,userList,resultObject);
        NSArray *usersArrayResultObject = resultObject;
        _disJMSGUser = usersArrayResultObject[0];
        NSLog(@"－－－\n clickGetStrideAppUserBlackStatus,获取用户［appkey:%@,user:%@］黑名单状态～！！result  :%d",_disAppkeyV,userList,_disJMSGUser.isInBlacklist);
        
        //弹出提示显示获取跨应用用户黑名单状态
        _disAlertText = [NSString stringWithFormat:@"获取用户［appkey:%@,user:%@］黑名单状态～！！result  :%d",_disAppkeyV,userList,_disJMSGUser.isInBlacklist];
        [self showAlert:_disAlertText];
     
    }];

}

- (IBAction)clickAddBlackListStrideMember:(id)sender {
        [self initTv];
    [JMSGUser addUsersToBlacklist:userList appKey:_disAppkeyV completionHandler:^(id resultObject, NSError *error) {
        
        if(error != nil ){
            NSLog(@"－－－\n clickAddBlackListStrideMember,给当前登陆用户 Add 跨应用黑名单［appkey：%@,user:%@］失败～！！result  :%@",_disAppkeyV,userList,error);
            
            _disAlertText = [NSString stringWithFormat:@"给当前登陆用户 Add 跨应用黑名单［appkey：%@,user:%@］失败～！！result  :%@",_disAppkeyV,userList,error];
            [self showAlert:_disAlertText];
            return ;
        }
        NSLog(@"－－－\n clickAddBlackListStrideMember,给当前登陆用户 Add 跨应用黑名单［appkey：%@,user:%@］成功～！！result  :%@",_disAppkeyV,userList,resultObject);
        
        _disAlertText = [NSString stringWithFormat:@"给当前登陆用户 Add 跨应用黑名单［appkey：%@,user:%@］成功～！！result  :%@",_disAppkeyV,userList,resultObject];
        [self showAlert:_disAlertText];
    }];
}
- (IBAction)clickDelBlackListStrideMember:(id)sender {
        [self initTv];
    [JMSGUser delUsersFromBlacklist:userList appKey:_disAppkeyV completionHandler:^(id resultObject, NSError *error) {
        if(error != nil ){
            NSLog(@"－－－\n clickDelBlackListStrideMember,给当前登陆用户 Del  跨应用黑名单[appkey:%@,user:%@]失败～！！error:%@",_disAppkeyV,userList,error);
            _disAlertText = [NSString stringWithFormat:@"给当前登陆用户 Del  跨应用黑名单[appkey:%@,user:%@]失败～！！error:%@",_disAppkeyV,userList,error];
            [self showAlert:_disAlertText];
            return ;
        }
        NSLog(@"－－－\n clickDelBlackListStrideMember,给当前登陆用户 Del 跨应用黑名单[appkey:%@,user:%@]成功～！！result  :%@",_disAppkeyV,userList,resultObject);
        
        _disAlertText = [NSString stringWithFormat:@"给当前登陆用户 Del 跨应用黑名单[appkey:%@,user:%@]成功～！！result  :%@",_disAppkeyV,userList,resultObject];
        [self showAlert:_disAlertText];
    }];

}

- (IBAction)clickSendStrideText:(id)sender {
        [self initTv];
    [self curTimeValue];
    
    if (_disConversation == nil) {
        NSLog(@"－－－\n clickSendStrideText，目前没有会话实例对象，放弃发送跨应用文本消息！");
        return;
    }
    
//    NSString * sendMsgText =  [NSString stringWithFormat:@"免打扰界面的发送到文本消息,发送给[%@],时间%@",_disConversation,_curTimeV];
    
    NSString * sendMsgText =  [NSString stringWithFormat:@"免打扰界面的clickSendStrideText，发送到文本消息,时间%@",_curTimeV];

    NSLog(@"----lingz--\n,clickSendStrideText消息内容：%@",sendMsgText);
    [_disConversation sendTextMessage:sendMsgText];
    NSLog(@"－－－\n clickSendStrideText，给［%@］发送文本消息。",_disConversation);
}

- (IBAction)clickSendStrideImge:(id)sender {
    [self initTv];
    [self curTimeValue];
        NSLog(@"---免打扰－clickSendStrideImge");
        
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
    if(_disConversation == nil){
        NSLog(@"-----尚未创建会话对象，不做发送图片动作！");
        return;
                  }
    [self sendImageMsg:picData];
    
}

-(void)sendImageMsg:(NSData *)imagePath{
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
    JMSGImageContent * convSendImage = [[JMSGImageContent alloc] initWithImageData:imagePath];
    
    [convSendImage addStringExtra:@"免打扰界面图片消息的 string extras value 1" forKey:@"免打扰界面图片消息的 string extras key 1"];
    [convSendImage addNumberExtra:[[NSNumber alloc]initWithInt:11111 ] forKey:@"免打扰界面图片消息的 nsnumber key"];

    [_disConversation createMessageAsyncWithImageContent:convSendImage completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"-------免打扰界面 sendImageMsg 发送消息 －－error： %@ ,-－－result：%@",error,resultObject);
            _disJMessage= resultObject;
            [_disConversation sendMessage: _disJMessage];
            
        }
        else {
            NSLog(@"-------免打扰界面 sendImageMsg 发送消息异常！ －－error： %@ ,-－－result：%@",error,resultObject);
            return ;
        }
        
    }];
}




- (IBAction)clickSendStrideCustomMsg:(id)sender {
    [self initTv];
    [self curTimeValue];
    
    NSDictionary *dictionary  = @{@"d":@"g",@"y66":@"sfjhdsjh"};
    //     NSDictionary *dictionary  = [[NSDictionary alloc] initWithObjectsAndKeys:@"",nil,nil];
    
    JMSGCustomContent *strideAppCustomContent = [[JMSGCustomContent alloc] initWithCustomDictionary:dictionary];
    NSString *sendCustomContent = [NSString stringWithFormat:@"clickSendStrideCustomMsg %@- %@,to appkey:%@\n",_disUser1V,_curTimeV,_disAppkeyV];
    JMSGMessage *cutMessage = [_disConversation createMessageWithContent:strideAppCustomContent];
    [strideAppCustomContent setContentText:sendCustomContent];
    [strideAppCustomContent addObjectValue:@"clickSendStrideCustomMsg custom key1" forKey:@"clickSendStrideCustomMsg custom value 1"];
    [strideAppCustomContent addStringExtra:@"clickSendStrideCustomMsg addStringExtra for value1" forKey:@"clickSendStrideCustomMsg addStringExtra for key 1"];
    
    [_disConversation sendMessage:cutMessage];
    
    //用快捷方法发送消息
//    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"clickSendStrideCustomMsg",@"567890",nil];
//    
//    JMSGCustomContent *customContent = [[JMSGCustomContent alloc] initWithCustomDictionary:dictionary];
//    [customContent addStringValue:@"hjs-hfsd clickSendStrideCustomMsg" forKey:@"gfhjkl-4567s"];
//    
//    //       _myJMSGConversation = resultObject;
//    
//    [JMessage removeAllDelegates];
//    [JMessage addDelegate:self withConversation:nil];
//    NSLog(@"-----发送文本按钮这里添加了delegate");
//    
//    
//    NSLog(@"----当前登陆的用户的displayName：%@",[_disJMSGUser displayName]);
//    
//    [customContent setContentText:@"customText的内容！！！！clickSendStrideCustomMsg－button"];
//    //       [customContent addObjectValue:nil forKey:nil];
//    [customContent addObjectValue:@"custom key1" forKey:@"custom value 1"];
//    [customContent addStringExtra:@"EViewXTRAS V" forKey:@"EXTRAS KEY"];
//    //              [customContent addStringExtra:nil forKey:nil];
//    //    JMSGMessage *cutMessage = [_myJMSGConversation createMessageWithContent:customContent];
//    
//    JMSGMessage *cutMessage = [JMSGMessage createSingleMessageWithContent:customContent username:_disUser1V];
//    
//    
//    NSLog(@"-----单聊－clickSendCustomMSG-message:%@",cutMessage);
//    
//    [cutMessage setFromName:@"custom setFromName :"];
//    _disJMSGUser = [JMSGUser myInfo];
//    
//    [JMSGMessage sendMessage:cutMessage];
//    NSLog(@"------发送的custom：%@",cutMessage);


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"-------进入了免打扰页面:DisturbAndBlackListViewController");
    [JMessage removeAllDelegates];
    [JMessage addDelegate:self withConversation:nil];
}

-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    if (error !=nil) {
        NSLog(@"－－－\n 免打扰--onReceiveMessage，收到消息异常：%@",error);
        _disAlertText = [NSString stringWithFormat:@"收到消息，异常！\n%@",error];
        [self showAlert:_disAlertText];
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
                _disAlertText = [NSString stringWithFormat:@"[%@]创建了群，群成员有:%@",fromUsername,[toUsernameList componentsJoinedByString:@","]];
                [self showAlert:_disAlertText];
                break;
                
            case 9:
                _disAlertText = [NSString stringWithFormat:@"[%@]退出了群",fromUsername];
                [self showAlert:_disAlertText];
                break;
                
            case 10:
                _disAlertText = [NSString stringWithFormat:@"[%@ ]邀请了［%@］进群",fromUsername,[toUsernameList componentsJoinedByString:@","]];
                [self showAlert:_disAlertText];
                break;
                
            case 11:
                _disAlertText = [NSString stringWithFormat:@"[%@ ]把［%@］移出了群",fromUsername,[toUsernameList componentsJoinedByString:@","]];
                [self showAlert:_disAlertText];
                break;
                
            case 12:
                _disAlertText = [NSString stringWithFormat:@"[%@ ]更新了群信息",fromUsername];
                [self showAlert:_disAlertText];
                break;
                
            default:
                _disAlertText = [NSString stringWithFormat:@"未知群事件：%ld",eventType];
                
                [self showAlert:_disAlertText];
                
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
    
    NSLog(@"－－－\n 免打扰onReceiveMessage，收到消息成功！messge：%@",message);
    _disAlertText = [NSString stringWithFormat:@"收到消息！\n%@",message];
    [self showAlert:_disAlertText];
    
    
}

-(void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    if (error !=nil) {
        NSLog(@"－－－\n 防打扰onSendMessageResponse，发送消息失败：%@",error);
        _disAlertText = [NSString stringWithFormat:@"发送消息失败！\n%@",error];
        [self showAlert:_disAlertText];
    }else {
        NSLog(@"－－－\n 防打扰onSendMessageResponse，发送消息成功！messge：%@",message);
        _disJMessage = message;
        _disAlertText = [NSString stringWithFormat:@"发送消息成功！\n%@",_disJMessage.serverMessageId];
        [self showAlert:_disAlertText];
    }
}

-(void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event{
    JMSGNotificationEvent *nEvent = event;
    NSLog(@"---------DisturbAndBlack--onReceiveNotificationEvent收到 通知事件");
    
    //    if ([event isKindOfClass:[JMSGFriendNotificationEvent class]]) {
    //        JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
    //        [friendEvent getReason];
    //    }
    
    switch (nEvent.eventType) {
        case  kJMSGEventNotificationFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------DisturbAndBlack--onReceiveNotificationEvent收到 好友邀请相关 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
            
        }
            break;
            
        case  kJMSGEventNotificationReceiveFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------DisturbAndBlack--onReceiveNotificationEvent收到 好友邀请 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
        }
            break;
            
        case  kJMSGEventNotificationAcceptedFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------DisturbAndBlack--onReceiveNotificationEvent收到 同意添加好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);        }
            break;
            
        case  kJMSGEventNotificationDeclinedFriendInvitation:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            
            NSLog(@"---------DisturbAndBlack--onReceiveNotificationEvent收到 拒绝好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
        }
            break;
            
        case  kJMSGEventNotificationDeletedFriend:
        {
            JMSGFriendNotificationEvent * friendEvent = (JMSGFriendNotificationEvent *)event;
            NSLog(@"---------DisturbAndBlack--onReceiveNotificationEvent收到 删除好友请求 通知事件，描述：%@,\nFromUserName:%@,\nFromNameUserObjec:%@\nReasion:%@",nEvent.eventDescription,  [friendEvent getFromUsername] ,[friendEvent getFromUser], [friendEvent getReason]);
            
        }
            
            break;
            
        case  kJMSGEventNotificationLoginKicked:
            NSLog(@"---------DisturbAndBlack--onReceiveNotificationEvent收到 多设备登陆被t 通知事件，描述：%@",nEvent.eventDescription);
            break;
        case  kJMSGEventNotificationServerAlterPassword:
            NSLog(@"---------DisturbAndBlack--onReceiveNotificationEvent收到 非客户端修改密码被t 通知事件，描述：%@",nEvent.eventDescription);
            break;
        case  kJMSGEventNotificationUserLoginStatusUnexpected:
            NSLog(@"---------DisturbAndBlack--onReceiveNotificationEvent收到 Juid变更导致下线的 事件，描述：%@",nEvent.eventDescription);
            break;
        case  kJMSGEventNotificationReceiveServerFriendUpdate:
            NSLog(@"---------home--onReceiveNotificationEvent收到 服务端变更好友相关 事件，描述：%@",nEvent.eventDescription);
            break;
        default:
            NSLog(@"---------DisturbAndBlack--onReceiveNotificationEvent收到 未知事件类型，描述：%@",nEvent.eventDescription);
            break;
    }
}

-(void)onReceiveMessageDownloadFailed:(JMSGMessage *)message{
    
    NSLog(@"-----防打扰 --onReceiveMessageDownloadFailed收到消息下载失败,----message:%@\n",message);
    _disAlertText = [NSString stringWithFormat:@"收到消息下载失败！\n%@",message];
    [self showAlert:_disAlertText];

}

-(void)onGroupInfoChanged:(JMSGGroup *)group{
    NSLog(@"----防打扰--onGroupInfoChanged:%@\n",group);
 
    
}

-(void)onConversationChanged:(JMSGConversation *)conversation{
    NSLog(@"---防打扰---onConversationChanged:%@\n",conversation);
 }

-(void)onUnreadChanged:(NSUInteger)newCount{
    NSLog(@"----防打扰---onUnreadChanged:%lu\n",(unsigned long)newCount);
}

-(void)onLoginUserKicked{
    NSLog(@"-----防打扰--onLoginUserKicked－－－\n --你被踢下线了！\n");
    _disAlertText = [NSString stringWithFormat:@"此账号已在其他地方登陆，你已下线！"];
    [self showAlert:_disAlertText];
    
}

//220b90及之前的220获取好友事件的方法
//-(void)onFriendChanged:(JMSGFriendEventContent *)event{
//    JMSGFriendEventContent * disturbJMSGFriendEventContent = event;
//    NSLog(@"----防打扰测试---onFriendChanged:%@\n",event);
//    NSLog(@"----防打扰测试---onFriendChanged:{\n好友通知事件类型:%ld,\n获取事件发生的理由:%@,\n事件发送者的username:%@,\n获取事件发送者user:%@",disturbJMSGFriendEventContent.eventType,[disturbJMSGFriendEventContent getReason],[disturbJMSGFriendEventContent getFromUsername],[disturbJMSGFriendEventContent getFromUser]);
//    
//}

@end
