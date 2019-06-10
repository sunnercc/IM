//
//  StringUtils.m
//  IM
//
//  Created by 陈晨晖 on 2019/6/10.
//  Copyright © 2019 chenhui.chen. All rights reserved.
//

#import "StringUtils.h"
#import "../IMCategory/NSDate+Utilities.h"

@implementation StringUtils

/**
 下午11:56 （是今天的）
 会话：同样以上字符 - 下午11:56
 
 昨天 上午10:22 （昨天的）
 会话：显示 - 昨天
 
 星期二 上午08:21 （今天昨天之前的一周显示星期）
 会话：显示 - 星期二
 
 2015年1月22日 上午11:58 （一周之前显示具体的日期了）
 会话：显示 - 2015/04/18
 */
//设置格式 年yyyy 月 MM 日dd 小时hh(HH) 分钟 mm 秒 ss MMM单月 eee周几 eeee星期几 a上午下午
static NSString * const FORMAT_PAST_SHORT = @"yyyy/MM/dd";
static NSString * const FORMAT_PAST_TIME = @"ahh:mm";
static NSString * const FORMAT_THIS_WEEK = @"eee ahh:mm";
static NSString * const FORMAT_THIS_WEEK_SHORT = @"eee";
static NSString * const FORMAT_YESTERDAY = @"ahh:mm";
static NSString * const FORMAT_TODAY = @"ahh:mm";

+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval {
    return [self getFriendlyDateString:timeInterval forConversation:NO];
}
+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval
                    forConversation:(BOOL)conversation {
    NSString *output = @"";
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:0];
    NSTimeInterval timeDis = [currentDate timeIntervalSinceDate:lastDate];
    if (timeDis < 60) {
        output = @"刚刚";
    } else if (timeDis < 60 * 60) {
        output = [NSString stringWithFormat:@"%d分钟前", (int)(timeDis / 60)];
    } else {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
        [format setLocale:locale];
        BOOL isYesterday = NO;
        BOOL isPastlong = NO;
        if ([lastDate isToday]) {
            [format setDateFormat:FORMAT_TODAY];
        } else if ([lastDate isYesterday]) {
            [format setDateFormat:FORMAT_YESTERDAY];
            isYesterday = isYesterday;
        } else if ([lastDate isThisWeek]) {
            if (conversation) {
                [format setDateFormat:FORMAT_THIS_WEEK_SHORT];
            } else {
                [format setDateFormat:FORMAT_THIS_WEEK];
            }
        } else {
            if (conversation) {
                 [format setDateFormat:FORMAT_PAST_SHORT];
            } else {
                 [format setDateFormat:FORMAT_PAST_TIME];
                isPastlong = YES;
            }
        }
        if (isYesterday) {
            NSString *yesterday = [self getYesterdayString:lastDate];
            if (conversation) {
                output = yesterday;
            } else {
                output = [format stringFromDate:lastDate];
                output = [NSString stringWithFormat:@"%@ %@", yesterday, output];
            }
        } else {
            output = [format stringFromDate:lastDate];
            if (isPastlong) {
                NSString *past = [self getPastDateString:lastDate];
                output = [NSString stringWithFormat:@"%@ %@", past, output];
            }
        }
    }
    return output;
}

+ (NSString *)getYesterdayString:(NSDate *)theDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    [formatter setLocale:locale];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    formatter.doesRelativeDateFormatting = YES;
    return [formatter stringFromDate:theDate];
}

+ (NSString *)getPastDateString:(NSDate *)theDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    [formatter setLocale:locale];
    formatter.dateStyle = NSDateFormatterLongStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    return [formatter stringFromDate:theDate];
}

@end
