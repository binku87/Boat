//
//  Drawer.h
//  Pods
//
//  Created by bin on 11/10/14.
//
//

#import <Foundation/Foundation.h>
#import "ImageButton.h"
#import "StyleParser.h"

@interface Drawer : NSObject

@property (nonatomic, retain) StyleParser *styleParser;
@property (nonatomic, retain) UIView *view;

- (id) initWithStyleFile:(NSString *)cssFile view:(UIView *)v;
- (CGRect) rectFor:(NSString *)uid;
- (CGRect) drawRect:(NSString *)uid options:(NSDictionary *)options;
- (CGRect) drawRect:(NSString *)uid;
- (CGRect) drawText:(NSString *)text css:(NSString *)uid options:(NSDictionary *)option;
- (CGRect) drawText:(NSString *)text css:(NSString *)uid;
- (CGRect) drawImage:(NSString *)imageName css:(NSString *)uid;
- (CGRect) drawImage:(NSString *)imageName placeholderImage:(NSString *)placeholderImageName css:(NSString *)uid;
- (UIImage*) genImage:(NSString *)imageName placeholderImage:(NSString *)placeholderImageName css:(NSString *)uid;
- (UIImageView*) genImageView:(NSString *)imageName placeholderImage:(NSString *)placeholderImageName css:(NSString *)uid;
- (UITextField*) genTextInput:(NSString *)placeholder css:(NSString *)uid;
- (ImageButton*) genImageButton:(NSString *)fileName css:(NSString *)uid;
- (CGRect) rectForText:(NSString *)text css:(NSString *)uid;

@end
