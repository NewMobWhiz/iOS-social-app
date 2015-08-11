//
//  FacebookVC.m
//  MyApp
//
//  Created by Faustino L on 8/15/14.

//

#import "FacebookVC.h"

#import "UIViewController+MMDrawerController.h"
#import "BButton.h"
#import "PAImageView.h"

#import "Config.h"
#import "SocialComms.h"

@interface FacebookVC ()<SocialCommsDelegate>
{
    BaseNC *baseNC;
}

@property (weak, nonatomic) IBOutlet BButton *facebookLoginBtn;
@property (weak, nonatomic) IBOutlet BButton *facebookLogoutBtn;
@property (weak, nonatomic) IBOutlet BButton *userInfoBtn;
@property (weak, nonatomic) IBOutlet PAImageView *avatarView;
@property (weak, nonatomic) IBOutlet UITextView *userInfoTV;

@end

@implementation FacebookVC

- (id)initWithView:(BaseNC *)rootNC
{
    self = [super initWithNibName:@"FacebookVC" bundle:nil];
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

    if ([SocialComms checkFacebookSessionState:self]) {
        [self setButtonsEnabled:YES];
    } else {
        [self setButtonsEnabled:NO];
    }
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
    
    [self.navigationItem setTitle:@"Facebook API Usage"];
    
    [_facebookLoginBtn setType:BButtonTypeFacebook];
    [_facebookLoginBtn setStyle:BButtonStyleBootstrapV3];
    [_facebookLoginBtn addAwesomeIcon:FAFacebook beforeTitle:YES];
    
    [_facebookLogoutBtn setType:BButtonTypeDanger];
    [_facebookLoginBtn setStyle:BButtonStyleBootstrapV3];
    
    [_userInfoBtn setType:BButtonTypeInfo];
    [_userInfoBtn setStyle:BButtonStyleBootstrapV3];
    
    [_avatarView setBackgroundProgresscolor:[UIColor whiteColor]];
    [_avatarView setProgressColor:[UIColor redColor]];
    
    [_userInfoTV setText:@""];
}

- (void)setButtonsEnabled:(BOOL)enabled
{
    [_facebookLoginBtn setEnabled:!enabled];
    [_facebookLogoutBtn setEnabled:enabled];
    [_userInfoBtn setEnabled:enabled];
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
        
    } else if (button.tag == 11) { // Facebook Login Button
        [SocialComms facebookLogIn:self];
    } else if (button.tag == 12) { // Facebook Logout Button
        [SocialComms facebookLogOut];
        [self setButtonsEnabled:NO];

    } else if (button.tag == 13) { // Facebook UserInfo Button
        NSArray *permissionsNeeded = @[@"public_profile", @"email"];
        [SocialComms facebookGetUserInfo:self PermissonsNeeded:permissionsNeeded];
        [baseNC showProgressWithTitle:@"loading..." Message:nil Mode:MBProgressHUDColorMode];
    }
}

//==================================================
// Socials Delegate Methods
//==================================================
#pragma mark- CommSocialss Delegate Methods
//==================================================
- (void)socialCommsDidAction:(NSDictionary *)response
{
    if ([[response objectForKey:@"actionType"] intValue] == FacebookActionTypeCheck) {
        if ([[response objectForKey:@"responseCode"] boolValue]) {
            [self setButtonsEnabled:YES];
        } else {
            [self setButtonsEnabled:NO];
        }
    } else if ([[response objectForKey:@"actionType"] intValue] == FacebookActionTypeLogin) {
        if ([[response objectForKey:@"responseCode"] boolValue]) {
            [self setButtonsEnabled:YES];
        }
    } else if ([[response objectForKey:@"actionType"] intValue] == FacebookActionTypeUserInfo) {
        [baseNC hideProgress];
        if ([[response objectForKey:@"responseCode"] boolValue]) {
            NSDictionary *userInfo = response[@"userInfo"];
            NSURL *avatarUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", userInfo[@"id"]]];
            [_avatarView setImageURL:avatarUrl];            
            [_userInfoTV setText:[NSString stringWithFormat:@"%@", userInfo]];
        }
    }
}

@end
