//
//  ChatMessageContentView.m
//  IM
//
//  Created by 陈晨晖 on 2019/6/10.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#import "ChatMessageContentView.h"

@interface ChatMessageContentView ()
@property (nonatomic, strong) UILabel *text;
@end

@implementation ChatMessageContentView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.text = [[UILabel alloc] init];
        self.text.font = kfont;
        self.text.numberOfLines = 0;
        [self addSubview:self.text];
    }
    return self;
}

- (void)setMessage:(Message *)message {
    _message = message;
    // set layer
    UIImage *img = [UIImage imageNamed:@"sendChat"];
    if (message.senderType == MessageSenderTypeOther) {
        img = [UIImage imageNamed:@"receiveChat"];
    }
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 28, 20)];
    self.image = img;
    // set text
    self.text.text = message.text;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // layout text
    CGFloat textX = _message.senderType == MessageSenderTypeMe ? (kcontentPadding) : (kcontentPadding + kbubbleOffset);
    CGFloat textY = kcontentPadding;
    CGFloat textW = self.frame.size.width - kcontentPadding * 2 - kbubbleOffset;
    CGFloat textH = self.frame.size.height - kcontentPadding * 2;
    self.text.frame = CGRectMake(textX, textY, textW, textH);
    
}

@end
