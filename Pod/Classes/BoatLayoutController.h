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

@protocol BoatLayoutControllerProtocol

- (CGRect) contentRect;

@end

@interface BoatLayoutController : BoatViewController<BoatLayoutControllerProtocol>

@property (nonatomic, assign) UIView *viewContent;

-(void)switchToView:(UIView *)contentView animation:(NSString *)animation;

@end
