//
//  Router.m
//  Pods
//
//  Created by bin on 18/10/14.
//
//

#import "Router.h"
#import "BoatViewController.h"
#import "BoatLayoutController.h"

static NSMutableDictionary *loadedControllers = nil;

@implementation Router

+ (void) redirectTo:(NSString *)viewControllerName params:(NSDictionary *) params
{
    BoatLayoutController *layoutController;
    BoatViewController *contentController = [Router controllerByName:viewControllerName];
    NSString *layoutName = @"";
    if ([contentController respondsToSelector:@selector(layoutName)]) {
        layoutName = [contentController layoutName];
    }
    if ([layoutName isEqual:@""]) {
    } else {
        layoutController = (BoatLayoutController *)[Router controllerByName:layoutName];
        [layoutController refreshView:params];
        [[self mainWindow] bringSubviewToFront:layoutController.view];
        [layoutController switchToView:contentController.view];
        if ([contentController respondsToSelector:@selector(refreshView:)]) {
            [contentController refreshView:params];
        }
    }
}

+ (BoatViewController *) controllerByName:(NSString *) viewControllerName
{
    viewControllerName = [viewControllerName stringByAppendingString:@"Controller"];
    BoatViewController *viewController;
    if (loadedControllers == nil) {
        loadedControllers = [NSMutableDictionary new];
    }
    if ([loadedControllers objectForKey:viewControllerName]) {
        viewController = [loadedControllers objectForKey:viewControllerName];
    } else {
        viewController = [[NSClassFromString(viewControllerName) alloc] init];
        [loadedControllers setObject:viewController forKey:viewControllerName];
        [[self mainWindow] addSubview:viewController.view];
    }
    if (viewController == nil) {
        NSString *message = [NSString stringWithFormat:@"Controller %@ can't found", viewControllerName];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alertView show];
    }
    return viewController;
}

+ (UIWindow *) mainWindow
{
    return [[[UIApplication sharedApplication] delegate] window];
}

@end
