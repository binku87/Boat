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

- (void) reset:(NSDictionary *)options;
- (id) initWithStyleFile:(NSString *)cssFile options:(NSDictionary *)options;
- (id) valueFor:(NSString *)uid attr:(NSString *)attr;
- (CGRect) rectForText:(NSString *)text uid:(NSString *)uid;
- (UIFont *) fontFor:(NSString *)uid;
- (UIColor *) colorFor:(NSString *)uid;
- (CGRect) paddingFor:(NSString *)uid;
- (CGRect) addPadding:(CGRect)originalRect uid:(NSString *)uid;
- (UIColor *) backgroundColorFor:(NSString *)uid;
- (CGFloat) winWidth;
- (CGFloat) winHeight;
- (CGFloat) calVal:(NSString *)attrVal width:(CGFloat)width height:(CGFloat)height;
- (CGRect) rectFor:(NSString *)uid;
- (void) saveCalRectFor:(NSString *)uid rect:(CGRect)rect;
- (CGFloat) widthForTextWithHeight:(NSString *)text uid:(NSString *)uid height:(CGFloat)height;
- (CGFloat) heightForTextWithWidth:(NSString *)text uid:(NSString *)uid width:(CGFloat)width;

@end
