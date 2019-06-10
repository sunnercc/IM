//
//  StringUtils.h
//  IM
//
//  Created by 陈晨晖 on 2019/6/10.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StringUtils : NSObject
+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval;
+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval
                    forConversation:(BOOL)conversation;
@end

NS_ASSUME_NONNULL_END
