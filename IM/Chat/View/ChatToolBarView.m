//
//  ChatToolBarView.m
//  IM
//
//  Created by 陈晨晖 on 2019/6/10.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#import "ChatToolBarView.h"

@interface ChatToolBarView () <UITextViewDelegate>

@end

@implementation ChatToolBarView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.input.delegate = self;
    self.input.returnKeyType = UIReturnKeySend;
    [self.voiceInput setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.voiceInput setTitle:@"松开 结束" forState:UIControlStateHighlighted];
    [self.voiceInput addTarget:self action:@selector(voiceInputTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.voiceInput addTarget:self action:@selector(voiceInputTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self.voiceInput addTarget:self action:@selector(voiceInputTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceInput addTarget:self action:@selector(voiceInputDragOutside) forControlEvents:UIControlEventTouchDragExit];
    [self.voiceInput addTarget:self action:@selector(voiceInputDragInside) forControlEvents:UIControlEventTouchDragEnter];
}

- (void)setType:(InputStatusType)type {
    _type = type;
    [self switchType:type];
}
- (void)setToolType:(MoreToolStatusType)toolType {
    _toolType = toolType;
    [self switchToolType:toolType];
}
- (IBAction)status:(UIButton *)button {
    if (_type == InputStatusTypeText) {
        _type = InputStatusTypeVoice;
    } else {
        _type = InputStatusTypeText;
    }
    [self switchType:_type];
    if ([self.delegate respondsToSelector:@selector(inputTypeSwitch:)]) {
        [self.delegate inputTypeSwitch:_type];
    }
}
- (IBAction)moreTool:(UIButton *)button {
    if (_toolType == MoreToolStatusTypeNone) {
        _toolType = MoreToolStatusTypeMore;
    } else {
        _toolType = MoreToolStatusTypeNone;
    }
    [self switchToolType:_toolType];
    if ([self.delegate respondsToSelector:@selector(moreToolSwitch:)]) {
        [self.delegate moreToolSwitch:_toolType];
    }
}
- (void)switchType:(InputStatusType)type {
    if (type == InputStatusTypeText) {
        self.input.hidden = NO;
        self.voiceInput.hidden = YES;
        [self.statusButton setTitle:@"t" forState:UIControlStateNormal];
    } else {
        self.input.hidden = YES;
        self.voiceInput.hidden = NO;
        [self.statusButton setTitle:@"v" forState:UIControlStateNormal];
    }
}
- (void)switchToolType:(MoreToolStatusType)toolType {
    //
}
#pragma mark - voiceInput
- (void)voiceInputTouchDown {
    if ([self.delegate respondsToSelector:@selector(didStartRecordingVoiceAction)]) {
        [self.delegate didStartRecordingVoiceAction];
    }
}
- (void)voiceInputTouchUpOutside {
    if ([self.delegate respondsToSelector:@selector(didCancelRecordingVoiceAction)]) {
        [self.delegate didCancelRecordingVoiceAction];
    }
}
- (void)voiceInputTouchUpInside {
    if ([self.delegate respondsToSelector:@selector(didFinishRecordingVoiceAction)]) {
        [self.delegate didFinishRecordingVoiceAction];
    }
}
- (void)voiceInputDragOutside {
    if ([self.delegate respondsToSelector:@selector(didDragOutsideAction)]) {
        [self.delegate didDragOutsideAction];
    }
}
- (void)voiceInputDragInside {
    if ([self.delegate respondsToSelector:@selector(didDragInsideAction)]) {
        [self.delegate didDragInsideAction];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.delegate textViewShouldBeginEditing:textView];
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

@end
