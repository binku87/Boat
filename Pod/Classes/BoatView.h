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

@property (nonatomic) Drawer *btDrawer;

- (id) initWithFrame:(CGRect)frame styleFile:(NSString *)styleFile;

@end
