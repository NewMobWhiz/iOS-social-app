//
//  GoogleVC.m
//  MyApp
//
//  Created by Faustino L on 8/16/14.

//

#import "GoogleVC.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

#import "PAImageView.h"

#import "UIViewController+MMDrawerController.h"
#import "BButton.h"

#import "Config.h"

@interface GoogleVC ()<GPPSignInDelegate>
{
    BaseNC *baseNC;
}

@property (weak, nonatomic) IBOutlet BButton *googleLoginBtn;
@property (weak, nonatomic) IBOutlet BButton *googleLogoutBtn;
@property (weak, nonatomic) IBOutlet UILabel *googleIdLB;
@property (weak, nonatomic) IBOutlet UILabel *emailLB;
@property (weak, nonatomic) IBOutlet UILabel *usernameLB;
@property (weak, nonatomic) IBOutlet PAImageView *avatarView;

@end

@implementation GoogleVC

- (id)initWithView:(BaseNC *)rootNC
{
    self = [super initWithNibName:@"GoogleVC" bundle:nil];
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
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    [signIn setClientID:GOOGLE_CLIENTID];
    [signIn setShouldFetchGoogleUserID:YES];
    [signIn setShouldFetchGooglePlusUser:YES];
    [signIn setShouldFetchGoogleUserEmail:YES];
    [signIn setScopes:@[kGTLAuthScopePlusLogin]];
    
    [signIn setDelegate:self];
    
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
    
    [self setButtonsEnabled:NO];
    [[GPPSignIn sharedInstance] trySilentAuthentication];
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
    
    [self.navigationItem setTitle:@"Google API Usage"];
    
    [_googleLoginBtn setType:BButtonTypeDanger];
    [_googleLoginBtn setStyle:BButtonStyleBootstrapV3];
    [_googleLoginBtn addAwesomeIcon:FAGooglePlus beforeTitle:YES];
    
    [_googleLogoutBtn setType:BButtonTypePurple];
    [_googleLogoutBtn setStyle:BButtonStyleBootstrapV3];
    
    [_googleIdLB setText:@"ID:"];
    [_emailLB setText:@"Email:"];
    [_usernameLB setText:@"Username:"];
    
    [_avatarView setBackgroundProgresscolor:[UIColor whiteColor]];
    [_avatarView setProgressColor:[UIColor lightGrayColor]];
}

- (void)setButtonsEnabled:(BOOL)enabled
{
    [_googleLoginBtn setEnabled:!enabled];
    [_googleLogoutBtn setEnabled:enabled];
    
    NSString *userID = @"ID:";
    NSString *userEmail = @"Email:";
    NSString *userName = @"Username:";
    if (enabled) {
        userID = [NSString stringWithFormat:@"%@ %@", userID, [GPPSignIn sharedInstance].userID];
        userEmail = [NSString stringWithFormat:@"%@ %@", userEmail, [GPPSignIn sharedInstance].userEmail];
        userName = [NSString stringWithFormat:@"%@ %@", userName,[GPPSignIn sharedInstance].googlePlusUser.displayName];
    }
    [_googleIdLB setText:userID];
    [_emailLB setText:userEmail];
    [_usernameLB setText:userName];
    NSURL *url = [NSURL URLWithString:[GPPSignIn sharedInstance].googlePlusUser.image.url];
    [_avatarView setImageURL:url];
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
        
    } else if (button.tag == 11) { // Google+ Login Button
        [[GPPSignIn sharedInstance] authenticate];
        [baseNC showProgressWithTitle:@"signing in..." Message:nil Mode:MBProgressHUDColorMode];
        
    } else if (button.tag == 12) { // Google+ Logout Button
        [[GPPSignIn sharedInstance] signOut];
        [self setButtonsEnabled:NO];        
    }
}

//==================================================
// GPPSignIn Delegate Methods
//==================================================
#pragma mark- GPPSignIn Delegate Methods
//==================================================
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    [baseNC hideProgress];
    if (error) {
        NSLog(@"Google+ Signin error: %@", error);
        return;
    }

    NSLog(@"Received auth object %@", auth);
    [self setButtonsEnabled:YES];
}

@end
