//
//  AppDelegate.h
//  MyApp
//
//  Created by Faustino L on 8/12/14.
//

#import <UIKit/UIKit.h>

@class BaseModel, BaseNC;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BaseModel *model;
    BaseNC *view;
}

@property (strong, nonatomic) UIWindow *window;

@end
