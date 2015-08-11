//
//  ColorsVC.m
//  MyApp
//
//  Created by Faustino L on 8/14/14.

//

#import "ColorsVC.h"

#import "UIViewController+MMDrawerController.h"
#import "UIColor+BrandColors.h"

@interface ColorsVC ()
{
    BaseNC *baseNC;
    NSArray *brandColors;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ColorsVC

- (id)initWithView:(BaseNC *)rootNC
{
    self = [super initWithNibName:@"ColorsVC" bundle:nil];
    if (self) {
        // Custom initialization
        baseNC = rootNC;
        brandColors = [UIColor bc_brands];
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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sidemenu"] style:UIBarButtonItemStyleDone target:self action:@selector(buttonPressed:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    [backButton setTag:1];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(buttonPressed:)];
    [self.navigationItem setRightBarButtonItem:nextButton];
    [nextButton setTag:2];

    [self.navigationItem setTitle:@"BrandColors"];
    
    [_tableView setRowHeight:54];
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
    } 
}

//==================================================
// UITableView Methods
//==================================================
#pragma mark- UITableView DataSource Methods
//==================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return brandColors.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeftSideMenuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        cell.separatorInset = UIEdgeInsetsZero;
    }
    
    NSString *colorName = brandColors[indexPath.row];
    UIColor *cellColor = [UIColor bc_colorForBrand:colorName];
    if ([[UIColor bc_brandsWithLightColor] containsObject:colorName]) {
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    else {
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    [cell.textLabel setText:colorName];
    [cell setBackgroundColor:cellColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UserManager sharedManager] setBackColorName:brandColors[indexPath.row]];
    [[UserManager sharedManager] updateUserManager];
    
    [baseNC setBackColor:[UIColor bc_colorForBrand:brandColors[indexPath.row]]];
    [baseNC.centerDrawerNC.navigationBar setBarTintColor:[UIColor bc_colorForBrand:brandColors[indexPath.row]]];
}
@end
