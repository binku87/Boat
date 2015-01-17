//
//  StyleParser.m
//  Tmeiju
//
//  Created by bin on 7/10/14.
//  Copyright (c) 2014 bin. All rights reserved.
//

#import "StyleParser.h"
#define alert(...) UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"信息" message:__VA_ARGS__ delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]; [alertView show];
#define isEmpty(...) ([__VA_ARGS__ isEqual:[NSNull null]] || [__VA_ARGS__ isEqual:@""])
#define V(X, Y) (X == nil || [X objectForKey:Y] == [NSNull null] ? @"" : ([[X objectForKey:Y] isKindOfClass:[NSNumber class]] ? [[X objectForKey:Y] stringValue] : [X objectForKey:Y]))

@interface StyleParser()

@property(nonatomic) NSString *cssFile;
@property(nonatomic) NSDictionary *options;

@end

@implementation StyleParser

@synthesize domMap;

- (id) initWithStyleFile:(NSString *)cssFile options:(NSDictionary *)options
{
    [self initDomMap:cssFile];
    _cssFile = cssFile;
    _options = options;
    return self;
}

- (void) reset:(NSDictionary *)options
{
    _options = options;
    [domMap removeAllObjects];
    [self initDomMap:_cssFile];
}

- (id) valueFor:(NSString *)uid attr:(NSString *)attr
{
    if (isEmpty(uid)) {
        alert(@"uid Can't be blank");
        return nil;
    }
    NSMutableDictionary *dom = [self getCombineDom:uid];
    return [dom objectForKey:attr];
}

- (CGRect) rectFor:(NSString *)uid
{
    if (isEmpty(uid)) {
        alert(@"uid Can't be blank");
        return CGRectMake(0, 0, 0, 0);
    }
    NSMutableDictionary *dom = [self getCombineDom:uid];
    CGFloat startX = 0;
    CGFloat startY = 0;
    CGFloat width = [[dom objectForKey:@"width"] floatValue];
    CGFloat height = [[dom objectForKey:@"height"] floatValue];
    CGRect relativeDom;
    if ([StyleParser isCalculatedRect:dom]) {
        return CGRectMake([[dom objectForKey:@"left"] floatValue],
                          [[dom objectForKey:@"top"] floatValue],
                          [[dom objectForKey:@"width"] floatValue],
                          [[dom objectForKey:@"height"] floatValue]);
    }
    NSString *widthAttr = [dom objectForKey:@"width"];
    if (widthAttr) {
        width = [self calVal:widthAttr width:width height:height];
        [dom setObject:[NSString stringWithFormat:@"%f", width] forKey:@"width"];
    }
    NSString *heightAttr = [dom objectForKey:@"height"];
    if (heightAttr) {
        height = [self calVal:heightAttr width:width height:height];
        [dom setObject:[NSString stringWithFormat:@"%f", height] forKey:@"height"];
    }
    NSString *relative = [dom objectForKey:@"relative"];
    if (relative) {
        relativeDom = [self rectFor:relative];
        [dom setObject:@"1" forKey:@"isCalRelative"];
    }
    NSString *leftAttr = [dom objectForKey:@"left"];
    if (leftAttr) {
        startX = [self calVal:leftAttr width:width height:height];
        if (relative) {
            startX += relativeDom.origin.x;
        }
        [dom setObject:[NSString stringWithFormat:@"%f", startX] forKey:@"left"];
        [dom setObject:[NSString stringWithFormat:@"%f", startX + width] forKey:@"right"];
    }
    NSString *topAttr = [dom objectForKey:@"top"];
    if (topAttr) {
        startY = [self calVal:topAttr width:width height:height];
        if (relative) {
            startY += relativeDom.origin.y;
        }
        [dom setObject:[NSString stringWithFormat:@"%f", startY] forKey:@"top"];
        [dom setObject:[NSString stringWithFormat:@"%f", startY + height] forKey:@"bottom"];
    }
    CGRect rect = CGRectMake(startX, startY, width, height);
    rect = [self addPadding:rect uid:uid];
    //NSLog(@"Boat: [StyleParser] Rect %@ - (%f, %f, %f, %f)", uid, startX, startY, width, height);
    return rect;
}

- (CGRect) rectForText:(NSString *)text uid:(NSString *)uid
{
    if (isEmpty(uid)) {
        alert(@"uid Can't be blank");
        return CGRectMake(0, 0, 0, 0);
    }
    NSMutableDictionary *dom = [self getCombineDom:uid];
    if ([[dom objectForKey:@"width"] intValue] == 0 || [[dom objectForKey:@"height"] intValue] == 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: [self fontFor:uid],
                                     NSParagraphStyleAttributeName: paragraphStyle };
        CGFloat textMaxWidth = [self calVal:[dom objectForKey:@"width"] width:0 height:0];
        if(textMaxWidth == 0) textMaxWidth = self.winWidth;
        CGFloat textMaxHeight = [self calVal:[dom objectForKey:@"height"] width:0 height:0];
        if(textMaxHeight == 0) textMaxHeight = 1000;
        CGRect textSpace = [text boundingRectWithSize:CGSizeMake(textMaxWidth, textMaxHeight)
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:attributes
                                              context:nil];
        if (![dom objectForKey:@"width"] || [[dom objectForKey:@"width"] isEqualToString:@"0.000000"]) {
            [dom setObject:[NSString stringWithFormat:@"%f", textSpace.size.width] forKey:@"width"];
        }
        if (![dom objectForKey:@"height"] || [[dom objectForKey:@"height"] isEqualToString:@"0.000000"]) {
            [dom setObject:[NSString stringWithFormat:@"%f", textSpace.size.height] forKey:@"height"];
        }
    }
    [domMap setObject:dom forKey:uid];
    return [self rectFor:uid];
}

- (UIFont *) fontFor:(NSString *)uid
{
    if (isEmpty(uid)) {
        alert(@"uid Can't be blank");
        return nil;
    }
    NSMutableDictionary *dom = [self getCombineDom:uid];
    NSString *fontAttr = [dom objectForKey:@"font-size"];
    NSString *fontFamilyAttr = [dom objectForKey:@"font-family"];
    UIFont *font = [UIFont systemFontOfSize:20];
    if (!fontFamilyAttr) {
        fontFamilyAttr = @"Helvetica";
    }
    if (fontAttr) {
        font = [UIFont fontWithName:fontFamilyAttr size:[fontAttr intValue]];
    }
    if (!font) {
        alert(@"Font family doesn't exist");
    }
    return font;
}

- (UIColor *) colorFor:(NSString *)uid
{
    if (isEmpty(uid)) {
        alert(@"uid Can't be blank");
        return nil;
    }
    NSMutableDictionary *dom = [self getCombineDom:uid];
    NSString *colorAttr = [dom objectForKey:@"color"];
    UIColor *color = [UIColor grayColor];
    if (colorAttr) {
        colorAttr = [colorAttr stringByReplacingOccurrencesOfString:@"rgb(" withString:@""];
        colorAttr = [colorAttr stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSArray *rgb = [colorAttr componentsSeparatedByString:@","];
        float rVal = [(NSString *)[rgb objectAtIndex:0] floatValue];
        float gVal = [(NSString *)[rgb objectAtIndex:1] floatValue];
        float bVal = [(NSString *)[rgb objectAtIndex:2] floatValue];
        color = [UIColor colorWithRed:rVal/255.0f green:gVal/255.0f blue:bVal/255.0f alpha:1];
    }
    return color;
}

- (UIColor *) backgroundColorFor:(NSString *)uid
{
    if (isEmpty(uid)) {
        alert(@"uid Can't be blank");
        return nil;
    }
    NSMutableDictionary *dom = [self getCombineDom:uid];
    NSString *colorAttr = [dom objectForKey:@"background-color"];
    UIColor *color = [UIColor grayColor];
    if (colorAttr) {
        colorAttr = [colorAttr stringByReplacingOccurrencesOfString:@"rgb(" withString:@""];
        colorAttr = [colorAttr stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSArray *rgb = [colorAttr componentsSeparatedByString:@","];
        float rVal = [(NSString *)[rgb objectAtIndex:0] floatValue];
        float gVal = [(NSString *)[rgb objectAtIndex:1] floatValue];
        float bVal = [(NSString *)[rgb objectAtIndex:2] floatValue];
        color = [UIColor colorWithRed:rVal/255.0f green:gVal/255.0f blue:bVal/255.0f alpha:1];
    }
    return color;
}

- (CGRect) paddingFor:(NSString *)uid
{
    if (isEmpty(uid)) {
        alert(@"uid Can't be blank");
        return CGRectMake(0, 0, 0, 0);
    }
    CGRect rect = CGRectMake(0, 0, 0, 0);
    NSMutableDictionary *dom = [self getCombineDom:uid];
    NSString *paddingAttr = [dom objectForKey:@"padding"];
    if (paddingAttr) {
        NSArray *offsets = [paddingAttr componentsSeparatedByString:@" "];
        if([offsets count] != 4) {
            alert(@"Boat: [StyleParser] padding format is wrong!");
        }
        rect = CGRectMake([[offsets objectAtIndex:3] floatValue], [[offsets objectAtIndex:0] floatValue],
                          [[offsets objectAtIndex:1] floatValue], [[offsets objectAtIndex:2] floatValue]);
    }
    return rect;
}

- (CGRect) addPadding:(CGRect)originalRect uid:(NSString *)uid
{
    if ([uid isEqual:@"shoe_live_cell_content_right"]) {
        
    }
    CGRect paddingRect = [self paddingFor:uid];
    originalRect.origin.x -= paddingRect.origin.x;
    originalRect.origin.y -= paddingRect.origin.y;
    originalRect.size.width += paddingRect.size.width + paddingRect.origin.x;
    originalRect.size.height += paddingRect.size.height + paddingRect.origin.y;
    return originalRect;
}

// Helpers
- (CGFloat) winWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}

- (CGFloat) winHeight
{
    return [[UIScreen mainScreen] bounds].size.height;
}

- (CGFloat) calVal:(NSString *)_attrVal width:(CGFloat)width height:(CGFloat)height
{
    if(_attrVal == nil) return 0;
    NSString *attrVal = [_attrVal copy];
    for (NSString *uid in [domMap allKeys]) {
        if ([attrVal rangeOfString:[NSString stringWithFormat:@"%@.", uid] options:NSCaseInsensitiveSearch].location != NSNotFound) {
            CGRect rect = [self rectFor:uid];
            CGFloat uidWidth = rect.origin.x + rect.size.width;
            CGFloat uidHeight = rect.origin.y + rect.size.height;
            attrVal = [attrVal stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@.left", uid] withString:[NSString stringWithFormat:@"%f", rect.origin.x]];
            attrVal = [attrVal stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@.top", uid] withString:[NSString stringWithFormat:@"%f", rect.origin.y]];
            attrVal = [attrVal stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@.right", uid] withString:[NSString stringWithFormat:@"%f", uidWidth]];
            attrVal = [attrVal stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@.bottom", uid] withString:[NSString stringWithFormat:@"%f", uidHeight]];
            attrVal = [attrVal stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@.width", uid] withString:[NSString stringWithFormat:@"%f", rect.size.width]];
            attrVal = [attrVal stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@.height", uid] withString:[NSString stringWithFormat:@"%f", rect.size.height]];
        }
    }
    attrVal = [attrVal stringByReplacingOccurrencesOfString:@"win_width" withString:[NSString stringWithFormat:@"%f", [self winWidth]]];
    attrVal = [attrVal stringByReplacingOccurrencesOfString:@"win_height" withString:[NSString stringWithFormat:@"%f", [self winHeight]]];
    if ([_options objectForKey:@"content_width"]) {
        attrVal = [attrVal stringByReplacingOccurrencesOfString:@"content_width" withString:V(_options, @"content_width")];
    }
    if ([_options objectForKey:@"content_height"]) {
        attrVal = [attrVal stringByReplacingOccurrencesOfString:@"content_height" withString:V(_options, @"content_height")];
    }
    attrVal = [attrVal stringByReplacingOccurrencesOfString:@"width" withString:[NSString stringWithFormat:@"%f", width]];
    attrVal = [attrVal stringByReplacingOccurrencesOfString:@"height" withString:[NSString stringWithFormat:@"%f", height]];
    NSExpression *expression = [NSExpression expressionWithFormat:attrVal];
    @try {
        id result = [expression expressionValueWithObject:nil context:nil];
        return [result floatValue];
    }
    @catch (NSException *exception) {
        alert([NSString stringWithFormat:@"Boat: [StyleParser] Expression (%@) is invalid", expression]);
        return 0;
    }
}

- (void) saveCalRectFor:(NSString *)uid rect:(CGRect)rect
{
    NSMutableDictionary *dom = [domMap objectForKey:uid];
    if ([dom valueForKey:@"is_updated"] == NULL) {
        [dom setObject:[NSString stringWithFormat:@"%f", rect.origin.x] forKey:@"left"];
        [dom setObject:[NSString stringWithFormat:@"%f", rect.origin.y] forKey:@"top"];
        [dom setObject:[NSString stringWithFormat:@"%f", rect.origin.y + rect.size.height] forKey:@"bottom"];
        [dom setObject:[NSString stringWithFormat:@"%f", rect.size.width] forKey:@"width"];
        [dom setObject:[NSString stringWithFormat:@"%f", rect.size.height] forKey:@"height"];
        [dom setObject:[NSString stringWithFormat:@"%i", true] forKey:@"is_updated"];
    }
}

- (void) initDomMap:(NSString *)cssFile
{
    domMap = [[NSMutableDictionary alloc] init];
    @try {
        NSArray *fileAttrs = [cssFile componentsSeparatedByString:@"."];
        NSString *file = [[NSBundle mainBundle] pathForResource:[fileAttrs objectAtIndex:0] ofType:[fileAttrs objectAtIndex:1]];
        NSString *fileContents = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
        NSArray *allLinedStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        if (allLinedStrings == nil) {
            NSString *message = [NSString stringWithFormat:@"Style file %@ doesn't exist", cssFile];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alertView show];
        }
        NSMutableDictionary *dom;
        for (NSString *line in allLinedStrings) {
            BOOL isCommentOrBlankLine = [line hasPrefix:@"//"] || [[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual:@""];
            if (!isCommentOrBlankLine) {
                NSString *formatedLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if ([formatedLine hasSuffix:@":"]) {
                    dom = [[NSMutableDictionary alloc] init];
                    NSString *uid = [formatedLine stringByReplacingOccurrencesOfString:@":" withString:@""];
                    [domMap setObject:dom forKey:uid];
                } else {
                    NSArray *keyVal = [formatedLine componentsSeparatedByString:@":"];
                    NSString *key = [[keyVal objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString *val = [[keyVal objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    val = [self preHandleForSpecialValue:dom attr:key value:val];
                    [dom setObject:val forKey:key];
                }
            }
        }
    }
    @catch (NSException *exception) {
        alert([NSString stringWithFormat:@"Boat: Parse css file %@ failure", cssFile]);
    }
}

- (NSString *) preHandleForSpecialValue:(NSDictionary *)currentDom attr:(NSString*)attr value:(NSString*)value {
    if ([attr isEqual:@"top"] && [value isEqual:@"middle"]) {
        if ([currentDom objectForKey:@"relative"]) {
            value = [NSString stringWithFormat:@"((%@.height - height) / 2)", [currentDom objectForKey:@"relative"]];
        } else {
            value = @"(win_height - height) / 2)";
        }
    }
    if ([attr isEqual:@"left"] && [value isEqual:@"center"]) {
        if ([currentDom objectForKey:@"relative"]) {
            value = [NSString stringWithFormat:@"((%@.width - width) / 2)", [currentDom objectForKey:@"relative"]];
        } else {
            value = @"(win_width - width) / 2)";
        }
    }
    return value;
}

- (NSMutableDictionary*) getCombineDom:(NSString *)uid {
    if ([domMap objectForKey:uid]) {
        return [domMap objectForKey:uid];
    }
    NSMutableDictionary *dom = [NSMutableDictionary new];
    for (NSString *_uid in [uid componentsSeparatedByString:@" "]) {
        [dom addEntriesFromDictionary:[domMap objectForKey:_uid]];
    };
    return dom;
}

+ (BOOL) isCalculatedRect:(NSDictionary *)dom {
    if ([dom objectForKey:@"relative"] && ![dom objectForKey:@"isCalRelative"]) {
        return NO;
    }
    if ([StyleParser isNumValue:[dom objectForKey:@"width"]] &&
        [StyleParser isNumValue:[dom objectForKey:@"height"]] &&
        [StyleParser isNumValue:[dom objectForKey:@"left"]] &&
        [StyleParser isNumValue:[dom objectForKey:@"top"]]) {
        return YES;
    }
    return NO;
}

+ (BOOL) isNumValue:(NSString *)value {
    
    NSPredicate *num = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]{0,10}.?[0-9]{0,10}$"];
    if ([num evaluateWithObject:value])
    {
        return YES;
    }
    return NO;
}

- (CGFloat) widthForTextWithHeight:(NSString *)text uid:(NSString *)uid height:(CGFloat)height
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    UIFont *font = [self fontFor:uid];
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName: paragraphStyle };
    CGRect textSpace = [text boundingRectWithSize:CGSizeMake(0, height)
                                          options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                       attributes:attributes
                                          context:nil];
    if (font.pointSize * 2 > height) {
        // Only have one line
        return textSpace.size.width;
    } else {
        // More than one line
        NSMutableDictionary *dom = [self getCombineDom:uid];
        return [[dom objectForKey:@"width"] floatValue];
    }
}

- (CGFloat) heightForTextWithWidth:(NSString *)text uid:(NSString *)uid width:(CGFloat)width
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: [self fontFor:uid],
                                 NSParagraphStyleAttributeName: paragraphStyle };
    CGRect textSpace = [text boundingRectWithSize:CGSizeMake(width, [self winHeight])
                                          options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                       attributes:attributes
                                          context:nil];
    return textSpace.size.height;
}
@end