//
//  ImageButton.m
//  Pods
//
//  Created by bin on 11/10/14.
//
//

#import "ImageButton.h"

@implementation ImageButton

- (id)initWithFrame:(CGRect)frame imageNamed:(NSString *)imageNamed
{
    self = [ImageButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        // Initialization code
        self.frame = frame;
        [self changeImage:imageNamed];
    }
    return self;
}

- (void)changeImage:(NSString *)imageNamed
{
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNamed ofType:@"png"]];
    UIImage *imgHL = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-hl", imageNamed] ofType:@"png"]];
    [self setImage:img forState:UIControlStateNormal];
    [self setImage:imgHL forState:UIControlStateHighlighted];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
