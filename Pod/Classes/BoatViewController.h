//
//  BoatViewController.h
//  Pods
//
//  Created by bin on 19/10/14.
//
//

#import <UIKit/UIKit.h>
#import "BoatControllerProtocol.h"

@interface BoatViewController : UIViewController

@property (nonatomic) NSMutableDictionary *params;

- (NSString *) layoutName;
- (BOOL) beforeFilter;
- (void) doAction;
- (NSDictionary *) layoutExtraParams;

@end
