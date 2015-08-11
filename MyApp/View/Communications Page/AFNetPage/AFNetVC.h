//
//  AFNetVC.h
//  MyApp
//
//  Created by Faustino L on 8/19/14.

//

#import <UIKit/UIKit.h>

#import "BaseNC.h"

@interface AFNetVC : UIViewController

- (id)initWithView:(BaseNC *)rootNC;
- (void)setRefresh:(BOOL)refresh;

@end
