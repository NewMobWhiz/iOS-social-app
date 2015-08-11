//
//  UserManager.h
//  MyApp
//
//  Created by Faustino L on 9/3/14.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *sessionId;

@property (nonatomic, retain) NSString *backColorName;

+ (UserManager *)sharedManager;

- (void)loadUserData;
- (void)updateUserManager;

@end
