//
//  LeftSideDrawerVC.m
//  MyApp
//
//  Created by Faustino L on 8/13/14.

//

#import "LeftSideDrawerVC.h"

#import "LeftSideMenuCell.h"
#import "AFNetVC.h"
#import "AudioVC.h"

@interface LeftSideDrawerVC ()
{
    BaseNC *baseNC;
    NSArray *sections;
    NSArray *menuItems;
    NSArray *menuIcons;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation LeftSideDrawerVC

- (id)initWithView:(BaseNC *)rootNC
{
    self = [super initWithNibName:@"LeftSideDrawerVC" bundle:nil];
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
    NSLog(@"LeftSideDrawerVC didReceiveMemoryWarning");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:baseNC.backColor];
}

//==================================================
// Custom Methods
//==================================================
#pragma mark- Custom Methods
//==================================================
- (void)setupUI
{   
    sections = [[NSArray alloc] initWithObjects:@"Home", @"UI", @"Social", @"Communication", @"Media", nil];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [temp addObject:@[@"Home"]];
    [temp addObject:@[@"BrandColors", @"MPGNotification"]];
    [temp addObject:@[@"Facebook", @"Twitter", @"Google+"]];
    [temp addObject:@[@"AFNetworking"]];
    [temp addObject:@[@"Camera", @"Video", @"Audio"]];
    menuItems = [temp copy];
    menuIcons = [[NSArray alloc] initWithObjects:@"home", @"home", @"home", @"home", @"home", nil];
}

//==================================================
// UITableView Methods
//==================================================
#pragma mark- UITableView DataSource Methods
//==================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *subItems = [menuItems objectAtIndex:section];
    return subItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBounds:CGRectMake(0, 0, 320.f, 30.f)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 30)];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:sections[section]];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeftSideMenuCell";
    
    LeftSideMenuCell *cell = (LeftSideMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LeftSideMenuCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSArray *subItems = [menuItems objectAtIndex:indexPath.section];
    [cell.menuItemIV setImage:[UIImage imageNamed:menuIcons[indexPath.row]]];
    [cell.menuItemLB setText:subItems[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // Home Section
        if (indexPath.row == 0) { // Home
            if ([baseNC isViewController:(UIViewController *)baseNC.homeVC inStackOfNavigationController:baseNC.centerDrawerNC]) {
                [baseNC.centerDrawerNC popToViewController:(UIViewController *)baseNC.homeVC animated:NO];
            } else {
                [baseNC.centerDrawerNC pushViewController:(UIViewController *)baseNC.homeVC animated:NO];
            }
        }
    } else if (indexPath.section == 1) { // UI Section
        if (indexPath.row == 0) { // Brand Colors
            if ([baseNC isViewController:(UIViewController *)baseNC.colorsVC inStackOfNavigationController:baseNC.centerDrawerNC]) {
                [baseNC.centerDrawerNC popToViewController:(UIViewController *)baseNC.colorsVC animated:NO];
            } else {
                [baseNC.centerDrawerNC pushViewController:(UIViewController *)baseNC.colorsVC animated:NO];
            }
        } else if (indexPath.row == 1) { // MPGNotification
            if ([baseNC isViewController:(UIViewController *)baseNC.notifyVC inStackOfNavigationController:baseNC.centerDrawerNC]) {
                [baseNC.centerDrawerNC popToViewController:(UIViewController *)baseNC.notifyVC animated:NO];
            } else {
                [baseNC.centerDrawerNC pushViewController:(UIViewController *)baseNC.notifyVC animated:NO];
            }
        }
    } else if (indexPath.section == 2) { // Social Section
        if (indexPath.row == 0) { // Facebook
            if ([baseNC isViewController:(UIViewController *)baseNC.facebookVC inStackOfNavigationController:baseNC.centerDrawerNC]) {
                [baseNC.centerDrawerNC popToViewController:(UIViewController *)baseNC.facebookVC animated:NO];
            } else {
                [baseNC.centerDrawerNC pushViewController:(UIViewController *)baseNC.facebookVC animated:NO];
            }
        } else if (indexPath.row == 1) { // Twitter
            if ([baseNC isViewController:(UIViewController *)baseNC.twitterVC inStackOfNavigationController:baseNC.centerDrawerNC]) {
                [baseNC.centerDrawerNC popToViewController:(UIViewController *)baseNC.twitterVC animated:NO];
            } else {
                [baseNC.centerDrawerNC pushViewController:(UIViewController *)baseNC.twitterVC animated:NO];
            }
        } else if (indexPath.row == 2) { // Google+
            if ([baseNC isViewController:(UIViewController *)baseNC.googleVC inStackOfNavigationController:baseNC.centerDrawerNC]) {
                [baseNC.centerDrawerNC popToViewController:(UIViewController *)baseNC.googleVC animated:NO];
            } else {
                [baseNC.centerDrawerNC pushViewController:(UIViewController *)baseNC.googleVC animated:NO];
            }
        }
    } else if (indexPath.section == 3) { // Communication Section
        if (indexPath.row == 0) { // AFNetworking
            if (baseNC.centerDrawerNC.visibleViewController != baseNC.afNetVC) {
                [baseNC.afNetVC setRefresh:YES];
                if ([baseNC isViewController:(UIViewController *)baseNC.afNetVC inStackOfNavigationController:baseNC.centerDrawerNC]) {
                    [baseNC.centerDrawerNC popToViewController:(UIViewController *)baseNC.afNetVC animated:NO];
                } else {
                    [baseNC.centerDrawerNC pushViewController:(UIViewController *)baseNC.afNetVC animated:NO];
                }
            }
        }
    } else if (indexPath.section == 4) { // Media Section
        if (indexPath.row == 0) { // Camera
        } else if (indexPath.row == 1) { // Video
            
        } else if (indexPath.row == 2) { // Audio
            if (baseNC.centerDrawerNC.visibleViewController != baseNC.audioVC) {
                [baseNC.audioVC setRefresh:YES];
                if ([baseNC isViewController:(UIViewController *)baseNC.audioVC inStackOfNavigationController:baseNC.centerDrawerNC]) {
                    [baseNC.centerDrawerNC popToViewController:(UIViewController *)baseNC.audioVC animated:NO];
                } else {
                    [baseNC.centerDrawerNC pushViewController:(UIViewController *)baseNC.audioVC animated:NO];
                }
            }
        }
    }
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
