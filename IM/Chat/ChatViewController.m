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

#define iPhoneXSeries (([[UIApplication sharedApplication] statusBarFrame].size.height == 44.0f) ? (YES):(NO))
#define kInputH 50
#define kInputMaxH 200

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UITextView *input;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fixViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fixViewBottom;
@property (nonatomic, strong) NSMutableArray <Message *> *messages;
@end

@implementation ChatViewController

- (NSMutableArray<Message *> *)messages {
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"chat";
    
    if (iPhoneXSeries) {
        self.fixViewH.constant = 49;
    } else {
        self.fixViewH.constant = 0;
    }
    
    self.input.delegate = self;
    self.input.returnKeyType = UIReturnKeySend;
    
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.chatTableView scrollToBottomAtSection:0];
    
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
        self.toolViewH.constant = constant;
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
#pragma mark - keyboard notification
- (void)keyboardWillShow:(NSNotification *)sender {
    NSValue *value = [[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboard_h = [value CGRectValue].size.height;
    self.fixViewBottom.constant += (keyboard_h - self.fixViewH.constant);
}

- (void)keyboardWllHide:(NSNotification *)sender {
    self.fixViewBottom.constant = 0;
}
#pragma mark - chatTableView delegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.row];
    if (message.type == MessageTypeText) {
        static NSString *reuseID = @"cell";
        ChatMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell = [[ChatMessageViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.message = message;
        return cell;
    } else {
        static NSString *reuseID = @"time";
        ChatMessageTimeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ChatMessageTimeViewCell class]) owner:nil options:nil].lastObject;
        }
        cell.message = message;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.messages[indexPath.row].cellSize.height;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.input resignFirstResponder];
}
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self.chatTableView scrollToBottomAtSection:0];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) { // send
        if (textView.text.length > 0) {
            [self prepareTextMessage:textView.text];
            [self.chatTableView reloadData];
            textView.text = @"";
            [self adjustInputFrameWithInput:textView content:textView.text];
        }
        return NO;
    }
    NSString *content = [textView.text stringByReplacingCharactersInRange:range withString:@""];
    content = [content stringByAppendingString:text];
    [self adjustInputFrameWithInput:textView content:content];
    return YES;
}
@end
