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
#import "UIImage+animatedGIF.h"

#define alert(...) UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"信息" message:__VA_ARGS__ delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]; [alertView show];

@interface Drawer()

@property (nonatomic) NSMutableDictionary *cachedDomAttributes;

@end

@implementation Drawer

@synthesize styleParser, view;

- (id) initWithStyleFile:(NSString *)cssFile view:(UIView *)v;
{
    view = v;
    styleParser = [[StyleParser alloc] initWithStyleFile:cssFile];
    _cachedDomAttributes = [NSMutableDictionary new];
    return self;
}

- (CGRect) rectFor:(NSString *)uid {
    return [styleParser rectFor:uid];
}

- (CGRect) rectForText:(NSString *)text css:(NSString *)uid {
    return [styleParser rectForText:text uid:uid];
};

- (CGRect) drawRect:(NSString *)uid options:(NSDictionary *)options {
    CGRect rect = [styleParser rectFor:uid];
    if ([options objectForKey:@"offsetX"]) rect.origin.x += [[options objectForKey:@"offsetX"] floatValue];
    if ([options objectForKey:@"offsetY"]) rect.origin.y += [[options objectForKey:@"offsetY"] floatValue];
    if ([options objectForKey:@"offsetWidth"]) rect.size.width += [[options objectForKey:@"offsetWidth"] floatValue];
    if ([options objectForKey:@"offsetHeight"]) rect.size.height += [[options objectForKey:@"offsetHeight"] floatValue];
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

- (CGRect) drawRect:(NSString *)uid
{
    return [self drawRect:uid options:@{}];
}

- (CGRect) drawText:(NSString *)text css:(NSString *)uid options:(NSDictionary *)options {
    if ([text isEqual:[NSNull null]]) {
        text = @"";
    }
    
    CGRect rect = [styleParser rectForText:text uid:uid];
    if ([options objectForKey:@"offsetX"]) rect.origin.x += [[options objectForKey:@"offsetX"] floatValue];
    if ([options objectForKey:@"offsetY"]) rect.origin.y += [[options objectForKey:@"offsetY"] floatValue];
    if ([options objectForKey:@"offsetWidth"]) rect.size.width += [[options objectForKey:@"offsetWidth"] floatValue];
    if ([options objectForKey:@"offsetHeight"]) rect.size.height += [[options objectForKey:@"offsetHeight"] floatValue];
    UIFont *font = [styleParser fontFor:uid];
    UIColor *color = [styleParser colorFor:uid];
    [color set];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: color,
                                 NSParagraphStyleAttributeName: paragraphStyle };
    if ([styleParser valueFor:uid attr:@"background-color"]) {
        CGFloat textWidth = [styleParser widthForTextWithHeight:text uid:uid height:rect.size.height];
        CGFloat textHeight = [styleParser heightForTextWithWidth:text uid:uid width:rect.size.width];
        CGRect backgroundRect = CGRectMake(rect.origin.x, rect.origin.y, textWidth, textHeight);
        backgroundRect = [styleParser addPadding:backgroundRect uid:uid];
        [self drawFillRect:backgroundRect radius:4 color:[styleParser backgroundColorFor:uid]];
        [text drawInRect:rect withAttributes:attributes];
        return backgroundRect;
    } else {
        [text drawInRect:rect withAttributes:attributes];
        return rect;
    }
}

- (NSDictionary *) cachedDrawTextAttrs:(NSString *)text uid:(NSString *)uid
{
    if ([_cachedDomAttributes objectForKey:uid]) {
        return [_cachedDomAttributes objectForKey:uid];
    } else {
        NSLog(@"Boat: [Drawder] calculating %@", uid);
        UIFont *font = [styleParser fontFor:uid];
        UIColor *color = [styleParser colorFor:uid];
        NSDictionary *attrs = [NSDictionary new];
        NSValue *rectValue = [NSValue valueWithCGRect:[styleParser rectForText:text uid:uid]];
        [attrs setValue:font forKey:@"font"];
        [attrs setValue:color forKey:@"color"];
        [attrs setValue:rectValue forKey:@"rect"];
        [_cachedDomAttributes setValue:attrs forKey:uid];
        return attrs;
    }
}

- (CGRect) drawText:(NSString *)text css:(NSString *)uid
{
    return [self drawText:text css:uid options:@{}];
}

- (CGRect) drawImage:(NSString *)imageName css:(NSString *)uid {
    if ([imageName hasPrefix:@"http"]) {
        NSLog(@"Boat: [Drawer] Doesn't support draw remote image");
        return CGRectMake(0, 0, 0, 0);
    }
    return [self drawImage:imageName placeholderImage:nil css:uid];
}

- (CGRect) drawImage:(NSString *)imageName placeholderImage:(NSString *)placeholderImageName css:(NSString *)uid
{
    if([imageName isEqual:[NSNull null]]) return CGRectMake(0, 0, 0, 0);
    NSDictionary *attrs = [self cachedDrawImage:imageName placeholdrImage:placeholderImageName css:uid];
    UIImageView *imgView = [attrs objectForKey:@"imageView"];
    CGRect rect = [(NSValue*)[attrs objectForKey:@"rect"] CGRectValue];
    [imgView.image drawInRect:rect];
    return rect;
}

- (NSDictionary *)cachedDrawImage:(NSString *)imageName placeholdrImage:(NSString *)placeholdrImageName css:(NSString *)uid
{
    NSString *key = [NSString stringWithFormat:@"%@-%@-%@", imageName, placeholdrImageName, uid];
    if ([_cachedDomAttributes objectForKey:key]) {
        return [_cachedDomAttributes objectForKey:key];
    } else {
        NSLog(@"Drawing ------ %@", uid);
        UIImageView *imgView = [self genImageView:imageName placeholderImage:placeholdrImageName css:uid];
        NSMutableDictionary *attrs = [NSMutableDictionary new];
        [attrs setObject:imgView forKey:@"imageView"];
        NSValue *rectValue = [NSValue valueWithCGRect:[styleParser rectFor:uid]];
        [attrs setObject:rectValue forKey:@"rect"];
        [_cachedDomAttributes setObject:attrs forKey:key];
        return attrs;
    }
}

- (UIImage*) genImage:(NSString *)imageName placeholderImage:(NSString *)placeholderImageName css:(NSString *)uid
{
    CGRect rect = [styleParser rectFor:uid];
    UIImage *img;
    if ([imageName hasPrefix:@"http"]) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:placeholderImageName]];
        img = [UIImage imageWithCGImage:imgView.image.CGImage];
    } else {
        NSArray *fileAttrs = [imageName componentsSeparatedByString:@"."];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileAttrs objectAtIndex:0] ofType:[fileAttrs objectAtIndex:1]];
        if ([imageName hasSuffix:@".gif"]) {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            img = [UIImage animatedImageWithAnimatedGIFData:data];
        } else {
            img = [UIImage imageWithContentsOfFile:filePath];
        }
    }
    return img;
}

- (UIImageView*) genImageView:(NSString *)imageName placeholderImage:(NSString *)placeholderImageName css:(NSString *)uid {
    CGRect rect = [styleParser rectFor:uid];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    if ([imageName hasPrefix:@"http"]) {
        [imgView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:placeholderImageName]];
    } else {
        NSArray *fileAttrs = [imageName componentsSeparatedByString:@"."];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileAttrs objectAtIndex:0] ofType:[fileAttrs objectAtIndex:1]];
        if ([imageName hasSuffix:@".gif"]) {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            imgView.image = [UIImage animatedImageWithAnimatedGIFData:data];
        } else {
            imgView.image = [UIImage imageWithContentsOfFile:filePath];
        }
    }
    return imgView;
};


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

// HELPER

- (void) drawFillRect:(CGRect)rect radius:(int)radius color:(UIColor *)color
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    CGContextSetFillColorWithColor(context, color.CGColor);
    [bezierPath fill];
}
@end