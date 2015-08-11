//
//  TwitterVC.m
//  MyApp
//
//  Created by Faustino L on 8/15/14.

//

#import "TwitterVC.h"

#import "UIViewController+MMDrawerController.h"
#import "FHSTwitterEngine.h"
#import "BButton.h"
#import "TNRadioButtonGroup.h"

#import "Config.h"

@interface TwitterVC ()<FHSTwitterEngineAccessTokenDelegate, UIAlertViewDelegate>
{
    BaseNC *baseNC;
}

@property (weak, nonatomic) IBOutlet BButton *twitterLoginBtn;
@property (retain, nonatomic) IBOutlet TNRadioButtonGroup *authGroup;
@property (weak, nonatomic) IBOutlet BButton *twitterLogoutBtn;
@property (weak, nonatomic) IBOutlet BButton *userInfoBtn;

@end

@implementation TwitterVC

- (id)initWithView:(BaseNC *)rootNC
{
    self = [super initWithNibName:@"TwitterVC" bundle:nil];
    if (self) {
        // Custom initialization
        baseNC = rootNC;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:TWITTER_API_KEY andSecret:TWITTER_SECRET];
    [[FHSTwitterEngine sharedEngine] setDelegate:self];
    [[FHSTwitterEngine sharedEngine] loadAccessToken];
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Show Navigation Bar
    HideNavigationBar(NO);
    [self.view setBackgroundColor:baseNC.backColor];
    [self setButtonsEnabled:FHSTwitterEngine.sharedEngine.isAuthorized];
}

//==================================================
// Custom Methods
//==================================================
#pragma mark- Custom Methods
//==================================================
- (void)setupUI
{
    // Make BarButton Item
    UIBarButtonItem *drawerButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sidemenu"] style:UIBarButtonItemStyleDone target:self action:@selector(buttonPressed:)];
    [self.navigationItem setLeftBarButtonItem:drawerButton];
    [drawerButton setTag:1];
    
    [self.navigationItem setTitle:@"Twitter API Usage"];
    
    [_twitterLoginBtn setType:BButtonTypeTwitter];
    [_twitterLoginBtn setStyle:BButtonStyleBootstrapV3];
    [_twitterLoginBtn addAwesomeIcon:FATwitter beforeTitle:YES];
    
    [_twitterLogoutBtn setType:BButtonTypeDanger];
    [_twitterLogoutBtn setStyle:BButtonStyleBootstrapV3];
    [_twitterLogoutBtn addAwesomeIcon:FATwitterSquare beforeTitle:YES];
    
    [_userInfoBtn setType:BButtonTypeInfo];
    [_userInfoBtn setStyle:BButtonStyleBootstrapV3];
    
    TNRectangularRadioButtonData *oAuthData = [TNRectangularRadioButtonData new];
    oAuthData.labelText = @"OAuth";
    oAuthData.identifier = @"oauth";
    oAuthData.selected = YES;
    oAuthData.borderColor = [UIColor blackColor];
    oAuthData.rectangleColor = [UIColor blackColor];
    oAuthData.borderWidth = oAuthData.borderHeight = 20;
    oAuthData.rectangleWidth = oAuthData.rectangleHeight = 10;
    
    TNRectangularRadioButtonData *xAuthData = [TNRectangularRadioButtonData new];
    xAuthData.labelText = @"XAuth";
    xAuthData.identifier = @"xauth";
    xAuthData.selected = NO;
    xAuthData.rectangleColor = [UIColor blackColor];
    xAuthData.borderWidth = xAuthData.borderHeight = 20;
    xAuthData.rectangleWidth = xAuthData.rectangleHeight = 10;
    
    _authGroup = [_authGroup initWithRadioButtonData:@[oAuthData, xAuthData] layout:TNRadioButtonGroupLayoutHorizontal];
    _authGroup.identifier = @"Auth group";
    [_authGroup create];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authGroupUpdated:) name:SELECTED_RADIO_BUTTON_CHANGED object:self.authGroup];
}

- (void)setButtonsEnabled:(BOOL)enabled
{
    [_twitterLoginBtn setEnabled:!enabled];
    [_twitterLogoutBtn setEnabled:enabled];
    [_userInfoBtn setEnabled:enabled];
    NSLog(@"Twitter ID: %@", [[FHSTwitterEngine sharedEngine] authenticatedID]);
    NSLog(@"Twitter Username: %@", [[FHSTwitterEngine sharedEngine] authenticatedUsername]);
}

- (void)loginOAuth
{
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
    }];
    [self presentViewController:loginController animated:YES completion:nil];
}

- (void)loginXAuth
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"xAuth Login" message:@"Enter your Twitter login credentials:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
    [av setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [[av textFieldAtIndex:0]setPlaceholder:@"Username"];
    [[av textFieldAtIndex:1]setPlaceholder:@"Password"];
    [av show];
}

- (void)logTimeline
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            NSLog(@"%@",[[FHSTwitterEngine sharedEngine] getTimelineForUser:[[FHSTwitterEngine sharedEngine]authenticatedID] isID:YES count:10]);
            dispatch_sync(dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    [baseNC hideProgress];
                    [[[UIAlertView alloc]initWithTitle:@"Complete" message:@"Your list of followers has been fetched. Check your debugger." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                }
            });
        }
    });
}

//==================================================
// UIButton Delegate Methods
//==================================================
#pragma mark- UIButton Delegate Methods
//==================================================
- (IBAction)buttonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1) { // Side Menu Button
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        
    } else if (button.tag == 11) { // Twitter Login Button
        if ([_authGroup.selectedRadioButton.data.identifier isEqualToString:@"oauth"]) {
            [self loginOAuth];
        } else {
            [self loginXAuth];
        }
        
    } else if (button.tag == 12) { // Twitter Logout Button
        [[FHSTwitterEngine sharedEngine] clearAccessToken];
        [self setButtonsEnabled:NO];
        
    } else if (button.tag == 13) { // Twitter UserInfo Button
        [self logTimeline];
        [baseNC showProgressWithTitle:@"loading..." Message:nil Mode:MBProgressHUDColorMode];
    }
}

- (void)authGroupUpdated:(NSNotification *)notification {
    NSLog(@"Auth group updated to %@", _authGroup.selectedRadioButton.data.identifier);
}

//==================================================
// FHSTwitterEngine Delegate Methods
//==================================================
#pragma mark- FHSTwitterEngine Delegate Methods
//==================================================
- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedTwitterAccessHTTPBody"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedTwitterAccessHTTPBody"];
}

//==================================================
// UIAlertView Delegate Methods
//==================================================
#pragma mark- UIAlertView Delegate Methods
//==================================================
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Tweet"]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                NSString *tweet = [alertView textFieldAtIndex:0].text;
                id returned = [[FHSTwitterEngine sharedEngine]postTweet:tweet];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                NSString *title = nil;
                NSString *message = nil;
                
                if ([returned isKindOfClass:[NSError class]]) {
                    NSError *error = (NSError *)returned;
                    title = [NSString stringWithFormat:@"Error %ld",(long)error.code];
                    message = error.localizedDescription;
                } else {
                    NSLog(@"%@",returned);
                    title = @"Tweet Posted";
                    message = tweet;
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    @autoreleasepool {
                        UIAlertView *av = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [av show];
                    }
                });
            }
        });
    } else {
        if (buttonIndex == 1) {
            NSString *username = [alertView textFieldAtIndex:0].text;
            NSString *password = [alertView textFieldAtIndex:1].text;
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @autoreleasepool {
                    // getXAuthAccessTokenForUsername:password: returns an NSError, not id.
                    NSError *returnValue = [[FHSTwitterEngine sharedEngine]getXAuthAccessTokenForUsername:username password:password];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        @autoreleasepool {
                            NSString *title = returnValue?[NSString stringWithFormat:@"Error %ld",(long)returnValue.code]:@"Success";
                            NSString *message = returnValue?returnValue.localizedDescription:@"You have successfully logged in via XAuth";
                            UIAlertView *av = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [av show];
                        }
                    });
                }
            });
        }
    }
}
@end
