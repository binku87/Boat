//
//  ActiveRecord.m
//  Pods
//
//  Created by bin on 17/11/14.
//
//

#import "ActiveRecord.h"
#import "FMDatabase.h"
#import "FMDBMigrationManager.h"

#define alert(...) UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"信息" message:__VA_ARGS__ delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]; [alertView show];

static NSString *databaseName;

@implementation ActiveRecord

//[user delete];
//[User executeSQL:@""];

+ (void) createAndMigrateDB:(NSString *)_databaseName {
    databaseName = _databaseName;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:databaseName];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    FMDBMigrationManager *manager = [FMDBMigrationManager managerWithDatabaseAtPath:dbPath migrationsBundle:[NSBundle mainBundle]];
    NSError *error = nil;
    [manager createMigrationsTable:&error];
    [manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:&error];
}

+ (NSString *) tableName {
    alert(@"ActiveRecord: Should set table name");
    return @"";
}


+ (NSString *)getPrimaryKey {
    return @"id";
}

+ (NSString *) getTableName {
    return [self tableName];
}

+ (LKDBHelper *)getUsingLKDBHelper {
    static LKDBHelper *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:databaseName];
        db = [[LKDBHelper alloc]initWithDBPath:dbPath];
    });
    return db;
}

+ (NSArray *) where:(NSString *)condition {
    NSArray *result = [self.class searchWithWhere:condition orderBy:nil offset:0 count:1000000];
    return result;
};

+ (NSArray *) where:(NSString *)condition order:(NSString *)order{
    NSArray *result = [self.class searchWithWhere:condition orderBy:order offset:0 count:1000000];
    return result;
};

+ (NSArray *) where:(NSString *)condition order:(NSString *)order offset:(NSInteger)offset limit:(NSInteger)limit {
    NSArray *result = [self.class searchWithWhere:condition orderBy:order offset:offset count:limit];
    return result;
};

+ (id) first {
    NSArray *result = [self.class searchWithWhere:@"rowid >= 1" orderBy:@"rowid ASC" offset:0 count:1];
    if ([result count] == 0) {
        return nil;
    }
    ActiveRecord *record = [result objectAtIndex:0];
    record.rowid = record.id;
    return record;
}

+ (id) firstBy:(NSString *)condition {
    NSArray *result = [self.class searchWithWhere:condition orderBy:nil offset:0 count:1];
    if ([result count] == 0) {
        return nil;
    }
    ActiveRecord *record = [result objectAtIndex:0];
    record.rowid = record.id;
    return record;
};

- (BOOL) destroy {
    return [self.class deleteToDB:self];
}

- (BOOL) save {
    return [self saveToDB];
}
@end