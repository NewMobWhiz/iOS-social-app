//
//  CtrlVC.m
//  MyApp
//
//  Created by Faustino L on 8/14/14.

//

#import "CtrlVC.h"

@interface CtrlVC ()
{
    BaseNC *baseNC;
}
@end

@implementation CtrlVC

- (id)initWithView:(BaseNC *)rootNC
{
    self = [super initWithNibName:@"CtrlVC" bundle:nil];
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
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sidemenu"] style:UIBarButtonItemStyleDone target:self action:@selector(buttonPressed:)];
//    [self.navigationItem setLeftBarButtonItem:backButton];
//    [backButton setTag:1];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(buttonPressed:)];
    [self.navigationItem setRightBarButtonItem:nextButton];
    [nextButton setTag:2];
    
    [self.navigationItem setTitle:@"Custom Controls"];
}

//==================================================
// UIButton Delegate Methods
//==================================================
#pragma mark- UIButton Delegate Methods
//==================================================
- (IBAction)buttonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1) { // Back Button
        NSLog(@"sidemenu");
    } 
}
@end
