#import "HelloWorldController.h"
#import "HelloWorldView.h"

@interface HelloWorldController ()

@property (nonatomic) HelloWorldView *viewHelloWord;

@end

@implementation HelloWordController

- (id)init
{
    if (self) {
        self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.viewHelloWord = [[HelloWordView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:self.viewHelloWord];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

