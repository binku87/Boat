//
//  StyleParser.m
//  Tmeiju
//
//  Created by bin on 7/10/14.
//  Copyright (c) 2014 bin. All rights reserved.
//

#import "StyleParser.h"

@implementation StyleParser

@synthesize domMap;

- (id) initWithStyleFile:(NSString *)cssFile
{
    [self initDomMap:cssFile];
    return self;
}

- (id) valueFor:(NSString *)uid attr:(NSString *)attr
{
    NSMutableDictionary *dom = [domMap objectForKey:uid];
    return [dom objectForKey:attr];
}

- (CGRect) rectFor:(NSString *)uid
{
    CGFloat startX = 0;
    CGFloat startY = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    NSMutableDictionary *dom = [domMap objectForKey:uid];
    if ([[dom objectForKey:@"is_updated"] isEqual:@"1"]) {
        return CGRectMake([[dom objectForKey:@"left"] floatValue],
                          [[dom objectForKey:@"top"] floatValue],
                          [[dom objectForKey:@"width"] floatValue],
                          [[dom objectForKey:@"height"] floatValue]);
    }
    NSString *widthAttr = [dom objectForKey:@"width"];
    if (widthAttr) width = [self calVal:widthAttr width:width height:height];
    NSString *heightAttr = [dom objectForKey:@"height"];
    if (heightAttr) height = [self calVal:heightAttr width:width height:height];
    NSString *leftAttr = [dom objectForKey:@"left"];
    if (leftAttr) startX = [self calVal:leftAttr width:width height:height];
    NSString *topAttr = [dom objectForKey:@"top"];
    if (topAttr) startY = [self calVal:topAttr width:width height:height];
    NSString *relative = [dom objectForKey:@"relative"];
    if (relative) {
        CGRect relativeDom = [self rectFor:relative];
        startX += relativeDom.origin.x;
        startY += relativeDom.origin.y;
    }
    if ([uid isEqual:@"text_input_email_wrap"]) {
        
    }
    CGRect rect = CGRectMake(startX, startY, width, height);
    [self saveCalRect:dom rect:rect];
    NSLog(@"Boat: [StyleParser] Rect %@ - (%f, %f, %f, %f)", uid, startX, startY, width, height);
    return rect;
}

- (CGRect) rectForText:(NSString *)text uid:(NSString *)uid
{
    CGRect rect;
    NSMutableDictionary *dom = [domMap objectForKey:uid];
    if ([dom objectForKey:@"width"] == NULL || [dom objectForKey:@"height"] == NULL) {
        CGFloat startX = 0;
        CGFloat startY = 0;
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        NSDictionary *attributes = @{NSFontAttributeName: [self fontFor:uid],
                                     NSParagraphStyleAttributeName: paragraphStyle };
        CGRect textSpace = [text boundingRectWithSize:CGSizeMake(self.winWidth, 300)
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:attributes
                                              context:nil];
        NSString *leftAttr = [dom objectForKey:@"left"];
        if (leftAttr) startX += [self calVal:leftAttr width:textSpace.size.width height:textSpace.size.height];
        NSString *topAttr = [dom objectForKey:@"top"];
        if (topAttr) startY += [self calVal:topAttr width:textSpace.size.width height:textSpace.size.height];
        rect = CGRectMake(startX, startY, textSpace.size.width, textSpace.size.height);
        NSLog(@"Boat: [StyleParser] Rect %@ - (%f, %f, %f, %f)", uid, startX, startY, textSpace.size.width, textSpace.size.height);
        [self saveCalRect:dom rect:rect];
    } else {
        rect = [self rectFor:uid];
    }
    return rect;
}

- (UIFont *) fontFor:(NSString *)uid
{
    NSDictionary *dom = [domMap objectForKey:uid];
    NSString *fontAttr = [dom objectForKey:@"font-size"];
    UIFont *font = [UIFont systemFontOfSize:20];
    if (fontAttr) {
        font = [UIFont systemFontOfSize:[fontAttr intValue]];
    }
    return font;
}

- (UIColor *) colorFor:(NSString *)uid
{
    NSDictionary *dom = [domMap objectForKey:uid];
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

// Helpers
- (CGFloat) winWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}

- (CGFloat) winHeight
{
    return [[UIScreen mainScreen] bounds].size.height;
}

- (CGFloat) calVal:(NSString *)attrVal width:(CGFloat)width height:(CGFloat)height
{
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
    attrVal = [attrVal stringByReplacingOccurrencesOfString:@"width" withString:[NSString stringWithFormat:@"%f", width]];
    attrVal = [attrVal stringByReplacingOccurrencesOfString:@"height" withString:[NSString stringWithFormat:@"%f", height]];
    NSExpression *expression = [NSExpression expressionWithFormat:attrVal];
    NSLog(@"Boat: [StyleParser] %@", expression);
    id result = [expression expressionValueWithObject:nil context:nil];
    return [result floatValue];
}

- (void) saveCalRect:(NSMutableDictionary *)dom rect:(CGRect)rect
{
    if ([dom valueForKey:@"is_updated"] == NULL) {
        [dom setObject:[NSString stringWithFormat:@"%f", rect.origin.x] forKey:@"left"];
        [dom setObject:[NSString stringWithFormat:@"%f", rect.origin.y] forKey:@"top"];
        [dom setObject:[NSString stringWithFormat:@"%f", rect.size.width] forKey:@"width"];
        [dom setObject:[NSString stringWithFormat:@"%f", rect.size.height] forKey:@"height"];
        [dom setObject:[NSString stringWithFormat:@"%i", true] forKey:@"is_updated"];
    }
}

- (void) initDomMap:(NSString *)cssFile
{
    domMap = [[NSMutableDictionary alloc] init];
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
                [dom setObject:val forKey:key];
            }
        }
    }
}
@end