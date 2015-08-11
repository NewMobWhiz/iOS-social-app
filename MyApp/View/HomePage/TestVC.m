//
//  TestVC.m
//  MyApp
//
//  Created by Faustino L on 9/4/14.

//

#import "TestVC.h"

#import "UIUtils.h"

@interface TestVC ()
{
    BaseNC *baseNC;
}

@end

@implementation TestVC

- (id)initWithView:(BaseNC *)rootNC
{
    self = [super initWithNibName:@"TestVC" bundle:nil];
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//==================================================
// Custom Methods
//==================================================
#pragma mark- Custom Methods
//==================================================
- (void)setupUI
{
    // Configure Navigation Bar
    // Make BarButton Item
    UIBarButtonItem *backBarBtnItem = [UIUtils createCustomBackButtonWithImageName:@"back" Title:@"Back" Target:self Action:@selector(backButtonPressed:) Tag:0];
    [self.navigationItem setLeftBarButtonItem:backBarBtnItem];
    
    [self.navigationItem setTitle:@"Test"];
}

//==================================================
// Custom Methods
//==================================================
#pragma mark- Custom Methods
//==================================================
- (IBAction)backButtonPressed:(id)sender {
    if ([baseNC isViewController:(UIViewController *)baseNC.homeVC inStackOfNavigationController:baseNC.centerDrawerNC]) {
        [baseNC.centerDrawerNC popToViewController:(UIViewController *)baseNC.homeVC animated:YES];
        
    } else {
        [baseNC.centerDrawerNC pushViewController:(UIViewController *)baseNC.homeVC animated:YES];
    }
}

@end
