//
//  Message.h
//  IM
//
//  Created by 陈晨晖 on 2019/6/6.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMConstant.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MessageSenderType) {
    MessageSenderTypeMe,
    MessageSenderTypeOther,
};

typedef NS_ENUM(NSUInteger, MessageType) {
    MessageTypeText,
    MessageTypeTime,
    MessageTypeVoice,
};

@interface Message : NSObject
@property (nonatomic, assign) MessageSenderType senderType;
@property (nonatomic, assign) MessageType type;
@property (nonatomic, readonly) CGSize cellSize;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, strong) NSString *voicePath;
@property (nonatomic, strong) NSString *voiceDuration;
@end

NS_ASSUME_NONNULL_END
