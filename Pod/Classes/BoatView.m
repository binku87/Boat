//
//  BoatView.m
//  Pods
//
//  Created by bin on 30/12/14.
//
//

#import "BoatView.h"
#import "Router.h"

@interface BoatView()

@property (nonatomic) NSMutableArray *touchedViews;
@property (nonatomic) CGPoint btPanStartPoint;
@property (nonatomic) NSString *btPanBackControllerName;
@property (nonatomic) NSDictionary *btPanBackParams;
@property (nonatomic) BoatView *btPanBackView;

@end

@implementation BoatView

@synthesize controller, btDrawer;

- (id) initWithFrame:(CGRect)frame controller:(id)ctrl
{
    self.controller = ctrl;
    self = [super initWithFrame:frame];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return self;
}

- (id) initWithFrame:(CGRect)frame styleFile:(NSString *)styleFile controller:(id)ctrl
{
    self.controller = ctrl;
    self = [self initWithFrame:frame styleFile:styleFile];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return self;
}

- (id) initWithFrame:(CGRect)frame styleFile:(NSString *)styleFile
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    btDrawer = [[Drawer alloc] initWithStyleFile:styleFile view:self];
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [btDrawer reset];
}

- (void)panBackTo:(NSString*)controllerName params:(NSDictionary*)params
{
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(btHandlePanGesture:)];
    _btPanBackControllerName = controllerName;
    _btPanBackParams = params;
    [self addGestureRecognizer:panGesture];
}

-(void)btHandlePanGesture:(UIGestureRecognizer*)sender
{
    CGPoint translation = [sender locationInView:self];
    float offsetX = translation.x - _btPanStartPoint.x;
    if(sender.state == UIGestureRecognizerStateBegan) {
        _btPanStartPoint = translation;
        _btPanBackView = (BoatView*)[[Router controllerByName:_btPanBackControllerName] view];
        [_btPanBackView offsetFrame:-50 y:0 width:0 height:0];
        [[self superview] insertSubview:_btPanBackView belowSubview:self];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        float winWidth = [[UIScreen mainScreen] bounds].size.width;
        if (self.frame.origin.x > winWidth * 0.3) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                CGRect offsetFrame = self.frame;
                offsetFrame.origin.x = winWidth;
                self.frame = offsetFrame;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                [Router redirectTo:_btPanBackControllerName params:_btPanBackParams];
            }];
            
            [_btPanBackView offsetFrame:-_btPanBackView.frame.origin.x y:0 width:0 height:0 animationDuration:0.3];
        } else {
            [self offsetFrame:-self.frame.origin.x y:0 width:0 height:0 animationDuration:0.3];
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                CGRect offsetFrame = _btPanBackView.frame;
                offsetFrame.origin.x = -50;
                _btPanBackView.frame = offsetFrame;
            } completion:^(BOOL finished) {
                CGRect offsetFrame = _btPanBackView.frame;
                offsetFrame.origin.x = 0;
                _btPanBackView.frame = offsetFrame;
                [_btPanBackView removeFromSuperview];
            }];
        }
    } else {
        [self offsetFrame:offsetX y:0 width:0 height:0];
        [_btPanBackView offsetFrame:(50 * offsetX / self.frame.size.width) y:0 width:0 height:0];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = event.allTouches.anyObject;
    CGPoint point = [touch locationInView:self];
    _touchedViews = [NSMutableArray new];
    for (NSString *uid in btDrawer.touchedColorRects.allKeys) {
        CGRect rect = [[btDrawer.touchedColorRects objectForKey:uid] CGRectValue];
        if (CGRectContainsPoint(rect, point)) {
            UIView *touchedView = [[UIView alloc] initWithFrame:rect];
            touchedView.backgroundColor = [self.btDrawer.styleParser touchedColorFor:uid];
            [_touchedViews addObject:touchedView];
            [self addSubview:touchedView];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    for (UIView *touchView in _touchedViews) {
        [touchView removeFromSuperview];
    }
}

-(void)offsetFrame:(float)x y:(float)y width:(float)width height:(float)height
{
    [self offsetFrame:x y:y width:width height:height animationDuration:0];
}

-(void)offsetFrame:(float)x y:(float)y width:(float)width height:(float)height animationDuration:(float)duration
{
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect offsetFrame = self.frame;
        offsetFrame.origin.x += x;
        offsetFrame.origin.y += y;
        offsetFrame.size.width += width;
        offsetFrame.size.height += height;
        self.frame = offsetFrame;
    } completion:nil];
}
@end