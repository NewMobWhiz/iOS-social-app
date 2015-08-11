//
//  AudioVC.m
//  MyApp
//
//  Created by Faustino L on 9/2/14.

//

#import "AudioVC.h"
#import <AudioToolbox/AudioToolbox.h>

#import "UIViewController+MMDrawerController.h"

@interface AudioVC ()
{
    BaseNC *baseNC;
    BOOL needRefresh;
    NSArray *allAudioFiles;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AudioVC

- (id)initWithView:(BaseNC *)rootNC
{
    self = [super initWithNibName:@"AudioVC" bundle:nil];
    if (self) {
        // Custom initialization
        baseNC = rootNC;
        needRefresh = NO;
        allAudioFiles = nil;
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
    if (needRefresh) [self reloadPage];
    else [self refreshPage];
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
    
    UIBarButtonItem *clientButton = [[UIBarButtonItem alloc] initWithTitle:@"Temp" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonPressed:)];
    [self.navigationItem setRightBarButtonItem:clientButton];
    [clientButton setTag:2];
    
    [self.navigationItem setTitle:@"System Sounds"];
}

- (void)setRefresh:(BOOL)refresh
{
    needRefresh = refresh;
}

- (void)reloadPage
{
    needRefresh = NO;
    allAudioFiles = [[NSArray alloc] init];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *directoryURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds"];
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    NSDirectoryEnumerator *enumerator = [fileManager
                                         enumeratorAtURL:directoryURL
                                         includingPropertiesForKeys:keys
                                         options:0
                                         errorHandler: ^(NSURL *url, NSError *error) {
                                             // Handle the error.
                                             NSLog(@"Error: %@", error.description);
                                             // Return YES if the enumerationi should be continue after the error.
                                             return YES;
                                         }];
    for (NSURL *url in enumerator) {
        NSError *error;
        NSNumber *isDirectory = nil;
        if (![url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            NSLog(@"Error: %@", error.description);
        } else if (![isDirectory boolValue]) {
            [temp addObject:url];
        }
    }
    
    allAudioFiles = [temp copy];
    [self refreshPage];
}

- (void)refreshPage
{
    [_tableView reloadData];
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
        
    } else if (button.tag == 2) { // Client Button
        
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
    return allAudioFiles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AudioFileCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        cell.separatorInset = UIEdgeInsetsZero;
    }
    
    [cell.textLabel setText:[[allAudioFiles objectAtIndex:indexPath.row] lastPathComponent]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemSoundID soundID;
    //AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)[allAudioFiles objectAtIndex:indexPath.row], &soundID);
    AudioServicesCreateSystemSoundID(CFBridgingRetain([allAudioFiles objectAtIndex:indexPath.row]), &soundID);
    //AudioServicesPlaySystemSound(soundID);
    AudioServicesPlayAlertSound(soundID);
    NSLog(@"Selected sound: %u, %@", (unsigned int)soundID, [allAudioFiles[indexPath.row] description]);
}
@end
