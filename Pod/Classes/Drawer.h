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

- (id) initWithStyleFile:(NSString *)cssFile;
- (CGRect) drawRect:(NSString *)uid;
- (CGRect) drawText:(NSString *)text css:(NSString *)uid;
- (CGRect) drawImage:(NSString *)fileName css:(NSString *)uid;
- (UIImageView*) genRemoteImage:(NSString *)url placeholderImage:(NSString *)placeholderImageName css:(NSString *)uid;
- (UITextField*) genTextInput:(NSString *)placeholder css:(NSString *)uid;
- (ImageButton*) genImageButton:(NSString *)fileName css:(NSString *)uid;

@end
