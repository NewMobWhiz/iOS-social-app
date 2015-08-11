//
//  UIUtils.h
//  Gathr
//
//  Created by Faustino L on 1/28/14.
//

#import <Foundation/Foundation.h>

// AnimationControllers and InteractionControllers for UI Transition
#define ACs (@[@"None", @"Portal", @"Cards", @"Fold", @"Explode", @"Flip", @"Turn", @"Crossfade", @"NatGeo", @"Cube"])
#define ICs (@[@"None", @"HorizontalSwipe", @"VerticalSwipe", @"Pinch"])

@interface UIUtils : NSObject

// For Transitions
+ (NSString *)classToTransitionName:(NSObject *)instance;
+ (id)transitionNameToInstance:(NSString *)transitionName;

+ (void)showAlertWithTitle:(NSString *)title Message:(NSString *)msg;

+ (void)installInputAccessoryViewForTextField:(id)textControl;
+ (void)pushUpView:(UIView *)view Offset:(float)offset BgColor:(UIColor *)bgColor;
+ (void)pushDownView:(UIView *)view Offset:(float)offset BgColor:(UIColor *)bgColor;

+ (UIBarButtonItem *)createCustomBackButtonWithImageName:(NSString *)imageName Title:(NSString *)title Target:(id)target Action:(SEL)selector Tag:(int)tag;

@end
