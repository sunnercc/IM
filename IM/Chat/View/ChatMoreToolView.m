//
//  ChatMoreToolView.m
//  IM
//
//  Created by 陈晨晖 on 2019/6/10.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#import "ChatMoreToolView.h"
#define cellMargin 10

@interface ChatMoreToolView ()
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;
@end

@implementation ChatMoreToolView
- (NSMutableArray *)cells {
    if (!_cells) {
        _cells = [NSMutableArray array];
    }
    return _cells;
}
- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"图片", @"拍照", @"文件", @"位置"];
    }
    return _titles;
}
- (NSArray *)images {
    if (!_images) {
        _images = @[@"", @"", @"", @""];
    }
    return _images;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    int col = 4;
    CGFloat w = (self.frame.size.width - (col + 1) * cellMargin) / col;
    CGFloat h = w + 20;
    for (int i = 0; i < self.titles.count; i++) {
        CGFloat x = cellMargin + i % col * (w + cellMargin);
        CGFloat y = cellMargin + i / col * (h + cellMargin);
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
        button.backgroundColor = [UIColor redColor];
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        [self addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)click:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(chatMoreToolViewClickCell:)]) {
        [self.delegate chatMoreToolViewClickCell:button.tag];
    }
}

@end
