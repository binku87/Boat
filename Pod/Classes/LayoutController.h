//
//  LayoutController.h
//  Pods
//
//  Created by bin on 18/10/14.
//
//

#import <UIKit/UIKit.h>
#import "BoatViewController.h"

@interface LayoutController : BoatViewController

@property (nonatomic, assign) UIView *viewContent;

-(void)switchToView:(UIView *)contentView;

@end
