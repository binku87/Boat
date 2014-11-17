//
//  ActiveRecord.h
//  Pods
//
//  Created by bin on 17/11/14.
//
//

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"

@interface ActiveRecord : NSObject

@property (nonatomic) NSInteger id;

+ (void) createAndMigrateDB:(NSString *)_databaseName;
+ (id) firstBy:(NSString *)condition;
+ (id) first;
+ (NSArray *) where:(NSString *)condition;
+ (NSArray *) where:(NSString *)condition order:(NSString *)order;
+ (NSArray *) where:(NSString *)condition order:(NSString *)order offset:(NSInteger)offset limit:(NSInteger)limit;
- (BOOL) destroy;
- (BOOL) save;

@end
