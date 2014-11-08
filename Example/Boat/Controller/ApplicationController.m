//
//  ApplicationController.m
//  Boat
//
//  Created by bin on 19/10/14.
//  Copyright (c) 2014 binku. All rights reserved.
//

#import "ApplicationController.h"

#define WIN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define WIN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface ApplicationController ()

@end

@implementation ApplicationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGRect)contentRect {
    return CGRectMake(0, WIN_HEIGHT * 0.1, [[UIScreen mainScreen] bounds].size.width, WIN_HEIGHT - WIN_HEIGHT * 0.1 - 40);
}
@end
