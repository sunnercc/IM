//
//  ChatViewController.m
//  IM
//
//  Created by 陈晨晖 on 2019/6/6.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#import "ChatViewController.h"
#import "NSString+ct.h"
#import "UITableView+ct.h"
#import "Model/Message.h"
#import "View/ChatMessageViewCell.h"
#import "View/ChatMessageTimeViewCell.h"
#import "View/ChatToolBarView.h"
#import "View/ChatMoreToolView.h"
#import "View/RecordView/Macro/XHMacro.h"
#import "View/RecordView/XHVoiceRecordHUD.h"
#import "View/RecordView/XHVoiceRecordHelper.h"

#define iPhoneXSeries (([[UIApplication sharedApplication] statusBarFrame].size.height == 44.0f) ? (YES):(NO))
#define kInputH 50
#define kInputMaxH 200

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource, SendMessageDelegate, ChatMoreToolDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet ChatToolBarView *toolView;
@property (weak, nonatomic) IBOutlet ChatMoreToolView *moreToolView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fixViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fixViewBottom;
@property (strong, nonatomic) XHVoiceRecordHUD *voiceRecordHUD;
@property (strong, nonatomic) XHVoiceRecordHelper *voiceRecordHelper;
@property (strong, nonatomic) NSString *recordPath;
@property (nonatomic, strong) NSMutableArray <Message *> *messages;
@end

@implementation ChatViewController

- (NSMutableArray<Message *> *)messages {
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}
- (XHVoiceRecordHUD *)voiceRecordHUD {
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _voiceRecordHUD;
}
- (XHVoiceRecordHelper *)voiceRecordHelper {
    if (!_voiceRecordHelper) {
        _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
        __weak typeof(self) ws = self;
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            __strong typeof(ws) ss = ws;
            [ss finishRecord];
        };
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
            __strong typeof(ws) ss = ws;
            ss.voiceRecordHUD.peakPower = peakPowerForChannel;
        };
        _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
    }
    return _voiceRecordHelper;
}
- (NSString *)recordPath {
    if (!_recordPath) {
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yy-MMMM-dd";
        NSString *path = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
        dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
        path = [path stringByAppendingFormat:@"%@-MySound.ilbc", [dateFormatter stringFromDate:now]];
        _recordPath = path;
    }
    return _recordPath;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"chat";
    //
    if (iPhoneXSeries) {
        self.fixViewH.constant = 49;
    } else {
        self.fixViewH.constant = 0;
    }
    //
    self.toolView.delegate = self;
    //
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.chatTableView scrollToBottomAtSection:0];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWllHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - custom
- (void)adjustInputFrameWithInput:(UITextView *)input content:(NSString *)content {
    CGFloat h = [content sizeFits:CGSizeMake(input.frame.size.width-10, MAXFLOAT) font:kfont].height;
    CGFloat constant = h + input.textContainerInset.top + input.textContainerInset.bottom + 10;
    if (constant < kInputH) {
        constant = kInputH;
    }
    if (constant < kInputMaxH) {
        [UIView animateWithDuration:0.2 animations:^{
            self.toolViewH.constant = constant;
            [self.view layoutIfNeeded];
        }];
        [self.chatTableView scrollToBottomAtSection:0];
    }
}
- (void)addMessageTime:(NSTimeInterval)time {
    Message *lastMessage = self.messages.lastObject;
    if (lastMessage) {
        NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:time];
        NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:lastMessage.timestamp];
        NSTimeInterval timeDis = [currentDate timeIntervalSinceDate:lastDate];
        if (fabs(timeDis) > kTimeOffset) {  // 大于限定时间，显示时间
            [self prepareTimeMessage:time];
        }
    } else if (self.messages.count == 0) {  // 首条消息显示时间
        [self prepareTimeMessage:time];
    }
}
- (void)prepareTimeMessage:(NSTimeInterval)time {
    Message *message = [[Message alloc] init];
    message.type = MessageTypeTime;
    [self.messages addObject:message];
}
- (void)prepareTextMessage:(NSString *)text {
    Message *message = [[Message alloc] init];
    message.type = MessageTypeText;
    message.text = text;
    if (self.messages.count % 2 == 0) {
        message.senderType = MessageSenderTypeMe;
    } else {
        message.senderType = MessageSenderTypeOther;
    }
    [self addMessageTime:message.timestamp];
    [self.messages addObject:message];
}
- (void)prepareVoiceMessage:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration {
    Message *message = [[Message alloc] init];
    message.type = MessageTypeVoice;
    message.voicePath = voicePath;
    message.voiceDuration = voiceDuration;
    if (self.messages.count % 2 == 0) {
        message.senderType = MessageSenderTypeMe;
    } else {
        message.senderType = MessageSenderTypeOther;
    }
    [self addMessageTime:message.timestamp];
    [self.messages addObject:message];
}
#pragma mark - keyboard notification
- (void)keyboardWillShow:(NSNotification *)sender {
    NSValue *value = [[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber *duration = [[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat keyboard_h = [value CGRectValue].size.height;
    [UIView animateWithDuration:duration.floatValue animations:^{
        self.fixViewBottom.constant = (keyboard_h - self.fixViewH.constant);
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWllHide:(NSNotification *)sender {
    NSNumber *duration = [[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:duration.floatValue animations:^{
        self.fixViewBottom.constant = 0;
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - chatTableView delegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.row];
    if (message.type == MessageTypeTime) {
        static NSString *reuseID = @"time";
        ChatMessageTimeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ChatMessageTimeViewCell class]) owner:nil options:nil].lastObject;
        }
        cell.message = message;
        return cell;
    } else {
        static NSString *reuseID = @"cell";
        ChatMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell = [[ChatMessageViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.message = message;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.messages[indexPath.row].cellSize.height;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.toolView.input resignFirstResponder];
}
#pragma mark - sendMessage
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self.chatTableView scrollToBottomAtSection:0];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) { // send
        if (textView.text.length > 0) {
            [self prepareTextMessage:textView.text];
            [self.chatTableView reloadData];
            [self.chatTableView scrollToBottomAtSection:0];
            textView.text = @"";
        }
        return NO;
    }
    NSString *content = [textView.text stringByReplacingCharactersInRange:range withString:@""];
    content = [content stringByAppendingString:text];
    [self adjustInputFrameWithInput:textView content:content];
    return YES;
}
- (void)inputTypeSwitch:(InputStatusType)type {
    if (type == InputStatusTypeText) {
        [self.toolView.input becomeFirstResponder];
    } else {
        [self.toolView.input resignFirstResponder];
    }
}
- (void)moreToolSwitch:(MoreToolStatusType)toolType {
    if (toolType == MoreToolStatusTypeNone) {
        [UIView animateWithDuration:0.25 animations:^{
            self.fixViewBottom.constant = 0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.moreToolView.hidden = YES;
            if (self.toolView.input.isFirstResponder) {
                [self.toolView.input resignFirstResponder];
            } else {
                [self.toolView.input becomeFirstResponder];
            }
        }];
    } else {
        self.moreToolView.hidden = NO;
         [self.toolView.input resignFirstResponder];
        [UIView animateWithDuration:0.25 animations:^{
            self.fixViewBottom.constant = (self.moreToolView.frame.size.height - self.fixViewH.constant);
            [self.view layoutIfNeeded];
        }];
    }
}
- (void)didStartRecordingVoiceAction {
    [self startRecord];
}
- (void)didCancelRecordingVoiceAction {
    [self cancelRecord];
}
- (void)didFinishRecordingVoiceAction {
    [self finishRecord];
}
- (void)didDragOutsideAction {
    [self resumeRecord];
}
- (void)didDragInsideAction {
    [self pauseRecord];
}
#pragma mark - record
- (void)startRecord {
    [self.voiceRecordHUD startRecordingHUDAtView:self.view];
    [self.voiceRecordHelper startRecordingWithPath:self.recordPath StartRecorderCompletion:^{
        
    }];
}
- (void)cancelRecord {
    __weak typeof(self) ws = self;
    [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
        ws.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
        
    }];
}
- (void)resumeRecord {
    [self.voiceRecordHUD resaueRecord];
}
- (void)pauseRecord {
    [self.voiceRecordHUD pauseRecord];
}
- (void)finishRecord {
    __weak typeof(self) ws = self;
    [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
        ws.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
        __strong typeof(ws) ss = ws;
        if (ss.voiceRecordHelper.recordDuration.integerValue < 0.5 || ss.voiceRecordHelper.recordDuration.integerValue > 60) {
            NSLog(@"录音时长小于0.5s或大于60s");
            return;
        }
        [ss prepareVoiceMessage:ss.voiceRecordHelper.recordPath voiceDuration:ss.voiceRecordHelper.recordDuration];
        [ss.chatTableView reloadData];
        [ss.chatTableView scrollToBottomAtSection:0];
    }];
}
#pragma mark - ChatMoreToolDelegate
- (void)chatMoreToolViewClickCell:(NSUInteger)index {
    if (index == 0) { // 图片
        
    }
}

@end
