//
//  ChatToolBarView.h
//  IM
//
//  Created by 陈晨晖 on 2019/6/10.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, InputStatusType) {
    InputStatusTypeText,
    InputStatusTypeVoice,
};
typedef NS_ENUM(NSUInteger, MoreToolStatusType) {
    MoreToolStatusTypeNone,
    MoreToolStatusTypeMore,
};

@protocol SendMessageDelegate <NSObject>
@optional
/**
 *  开始编辑
 */
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
/**
 *  正在输入
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
/**
 *  状态切换
 */
- (void)inputTypeSwitch:(InputStatusType)type;
/**
 *  工具状态切换
 */
- (void)moreToolSwitch:(MoreToolStatusType)toolType;
/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction;
/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction;
/**
 *  松开手指完成录音
 */
- (void)didFinishRecordingVoiceAction;
/**
 *  当手指离开按钮的范围内时，主要为了通知外部的HUD
 */
- (void)didDragOutsideAction;
/**
 *  当手指再次进入按钮的范围内时，主要也是为了通知外部的HUD
 */
- (void)didDragInsideAction;
@end

@interface ChatToolBarView : UIView
@property (nonatomic, weak) id<SendMessageDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextView *input;
@property (weak, nonatomic) IBOutlet UIButton *voiceInput;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UIButton *moreToolButton;
@property (nonatomic, assign) InputStatusType type;
@property (nonatomic, assign) MoreToolStatusType toolType;
@end

NS_ASSUME_NONNULL_END
