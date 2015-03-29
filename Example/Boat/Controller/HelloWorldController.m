#import "HelloWorldController.h"
#import "HelloWorldView.h"

@interface HelloWorldController ()

@property (nonatomic) HelloWorldView *view;

@end

@implementation HelloWorldController

- (id)init
{
    if (self) {
        self.view = [[HelloWorldView alloc] initWithFrame:[[UIScreen mainScreen] bounds] controller:self];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) layoutName
{
    return @"Application";
}

- (BOOL) beforeFilter
{
    if ([self.params objectForKey:@"back"]) { return false; }
    return true;
}

- (void) doAction
{
}
@end

