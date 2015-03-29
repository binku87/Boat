//
//  BoatView.h
//  Pods
//
//  Created by bin on 30/12/14.
//
//

#import <UIKit/UIKit.h>
#import "Drawer.h"

@interface BoatView : UIView

@property (nonatomic) id controller;
@property (nonatomic) Drawer *btDrawer;

- (id) initWithFrame:(CGRect)frame styleFile:(NSString *)styleFile;
- (id) initWithFrame:(CGRect)frame styleFile:(NSString *)styleFile controller:(id)ctrl;
- (id) initWithFrame:(CGRect)frame controller:(id)ctrl;
- (void)panBackTo:(NSString*)controllerName params:(NSDictionary*)params;
-(void)offsetFrame:(float)x y:(float)y width:(float)width height:(float)height;
-(void)offsetFrame:(float)x y:(float)y width:(float)width height:(float)height animationDuration:(float)duration;

@end
