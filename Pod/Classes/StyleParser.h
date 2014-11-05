//
//  StyleParser.h
//  Tmeiju
//
//  Created by bin on 7/10/14.
//  Copyright (c) 2014 bin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StyleParser.h"

@interface StyleParser : NSObject

@property (nonatomic, retain) NSMutableDictionary *domMap;

- (id) initWithStyleFile:(NSString *)cssFile;
- (id) valueFor:(NSString *)uid attr:(NSString *)attr;
- (CGRect) rectForText:(NSString *)text uid:(NSString *)uid;
- (UIFont *) fontFor:(NSString *)uid;
- (UIColor *) colorFor:(NSString *)uid;
- (CGFloat) winWidth;
- (CGFloat) winHeight;
- (CGFloat) calVal:(NSString *)attrVal width:(CGFloat)width height:(CGFloat)height;
- (CGRect) rectFor:(NSString *)uid;
- (void) saveCalRectFor:(NSString *)uid rect:(CGRect)rect;

@end
