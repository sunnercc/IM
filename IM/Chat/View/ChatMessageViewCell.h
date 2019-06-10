//
//  ChatMessageViewCell.h
//  IM
//
//  Created by 陈晨晖 on 2019/6/6.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatMessageViewCell : UITableViewCell
@property (nonatomic, strong) Message *message;
@end

NS_ASSUME_NONNULL_END
