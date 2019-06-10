//
//  ChatMessageViewCell.m
//  IM
//
//  Created by 陈晨晖 on 2019/6/6.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//  用来布局messageView，传递model

#import "ChatMessageViewCell.h"
#import "NSString+ct.h"
#import "ChatMessageContentView.h"

@interface ChatMessageViewCell ()
@property (nonatomic, strong) UIButton *photo;
@property (nonatomic, strong) ChatMessageContentView *messageView;
@property (nonatomic, strong) UILabel *time;
@end

@implementation ChatMessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.photo = [[UIButton alloc] init];
        self.photo.backgroundColor = [UIColor blueColor];
        self.photo.layer.cornerRadius = 5;
        [self addSubview:self.photo];
        self.messageView = [[ChatMessageContentView alloc] init];
        [self addSubview:self.messageView];
        self.time = [[UILabel alloc] init];
        self.time.font = kfont;
        self.time.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.time];
    }
    return self;
}

- (void)setMessage:(Message *)message {
    _message = message;
    _messageView.message = message;
    if (_message.type == MessageTypeVoice) {
        _time.hidden = NO;
        _time.text = [NSString stringWithFormat:@"%ld''", _message.voiceDuration.integerValue];
    } else {
        _time.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setup];
}

- (void)setup {
    if (_message.senderType == MessageSenderTypeMe) {
        // photo
        CGFloat photoW = kphotoW;
        CGFloat photoH = kphotoH;
        CGFloat photoX = self.frame.size.width - photoW - kphoto2CellMargin;
        CGFloat photoY = kCellTopMargin;
        self.photo.frame = CGRectMake(photoX, photoY, photoW, photoH);
        // messageView
        CGFloat messageViewX = self.frame.size.width - (_message.cellSize.width - kVoiceTimeLabelW);
        CGFloat messageViewY = kCellTopMargin;
        CGFloat messageViewW = _message.cellSize.width - kphotoW - kphoto2contentMargin - kphoto2CellMargin - kVoiceTimeLabelW;
        CGFloat messageViewH = _message.cellSize.height - kCellTopMargin - kCellBottomMargin;
        self.messageView.frame = CGRectMake(messageViewX, messageViewY, messageViewW, messageViewH);
        // voice time label
        CGFloat timeW = kVoiceTimeLabelW;
        CGFloat timeH = messageViewH;
        CGFloat timeX = CGRectGetMinX(self.messageView.frame)-timeW;
        CGFloat timeY = messageViewY;
        self.time.frame = CGRectMake(timeX, timeY, timeW, timeH);
    }
    else if (_message.senderType == MessageSenderTypeOther) {
        // photo
        CGFloat photoX = kphoto2CellMargin;
        CGFloat photoY = kCellTopMargin;
        CGFloat photoW = kphotoW;
        CGFloat photoH = kphotoH;
        self.photo.frame = CGRectMake(photoX, photoY, photoW, photoH);
        // messageView
        CGFloat messageViewX = photoX + photoW + kphoto2contentMargin;
        CGFloat messageViewY = photoY;
        CGFloat messageViewW = _message.cellSize.width - kphotoW - kphoto2contentMargin - kphoto2CellMargin - kVoiceTimeLabelW;
        CGFloat messageViewH = _message.cellSize.height - kCellTopMargin - kCellBottomMargin;
        self.messageView.frame = CGRectMake(messageViewX, messageViewY, messageViewW, messageViewH);
        // voice time label
        CGFloat timeW = kVoiceTimeLabelW;
        CGFloat timeH = messageViewH;
        CGFloat timeX = CGRectGetMaxX(self.messageView.frame);
        CGFloat timeY = messageViewY;
        self.time.frame = CGRectMake(timeX, timeY, timeW, timeH);
    }
}


@end
