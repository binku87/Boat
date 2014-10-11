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
- (void) drawText:(NSString *)text css:(NSString *)uid;
- (void) drawImage:(NSString *)fileName css:(NSString *)uid;
- (UITextField*) genTextInput:(NSString *)placeholder css:(NSString *)uid;
- (ImageButton*) genImageButton:(NSString *)fileName css:(NSString *)uid;

@end
