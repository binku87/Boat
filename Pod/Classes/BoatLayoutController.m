//
//  LayoutController.m
//  Pods
//
//  Created by bin on 18/10/14.
//
//

#import "BoatLayoutController.h"
#import "StyleParser.h"

#define alert(...) UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"信息" message:__VA_ARGS__ delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]; [alertView show];

@interface BoatLayoutController ()

@end

@implementation BoatLayoutController

@synthesize viewContent;

- (id) init {
    if (self) {
        NSString *controllerName = NSStringFromClass([self class]);
        controllerName = [controllerName stringByReplacingOccurrencesOfString:@"Controller" withString:@""];
        NSString *viewClassName = [NSString stringWithFormat:@"%@View", controllerName];
        self.view = [[NSClassFromString(viewClassName) alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchToView:(UIView *)contentView animation:(NSString *)animation {
    UIView *previousView;
    contentView.frame = [self contentRect];
    if ([[self.view subviews] count] > 0) {
        previousView = [[self.view subviews] objectAtIndex:0];
    }
    [self showView:contentView hideView:previousView withAnimation:animation];
}

- (CGRect)contentRect {
    alert(@"WARNING: doesn't override layout's contentRect yet");
    return CGRectMake(0, 0, 0, 0);
}

- (void) showView:(UIView *)contentView hideView:(UIView *)previousView withAnimation:(NSString *)animation
{
    float interval = 0.3;
    if (animation == nil) {
        [previousView removeFromSuperview];
        [self.view addSubview:contentView];
        return;
    }
    if ([animation isEqual: @"RightToLeft"]) {
        [UIView animateWithDuration:interval delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect frame = previousView.frame;
            frame.origin.x -= 50;
            previousView.frame = frame;
        } completion:^(BOOL finished) {
            [previousView removeFromSuperview];
        }];
        
        [self.view addSubview:contentView];
        CGRect originalFrame = contentView.frame;
        CGRect frame = contentView.frame;
        frame.origin.x += frame.size.width;
        contentView.frame = frame;
        [UIView animateWithDuration:interval delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            contentView.frame = originalFrame;
        } completion:^(BOOL finished) {
        }];
        return;
    }
    if ([animation isEqual: @"LeftToRight"]) {
        [UIView animateWithDuration:interval delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect frame = previousView.frame;
            frame.origin.x = frame.size.width;
            previousView.frame = frame;
        } completion:^(BOOL finished) {
            [previousView removeFromSuperview];
        }];
        
        CGRect originalFrame = contentView.frame;
        CGRect frame = contentView.frame;
        frame.origin.x -= 50;
        contentView.frame = frame;
        [self.view insertSubview:contentView belowSubview:previousView];
        [UIView animateWithDuration:interval delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            contentView.frame = originalFrame;
        } completion:^(BOOL finished) {
        }];
        return;
    }
}
@end