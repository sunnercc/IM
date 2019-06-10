//
//  Message.m
//  IM
//
//  Created by 陈晨晖 on 2019/6/6.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#import "Message.h"
#import "NSString+ct.h"

@implementation Message

- (instancetype)init {
    self = [super init];
    if (self) {
        self.timestamp = [NSDate date].timeIntervalSince1970;
    }
    return self;
}

- (CGSize)cellSize {
    if (_type == MessageTypeText) {
        CGSize size = [_text sizeFits:CGSizeMake(kcontentW - kcontentPadding * 2 - kbubbleOffset, MAXFLOAT) font:kfont];
        CGFloat w = size.width;
        CGFloat h = ((size.height / kfont.pointSize) + 1) * kfontH;
        if (h < kphotoH) h = kphotoH;
        w += (kcontentPadding * 2 + kphoto2contentMargin + kphoto2CellMargin + kphotoW + kbubbleOffset + kVoiceTimeLabelW);
        h += (kCellTopMargin + kCellBottomMargin);
        return CGSizeMake(w, h);
    } else if (_type == MessageTypeTime) {
        return CGSizeMake(kCellW, 31);
    } else if (_type == MessageTypeVoice) {
        CGFloat w = 0;
        CGFloat h = kphotoH;
        w = 10 + _voiceDuration.integerValue * (kcontentW / 60);
        w += (kcontentPadding * 2 + kphoto2contentMargin + kphoto2CellMargin + kphotoW + kbubbleOffset + kVoiceTimeLabelW);
        h += (kCellTopMargin + kCellBottomMargin);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

@end
