//
//  ImageButton.h
//  Pods
//
//  Created by bin on 11/10/14.
//
//

#import <UIKit/UIKit.h>

@interface ImageButton : UIButton

- (id)initWithFrame:(CGRect)frame imageNamed:(NSString *)imageNamed;
- (void)changeImage:(NSString *)imageNamed;

@end
