//
//  BoatViewController.m
//  Pods
//
//  Created by bin on 19/10/14.
//
//

#import "BoatViewController.h"

@interface BoatViewController ()

@end

@implementation BoatViewController

@synthesize params;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) layoutName {
    return @"";
}

- (void) doAction {
}

- (NSDictionary *) layoutExtraParams {
    return @{};
}

- (BOOL) beforeFilter
{
    return true;
}
@end
