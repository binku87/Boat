//
//  LayoutController.m
//  Pods
//
//  Created by bin on 18/10/14.
//
//

#import "BoatLayoutController.h"

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
        if(v.tag == contentView.tag) {
            hasThisView = YES;
            break;
        }
    }
    if (hasThisView) {
        [self.view bringSubviewToFront:contentView];
    } else {
        [self.view addSubview:contentView];
    }
}

@end
