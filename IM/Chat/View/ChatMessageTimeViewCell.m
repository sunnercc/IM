//
//  ChatMessageTimeViewCell.m
//  IM
//
//  Created by 陈晨晖 on 2019/6/10.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#import "ChatMessageTimeViewCell.h"
#import "../../IMUtils/StringUtils.h"
@interface ChatMessageTimeViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *time;
@end
@implementation ChatMessageTimeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessage:(Message *)message {
    _message = message;
    self.time.text = [StringUtils getFriendlyDateString:message.timestamp];
}

@end
