//
//  APIClient.m
//  Tmeiju
//
//  Created by bin on 7/27/13.
//  Copyright (c) 2013 bin. All rights reserved.
//

#import "APIClient.h"
#import "ActiveRecord.h"

#import "AFJSONRequestOperation.h"
#import "AFHTTPRequestOperation+ResponseObject.h"
#import "AFHTTPClient+Synchronous.h"

//#import "Route.h"
//#import "System.h"

#define API_SUCCESS 200
#define API_UNAUTHORIZED 401
#define API_FAILURE 500
#define AUTH_FAILURE @"Re-Authorization Required"
#define AUTH_REQUIRED @"Authorization Required"
#define INT_VAL(...) ((NSNumber *)__VA_ARGS__).intValue
#define alert(...) UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"信息" message:__VA_ARGS__ delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]; [alertView show];

//static NSString * const kAFAppDotNetAPIBaseURLString = @"http://192.168.0.101:3000";
//static NSString * const kAFAppDotNetAPIBaseURLString = @"http://localhost:3000";
static NSString * const kAFAppDotNetAPIBaseURLString = @"http://app.dunkhome.com";

@implementation APIClient

+ (void)login:(NSDictionary *)data success:(void (^)(id data))success failure:(void (^)(int error))failure
{
    [[APIClient sharedClient] postPath:@"users/sign_in" parameters:data success:^(AFHTTPRequestOperation *operation, id result) {
        if (INT_VAL([result objectForKey:@"status"]) == API_UNAUTHORIZED) {
            alert([result objectForKey:@"simple_message"]);
        } else if (INT_VAL([result objectForKey:@"status"]) == API_SUCCESS) {

        } else {
            alert(@"登陆失败，请重新登陆");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        alert(@"请重新尝试");
        if (failure) {
            failure(API_FAILURE);
        }
    }];
}

+ (void)signUp:(NSDictionary *)data success:(void (^)(id data))success failure:(void (^)(int error))failure
{
    [[APIClient sharedClient] postPath:@"/users.json" parameters:data success:^(AFHTTPRequestOperation *operation, id data) {
        if (INT_VAL([data objectForKey:@"status"]) == API_FAILURE) {
            alert([data objectForKey:@"simple_message"])
        } else {
            //[System setUserName:[data objectForKey:@"user[nick_name]"]];
            //[System setPassword:[data objectForKey:@"user[password]"]];
            //[Route goToResources];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        alert(@"请重新尝试");
        if (failure) {
            failure(API_FAILURE);
        }
    }];
}

+ (void)logout:(void (^)(id data))success failure:(void (^)(int error))failure
{
    /*[System setUserName:nil];
    [System setPassword:nil];*/
    [[APIClient sharedClient] getPath:@"users/sign_out" parameters:nil success:^(AFHTTPRequestOperation *operation, id result) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    success(@"");
}

+ (void)getData:(NSString *)url params:(NSDictionary *)params success:(void (^)(id data))success failure:(void (^)(int error))failure
{
    [[self sharedClient] getPath:url parameters:params success:^(AFHTTPRequestOperation *operation, id result) {
        [self handleResponse:result url:url method:@"Get" params:params success:success failure:failure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        alert(@"出现异常，请重新尝试");
        if (failure) {
            failure(API_FAILURE);
        }
    }];
}

+ (void)postData:(NSString *)url params:(NSDictionary *)params success:(void (^)(id data))success failure:(void (^)(int error))failure
{
    [[APIClient sharedClient] postPath:url parameters:params success:^(AFHTTPRequestOperation *operation, id result) {
        [APIClient handleResponse:result url:url method:@"Post" params:params success:success failure:failure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        alert(@"出现异常，请重新尝试");
        if (failure) {
            failure(API_FAILURE);
        }
    }];
}

+ (void)putData:(NSString *)url params:(NSDictionary *)params success:(void (^)(id data))success failure:(void (^)(int error))failure
{
    [[APIClient sharedClient] putPath:url parameters:params success:^(AFHTTPRequestOperation *operation, id result) {
        [APIClient handleResponse:result url:url method:@"Put" params:params success:success failure:failure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        alert(@"出现异常，请重新尝试");
        if (failure) {
            failure(API_FAILURE);
        }
    }];
}

/* ----------------- Helper -----------------------*/
+ (APIClient *)sharedClient {
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFAppDotNetAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    // By default, the example ships with SSL pinning enabled for the app.net API pinned against the public key of adn.cer file included with the example. In order to make it easier for developers who are new to AFNetworking, SSL pinning is automatically disabled if the base URL has been changed. This will allow developers to hack around with the example, without getting tripped up by SSL pinning.
    if ([[url scheme] isEqualToString:@"https"] && [[url host] isEqualToString:@"alpha-api.app.net"]) {
        self.defaultSSLPinningMode = AFSSLPinningModePublicKey;
    } else {
        self.defaultSSLPinningMode = AFSSLPinningModeNone;
    }
    
    return self;
}

+ (id) authentication {
    alert(@"APClient#anthentication doesn't implement yet");
    return false;
}

+ (void)handleResponse:(id) result url:(NSString *)url method:(NSString *)method params:(NSDictionary *)params success:(void (^)(id data))success failure:(void (^)(int error))failure {
    NSError *error;
    if ([result isKindOfClass:[NSDictionary class]] && INT_VAL([result objectForKey:@"status"]) == API_UNAUTHORIZED) {
        if ([self authentication]) {
            if ([method isEqual:@"Get"]) {
                result = [[APIClient sharedClient] synchronouslyGetPath:url parameters:nil operation:NULL error:&error];
            } else if ([method isEqual:@"Post"]) {
                result = [[APIClient sharedClient] synchronouslyPostPath:url parameters:params operation:NULL error:&error];
            } else if ([method isEqual:@"Put"]) {
                result = [[APIClient sharedClient] synchronouslyPostPath:url parameters:params operation:NULL error:&error];
            }
        }
    }
    if (error) {
        if (failure) {
            failure(0);
        }
    } else {
        if (success) {
            success(result);
        }
    }
}
@end