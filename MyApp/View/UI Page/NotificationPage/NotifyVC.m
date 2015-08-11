//
//  NotifyVC.m
//  MyApp
//
//  Created by Faustino L on 8/19/14.

//

#import "NotifyVC.h"

#import "UIViewController+MMDrawerController.h"
#import "MPGNotification.h"

@interface NotifyVC ()
{
    BaseNC *baseNC;
    MPGNotification *notification;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *animationTypeSC;
@property (weak, nonatomic) IBOutlet UISwitch *iconSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *subtitleSwitch;
@property (weak, nonatomic) IBOutlet UILabel *buttonsLB;
@property (weak, nonatomic) IBOutlet UISegmentedControl *colorChooser;
@property (weak, nonatomic) IBOutlet UIButton *showNotificationBtn;

@end

@implementation NotifyVC

- (id)initWithView:(BaseNC *)rootNC;
{
    self = [super initWithNibName:@"NotifyVC" bundle:nil];
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
    HideNavigationBar(NO);
    [self.view setBackgroundColor:baseNC.backColor];
}

//==================================================
// Custom Methods
//==================================================
#pragma mark- Custom Methods
//==================================================
- (void)setupUI
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sidemenu"] style:UIBarButtonItemStyleDone target:self action:@selector(buttonPressed:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    [backButton setTag:1];
    
    [self.navigationItem setTitle:@"MPGNotification"];
    
    [_scrollView setContentSize:CGSizeMake(320.f, 450.f)];
}

- (void)showNotification
{
    NSArray *buttonArray;
    UIImage *icon;
    NSString *subtitle;
    switch ([[_buttonsLB text] intValue]) {
        case 0:
            buttonArray = nil;
            break;
            
        case 1:
            buttonArray = [NSArray arrayWithObject:@"Done"];
            break;
            
        case 2:
            buttonArray = [NSArray arrayWithObjects:@"Reply",@"Later", nil];
            break;
            
        default:
            break;
    }
    
    if ([_iconSwitch isOn]) {
        icon = [UIImage imageNamed:@"ChatIcon"];
    }
    else{
        icon = nil;
    }
    
    if ([_subtitleSwitch isOn]) {
        subtitle = @"Did you hear my new collab on Beatport? It's on #1. It's getting incredible reviews as well. Let me know what you think of it!";
    }
    else{
        subtitle = nil;
    }
    
    notification = [MPGNotification notificationWithTitle:@"Joey Dale" subtitle:subtitle backgroundColor:[_colorChooser tintColor] iconImage:icon];
    [notification setButtonConfiguration:buttonArray.count withButtonTitles:buttonArray];
    notification.duration = 2.0;
    
    __weak typeof(self) weakSelf = self;
    [notification setDismissHandler:^(MPGNotification *notification) {
        [weakSelf.showNotificationBtn setEnabled:YES];
    }];
    
    [notification setButtonHandler:^(MPGNotification *notification, NSInteger buttonIndex) {
        NSLog(@"buttonIndex : %ld", (long)buttonIndex);
        [weakSelf.showNotificationBtn setEnabled:YES];
    }];
    
    if (!([_colorChooser selectedSegmentIndex] == 3 || [_colorChooser selectedSegmentIndex] == 1)) {
        [notification setTitleColor:[UIColor whiteColor]];
        [notification setSubtitleColor:[UIColor whiteColor]];
    }
    
    switch ([_animationTypeSC selectedSegmentIndex]) {
        case 0:
            [notification setAnimationType:MPGNotificationAnimationTypeLinear];
            break;
            
        case 1:
            [notification setAnimationType:MPGNotificationAnimationTypeDrop];
            break;
            
        case 2:
            [notification setAnimationType:MPGNotificationAnimationTypeSnap];
            break;
            
        default:
            break;
    }
    
    [notification show];
    [_showNotificationBtn setEnabled:NO];
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
        
    } else if (button.tag == 6) { // Show Notification Button
        [self showNotification];
    }
}

- (IBAction)buttonCountChanged:(id)sender {
    [_buttonsLB setText:[NSString stringWithFormat:@"%d", (int)[(UIStepper *)sender value]]];
}

- (IBAction)colorChanged:(id)sender {
    switch ([(UISegmentedControl *)sender selectedSegmentIndex]) {
        case 0:
            [_colorChooser setTintColor:[UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0]];
            break;
            
        case 1:
            [_colorChooser setTintColor:[UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:1.0]];
            break;
            
        case 2:
            [_colorChooser setTintColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:255.0/255.0 alpha:1.0]];
            break;
            
        case 3:
            [_colorChooser setTintColor:[UIColor colorWithRed:241.0/255.0 green:196.0/255.0 blue:15.0/255.0 alpha:1.0]];
            break;
            
        case 4:
            [_colorChooser setTintColor:[UIColor colorWithRed:52.0/255.0 green:73.0/255.0 blue:94.0/255.0 alpha:1.0]];
            break;
            
        default:
            break;
    }
}

@end
