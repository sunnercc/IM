//
//  ChatMessageContentView.h
//  IM
//
//  Created by 陈晨晖 on 2019/6/10.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatMessageContentView : UIImageView
@property (nonatomic, strong) Message *message;
@end

NS_ASSUME_NONNULL_END
