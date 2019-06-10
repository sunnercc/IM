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
@property (nonatomic, strong) UIImageView *voice;
@end

@implementation ChatMessageContentView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.text = [[UILabel alloc] init];
        self.text.font = kfont;
        self.text.numberOfLines = 0;
        [self addSubview:self.text];
        self.voice = [[UIImageView alloc] init];
        [self addSubview:self.voice];
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
    // clear
    _text.hidden = YES;
    _voice.hidden = YES;
    // set text
    if (_message.type == MessageTypeText) {
        _text.hidden = NO;
        _text.text = _message.text;
    }
    if (_message.type == MessageTypeVoice) {
        _voice.hidden = NO;
        if (_message.senderType == MessageSenderTypeMe) {
            [_voice setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying"]];
        } else {
            [_voice setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying"]];
        }
        // 下载 voice
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // layout text
    CGFloat textX = _message.senderType == MessageSenderTypeMe ? (kcontentPadding) : (kcontentPadding + kbubbleOffset);
    CGFloat textY = kcontentPadding;
    CGFloat textW = self.frame.size.width - kcontentPadding * 2 - kbubbleOffset;
    CGFloat textH = self.frame.size.height - kcontentPadding * 2;
    self.text.frame = CGRectMake(textX, textY, textW, textH);
    // layout voice
    CGFloat voiceW = 9;
    CGFloat voiceH = 16;
    CGFloat voiceX = _message.senderType == MessageSenderTypeMe ? (self.frame.size.width - kbubbleOffset - kcontentPadding - voiceW) : (kbubbleOffset + kcontentPadding);
    CGFloat voiceY = (self.frame.size.height - voiceH) / 2;
    self.voice.frame = CGRectMake(voiceX, voiceY, voiceW, voiceH);
}

@end
