//
//  ChatMoreToolView.h
//  IM
//
//  Created by 陈晨晖 on 2019/6/10.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ChatMoreToolDelegate <NSObject>
- (void)chatMoreToolViewClickCell:(NSUInteger)index;
@end

@interface ChatMoreToolView : UIView
@property (nonatomic, weak) id<ChatMoreToolDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
