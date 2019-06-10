//
//  NSString+ct.h
//  IM
//
//  Created by 陈晨晖 on 2019/6/6.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ct)

- (CGSize)sizeFits:(CGSize)maxSize font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
