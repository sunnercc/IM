//
//  ViewController.m
//  IM
//
//  Created by 陈晨晖 on 2019/6/6.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#import "ViewController.h"
#import "Chat/ChatViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ChatViewController *ChatVC = [[ChatViewController alloc] initWithNibName:NSStringFromClass([ChatViewController class]) bundle:nil];
    [self.navigationController pushViewController:ChatVC animated:YES];
}


@end
