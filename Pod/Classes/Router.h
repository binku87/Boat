//
//  Router.h
//  Pods
//
//  Created by bin on 18/10/14.
//
//

#import <Foundation/Foundation.h>
#import "BoatViewController.h"
#import <UIKit/UIKit.h>

@interface Router : NSObject

+ (void) redirectTo:(NSString *)viewControllerName params:(NSDictionary *) params;
+ (BoatViewController *) controllerByName:(NSString *) viewControllerName;
+ (NSString *)currentContentController;

@end
