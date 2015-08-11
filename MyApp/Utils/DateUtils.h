//
//  DateUtils.h
//  Gathr
//
//  Created by Faustino L on 5/8/14.

//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

+ (NSString *)getFormattedDateFromDate:(NSDate *)date Format:(NSString *)format;
@end
