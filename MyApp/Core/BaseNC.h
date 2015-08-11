//
//  BaseNC.h
//  MyApp
//
//  Created by Faustino L on 8/12/14.
//

#import <UIKit/UIKit.h>

@class BaseModel;
@class CEReversibleAnimationController, CEBaseInteractionController;
@class  MMDrawerController, LeftSideDrawerVC,
        HomeVC, TestVC,
        ColorsVC, NotifyVC, CtrlVC,
        FacebookVC, TwitterVC, GoogleVC,
        AFNetVC,
        AudioVC;

@interface BaseNC : UINavigationController

@property (nonatomic, retain) BaseModel *baseModel;

@property (nonatomic, retain) UIColor *backColor;

@property (strong, nonatomic) CEReversibleAnimationController *baseAC;
@property (strong, nonatomic) CEBaseInteractionController *baseIC;

@property (nonatomic, retain) MMDrawerController *drawerVC;
@property (nonatomic, retain) UINavigationController * centerDrawerNC;
@property (nonatomic, retain) LeftSideDrawerVC *leftSideDrawerVC;

@property (nonatomic, retain) HomeVC *homeVC;
@property (nonatomic, retain) TestVC *testVC;

@property (nonatomic, retain) ColorsVC *colorsVC;
@property (nonatomic, retain) NotifyVC *notifyVC;
@property (nonatomic, retain) CtrlVC *ctrlVC;

@property (nonatomic, retain) FacebookVC *facebookVC;
@property (nonatomic, retain) TwitterVC *twitterVC;
@property (nonatomic, retain) GoogleVC *googleVC;

@property (nonatomic, retain) AFNetVC *afNetVC;

@property (nonatomic, retain) AudioVC *audioVC;

- (id)initWithModel:(BaseModel *)model;
- (void)setAnimationController:(NSString *)animationTransitionName InteractionController:(NSString *)interactionTransitionName;

- (void)showProgressWithTitle:(NSString *)title Message:(NSString *)msg Mode:(int)mode;
- (void)hideProgress;

- (BOOL)isViewController:(UIViewController *)viewController inStackOfNavigationController:(UINavigationController *)navigationController;
@end
