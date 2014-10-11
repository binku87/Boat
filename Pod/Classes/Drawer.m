//
//  Drawer.m
//  Pods
//
//  Created by bin on 11/10/14.
//
//

#import "Drawer.h"
#import "StyleParser.h"
#import "ImageButton.h"

@implementation Drawer

@synthesize styleParser;

- (id) initWithStyleFile:(NSString *)cssFile
{
    styleParser = [[StyleParser alloc] initWithStyleFile:cssFile];
    return self;
}

- (void) drawText:(NSString *)text css:(NSString *)uid
{
    CGRect rect = [styleParser rectForText:text uid:uid];
    UIFont *font = [styleParser fontFor:uid];
    UIColor *color = [styleParser colorFor:uid];
    [color set];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: color,
                                 NSParagraphStyleAttributeName: paragraphStyle };
    [text drawInRect:rect withAttributes:attributes];
}

- (void) drawImage:(NSString *)fileName css:(NSString *)uid
{
    NSArray *fileAttrs = [fileName componentsSeparatedByString:@"."];
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[fileAttrs objectAtIndex:0] ofType:[fileAttrs objectAtIndex:1]]];
    [img drawInRect:[styleParser rectFor:uid]];
}

- (UITextField*) genTextInput:(NSString *)placeholder css:(NSString *)uid
{
    UITextField *textUserName = [[UITextField alloc] initWithFrame:[styleParser rectFor:uid]];
    textUserName.placeholder = placeholder;
    textUserName.font = [styleParser fontFor:uid];
    return textUserName;
}

- (ImageButton*) genImageButton:(NSString *)fileName css:(NSString *)uid
{
    NSArray *fileAttrs = [fileName componentsSeparatedByString:@"."];
    ImageButton *btnLogin = [[ImageButton alloc] initWithFrame:[styleParser rectFor:uid] imageNamed:[fileAttrs objectAtIndex:0]];
    return btnLogin;
}

@end
