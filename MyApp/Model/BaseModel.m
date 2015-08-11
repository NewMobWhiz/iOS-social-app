//
//  BaseModel.m
//  Gathr
//
//  Created by Faustino L on 4/12/14.

//

#import "BaseModel.h"

#import "Config.h"

@implementation BaseModel

- (id)init
{
    if (debugBaseModel) NSLog(@"BaseModel init");
    
    self = [super init];
    if (self != nil) {
        
    }
    
    return self;
}

@end
