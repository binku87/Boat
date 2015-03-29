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

@synthesize styleParser, view, touchedColorRects;

- (id) initWithStyleFile:(NSString *)cssFile view:(UIView *)v;
{
    view = v;
    styleParser = [[StyleParser alloc] initWithStyleFile:cssFile
                                                 options:@{
                                                           @"content_width" : [NSString stringWithFormat:@"%f", v.frame.size.width],
                                                           @"content_height" : [NSString stringWithFormat:@"%f", v.frame.size.height]
                                                        }];
    _cachedDomAttributes = [NSMutableDictionary new];
    touchedColorRects = [NSMutableDictionary new];
    return self;
}

- (void) reset
{
    touchedColorRects = [NSMutableDictionary new];
    [styleParser reset:@{ @"content_width" : [NSString stringWithFormat:@"%f", view.frame.size.width],
                          @"content_height" : [NSString stringWithFormat:@"%f", view.frame.size.height] }];
}

- (CGRect) rectFor:(NSString *)uid {
    return [styleParser rectFor:uid];
}

- (CGRect) rectForText:(NSString *)text css:(NSString *)uid options:(NSDictionary *)options{
    CGRect rect = [styleParser rectForText:text uid:uid];
    if (options) {
        rect = [self offsetRect:rect options:options];
    }
    return [styleParser addPadding:rect uid:uid];
};

- (CGRect) drawRect:(NSString *)uid options:(NSDictionary *)options {
    CGRect rect = [styleParser rectFor:uid];
    if (options) {
        rect = [self offsetRect:rect options:options];
    }
    UIColor *color = [styleParser colorFor:uid];
    CGFloat radius = [styleParser radiusFor:uid];

    if ([styleParser valueFor:uid attr:@"border-color"]) {
        UIColor *borderColor = [styleParser borderColorFor:uid];
        CGFloat borderWidth = [styleParser borderWidthFor:uid];
        [self drawFillRect:rect radius:radius color:borderColor];

        CGRect backgroundRect = rect;
        backgroundRect.origin.x += borderWidth;
        backgroundRect.origin.y += borderWidth;
        backgroundRect.size.width -= borderWidth * 2;
        backgroundRect.size.height -= borderWidth * 2;

        [self drawFillRect:backgroundRect radius:(radius) color:color];
    } else {
        [self drawFillRect:rect radius:radius color:color];
    }
    if ([styleParser valueFor:uid attr:@"touched-color"]) {
        [touchedColorRects setObject:[NSValue valueWithCGRect:rect] forKey:uid];
    }
    return rect;
}

- (CGRect) drawRect:(NSString *)uid
{
    return [self drawRect:uid options:@{}];
}

- (CGRect) drawText:(NSString *)text css:(NSString *)uid options:(NSDictionary *)options {
    if (text == nil || [text isEqual:[NSNull null]] ) {
        text = @"";
    }

    CGRect rect = [styleParser rectForText:text uid:uid];
    //[self drawFillRect:rect radius:0 color:[UIColor redColor]];
    rect = [self offsetRect:rect options:options];
    UIColor *color = [styleParser colorFor:uid];
    [color set];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: [styleParser fontFor:uid],
                                 NSForegroundColorAttributeName: color,
                                 NSParagraphStyleAttributeName: paragraphStyle };
    if ([styleParser valueFor:uid attr:@"background-color"]) {
        CGRect rectWithPadding = [self rectForText:text css:uid options:options];
        [self drawFillRect:rectWithPadding radius:4 color:[styleParser backgroundColorFor:uid]];
    }
    if ([styleParser valueFor:uid attr:@"padding"]) {
        CGRect padding = [styleParser paddingFor:uid];
        rect.origin.x += padding.origin.x;
        rect.origin.y += padding.origin.y;
    }
    [text drawInRect:rect withAttributes:attributes];
    return rect;
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

- (CGRect) drawImage:(NSString *)imageName css:(NSString *)uid options:(NSDictionary *)options{
    if (options == nil) { options = @{}; }
    if ([imageName hasPrefix:@"http"]) {
        NSLog(@"Boat: [Drawer] Doesn't support draw remote image");
        return CGRectMake(0, 0, 0, 0);
    }
    return [self drawImage:imageName placeholderImage:nil css:uid options:options];
}

- (CGRect) drawImageWithImage:(UIImage *)image css:(NSString *)uid options:(NSDictionary *)options{
    CGRect rect = [self.styleParser rectFor:uid];
    rect = [self offsetRect:rect options:options];
    [image drawInRect:rect];
    return rect;
}

- (CGRect) drawImage:(NSString *)imageName placeholderImage:(NSString *)placeholderImageName css:(NSString *)uid options:(NSDictionary *)options
{
    if (options == nil) { options = @{}; }
    if([imageName isEqual:[NSNull null]]) return CGRectMake(0, 0, 0, 0);
    NSDictionary *attrs = [self cachedDrawImage:imageName placeholdrImage:placeholderImageName css:uid options:options];
    UIImageView *imgView = [attrs objectForKey:@"imageView"];
    CGRect rect = [(NSValue*)[attrs objectForKey:@"rect"] CGRectValue];
    rect = [self offsetRect:rect options:options];
    [imgView.image drawInRect:rect];
    return rect;
}

- (NSDictionary *)cachedDrawImage:(NSString *)imageName placeholdrImage:(NSString *)placeholdrImageName css:(NSString *)uid options:(NSDictionary *)options
{
    NSString *key = [NSString stringWithFormat:@"%@-%@-%@", imageName, placeholdrImageName, uid];
    if (![options objectForKey:@"force"] && [_cachedDomAttributes objectForKey:key]) {
        return [_cachedDomAttributes objectForKey:key];
    } else {
        UIImageView *imgView = [self createImageView:imageName placeholderImage:placeholdrImageName css:uid options:nil];
        NSMutableDictionary *attrs = [NSMutableDictionary new];
        [attrs setObject:imgView forKey:@"imageView"];
        NSValue *rectValue = [NSValue valueWithCGRect:[styleParser rectFor:uid]];
        [attrs setObject:rectValue forKey:@"rect"];
        [_cachedDomAttributes setObject:attrs forKey:key];
        return attrs;
    }
}

- (UIImageView *) addImageView:(NSString *)uid options:(NSDictionary *)options
{
    UIImageView *imageView = [self createImageView:uid options:options];
    [self.view addSubview:imageView];
    return imageView;
}

- (UIImageView *) createImageView:(NSString *)uid options:(NSDictionary *)options
{
    if (options == nil) { options = @{}; }
    CGRect rect = [self offsetRect:[styleParser rectFor:uid] options:options];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    if ([styleParser valueFor:uid attr:@"radius"]) {
        [imgView.layer setMasksToBounds:YES];
        imgView.layer.cornerRadius = [[styleParser valueFor:uid attr:@"radius"] intValue];
    }
    return imgView;
}

- (UIImageView *) createImageView:(NSString *)imageName placeholderImage:(NSString *)placeholderImageName  css:(NSString *)uid options:(NSDictionary *)options
{
    if (options == nil) { options = @{}; }
    CGRect rect = [styleParser rectFor:uid];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    if ([imageName hasPrefix:@"http"]) {
        [imgView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:placeholderImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            imgView.alpha = 0.0;
            [UIView transitionWithView:imgView duration:3.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                imgView.alpha = 1.0;
            } completion:NULL];
        }];
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
}

- (UIImage *) getStaticImage:(NSString *)imageName
{
    UIImage *image;
    if ([imageName isEqual:@""] || imageName == nil) {
        imageName = @"default_90x70.png";
    }
    
    NSArray *fileAttrs = [imageName componentsSeparatedByString:@"."];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileAttrs objectAtIndex:0] ofType:[fileAttrs objectAtIndex:1]];
    if ([imageName hasSuffix:@".gif"]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        image = [UIImage animatedImageWithAnimatedGIFData:data];
    } else {
        image = [UIImage imageWithContentsOfFile:filePath];
    }
    return image;
}

- (void) updateImageView:(UIImageView*)imageView imageName:(NSString *)imageName placeholderImage:(NSString *)placeholderImageName options:(NSDictionary *)options
{
    UIImage *placeholderImage;
    if (placeholderImageName != nil) {
        placeholderImage = [UIImage imageNamed:placeholderImageName];
    }
    if (([imageName isEqual:@""] || imageName == nil) && ![placeholderImageName isEqual:@""]) {
        imageName = placeholderImageName;
    }
    if ([imageName hasPrefix:@"http"]) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            imageView.alpha = 0;
            [UIView transitionWithView:imageView duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                imageView.alpha = 1.0;
            } completion:NULL];
        }];
    } else {
        if ([imageName isEqual:@""]) return;
        NSArray *fileAttrs = [imageName componentsSeparatedByString:@"."];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileAttrs objectAtIndex:0] ofType:[fileAttrs objectAtIndex:1]];
        if ([imageName hasSuffix:@".gif"]) {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            imageView.image = [UIImage animatedImageWithAnimatedGIFData:data];
        } else {
            imageView.image = [UIImage imageWithContentsOfFile:filePath];
        }
    }
}

- (UITextField*) addTextInput:(NSString *)placeholder css:(NSString *)uid
{
    UITextField *textField = [[UITextField alloc] initWithFrame:[styleParser rectFor:uid]];
    textField.placeholder = placeholder;
    textField.font = [styleParser fontFor:uid];
    [view addSubview:textField];
    return textField;
}

- (UITextField*) addTextInput:(NSString *)placeholder delegate:(id)delegate css:(NSString *)uid
{
    UITextField *textField = [self addTextInput:placeholder css:uid];
    textField.delegate = delegate;
    return textField;
}

- (UITableView*) addTableView:(id)delegate uid:(NSString *)uid
{
    UITableView *tv = [[UITableView alloc] initWithFrame:[styleParser rectFor:uid]];
    tv.delegate = delegate;
    tv.dataSource = delegate;
    tv.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [view addSubview:tv];
    return tv;
}

- (UIWebView *) addWebView:(id)delegate uid:(NSString *)uid {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[styleParser rectFor:uid]];
    webView.scalesPageToFit = YES;
    webView.delegate = delegate;
    [view addSubview:webView];
    return webView;
}

- (UISwitch *) addSwitchView:(NSString *)uid {
    UISwitch *switchView = [[UISwitch alloc]initWithFrame:[styleParser rectFor:uid]];
    [view addSubview:switchView];
    return switchView;
}

- (UITextField*) genTextInput:(NSString *)placeholder css:(NSString *)uid
{
    UITextField *textUserName = [[UITextField alloc] initWithFrame:[styleParser rectFor:uid]];
    textUserName.placeholder = placeholder;
    textUserName.font = [styleParser fontFor:uid];
    return textUserName;
}

// HELPER
- (void) drawFillRect:(CGRect)rect radius:(int)radius color:(UIColor *)color
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    CGContextSetFillColorWithColor(context, color.CGColor);
    [bezierPath fill];
}

- (CGRect) offsetRect:(CGRect)rect options:(NSDictionary *)options
{
    if ([options objectForKey:@"x"]) rect.origin.x = [[options objectForKey:@"x"] floatValue];
    if ([options objectForKey:@"y"]) rect.origin.x = [[options objectForKey:@"y"] floatValue];
    if ([options objectForKey:@"width"]) rect.size.width = [[options objectForKey:@"width"] floatValue];
    if ([options objectForKey:@"height"]) rect.size.height = [[options objectForKey:@"height"] floatValue];
    if ([options objectForKey:@"offsetX"]) rect.origin.x += [[options objectForKey:@"offsetX"] floatValue];
    if ([options objectForKey:@"offsetY"]) rect.origin.y += [[options objectForKey:@"offsetY"] floatValue];
    if ([options objectForKey:@"offsetWidth"]) rect.size.width += [[options objectForKey:@"offsetWidth"] floatValue];
    if ([options objectForKey:@"offsetHeight"]) rect.size.height += [[options objectForKey:@"offsetHeight"] floatValue];
    return rect;
}
@end
