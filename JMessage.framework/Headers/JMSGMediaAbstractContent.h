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

@class JMSGData;

/*!
 * 媒体内容类型的抽象父类
 *
 * 所有的媒体文件内容, 如 VoiceContent,ImageContent,
 * 都有媒体文件的处理逻辑, 比如上传与下载, 这些逻辑都放在这个类里统一处理.
 *
 * 这个类一般对外不可见.
 */
@interface JMSGMediaAbstractContent : JMSGAbstractContent <NSCopying>

JMSG_ASSUME_NONNULL_BEGIN

/*!
 * @abstract 媒体文件ID
 *
 * @discussion 这是 JMessage 内部用于表示资源文件的ID，使用该ID 可以定位到网络上的资源。
 *
 * 收到消息时，通过此ID 可以下载到资源；发出消息时，文件上传成功会生成此ID。
 *
 * 注意: 不支持外部设置媒体ID，也不支持把此字段设置为 URL 来下载到资源文件。
 */
@property(nonatomic, strong, readonly) NSString * JMSG_NULLABLE mediaID;

/*! @abstract 媒体格式 */
@property(nonatomic, strong, readonly) NSString * JMSG_NULLABLE format;

/*! @abstract 媒体文件大小 */
@property(nonatomic, strong, readonly) NSNumber *fSize;

// 不支持使用的初始化方法
- (nullable instancetype)init NS_UNAVAILABLE;

JMSG_ASSUME_NONNULL_END

@end

