//
//  HomeVC.m
//  MyApp
//
//  Created by Faustino L on 8/14/14.

//

#import "HomeVC.h"

#import "UIViewController+MMDrawerController.h"

@interface HomeVC () 
{
    BaseNC *baseNC;
}
@end

@implementation HomeVC

- (id)initWithView:(BaseNC *)rootNC
{
    self = [super initWithNibName:@"HomeVC" bundle:nil];
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
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonPressed:)];
    [self.navigationItem setRightBarButtonItem:addButton];
    [addButton setTag:2];
    
    [self.navigationItem setTitle:@"Home"];
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
        
    } else if (button.tag == 2) { // Add Button
        if ([baseNC isViewController:(UIViewController *)baseNC.ctrlVC inStackOfNavigationController:baseNC.centerDrawerNC]) {
            [baseNC.centerDrawerNC popToViewController:(UIViewController *)baseNC.ctrlVC animated:YES];

        } else {
            [baseNC.centerDrawerNC pushViewController:(UIViewController *)baseNC.ctrlVC animated:YES];
        }
        
    } else if (button.tag == 3) { // Test Action Button
        if ([baseNC isViewController:(UIViewController *)baseNC.testVC inStackOfNavigationController:baseNC.centerDrawerNC]) {
            [baseNC.centerDrawerNC popToViewController:(UIViewController *)baseNC.testVC animated:YES];
            
        } else {
            [baseNC.centerDrawerNC pushViewController:(UIViewController *)baseNC.testVC animated:YES];
        }
    }
}

@end
