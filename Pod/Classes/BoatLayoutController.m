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

-(void)switchToView:(UIView *)contentView {
    BOOL hasThisView = NO;
    for (UIView * v in [self.view subviews]) {
        if(v == contentView) {
            hasThisView = YES;
            break;
        } else {
            [v removeFromSuperview];
        }
    }
    if (hasThisView) {
        [self.view bringSubviewToFront:contentView];
    } else {
        contentView.frame = [self contentRect];
        [self.view addSubview:contentView];
    }
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.1;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    //[[contentView layer] addAnimation:animation forKey:@"animation"];
}

- (CGRect)contentRect {
    alert(@"WARNING: doesn't override layout's contentRect yet");
    return CGRectMake(0, 0, 0, 0);
}
@end