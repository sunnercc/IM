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
};

@interface Message : NSObject
@property (nonatomic, assign) MessageSenderType senderType;
@property (nonatomic, assign) MessageType type;
@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, readonly) CGSize cellSize;
@end

NS_ASSUME_NONNULL_END
