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
@property (nonatomic) NSMutableDictionary *touchedColorRects;

- (void) reset;
- (id) initWithStyleFile:(NSString *)cssFile view:(UIView *)v;
- (CGRect) rectFor:(NSString *)uid;
- (CGRect) drawRect:(NSString *)uid options:(NSDictionary *)options;
- (CGRect) drawRect:(NSString *)uid;
- (CGRect) drawText:(NSString *)text css:(NSString *)uid options:(NSDictionary *)option;
- (CGRect) drawText:(NSString *)text css:(NSString *)uid;
- (CGRect) drawImage:(NSString *)imageName css:(NSString *)uid options:(NSDictionary *)options;
- (CGRect) drawImage:(NSString *)imageName placeholderImage:(NSString *)placeholderImageName css:(NSString *)uid options:(NSDictionary *)options;
- (CGRect) drawImageWithImage:(UIImage *)image css:(NSString *)uid options:(NSDictionary *)options;
- (void) updateImageView:(UIImageView*)imageView imageName:(NSString *)imageName placeholderImage:(NSString *)placeholderImageName options:(NSDictionary *)options;
- (UIImageView *) addImageView:(NSString *)uid options:(NSDictionary *)options;
- (UIImageView *) createImageView:(NSString *)uid options:(NSDictionary *)options;
- (UIImageView *) createImageView:(NSString *)imageName placeholderImage:(NSString *)placeholderImageName  css:(NSString *)uid options:(NSDictionary *)options;
- (UITextField*) addTextInput:(NSString *)placeholder css:(NSString *)uid;
- (UITextField*) addTextInput:(NSString *)placeholder delegate:(id)delegate css:(NSString *)uid;
- (UITableView*) addTableView:(id)delegate uid:(NSString *)uid;
- (UIWebView *) addWebView:(id)delegate uid:(NSString *)uid;
- (UISwitch *) addSwitchView:(NSString *)uid;
- (UITextField*) genTextInput:(NSString *)placeholder css:(NSString *)uid;
- (CGRect) rectForText:(NSString *)text css:(NSString *)uid options:(NSDictionary *)options;
- (UIImage *) getStaticImage:(NSString *)imageName;

@end
