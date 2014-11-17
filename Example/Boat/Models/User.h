//
//  User.h
//  Boat
//
//  Created by bin on 13/11/14.
//  Copyright (c) 2014 binku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Boat/ActiveRecord.h>

@interface User : ActiveRecord

@property (nonatomic) NSInteger id;
@property(nonatomic) NSString* name;
@property(nonatomic) NSString* password;

@end
