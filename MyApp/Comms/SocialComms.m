//
//  SocialComms.m
//  MyApp
//
//  Created by Faustino L on 8/15/14.
//

#import "SocialComms.h"

#import "Config.h"
#import "UIUtils.h"

@implementation SocialComms
//==================================================
// Facebook Related Methods
//==================================================
#pragma mark- Facebook Related Methods
//==================================================
+ (void)facebookLogIn:(id<SocialCommsDelegate>)delegate
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
    }

    // Open a session showing the user the login UI
    // You must ALWAYS ask for public_profile permissions when opening a session
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]                                        allowLoginUI:YES
        completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
             // Retrieve the app delegate
             [SocialComms sessionStateChanged:delegate FBSession:session state:state error:error ActionType:FacebookActionTypeLogin];
    }];
}

+ (void)facebookLogOut
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

+ (BOOL)checkFacebookSessionState:(id<SocialCommsDelegate>)delegate
{
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"Found a cached session");
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [SocialComms sessionStateChanged:delegate FBSession:session state:state error:error ActionType:FacebookActionTypeCheck];
                                      }];
        return YES;
        // If there's no cached session, we will show a login button
    } else {
        return NO;
    }
}

// This method will handle ALL the session state changes in the app
+ (void)sessionStateChanged:(id<SocialCommsDelegate>)delegate FBSession:(FBSession *)session state:(FBSessionState) state error:(NSError *)error ActionType:(NSUInteger)actionType
{
    NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
    [response setObject:[NSNumber numberWithInt:actionType] forKey:@"actionType"];
    // If the session was opened successfully
    if (!error  &&  (state == FBSessionStateOpen  ||  state == FBSessionStateOpenTokenExtended)) {
        NSLog(@"Session opened");
        [response setObject:[NSNumber numberWithBool:YES] forKey:@"responseCode"];
        if ([delegate respondsToSelector:@selector(socialCommsDidAction:)])
            [delegate socialCommsDidAction:response];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
    }
    
    // Handle errors
    if (error) {
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [UIUtils showAlertWithTitle:alertTitle Message:alertText];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [UIUtils showAlertWithTitle:alertTitle Message:alertText];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [UIUtils showAlertWithTitle:alertTitle Message:alertText];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        [response setObject:[NSNumber numberWithBool:NO] forKey:@"responseCode"];
        if ([delegate respondsToSelector:@selector(socialCommsDidAction:)])
            [delegate socialCommsDidAction:response];
    }
}

+ (void)facebookGetUserInfo:(id<SocialCommsDelegate>)delegate PermissonsNeeded:(NSArray *)permissionsNeeded
{
    // We will request the user's public picture and the user's birthday
    // These are the permissions we need:
    
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *userInfo, NSError *error) {
        NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
        [response setObject:[NSNumber numberWithInt:FacebookActionTypeUserInfo] forKey:@"actionType"];
        if (!error) {
            // Success! Include your code to handle the results here
            [response setObject:[NSNumber numberWithBool:YES] forKey:@"responseCode"];
            [response setObject:userInfo forKey:@"userInfo"];
        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            [response setObject:[NSNumber numberWithBool:NO] forKey:@"responseCode"];
            [response setObject:error forKey:@"errorMsg"];
        }
        if ([delegate respondsToSelector:@selector(socialCommsDidAction:)])
            [delegate socialCommsDidAction:response];
    }]; 
    /*
    // Request the permissions the user currently has
    [FBSession activeSession];
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // These are the current permissions the user has
            NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
            // We will store here the missing permissions that we will have to request
            NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                  
            // Check if all the permissions we need are present in the user's current permissions
            // If they are not present add them to the permissions to be requested
            for (NSString *permission in permissionsNeeded) {
                if (![currentPermissions objectForKey:permission]) {
                    [requestPermissions addObject:permission];
                }
            }
                                  
            // If we have permissions to request
            if ([requestPermissions count] > 0) {
                // Ask for the missing permissions
                [FBSession.activeSession requestNewReadPermissions:requestPermissions completionHandler:^(FBSession *session, NSError *error) {
                    if (!error) {
                        // Permission granted, we can request the user information
                        [SocialComms makeRequestForUserData:delegate];
                    } else {
                        // An error occurred, we need to handle the error
                        // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                        NSLog(@"error %@", error.description);
                    }
                }];
            } else {
                // Permissions are present
                // We can request the user information
                [SocialComms makeRequestForUserData:delegate];
            }
                                  
        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                NSLog(@"error %@", error.description);
        }
    }]; */
}

+ (void)makeRequestForUserData:(id<SocialCommsDelegate>)delegate
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
        [response setObject:[NSNumber numberWithInt:FacebookActionTypeUserInfo] forKey:@"actionType"];

        if (!error) {
            // Success! Include your code to handle the results here
            [response setObject:[NSNumber numberWithBool:YES] forKey:@"responseCode"];
            [response setObject:result forKey:@"userInfo"];
        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            [response setObject:[NSNumber numberWithBool:NO] forKey:@"responseCode"];
            [response setObject:error forKey:@"errorMsg"];
        }
        if ([delegate respondsToSelector:@selector(socialCommsDidAction:)])
            [delegate socialCommsDidAction:response];
    }];
}
@end
