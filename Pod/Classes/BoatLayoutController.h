//
//  LayoutController.h
//  Pods
//
//  Created by bin on 18/10/14.
//
//

#import <UIKit/UIKit.h>
#import "BoatViewController.h"
#import "BoatControllerProtocol.h"

@interface BoatLayoutController : BoatViewController<BoatControllerProtocol>

@property (nonatomic, assign) UIView *viewContent;

-(void)switchToView:(UIView *)contentView;

@end
