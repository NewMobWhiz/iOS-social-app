//
//  AFNetVC.m
//  MyApp
//
//  Created by Faustino L on 8/19/14.

//

#import "AFNetVC.h"

#import "UIViewController+MMDrawerController.h"

#import "Config.h"
#import "AFNetClient.h"

@interface AFNetVC ()<AFNetClientDelegate, UIActionSheetDelegate, NSXMLParserDelegate>
{
    BaseNC *baseNC;
    BOOL needRefresh;
    BOOL clientType; // NO: HTTP GET, YES: HTTP POST
    NSString *responseBody;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *dataTypeSC;
@property (weak, nonatomic) IBOutlet UILabel *descLB;
@property (weak, nonatomic) IBOutlet UITextView *responseTV;

@property(nonatomic, strong) NSMutableDictionary *currentDictionary; // current section being parsed
@property(nonatomic, strong) NSMutableDictionary *xmlWeather; // completed parsed xml response
@property(nonatomic, strong) NSString *elementName;
@property(nonatomic, strong) NSMutableString *outstring;
@property(strong) NSDictionary *weather;
@end

@implementation AFNetVC

- (id)initWithView:(BaseNC *)rootNC
{
    self = [super initWithNibName:@"AFNetVC" bundle:nil];
    if (self) {
        // Custom initialization
        baseNC = rootNC;
        needRefresh = NO;
        clientType = NO;
        responseBody = @"";
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
    
    UIBarButtonItem *clientButton = [[UIBarButtonItem alloc] initWithTitle:@"Client" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonPressed:)];
    [self.navigationItem setRightBarButtonItem:clientButton];
    [clientButton setTag:2];
    
    [self.navigationItem setTitle:@"AFNetworking Usage"];
    
    [_dataTypeSC setSelectedSegmentIndex:0];
}

- (void)setRefresh:(BOOL)refresh
{
    needRefresh = refresh;
}

- (void)reloadPage
{
    needRefresh = NO;
    responseBody = @"";
    
    AFNetClient *client = [AFNetClient sharedAFNetClient];
    [client setDelegate:self];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (_dataTypeSC.selectedSegmentIndex == 0) {
        [client setRequestSerializer:AFNetClientRequestSerializerTypeJSON ResponseSerializer:AFNetClientResponseSerializerTypeJSON];
        params[@"format"] = @"json";
    } else if (_dataTypeSC.selectedSegmentIndex == 1) {
        [client setRequestSerializer:AFNetClientRequestSerializerTypeJSON ResponseSerializer:AFNetClientResponseSerializerTypeXML];
        params[@"format"] = @"xml";
    } else if (_dataTypeSC.selectedSegmentIndex == 2) {
        [client setRequestSerializer:AFNetClientRequestSerializerTypePLIST ResponseSerializer:AFNetClientResponseSerializerTypePLIST];
        params[@"format"] = @"plist";
    }
    
    [client getResponseFromServerWithClientType:clientType Params:[params copy]];
    [baseNC showProgressWithTitle:@"loading..." Message:nil Mode:MBProgressHUDColorMode];
}

- (void)refreshPage
{
    [_responseTV setText:responseBody];
    NSString *clientTypeString = clientType ? @"HTTP POST" : @"HTTP GET";
    if (_dataTypeSC.selectedSegmentIndex == 0  ||  _dataTypeSC.selectedSegmentIndex == 2)
        [_descLB setText:[NSString stringWithFormat:@"Server Response (%@)", clientTypeString]];
    else [_descLB setText:[NSString stringWithFormat:@"Server Response (%@)", clientTypeString]];
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
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"AFHTTPSessionManager"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"HTTP GET", @"HTTP POST", nil];
        [actionSheet showFromBarButtonItem:sender animated:YES];
    }
}

- (IBAction)dataTypeSCChanged:(id)sender {
    [self reloadPage];
}

//==================================================
// UIActionSheet Delegate Methods
//==================================================
#pragma mark- UIActionSheet Delegate Methods
//==================================================
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        // User pressed cancel -- abort
        return;
    }
    
    if (buttonIndex == 0) clientType = NO;
    else if (buttonIndex == 1) clientType = YES;
    
    [self reloadPage];
}

//==================================================
// AFNetClient Delegate Methods
//==================================================
#pragma mark- AFNetClient Delegate Methods
//==================================================
- (void)afnetClient:(AFNetClient *)client didSuccessWithResponse:(id)response
{
    [baseNC hideProgress];
    if (_dataTypeSC.selectedSegmentIndex == 1) { // XML type
        NSXMLParser *XMLParser = (NSXMLParser *)response;
        [XMLParser setShouldProcessNamespaces:YES];
        
        // These lines below were previously commented
        XMLParser.delegate = self;
        [XMLParser parse];
        
    } else {
        responseBody = [NSString stringWithFormat:@"%@", response];
        [self refreshPage];
    }
}

- (void)afnetClient:(AFNetClient *)client didFailWithError:(NSError *)error
{
    [baseNC hideProgress];
    responseBody = error.description;
    [self refreshPage];
}

//==================================================
// NSXMLParser Delegate Methods
//==================================================
#pragma mark - NSXMLParser Delegate
//==================================================
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.xmlWeather = [NSMutableDictionary dictionary];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.elementName = qName;
    
    if ([qName isEqualToString:@"current_condition"] ||
        [qName isEqualToString:@"weather"] ||
        [qName isEqualToString:@"request"]) {
        self.currentDictionary = [NSMutableDictionary dictionary];
    }
    
    self.outstring = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!self.elementName) return;
    
    [self.outstring appendFormat:@"%@", string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([qName isEqualToString:@"current_condition"] ||
        [qName isEqualToString:@"request"]) {
        self.xmlWeather[qName] = @[self.currentDictionary];
        self.currentDictionary = nil;
        
    } else if ([qName isEqualToString:@"weather"]) {
        // Initialize the list of weather items if it doesn't exist
        NSMutableArray *array = self.xmlWeather[@"weather"] ?: [NSMutableArray array];
        
        // Add the current weather object
        [array addObject:self.currentDictionary];
        
        // Set the new array to the "weather" key on xmlWeather dictionary
        self.xmlWeather[@"weather"] = array;
        
        self.currentDictionary = nil;
        
    } else if ([qName isEqualToString:@"value"]) {
        // Ignore value tags, they only appear in the two conditions below
    } else if ([qName isEqualToString:@"weatherDesc"] || [qName isEqualToString:@"weatherIconUrl"]) {
        NSDictionary *dictionary = @{@"value": self.outstring};
        NSArray *array = @[dictionary];
        self.currentDictionary[qName] = array;
        
    } else if (qName) {
        self.currentDictionary[qName] = self.outstring;
    }
    
	self.elementName = nil;
}

- (void) parserDidEndDocument:(NSXMLParser *)parser
{
    self.weather = @{@"data": self.xmlWeather};
    responseBody = [NSString stringWithFormat:@"%@", self.weather];
    [self refreshPage];
}
@end
