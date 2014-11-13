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
#import "UIImageView+WebCache.h"

@implementation Drawer

@synthesize styleParser;

- (id) initWithStyleFile:(NSString *)cssFile
{
    styleParser = [[StyleParser alloc] initWithStyleFile:cssFile];
    return self;
}

- (CGRect) drawRect:(NSString *)uid
{
    CGRect rect = [styleParser rectFor:uid];
    UIColor *color = [styleParser colorFor:uid];
    CGContextRef context = UIGraphicsGetCurrentContext();
    if ([[styleParser valueFor:uid attr:@"fill"] isEqualToString:@"0"]) {
        NSString *radius = [styleParser valueFor:uid attr:@"radius"];
        if (radius == nil) {
            radius = @"2";
        }
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:[radius intValue]];
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        [bezierPath stroke];
    } else {
        const CGFloat* colors = CGColorGetComponents(color.CGColor);
        CGContextSetRGBFillColor(context, colors[0], colors[1], colors[2], 1.0);
        CGContextFillRect(context, rect);
    }
    return rect;
}

- (CGRect) drawText:(NSString *)text css:(NSString *)uid
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
    return rect;
}

- (CGRect) drawImage:(NSString *)fileName css:(NSString *)uid
{
    CGRect rect = [styleParser rectFor:uid];
    NSArray *fileAttrs = [fileName componentsSeparatedByString:@"."];
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[fileAttrs objectAtIndex:0] ofType:[fileAttrs objectAtIndex:1]]];
    [img drawInRect:rect];
    return rect;
}

- (UIImageView*) genRemoteImage:(NSString *)url placeholderImage:(NSString *)placeholderImageName css:(NSString *)uid
{
    CGRect rect = [styleParser rectFor:uid];
    UIImageView *img = [[UIImageView alloc] initWithFrame:rect];
    [img sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:placeholderImageName]];
    return img;
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
