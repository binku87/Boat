//
//  Router.m
//  Pods
//
//  Created by bin on 18/10/14.
//
//

#import "Router.h"
#import "BoatViewController.h"

@implementation Router

static NSMutableDictionary *loadedControllers;

+ (void) redirectTo:(NSString *)viewControllerName
{
    BoatViewController *layoutController;
    BoatViewController *contentController = [Router controllerByName:viewControllerName];
    NSString *layoutName = [contentController layoutName];
    if ([layoutName isEqual:@""]) {
    } else {
        layoutController = [Router controllerByName:layoutName];
    }
}

+ (BoatViewController *) controllerByName:(NSString *) viewControllerName
{
    viewControllerName = [viewControllerName stringByAppendingString:@"Controller"];
    BoatViewController *viewController;
    if ([loadedControllers objectForKey:viewControllerName]) {
        viewController = [[NSClassFromString(viewControllerName) alloc] init];
        [loadedControllers setObject:viewController forKey:viewControllerName];
    } else {
        viewController = [loadedControllers objectForKey:viewControllerName];
    }
    return viewController;
}

@end
