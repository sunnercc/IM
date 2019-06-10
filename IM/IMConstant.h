//
//  IMConstant.h
//  IM
//
//  Created by 陈晨晖 on 2019/6/6.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#ifndef IMConstant_h
#define IMConstant_h

#define kphotoW 46  // 头像宽度
#define kphotoH kphotoW  // 头像高度
#define kphoto2CellMargin 5 // 头像距离cell边框的margin
#define kphoto2contentMargin 5 // 头像和content之间的margin
#define kCellW [UIScreen mainScreen].bounds.size.width  // cell宽度
#define kCellTopMargin 10  // cell距离顶部的margin
#define kCellBottomMargin 10  // cell距离底部的margin
#define kcontentW (kCellW - 2 * (kphotoW + kphoto2CellMargin + kphoto2contentMargin)) // cell内容content的宽度
#define kfont [UIFont systemFontOfSize:18]
#define kfontH 20
#define kcontentPadding 10 // content内边距
#define kbubbleOffset 8 // 聊天气泡伸出的距离
#define kVoiceTimeLabelW 30 // 显示语音秒数
#define kTimeOffset 60 * 2 // 2分钟以外显示时间
#endif /* IMConstant_h */
