//
//  DateUtils.m
//  Gathr
//
//  Created by Faustino L on 5/8/14.

//

#import "DateUtils.h"

@implementation DateUtils

+ (NSString *)getFormattedDateFromDate:(NSDate *)date Format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *time = [dateFormatter stringFromDate:date];
    
    return time;
}

@end
