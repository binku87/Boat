//
//  BoatView.m
//  Pods
//
//  Created by bin on 30/12/14.
//
//

#import "BoatView.h"

@implementation BoatView

@synthesize btDrawer;

- (id) initWithFrame:(CGRect)frame styleFile:(NSString *)styleFile
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    btDrawer = [[Drawer alloc] initWithStyleFile:styleFile view:self];
    return self;
}

@end
