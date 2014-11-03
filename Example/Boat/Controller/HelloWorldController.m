#import "HelloWorldController.h"
#import "HelloWorldView.h"

@interface HelloWorldController ()

@property (nonatomic) HelloWorldView *viewHelloWord;

@end

@implementation HelloWorldController

- (id)init
{
    if (self) {
        self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.viewHelloWord = [[HelloWorldView alloc] initWithFrame:self.view.frame];
        self.viewHelloWord.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.viewHelloWord];
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

- (void) refreshView:(NSDictionary *)params
{
}

@end

