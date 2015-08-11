//
//  BaseNC.m
//  MyApp
//
//  Created by Faustino L on 8/12/14.
//

#import "BaseNC.h"

#import "MBProgressHUD.h"
#import "CEBaseInteractionController.h"
#import "CEReversibleAnimationController.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "UIColor+BrandColors.h"

#import "UIUtils.h"
#import "BaseModel.h"

#import "LeftSideDrawerVC.h"
#import "HomeVC.h"
#import "TestVC.h"

#import "ColorsVC.h"
#import "NotifyVC.h"
#import "CtrlVC.h"

#import "FacebookVC.h"
#import "TwitterVC.h"
#import "GoogleVC.h"

#import "AFNetVC.h"

#import "AudioVC.h"

@interface BaseNC ()<UINavigationControllerDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@end

@implementation BaseNC

@synthesize baseModel;

@synthesize baseAC;
@synthesize baseIC;

- (id)initWithModel:(BaseModel *)model
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self setDelegate:self];
        baseModel = model;
        
        if ([UserManager sharedManager].backColorName) {
            _backColor = [UIColor bc_colorForBrand:[UserManager sharedManager].backColorName];
        } else {
            _backColor = [UIColor bc_colorForBrand:@"yahoo"];
        }
        
        _homeVC = [[HomeVC alloc] initWithView:self];
        _testVC = [[TestVC alloc] initWithView:self];

        _centerDrawerNC = [[UINavigationController alloc] initWithRootViewController:_homeVC];
        [_centerDrawerNC setDelegate:self];
        _leftSideDrawerVC = [[LeftSideDrawerVC alloc] initWithView:self];
        _drawerVC = [[MMDrawerController alloc] initWithCenterViewController:_centerDrawerNC leftDrawerViewController:_leftSideDrawerVC];
        [_drawerVC setShowsShadow:NO];
        [_drawerVC setMaximumLeftDrawerWidth:260.0];
        [_drawerVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [_drawerVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeParallax];
        [_drawerVC
         setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
             MMDrawerControllerDrawerVisualStateBlock block;
             block = [[MMExampleDrawerVisualStateManager sharedManager]
                      drawerVisualStateBlockForDrawerSide:drawerSide];
             if(block){
                 block(drawerController, drawerSide, percentVisible);
             }
         }];
        
        _colorsVC = [[ColorsVC alloc] initWithView:self];
        _notifyVC = [[NotifyVC alloc] initWithView:self];
        _ctrlVC = [[CtrlVC alloc] initWithView:self];
        _facebookVC = [[FacebookVC alloc] initWithView:self];
        _twitterVC = [[TwitterVC alloc] initWithView:self];
        _googleVC = [[GoogleVC alloc] initWithView:self];
        _afNetVC = [[AFNetVC alloc] initWithView:self];
        _audioVC = [[AudioVC alloc] initWithView:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (debugBaseNC) NSLog(@"BaseNC viewDidLoad");

    [self setAnimationController:ACs[0] InteractionController:ICs[0]];

    [_centerDrawerNC.navigationBar setBarTintColor:_backColor]; // back color of navigation bar
    [_centerDrawerNC.navigationBar setTintColor:[UIColor whiteColor]]; // barbutton color of navigation bar
    [_centerDrawerNC.view setBackgroundColor:_backColor];
    
    [self setNavigationBarHidden:YES];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]; // title color of navigation bar

    [self.view setBackgroundColor:_backColor];
    
    [self pushViewController:_drawerVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"BaseNC didReceiveMemoryWarning");
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//==================================================
// UINavigationControllerDelegate Methods
//==================================================
#pragma mark - UINavigationControllerDelegate
//==================================================
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    // when a push occurs, wire the interaction controller to the to- view controller
    if (baseIC) {
        [baseIC wireToViewController:toVC forOperation:CEInteractionOperationPop];
    }
    
    if (baseAC) {
        baseAC.reverse = operation == UINavigationControllerOperationPop;
    }
    
    return baseAC;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    // if we have an interaction controller - and it is currently in progress, return it
    return baseIC && baseIC.interactionInProgress ? baseIC : nil;
}

//==================================================
// Transition Setup Methods
//==================================================
#pragma mark - Transition Setup Methods
//==================================================
- (void)setAnimationController:(NSString *)animationTransitionName InteractionController:(NSString *)interactionTransitionName
{
    NSString *className = [NSString stringWithFormat:@"CE%@AnimationController", animationTransitionName];
    id animationTransitionInstance = [[NSClassFromString(className) alloc] init];
    baseAC = animationTransitionInstance;
    
    className = [NSString stringWithFormat:@"CE%@InteractionController", interactionTransitionName];
    id interactionTransitionInstance = [[NSClassFromString(className) alloc] init];
    baseIC = interactionTransitionInstance;
}

//==================================================
// Common UI Config Methods
//==================================================
#pragma mark- Custom Methods
//==================================================
- (void)showProgressWithTitle:(NSString *)title Message:(NSString *)msg Mode:(int)mode;
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    [HUD setDelegate:self];
    
    if (title != nil) [HUD setLabelText:title];
    if (msg != nil) [HUD setDetailsLabelText:msg];
    
    switch (mode) {
        case MBProgressHUDSpinMode:
            [HUD show:YES]; //[hud showWhileExecuting:nil onTarget:self withObject:nil animated:YES];
            break;
        case MBProgressHUDDeterminateMode:
            [HUD setMode:MBProgressHUDModeDeterminate];
            [HUD show:YES];
            break;
        case MBProgressHUDAnnularDeterminateMode:
            [HUD setMode:MBProgressHUDModeAnnularDeterminate];
            [HUD show:YES];
            break;
        case MBProgressHUDHorizontalBarMode:
            [HUD setMode:MBProgressHUDModeDeterminateHorizontalBar];
            [HUD show:YES];
            break;
        case MBProgressHUDCustomViewMode:
            [HUD setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]]];
            // Set custom view mode
            [HUD setMode:MBProgressHUDModeCustomView];
            [HUD show:YES];
            [HUD hide:YES afterDelay:1];
            break;
        case MBProgressHUDGradientMode:
            [HUD setDimBackground:YES];
            [HUD show:YES];
            break;
        case MBProgressHUDTextOnlyMode:
            [HUD setMode:MBProgressHUDModeText];
            HUD.margin = 10.f;
            HUD.yOffset = 150.f;
            HUD.removeFromSuperViewOnHide = YES;
            [HUD show:YES];
            [HUD hide:YES afterDelay:1];
            break;
        case MBProgressHUDColorMode:
            //[HUD setColor:[UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90]];
            [HUD show:YES];
            break;
        default:
            break;
    }
}

- (void)hideProgress
{
    [HUD hide:YES];
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hiddenHud
{
    // Remove HUD from screen when the HUD was hidded
	[hiddenHud removeFromSuperview];
	hiddenHud = nil;
}

//==================================================
// NC ViewController Stack Checking Methods
//==================================================
#pragma mark- NC ViewController Stack Checking Methods
//==================================================
- (BOOL)isViewController:(UIViewController *)viewController inStackOfNavigationController:(UINavigationController *)navigationController
{
    for (UIViewController *stackedVC in [navigationController viewControllers]) {
        if (viewController == stackedVC) return YES;
    }
    return NO;
}


@end
