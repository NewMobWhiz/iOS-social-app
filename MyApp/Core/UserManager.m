//
//  UserManager.m
//  MyApp
//
//  Created by Faustino L on 9/3/14.
//

#import "UserManager.h"

@implementation UserManager

@synthesize email;
@synthesize password;
@synthesize sessionId;

@synthesize backColorName;

static UserManager *sharedManager = nil;

- (id)init
{
    self = [super init];
    if (self != nil) {
        [self loadUserData];
    }
    return self;
}

+ (UserManager *)sharedManager
{
    @synchronized ([UserManager class]) {
        if (sharedManager == nil) {
            sharedManager = [[self alloc] init];
        }
        return sharedManager;
    }
    return nil;
}

- (void)loadUserData
{
    NSDictionary *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userData"];
    if (userData == nil) {
        [self setEmail:nil];
        [self setPassword:nil];
        [self setSessionId:nil];
        [self setBackColorName:nil];
    } else {
        NSArray *keys = [userData allKeys];
        if ([keys containsObject:@"email"]) {
            [self setEmail:[userData objectForKey:@"email"]];
        } else {
            [self setEmail:nil];
        }
        if ([keys containsObject:@"password"]) {
            [self setPassword:[userData objectForKey:@"password"]];
        } else {
            [self setPassword:nil];
        }
        if ([keys containsObject:@"sessionId"]) {
            [self setSessionId:[userData objectForKey:@"sessionId"]];
        } else {
            [self setSessionId:nil];
        }
        if ([keys containsObject:@"backColorName"]) {
            [self setBackColorName:[userData objectForKey:@"backColorName"]];
        } else {
            [self setBackColorName:nil];
        }
    }
}

- (void)updateUserManager
{
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
    if (email) [userData setObject:email forKey:@"email"];
    if (password) [userData setObject:password forKey:@"password"];
    if (sessionId) [userData setObject:sessionId forKey:@"sessionId"];
    if (backColorName) [userData setObject:backColorName forKey:@"backColorName"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[userData copy] forKey:@"userData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
