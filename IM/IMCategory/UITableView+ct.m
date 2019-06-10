//
//  UITableView+ct.m
//  IM
//
//  Created by 陈晨晖 on 2019/6/6.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#import "UITableView+ct.h"

@implementation UITableView (ct)

- (void)scrollToBottomAtSection:(NSUInteger)section {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUInteger rows = [self numberOfRowsInSection:section];
        if (rows > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rows-1 inSection:section];
            [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    });
}

@end
