//
//  SocialComms.h
//  MyApp
//
//  Created by Faustino L on 8/15/14.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

/**
 *  A constant describing the facebook action type. This sets the facebook action.
 */
typedef NS_ENUM(NSUInteger, FacebookActionType) {
    FacebookActionTypeCheck,
    FacebookActionTypeLogin,
    FacebookActionTypeUserInfo
};

@protocol SocialCommsDelegate <NSObject>
@optional
- (void)socialCommsDidAction:(NSDictionary *)response;
@end

@interface SocialComms : NSObject

+ (void)facebookLogIn:(id<SocialCommsDelegate>)delegate;
+ (void)facebookLogOut;
+ (BOOL)checkFacebookSessionState:(id<SocialCommsDelegate>)delegate;
+ (void)sessionStateChanged:(id<SocialCommsDelegate>)delegate FBSession:(FBSession *)session state:(FBSessionState) state error:(NSError *)error ActionType:(NSUInteger)actionType;
+ (void)facebookGetUserInfo:(id<SocialCommsDelegate>)delegate PermissonsNeeded:(NSArray *)permissionsNeeded;

@end
