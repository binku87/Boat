//
//  BoatView.m
//  Pods
//
//  Created by bin on 30/12/14.
//
//

#import "BoatView.h"

@implementation BoatView

@synthesize controller, btDrawer;

- (id) initWithFrame:(CGRect)frame controller:(id)ctrl
{
    self.controller = ctrl;
    self = [super initWithFrame:frame];
    return self;
}

- (id) initWithFrame:(CGRect)frame styleFile:(NSString *)styleFile controller:(id)ctrl
{
    self.controller = ctrl;
    self = [self initWithFrame:frame styleFile:styleFile];
    return self;
}

- (id) initWithFrame:(CGRect)frame styleFile:(NSString *)styleFile
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    btDrawer = [[Drawer alloc] initWithStyleFile:styleFile view:self];
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [btDrawer reset];
}

@end
