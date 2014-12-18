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

#define alert(...) UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"信息" message:__VA_ARGS__ delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]; [alertView show];

static NSMutableDictionary *_loadedControllers = nil;
static NSString *_currentContentController = nil;

@implementation Router

+ (void) redirectTo:(NSString *)viewControllerName params:(NSDictionary *) params
{
    _currentContentController = viewControllerName;
    if (params == nil) {
        params = @{};
    }
    BoatLayoutController *layoutController;
    BoatViewController *contentController = [Router controllerByName:viewControllerName];
    NSString *layoutName = @"";
    if ([contentController respondsToSelector:@selector(layoutName)]) {
        layoutName = [contentController layoutName];
    }
    if ([layoutName isEqual:@""]) {
        [[self mainWindow] bringSubviewToFront:contentController.view];
        [contentController refreshView:params];
    } else {
        layoutController = (BoatLayoutController *)[Router controllerByName:layoutName];
        NSMutableDictionary *combineParams = [NSMutableDictionary dictionaryWithDictionary:params];
        [[self mainWindow] bringSubviewToFront:layoutController.view];
        [layoutController switchToView:contentController.view];
        if ([contentController respondsToSelector:@selector(refreshView:)]) {
            [contentController refreshView:combineParams];
        }
        [combineParams addEntriesFromDictionary:[contentController layoutExtraParams]];
        [layoutController refreshView:combineParams];
    }
}

+ (BoatViewController *) controllerByName:(NSString *) viewControllerName
{
    if (viewControllerName == nil || [viewControllerName isEqual:@""]) {
        alert(@"Router#redirectTo: controller can't be empty");
        return nil;
    }
    viewControllerName = [viewControllerName stringByAppendingString:@"Controller"];
    BoatViewController *viewController;
    if (_loadedControllers == nil) {
        _loadedControllers = [NSMutableDictionary new];
    }
    if ([_loadedControllers objectForKey:viewControllerName]) {
        viewController = [_loadedControllers objectForKey:viewControllerName];
    } else {
        viewController = [[NSClassFromString(viewControllerName) alloc] init];
        [_loadedControllers setObject:viewController forKey:viewControllerName];
        [[self mainWindow] addSubview:viewController.view];
    }
    if (viewController == nil) {
        NSString *message = [NSString stringWithFormat:@"Controller %@ can't found", viewControllerName];
        alert(message);
    }
    return viewController;
}

+ (NSString *)currentContentController
{
    return _currentContentController;
}

+ (UIWindow *) mainWindow
{
    return [[[UIApplication sharedApplication] delegate] window];
}

@end
