//
//  User.h
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecurityPolicy.h"

@protocol User <NSObject, NSCopying>

@property (nonatomic, readonly, strong) NSString        *userId;
@property (nonatomic, readonly, strong) SecurityPolicy  *securityPolicy;

@end

@interface User : NSObject<User>

- (instancetype) initWithUserId: (NSString *)        userId
                 securityPolicy: (SecurityPolicy *)  securityPolicy
NS_DESIGNATED_INITIALIZER;

@end
