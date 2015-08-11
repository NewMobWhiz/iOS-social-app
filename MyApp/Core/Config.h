//
//  Config.h
//  MyApp
//
//  Created by Faustino L on 1/2/14.
//

#ifndef MyApp_Config_h

#define MyApp_Config_h

#define AppDelegateAccessor ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define IS_IPHONE_5 [[UIScreen mainScreen] bounds].size.height > 480 ? TRUE : FALSE
#define IS_PORTRAIT [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait  ||  [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown

#define HideNavigationBar(yesno) self.navigationController.navigationBarHidden = yesno

// -------- Define app constant variables for
#define PARSE_APP_ID @"KNOWh98eDV5klReiuo2mcWd6cuZ1715ZI1yqHVM5"
#define PARSE_CLIENT_KEY @"YsIvWJTR9khmrYlBWrZA01Nl6KKqX41GkFxpuGsf"
#define PARSE_REST_API_KEY @"WzgcDsULH95ryU70NrrStzaLLPljw0NJdTAaL7vM"

#define TWITTER_API_KEY @"CLd1WwwM8eRcvdad49PtVPcaN"
#define TWITTER_SECRET @"RCiQNq1PXAaLAEl0rFsBjTO8EyUF8G5FwGcNQ7aMz5noHgWrzu"

#define GOOGLE_CLIENTID @"919429546553-o0797absltjlvkh0bnrt3pin0i9jjagi.apps.googleusercontent.com"

#define BASE_SERVER_URL @"http://www.raywenderlich.com/demos/weather_sample/"

// -------- Define ui constant variables
#define LEFT_SIDE_MENU_WIDTH 240.0

static const int debugBaseNC = 1;
static const int debugBaseModel = 1;
static const int debugUtils = 1;
static const int debugDatabase = 1;
static const int debugUserManager = 1;


static const int MAXROWS = 15;

static const int MBProgressHUDSpinMode = 1;
static const int MBProgressHUDDeterminateMode = 2;
static const int MBProgressHUDAnnularDeterminateMode = 3;
static const int MBProgressHUDHorizontalBarMode = 4;
static const int MBProgressHUDCustomViewMode = 5;
static const int MBProgressHUDGradientMode = 6;
static const int MBProgressHUDTextOnlyMode = 7;
static const int MBProgressHUDColorMode = 8;


static const int TIMER_INTERVAL = 60;

#endif