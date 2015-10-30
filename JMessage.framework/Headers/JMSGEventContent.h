/*
 *	| |    | |  \ \  / /  | |    | |   / _______|
 *	| |____| |   \ \/ /   | |____| |  / /
 *	| |____| |    \  /    | |____| |  | |   _____
 * 	| |    | |    /  \    | |    | |  | |  |____ |
 *  | |    | |   / /\ \   | |    | |  \ \______| |
 *  | |    | |  /_/  \_\  | |    | |   \_________|
 *
 * Copyright (c) 2011 ~ 2015 Shenzhen HXHG. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <JMessage/JMSGAbstractContent.h>

/*!
 * 事件类型
 */
typedef NS_ENUM(NSInteger, JMSGEventNotificationType) {
  kJMSGEventNotificationLoginKicked = 1,
  kJMSGEventNotificationCreateGroup = 8,
  kJMSGEventNotificationExitGroup = 9,
  kJMSGEventNotificationAddGroupMembers = 10,
  kJMSGEventNotificationRemoveGroupMembers = 11,
};


/*!
 * 事件类型的消息内容
 *
 * 服务器端下发的事件通知, 比如用户被踢下线,群组里加了人, SDK 作为一个特殊的消息类型处理.
 * SDK 以消息的形式通知到 App. 详情参见 JMessageDelegate.
 */
@interface JMSGEventContent : JMSGAbstractContent <NSCopying>

/*!
 * @abstract 事件类型
 * @discussion 参考事件类型的定义 JMSGEventNotificationType
 */
@property(nonatomic, assign, readonly) JMSGEventNotificationType eventType;

// 不支持使用的初始化方法
- (nullable instancetype)init NS_UNAVAILABLE;

/*!
 @abstract 展示此事件的文本描述

 @discussion SDK 根据事件类型，拼接成完整的事件描述信息。
 */
- (NSString * JMSG_NONNULL)showEventNotification;

@end
