//
//  AppUtils.h
//  AutoDiler
//
//  Created by Faustino L on 1/28/14.
//

#import <Foundation/Foundation.h>

@interface AppUtils : NSObject

+ (BOOL)isPad;
+ (BOOL)iPhone5;
+ (BOOL)isAtLeastiOS7;

+ (BOOL)isValidEmail:(NSString *)email;

@end
