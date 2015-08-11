//
//  UIUtils.m
//  Gathr
//
//  Created by Faustino L on 1/28/14.
//

#import "UIUtils.h"

@implementation UIUtils

+ (NSString *)classToTransitionName:(NSObject *)instance
{
    if (!instance)
        return @"None";
    
    NSString *animationClass = NSStringFromClass(instance.class);
    
    NSMutableString *transitionName = [[NSMutableString alloc] initWithString:animationClass];
    [transitionName replaceOccurrencesOfString:@"CE" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, transitionName.length)];
    [transitionName replaceOccurrencesOfString:@"AnimationController" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, transitionName.length)];
    [transitionName replaceOccurrencesOfString:@"InteractionController" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, transitionName.length)];
    
    return transitionName;
}

+ (id)transitionNameToInstance:(NSString *)transitionName
{
    NSString *className = [NSString stringWithFormat:@"CE%@AnimationController", transitionName];
    return [[NSClassFromString(className) alloc] init];
}

+ (void)showAlertWithTitle:(NSString *)title Message:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

+ (void)installInputAccessoryViewForTextField:(id)textControl
{
    UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                       target:self action:nil];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:textControl action:@selector(resignFirstResponder)];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    toolbar.items = [NSArray arrayWithObjects:barButtonSpace, barButtonDone, nil];
    
    [textControl setInputAccessoryView:toolbar];
}

+ (void)pushUpView:(UIView *)view Offset:(float)offset BgColor:(UIColor *)bgColor
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [view setFrame:CGRectMake(view.frame.origin.x, (view.frame.origin.y - offset), view.frame.size.width, view.frame.size.height)];
    if (bgColor != nil) [view setBackgroundColor:bgColor];
    [UIView commitAnimations];
}

+ (void)pushDownView:(UIView *)view Offset:(float)offset BgColor:(UIColor *)bgColor
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [view setFrame:CGRectMake(view.frame.origin.x, (view.frame.origin.y + offset), view.frame.size.width, view.frame.size.height)];
    if (bgColor != nil) [view setBackgroundColor:[UIColor clearColor]];
    [UIView commitAnimations];
}

+ (UIBarButtonItem *)createCustomBackButtonWithImageName:(NSString *)imageName Title:(NSString *)title Target:(id)target Action:(SEL)selector Tag:(int)tag
{
    UIColor *tintColor = [UIColor whiteColor];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backArrowImage = [UIImage imageNamed:imageName];
    backArrowImage = [backArrowImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backBtn setImage:backArrowImage forState:UIControlStateNormal];
    [backBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitle:title forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
    [backBtn setTag:tag];
    
    [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, -13, 10, 0)];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [backBtn setFrame:CGRectMake(0, 0, 100, 40)];
    
    UIBarButtonItem *backBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBarBtnItem setTintColor:tintColor];
    return backBarBtnItem;
}

@end
