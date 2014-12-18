//
//  APIClient.h
//  Tmeiju
//
//  Created by bin on 7/27/13.
//  Copyright (c) 2013 bin. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation+ResponseObject.h"
#import "AFHTTPClient+Synchronous.h"

@interface APIClient : AFHTTPClient

+ (APIClient *)sharedClient;
+ (void)login:(id)data success:(void (^)(id data))success failure:(void (^)(int error))failure;
+ (void)signUp:(NSDictionary *)data success:(void (^)(id data))success failure:(void (^)(int error))failure;
+ (void)logout:(void (^)(id data))success failure:(void (^)(int error))failure;
+ (void)getData:(NSString *)url params:(NSDictionary *)params success:(void (^)(id data))success failure:(void (^)(int error))failure;
+ (void)postData:(NSString *)url params:(NSDictionary *)params success:(void (^)(id data))success failure:(void (^)(int error))failure;
+ (void)putData:(NSString *)url params:(NSDictionary *)params success:(void (^)(id data))success failure:(void (^)(int error))failure;
+ (id) authentication;

@end
