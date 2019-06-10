//
//  NSString+ct.m
//  IM
//
//  Created by 陈晨晖 on 2019/6/6.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#import "NSString+ct.h"

@implementation NSString (ct)

- (CGSize)sizeFits:(CGSize)maxSize font:(UIFont *)font {
    UILabel *text = [UILabel new];
    text.numberOfLines = 0;
    text.text = self;
    text.font = font;
    return [text sizeThatFits:maxSize];
}

@end
